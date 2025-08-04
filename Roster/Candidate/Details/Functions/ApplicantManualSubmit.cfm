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
 
<!--- verify if Submission record submission exists --->

<cfquery name="Bucket" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   FunctionOrganization
	WHERE  FunctionId = '#URL.ID#'
</cfquery>

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT ApplicantNo
	FROM   ApplicantSubmission
	WHERE PersonNo = '#URL.PersonNo#'
	<!--- limit creation
	AND SubmissionEdition = '#Bucket.SubmissionEdition#' 
	--->
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
	     FROM Parameter
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
		 SubmissionEdition,
		 eMailAddress,
		 LanguageId,
	 	 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
      VALUES ('#URL.PersonNo#',
	       '#LastNo.ApplicantNo#', 
           '#DateFormat(Now(),CLIENT.DateSQL)#',
		  '0',
		  'Manual',
		  '#Bucket.SubmissionEdition#',
		  '',
		  '001',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')
     </cfquery>
	 
	 <cfset appno = LastNo.ApplicantNo>

<cfelse> 

     <cfset appno = Verify.ApplicantNo>
	 
</cfif>
   
<!--- Update Function --->   

<cfparam name="Form.FunctionId" type="any" default="">

<cf_RosterActionNo ActionCode="FUN" ActionRemarks="Manual Entry"> 
		
	<cfquery name="Verify" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT FunctionId
		FROM   ApplicantFunction
		WHERE  ApplicantNo = '#AppNo#' 
		AND    FunctionId = '#URL.ID#'
	</cfquery>

<CFIF verify.recordCount eq 0> 

	<!--- create a bucket presence entry --->
	
	<cfquery name="InsertFunction" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO dbo.[ApplicantFunction] 
		        (ApplicantNo,
				 FunctionId,
				 Status,
				 Source,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,
				 Created)
		  VALUES ('#AppNo#', 
		      	  '#URL.ID#',
				  '0',
				  'Manual',
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#',
				  getDate())
	 </cfquery>
 
	<cfquery name="UpdateFunctionStatusAction" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO  ApplicantFunctionAction
			   (ApplicantNo,
			    FunctionId, 
			    RosterActionNo, 
			    Status)
		VALUES 
			   ('#AppNo#',
			   '#URL.ID#',
			   '#RosterActionNo#',
			   '0')
	</cfquery> 

</cfif>