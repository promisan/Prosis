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

<!--- verify if a submission record exists --->

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Parameter
</cfquery>

<cfquery name="UPDATE" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE ApplicantSubmission
		SET  ActionStatus = '1', 
		     SubmissionDate = getDate()		 
		WHERE ApplicantNo = '#URL.ApplicantNo#'		
</cfquery>


<cf_Navigation
	 Alias         = "AppsSelection"
	 TableName     = "ApplicantSubmission"
	 Object        = "Applicant"
	 ObjectId      = "No"
	 Group         = "PHP"
	 Section       = "#URL.Section#"
	 SectionTable  = "Ref_ApplicantSection"
	 Id            = "#URL.ApplicantNo#"
	 Owner         = "#url.owner#"
	 BackEnable    = "1"
	 HomeEnable    = "1"
	 ResetEnable   = "1"
	 ResetDelete   = "0"	
	 ProcessEnable = "0"
	 NextEnable    = "1"
	 NextSubmit    = "1"
	 Reload        = "1"
	 OpenDirect    = "1"
	 SetNext       = "1"
	 NextMode      = "1"
	 IconWidth 	  = "32"
	 IconHeight	  = "32">
