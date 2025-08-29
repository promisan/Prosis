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
<CFSET Value     = Attributes.FieldValue>
<CFSET Operator  = Attributes.FieldStatus>
<CFSET FileNo    = Attributes.FileNo>
   
<!--- to retrieve only certain status --->	   

<!--- ---- --->
<!--- -OR- --->
<!--- ---- --->

<cfquery name="Level" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
  SELECT SelectId
  FROM   RosterSearchLine
  WHERE  SearchId = '#Value#'
   AND   SearchClass = 'SelfAssessment'
</cfquery>

<cfif Operator is "ANY" >

<cfoutput>

  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_SASSelect">

  <cfquery name="Result" 
   datasource="AppsSelection" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT DISTINCT Fun.PersonNo   
       INTO   userQuery.dbo.tmp#SESSION.acc#_#fileNo#_SASSelect
       FROM   ApplicantSubmission AV,
	          ApplicantSubmissionTopic S,             
	          userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect Fun
	   WHERE  Fun.PersonNo   = AV.PersonNo	 	 
	   AND    AV.ApplicantNo = S.ApplicantNo
	   <!--- only enabled submission --->
	   AND    AV.RecordStatus = 1
       AND    EXISTS  
			         (SELECT 'X'
        			  FROM   RosterSearchLine
		        	  WHERE  SearchId        = '#Value#'
		        	  AND    SearchClass     = 'SelfAssessment'
					  AND    SelectId        = S.Topic
					  AND    SelectParameter = S.TopicValue ) 
					  
					  
   </cfquery>
   
</cfoutput>

<!--- ---- --->
<!--- AND- --->
<!--- ---- --->

<cfelse>

   <cfoutput>   
      
  <!--- all valid potential combinations to be used for querying--->
  
  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_SAS#Source#All">
   
  <cfquery name = "All" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">		  		   
   SELECT DISTINCT Fun.PersonNo, 
          S.Topic, S.TopicValue
   INTO	  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_SASAll	
   FROM   ApplicantSubmission AV,
          ApplicantSubmissionTopic S,             
          userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect Fun
   WHERE  Fun.PersonNo = AV.PersonNo
   AND    AV.ApplicantNo = S.ApplicantNo
   <!--- only enabled submission --->
   AND    AV.RecordStatus = 1
   AND    EXISTS  
			         (SELECT 'X'
        				FROM RosterSearchLine
		        		WHERE SearchId = '#Value#'
		        		  AND SearchClass = 'SelfAssessment'
						  AND SelectId        = S.Topic
						  AND SelectParameter = S.TopicValue )  
						    
  </cfquery>  

  <cfset From  = "">
  <cfset Where = "">
   
   </cfoutput>	 
   
     <cfquery name = "Select" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	  SELECT SelectId,SelectParameter 
      FROM   RosterSearchLine
      WHERE  SearchId = '#Value#'
      AND    SearchClass = 'SelfAssessment'
      </cfquery>              
       
      <cfloop query="select">
		   
      <cfoutput>		
     
	  <cfset q = "tmp"&#SESSION.acc#&#fileNo#&#Select.SelectId#>
	  
	  <!--- create subsets --->
	  
	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
		  
      <cfquery name="#q#" datasource="AppsQuery" 
	     username="#SESSION.login#" 
         password="#SESSION.dbpw#">	 
          SELECT Distinct PersonNo
		  INTO   #q#
	      FROM   tmp#SESSION.acc#_#fileNo#_SASAll S
          WHERE  S.Topic = '#SelectId#' AND S.TopicValue = '#SelectParameter#'
	  </cfquery>
      </cfoutput>
	   
     <cfoutput>    
	 <cfif From is "">  
    	  <cfset From  = q> 
		  <cfset Whs   = q>
	 <cfelse>
    	  <cfset From  = #From#&","&#q#>
          <cfif WHERE is "">
             <cfset WHERE = "WHERE "&#whs#&".PersonNo = "&#q#&".PersonNo">
          <cfelse>
             <cfset WHERE = #WHERE#&" AND "&#whs#&".PersonNo = "&#q#&".PersonNo">
          </cfif>		  
	 </cfif>
     </cfoutput>
     </cfloop>
  
     <cfoutput>	 
	 
	 <!--- combine subsets --->
	 
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_SASAll">
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_SASSelect">
	 
     <cfquery name="Result" datasource="AppsQuery" 
	    username="#SESSION.login#" 
       password="#SESSION.dbpw#">
		
         SELECT  DISTINCT #q#.PersonNo
		 INTO    tmp#SESSION.acc#_#fileNo#_SASSelect
         FROM    #From#
         #WHERE#
	 </cfquery>
    	 
      <cfloop query="select">
		 
	      <cfset q = "tmp"&#SESSION.acc#&#Select.SelectId#>  
	  	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
	  
      </cfloop>
  
   	  </cfoutput>
	  
</cfif>
