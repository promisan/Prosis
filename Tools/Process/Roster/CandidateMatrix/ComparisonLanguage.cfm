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
<cfparam name="comparisonApplicantNo" default="">

<cfquery name="Detail" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   ApplicantLanguage.*, 
         Ref_Language.LanguageClass, 
	     Ref_Language.ListingOrder, 
	     Ref_Language.LanguageName, 
		 S.Source,
		 R.AllowEdit
FROM     ApplicantSubmission S, ApplicantLanguage, Ref_Language, Ref_Source R
WHERE    S.PersonNo = '#URL.PersonNo#'
  AND    S.ApplicantNo = ApplicantLanguage.ApplicantNo
  <cfif comparisonApplicantNo neq "">
	AND 	 S.ApplicantNo = #comparisonApplicantNo#
  </cfif>
  AND    S.Source = R.Source
  AND    S.Source = '#SSource#'
  AND    ApplicantLanguage.LanguageId = Ref_Language.LanguageId
ORDER BY LanguageClass, ListingOrder, LanguageName
</cfquery>

<cfset cnt = "0">
<table width="95%" align="center">
<cfoutput query="detail">
    
	<cfset cnt = cnt + 1>
	
	<cfif cnt eq "1"><tr></cfif>
	
	<td class="labelit">#LanguageName# [#LevelRead#|#LevelWrite#|#LevelSpeak#|#LevelUnderstand#]</td>
	
	<cfif cnt eq "3">
		</tr>	
		<cfset cnt = "0">
	</cfif>
	
</cfoutput>
</table>

<!--- experience language --->