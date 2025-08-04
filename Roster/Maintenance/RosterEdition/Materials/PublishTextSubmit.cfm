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
<cf_ApplicantTextArea
	Table           = "Applicant.dbo.Ref_SubmissionEditionProfile" 
	Domain          = "Edition"
	FieldOutput     = "EditionNotes"				
	LanguageCode    = "#url.languagecode#"
	Mode            = "save"
	Log             = "No"				
	Key01           = "SubmissionEdition"
	Key01Value      = "#url.submissionedition#"
	Key02           = "Actionid"
	Key02Value      = "#url.ActionId#"
	Officer         = "N">	

<cfinclude template = "PublishText.cfm">

			