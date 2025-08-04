<!--
    Copyright © 2025 Promisan

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
<!--- Program Activity Class --->

<CFSET Value   = Attributes.FieldValue>
<CFSET Operator  = Attributes.FieldStatus>
<CFSET tbl = "CLS">

<!--- to retrieve only certain status --->	   

<!--- ---- --->
<!--- -OR- --->
<!--- ---- --->

<cfif #Operator# is "ANY">

<cfoutput>

  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc##tbl#Select">

  <cfquery name="Result" 
   datasource="AppsProgram" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT DISTINCT ProgramId
       INTO  userQuery.dbo.tmp#SESSION.acc##tbl#Select
       FROM  ProgramActivityClass PC, ProgramPeriod P, ProgramActivity PA
	   WHERE PC.ProgramCode    = P.ProgramCode
	    AND  PC.ActivityPeriod = P.Period
	   	AND  PC.ActivityID = PA.ActivityID
		AND	 PA.RecordStatus != 9
	     AND PC.ActivityClass IN 
	         (SELECT SelectId
        		FROM ProgramSearchLine
		        WHERE SearchId = '#Value#'
        		  AND SearchClass = 'Class')
   </cfquery>
   
</cfoutput>

<!--- ---- --->
<!--- AND- --->
<!--- ---- --->

<cfelse>

   <cfoutput>   
      
  <!--- all valid potential combinations to be used for querying--->
  
  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc##tbl#All">
   
  <cfquery name = "All" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT DISTINCT ProgramId, ActivityClass
       INTO  userQuery.dbo.tmp#SESSION.acc##tbl#All
       FROM  ProgramActivityClass PC, ProgramPeriod P, ProgramActivity PA
	   WHERE PC.ProgramCode    = P.ProgramCode
	   AND   PC.ActivityPeriod = P.Period
	   AND   PC.ActivityID = PA.ActivityID
	   AND	 PA.RecordStatus != 9
	   AND   PC.ActivityClass IN 
	         (SELECT SelectId
        		FROM ProgramSearchLine
		        WHERE SearchId = '#Value#'
        		  AND SearchClass = 'Class')
  
  </cfquery>  

  <cfset From  = "">
  <cfset Where = "">
   
   </cfoutput>	 
   
   <cfquery name = "Select" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT SelectId
    FROM   ProgramSearchLine
    WHERE  SearchId = '#Value#'
      AND  SearchClass = 'Class'
    </cfquery>        
       
      <cfloop query="select">
		   
      <cfoutput>		
      <cfset q = "tmp"&#SESSION.acc#&#Select.SelectId#>
	  
	  <!--- create subsets --->
	  
	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
		  
      <cfquery name="#q#" datasource="AppsQuery" 
	     username="#SESSION.login#" 
         password="#SESSION.dbpw#">
	 
          SELECT Distinct ProgramId
		  INTO   #q#
	      FROM   tmp#SESSION.acc##tbl#All
          WHERE  tmp#SESSION.acc##tbl#All.ActivityClass = '#Select.SelectId#'
	  </cfquery>
      </cfoutput>
	   
     <cfoutput>    
	 <cfif #From# is "">  
    	  <cfset From  = #q#> 
		  <cfset Whs   = #q#>
	 <cfelse>
    	  <cfset From  = #From#&","&#q#>
          <cfif #Where# is "">
             <cfset Where = "Where "&#whs#&".ProgramId = "&#q#&".ProgramId">
          <cfelse>
             <cfset Where = #Where#&" AND "&#whs#&".ProgramId = "&#q#&".ProgramId">
          </cfif>		  
	 </cfif>
     </cfoutput>
     </cfloop>
  
     <cfoutput>	 
	 
	 <!--- combine subsets --->
	 
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc##tbl#All">
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc##tbl#Select">
	 
     <cfquery name="Result" datasource="AppsQuery" 
	    username="#SESSION.login#" 
       password="#SESSION.dbpw#">
		
         SELECT Distinct #q#.ProgramId
		 INTO   tmp#SESSION.acc##tbl#Select
         FROM    #From#
         #Where#
	 </cfquery>
    	 
      <cfloop query="select">
		 
	      <cfset q = "tmp"&#SESSION.acc#&#Select.SelectId#>  
	  	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
	  
      </cfloop>
  
   	  </cfoutput>
</cfif>

<!--- IMPORTANT Since program categories are defined on the program component level 
NO need to include the program components here as well --->