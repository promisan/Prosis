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
<!--- verify if SKILL record submission exists --->

<cfparam name="url.source" default="#CLIENT.Submission#">

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Source
	WHERE  Source = '#url.source#' 
</cfquery>

<cfif Verify.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_Source (Source)
	    VALUES ('#url.source#')
	</cfquery>

</cfif>

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  ApplicantNo
	 FROM   ApplicantSubmission
	 WHERE  PersonNo = '#FORM.PersonNo#'
	  AND   Source   = '#url.source#'
	ORDER   BY Created DESC
</cfquery>

<cfif Verify.recordcount eq "0">

 <!--- temp measure --->
     <cfquery name="Last" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT  MAX(ApplicantNo) AS LastNo
	     FROM    ApplicantSubmission
     </cfquery>
	 
	 <cfif Last.LastNo neq "">
	    <cfset new = Last.LastNo+1>
	 <cfelse>	
	    <cfset new = "1">
	 </cfif> 

     <cfquery name="AssignNo" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE Parameter 
	 SET    ApplicantNo = #new#
     </cfquery>

     <cfquery name="LastNo" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT *
     FROM   Parameter
	 </cfquery>
 
     <!--- Submit submission --->

     <cfquery name="InsertApplicant" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ApplicantSubmission
         (PersonNo,
		 ApplicantNo,
  		 SubmissionDate,
		 ActionStatus,
		 Source,		
		 eMailAddress,
		 LanguageId,
	 	 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
      VALUES ('#Form.PersonNo#',
	       '#LastNo.ApplicantNo#', 
           '#DateFormat(Now(),CLIENT.dateSQL)#',
		  '0',
		  '#url.source#',		  
		  '',
		  '001',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())
     </cfquery>
	 
	 <cfset appno = LastNo.ApplicantNo>

<cfelse> 

     <cfset appno = Verify.ApplicantNo>
	 
</cfif>
