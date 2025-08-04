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

<CFSET Value   = Attributes.FieldValue>
<CFSET Operator  = Attributes.FieldStatus>
<CFSET FileNo  = Attributes.FileNo>

<CFSET tbl = "MIS">
   
<!--- to retrieve only certain status --->	   

<!--- ---- --->
<!--- -OR- --->
<!--- ---- --->

<cfif #Operator# is "ANY">

<cfoutput>

  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_#tbl#Select">

  <cfquery name="Result" 
   datasource="AppsSelection" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT DISTINCT S.PersonNo
       INTO  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_#tbl#Select
       FROM  ApplicantMission, ApplicantSubmission S
       WHERE S.ApplicantNo = ApplicantMission.ApplicantNo   
	   <!--- only enabled submission --->
	   AND   S.RecordStatus = '1'
	   AND   ApplicantMission.Mission IN 
	         (SELECT SelectId
        		FROM RosterSearchLine
		        WHERE SearchId = '#Value#'
        		  AND SearchClass = 'Mission')
	   UNION	
	   SELECT DISTINCT S.PersonNo
       FROM  ApplicantSubmission S
       WHERE S.ApplicantNo NOT IN (SELECT ApplicantNo 
	                               FROM ApplicantMission)
	   AND   S.PersonNo IN (SELECT * FROM userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect) 							   
   
   </cfquery>
   
</cfoutput>

<!--- ---- --->
<!--- AND- --->
<!--- ---- --->

<cfelse>

   <cfoutput>   
      
  <!--- all valid potential combinations to be used for querying--->
  
  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_#tbl#All">
   
  <cfquery name = "All" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		  		   
   SELECT DISTINCT S.PersonNo, ApplicantMission.ApplicantNo, ApplicantMission.Mission
   INTO	  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_#tbl#All	
   FROM   ApplicantMission, ApplicantSubmission S 
   WHERE  S.ApplicantNo = ApplicantMission.ApplicantNo  
   <!--- only enabled submission --->
   AND    S.RecordStatus = 1 
   AND    ApplicantMission.Mission IN 
	           (SELECT SelectId
        		FROM   RosterSearchLine
		        WHERE  SearchId = '#Value#'
        		AND    SearchClass = 'Mission')
	UNION
    SELECT DISTINCT S.PersonNo, S.ApplicantNo, 'all'
    FROM   ApplicantSubmission S
    WHERE  S.ApplicantNo NOT IN (SELECT ApplicantNo 
	                             FROM   ApplicantMission)
	AND    S.PersonNo IN (SELECT * FROM userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect) 			  
				  
  </cfquery>  

  <cfset From  = "">
  <cfset Where = "">
   
   </cfoutput>	 
   
   <cfquery name = "Select" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT SelectId
    FROM   RosterSearchLine
    WHERE  SearchId    = '#Value#'
      AND  SearchClass = 'Mission'
    </cfquery>              
       
      <cfloop query="select">
		   
      <cfoutput>		
      <cfset q = "tmp#SESSION.acc#_#fileNo#_#Select.SelectId#">
	  
	  <!--- create subsets --->
	  
	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
		  
      <cfquery name="#q#" datasource="AppsQuery" 
	     username="#SESSION.login#" 
         password="#SESSION.dbpw#">	 
          SELECT Distinct PersonNo
		  INTO   #q#
	      FROM   tmp#SESSION.acc#_#fileNo#_#tbl#All
          WHERE  tmp#SESSION.acc#_#fileNo#_#tbl#All.Mission = '#Select.SelectId#'
		  OR tmp#SESSION.acc#_#fileNo#_#tbl#All.Mission = 'all'
		  
	  </cfquery>
      </cfoutput>
	   
     <cfoutput>    
	 <cfif From is "">  
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
	 
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_#tbl#All">
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_#tbl#Select">
	 
     <cfquery name="Result" datasource="AppsQuery" 
	  username="#SESSION.login#" 
      password="#SESSION.dbpw#">
         SELECT Distinct #q#.PersonNo
		 INTO   tmp#SESSION.acc#_#fileNo#_#tbl#Select
         FROM    #From#
         #Where#
	 </cfquery>
    	 
      <cfloop query="select">
		 
	      <cfset q = "tmp"&#SESSION.acc#&#Select.SelectId#>  
	  	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
	  
      </cfloop>
  
   	  </cfoutput>
</cfif>