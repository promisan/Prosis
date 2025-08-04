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
    SELECT  FO.*, R.Owner
	FROM    FunctionOrganization AS FO INNER JOIN
            Ref_SubmissionEdition AS R ON FO.SubmissionEdition = R.SubmissionEdition	
	WHERE   FunctionId = '#URL.IDFunction#'
</cfquery>

<cfquery name="Person" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Applicant
	 WHERE  PersonNo = '#URL.PersonNo#'
</cfquery>

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT ApplicantNo
	 FROM   ApplicantSubmission
	 WHERE  PersonNo          = '#URL.PersonNo#'
	 AND    SubmissionEdition = '#Bucket.SubmissionEdition#' 	
</cfquery>

<cfif Verify.recordcount eq "0">

	<!--- search for a profile to be used based on the setting of the parent --->

	<cfquery name="getEdition" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    R.Owner,C.Source
		FROM      Ref_SubmissionEdition AS R INNER JOIN
	              Ref_ExerciseClass AS C ON R.ExerciseClass = C.ExcerciseClass
		WHERE     R.SubmissionEdition = '#Bucket.SubmissionEdition#'
	</cfquery>
	
	<cfif getEdition.Source eq "">
	
		<!--- we go deeper to the owner to select a default source --->
		
		<cfquery name="getEdition" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    DefaultPHPSource as Source
			FROM      Ref_ParameterOwner
			WHERE     Owner = '#Bucket.Owner#'		
	   </cfquery>	
	
	</cfif>

	<cfif getEdition.Source neq "">		

		<cfquery name="Verify" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   ApplicantNo
			FROM     ApplicantSubmission
			WHERE    PersonNo = '#URL.PersonNo#'
			AND      Source = '#getEdition.Source#' 	
			ORDER BY Created DESC
		</cfquery>
	
	<cfelse>
	
		<cfquery name="Verify" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   ApplicantNo
			FROM     ApplicantSubmission
			WHERE    PersonNo = '#URL.PersonNo#'
			ORDER BY Created DESC	
		</cfquery>
	
	</cfif>

</cfif>


<cfif Person.recordcount eq "1">
	
	<cfif Verify.recordcount eq "0">
	
	<!--- temp measure --->
	     <cfquery name="Last" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     	SELECT   MAX(ApplicantNo) AS LastNo
		    FROM     ApplicantSubmission
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
		     UPDATE Parameter SET ApplicantNo = #new#
	     </cfquery>
	
	     <cfquery name="LastNo" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     	 SELECT *
		     FROM   Parameter
		 </cfquery>
	 
	      <!--- Submit submission --->
		  
		  <cfif getEdition.Source neq "">
		  	<cfset Source = getEdition.Source>
		  <cfelse>
		    <cfset Source = "Manual">
		  </cfif>
	
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
			  '#Source#',
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
		AND    FunctionId = '#URL.IDFunction#'
	</cfquery>
	
	<CFIF Verify.recordCount is 1 > 
	
	<cf_tl id="Candidate was already recorded" var="1">
		
	<cfoutput>	
		<script>
			alert("#lt_text#")
		</script>
	</cfoutput>
	
	<!--- 
	do nothing, already registered
	--->
	
	<cfelse>
	
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
		      	  '#URL.IDFunction#',
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
		   '#URL.IDFunction#',
		   '#RosterActionNo#',
		   '0')
	</cfquery> 
	
	<cf_tl id="Candidate recorded" var="1">
		
	<cfoutput>	
		<script>
			alert("#lt_text#")
		</script>
	</cfoutput>
	
	</cfif>

</cfif>
	
<cfset url.box     = "manual">
<cfset url.source  = "#source#">
<cfset url.filter  = "0">
<cfset url.total   = "0">
<cfinclude template="FunctionViewListing.cfm">



