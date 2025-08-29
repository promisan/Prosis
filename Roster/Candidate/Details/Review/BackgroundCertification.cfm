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
<cfquery name="Line" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 ApplicantNo 
	FROM ApplicantSubmission
	WHERE PersonNo = '#Object.ObjectKeyValue1#' 
</cfquery>

<cfquery name="Review" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM ApplicantReview
	WHERE ReviewId = '#Object.ObjectKeyValue4#' 
</cfquery>

<cf_ComparisonView applicantno="#Line.ApplicantNo#" 
			HidePerson      = "Yes" 
			HideLanguage    = "Yes" 
			HideEducation   = "Yes" 
			HideTitle       = "Yes" 
			HideDetails     = "Yes"
			HideTopics      = "No"
			attachment      = "No" 
			Owner           = "#Review.Owner#"
			ExperienceStatus   = "'0','1'"
			ExperienceReviewed = "Yes"
			Layout          = "Vertical">	
			
<input name="savecustom" type="hidden"  value="">				