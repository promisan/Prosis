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
<table width="100%" align="center">

<cfquery name="language"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_SystemLanguage
	WHERE  LanguageCode != '' AND Operational != '0'
	ORDER BY LanguageCode	
</cfquery>

<cfoutput query="Language">

<tr><td height="4"></td></tr>
<tr><td class="labellarge" style="height:30"><b>#LanguageName#</td></tr>

<tr><td>

  <cf_ApplicantTextArea
				Table           = "Applicant.dbo.FunctionOrganizationNotes" 
				Domain          = "Position"
				FieldOutput     = "ProfileNotes"				
				LanguageCode    = "#languagecode#"
				Mode            = "View"				
				Key01           = "FunctionId"
				Key01Value      = "#URL.IDFunction#">	
				
</td></tr>

</cfoutput>

</table>						