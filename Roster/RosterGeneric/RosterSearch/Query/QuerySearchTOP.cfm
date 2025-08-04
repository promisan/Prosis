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
<CFSET tbl = "TOP">
<CFSET FileNo  = Attributes.FileNo>

<!--- query ---->

<cfquery name="Operator" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT SelectId, SelectDescription
	 FROM   RosterSearchLine
	 WHERE  SearchId = '#Value#'
	 AND    SearchClass = 'TopicOperator'
</cfquery>

<cfquery name="Result" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT SelectId, SelectDescription
	 FROM   RosterSearchLine
	 WHERE  SearchId = '#Value#'
	 AND    SearchClass = 'Topic'
</cfquery>

 <cfoutput>   
      
  <!--- all valid potential combinations to be used for querying--->
  
  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_#tbl#All">
   
  <cfquery name = "All" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT DISTINCT Fun.PersonNo,
          Topic.ApplicantNo,
          Topic.TopicId,
		  Topic.TopicValue
   INTO	  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_#tbl#All	
   FROM   ApplicantFunctionTopic Topic, 
          ApplicantSubmission S,  
          userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect Fun 
   WHERE  Fun.PersonNo = S.PersonNo
   <!--- only enabled submission --->
    AND   S.RecordStatus = '1'
    AND   S.ApplicantNo = Topic.ApplicantNo  
  </cfquery>  

  <cfset From  = "">
  <cfset Where = "">
   
   </cfoutput>	 
   
   <cfquery name = "Select" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT SelectId, SelectParameter, SelectDescription
    FROM   RosterSearchLine
    WHERE  SearchId = '#Value#'
      AND  SearchClass = 'Topic'
    </cfquery>              
       
      <cfloop query="select">
		   
      <cfoutput>		
      <cfset q = "tmp"&#SESSION.acc#&#fileNo#&#currentrow#>
	  
	  <!--- create subsets --->
	 	  
	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
		  
      <cfquery name="#q#" datasource="AppsQuery" 
	     username="#SESSION.login#" 
         password="#SESSION.dbpw#">
          SELECT Distinct PersonNo
		  INTO   #q#
	      FROM   tmp#SESSION.acc#_#fileNo#_#tbl#All T
          WHERE  T.TopicId = '#Select.SelectId#'
		  AND    T.TopicValue = '#Select.SelectParameter#'
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
	 
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_#tbl#All">
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_#tbl#Select">
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_#tbl#Select1">
	 	 	 
	 <cfif Operator.selectid eq "0">
	 
		 <cfquery name="Result" datasource="AppsQuery" 
		    username="#SESSION.login#" 
	       password="#SESSION.dbpw#">
	         SELECT DISTINCT #q#.PersonNo
			 INTO   tmp#SESSION.acc#_#fileNo#_#tbl#Select1
	         FROM    #From#
	         #Where#
		 </cfquery>
	 	 
	     <cfquery name="Result" 
		   datasource="AppsQuery" 
		   username="#SESSION.login#" 
	       password="#SESSION.dbpw#">
		   SELECT DISTINCT PersonNo
		   INTO   tmp#SESSION.acc#_#fileNo#_#tbl#Select
		   FROM  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect 
		   WHERE PersonNo NOT IN (SELECT PersonNo FROM tmp#SESSION.acc#_#fileNo#_#tbl#Select1)
		 </cfquery>
		 
	 <cfelse>
	 
		 <cfquery name="Result" datasource="AppsQuery" 
		    username="#SESSION.login#" 
	       password="#SESSION.dbpw#">
	         SELECT DISTINCT #q#.PersonNo
			 INTO   tmp#SESSION.acc#_#fileNo#_#tbl#Select
	         FROM    #From#
	         #Where#
		 </cfquery>	 
	 
	 </cfif>
	 
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_#tbl#Select1">
    	 
      <cfloop query="select">
		 
	      <cfset q = "tmp"&#SESSION.acc#&#Select.SelectId#>  
	  	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
	  
      </cfloop>
  
   	  </cfoutput>