<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<CFSET Value   = Attributes.FieldValue>
<CFSET Operator  = Attributes.FieldStatus>

   
<!--- to retrieve only certain status --->	   

<!--- ---- --->
<!--- -OR- --->
<!--- ---- --->

<cfif #Operator# is "ANY">

<cfoutput>

  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#MISSelect">

  <cfquery name="Result" 
   datasource="AppsEmployee" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT DISTINCT PersonNo
       INTO  userQuery.dbo.tmp#SESSION.acc#MISSelect
       FROM  PersonAssignment P, Position Pos
       WHERE P.PositionNo = Pos.PositionNo
	   AND   Pos.Mission IN 
	         (SELECT SelectId
        		FROM PersonSearchLine
		        WHERE SearchId = '#Value#'
        		  AND SearchClass = 'Mission')
   </cfquery>
   
</cfoutput>

<!--- ---- --->
<!--- AND- --->
<!--- ---- --->

<cfelse>

   <cfoutput>   
      
  <!--- all valid potential combinations to be used for querying--->
  
  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#MISAll">
   
  <cfquery name = "All" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		  		   
   SELECT DISTINCT
          PersonNo, Mission
   INTO	  userQuery.dbo.tmp#SESSION.acc#MISAll	
   FROM  PersonAssignment P, Position Pos
   WHERE P.PositionNo = Pos.PositionNo
   AND   Pos.Mission IN 
   	           (SELECT SelectId
        		FROM PersonSearchLine
		        WHERE SearchId = '#Value#'
        		  AND SearchClass = 'Mission')
  </cfquery>  

  <cfset From  = "">
  <cfset Where = "">
   
   </cfoutput>	 
   
   <cfquery name = "Select" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT SelectId
    FROM   PersonSearchLine
    WHERE  SearchId = '#Value#'
      AND  SearchClass = 'Mission'
    </cfquery>              
       
      <cfloop query="select">
		   
      <cfoutput>	
	  
	  <cfset Select.SelectId = Replace(#Select.SelectId#,"-","",'ALL')>	
	  
      <cfset q = "tmp"&#SESSION.acc#&#Select.SelectId#>
	  
	  <!--- create subsets --->
	  
	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
		  
      <cfquery name="#q#" datasource="AppsQuery" 
	     username="#SESSION.login#" 
         password="#SESSION.dbpw#">
	 
          SELECT Distinct PersonNo
		  INTO   #q#
	      FROM   tmp#SESSION.acc#MisAll
          WHERE  tmp#SESSION.acc#MisAll.Mission = '#Select.SelectId#'
	  </cfquery>
      </cfoutput>
	   
     <cfoutput>    
	 <cfif #From# is "">  
    	  <cfset From  = #q#> 
		  <cfset Whs   = #q#>
	 <cfelse>
    	  <cfset From  = #From#&","&#q#>
          <cfif #Where# is "">
             <cfset Where = "Where "&#whs#&".PersonNo = "&#q#&".PersonNo">
          <cfelse>
             <cfset Where = #Where#&" AND "&#whs#&".PersonNo = "&#q#&".PersonNo">
          </cfif>		  
	 </cfif>
     </cfoutput>
     </cfloop>
  
     <cfoutput>	 
	 
	 <!--- combine subsets --->
	 
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#MisAll">
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#MisSelect">
	 
     <cfquery name="Result" datasource="AppsQuery" 
	    username="#SESSION.login#" 
       password="#SESSION.dbpw#">
		
         SELECT Distinct #q#.PersonNo
		 INTO   tmp#SESSION.acc#MisSelect
         FROM    #From#
         #Where#
	 </cfquery>
    	 
      <cfloop query="select">
		 
	      <cfset q = "tmp"&#SESSION.acc#&#Select.SelectId#>  
	  	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
	  
      </cfloop>
  
   	  </cfoutput>
</cfif>