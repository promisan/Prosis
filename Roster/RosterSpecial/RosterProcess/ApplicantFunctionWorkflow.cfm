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
<cfquery name="Get" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     A.*, R.EntityClass
		FROM         ApplicantSubmission ASS INNER JOIN
		                      Applicant A ON ASS.PersonNo = A.PersonNo INNER JOIN
		                      ApplicantFunctionAction AF ON ASS.ApplicantNo = AF.ApplicantNo INNER JOIN
		                      Ref_StatusCode R ON AF.Status = R.Status INNER JOIN
		                      FunctionOrganization FO ON AF.FunctionId = FO.FunctionId INNER JOIN
		                      Ref_SubmissionEdition SE ON FO.SubmissionEdition = SE.SubmissionEdition AND R.Owner = SE.Owner
		WHERE     (R.Id = 'Fun') AND AF.RosterActionId = '#URL.ajaxId#'
</cfquery>		

<cfparam name="url.terminate" default="0">

<cfif url.terminate eq "0">
	
	<cf_ActionListing 
		EntityCode       = "EntRosterClearance"
		EntityClass      = "#get.entityClass#"
		ObjectKey4       = "#url.ajaxid#"
		AjaxId           = "#URL.ajaxid#"
		ObjectReference  = "#Get.FirstName# #Get.LastName#"
		Reset            = "Limited"
		Show             = "Yes">
	
<cfelse>

	<!--- this workflow is superseded by a later action which is shown above it so we close this workflow object 
	if it is not finished yet and we make an statement in the workflow that it is finished by the
	method --->

	<cf_ActionListing 
		EntityCode       = "EntRosterClearance"
		EntityClass      = "#get.entityClass#"
		ObjectKey4       = "#url.ajaxid#"
		AjaxId           = "#URL.ajaxid#"
		ObjectReference  = "#Get.FirstName# #Get.LastName#"
		CompleteCurrent  = "1"
		Reset            = "Limited"
		Show             = "Yes">


</cfif>	