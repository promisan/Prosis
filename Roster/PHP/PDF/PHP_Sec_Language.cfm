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
<!--- *************************************************************************** --->

<table width="100%" border="0" align="center" >
	<tr></tr>
	
	<!--- Applicant --->
		<cfquery name="ApplicantSubmission" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
		   	FROM ApplicantSubmission
		   	WHERE PersonNo = '#PHPPersonNo#'
			AND Source = 'Galaxy'
		</cfquery>	
		
		<cfquery name="UNLanguage" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT A.*, L.LanguageName
		   	FROM ApplicantLanguage A Inner Join Ref_Language L on 
				A.LanguageID = L.LanguageId				
		   	WHERE ApplicantNo = '#ApplicantSubmission.ApplicantNo#'
			AND L.LanguageClass = 'Official'
		</cfquery>	

		<cfquery name="NonUNLanguage" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT A.*, L.LanguageName
		   	FROM ApplicantLanguage A Inner Join Ref_Language L on 
				A.LanguageID = L.LanguageId				
		   	WHERE ApplicantNo = '#ApplicantSubmission.ApplicantNo#'
			AND L.LanguageClass != 'Official'
		</cfquery>	

		<tr></tr>	
		<tr><td>
		<table width="96%" border="0" align="center" >
		<Cfoutput>
		<tr><td colspan="6" bgcolor="333333"><td></td></tr>
		<tr><td colspan="6">List any of the Official Languages of the United Nations you know.</td></tr>
		</Cfoutput>
		<tr></tr>
		
		<cfif UNLanguage.RecordCount gt "0">
		<tr>
			<td width="10%"><i>Language</i></td>
			<td width="20%" align="center"><i>Mother Tongue</i></td>
			<td width="20%" align="center"><i>Speak</i></td>
			<td width="20%" align="center"><i>Read</i></td>
			<td width="20%" align="center"><i>Write</i></td>
			<td width="10%" align="center"><i>Understand</i></td>
		</tr>
		<tr><td colspan="6" bgcolor="333333"></td></tr>
		<cfloop query="UNLanguage"> 
		<tr>
			<cfoutput>
			<td><b>#UNLanguage.LanguageName#</b></td>
			<td align="center"><b><cfif UNLanguage.MotherTongue>Yes<cfelse>No</cfif></b></td>
			<td align="center"><b><cfif UNLanguage.LevelSpeak eq "1">Easily<cfelse>Not easily</cfif></b></td>
			<td align="center"><b><cfif UNLanguage.LevelRead eq "1">Easily<cfelse>Not easily</cfif></b></td>
			<td align="center"><b><cfif UNLanguage.LevelWrite eq "1">Easily<cfelse>Not easily</cfif></b></td>
			<td align="center"><b><cfif UNLanguage.LevelUnderstand eq "1">Easily<cfelse>Not easily</cfif></b></td>
			</cfoutput>
		</tr>
		</cfloop>
		<tr><td colspan="6" bgcolor="333333"><td></td></tr>
		</cfif>
		</table>
		</td></tr>
		
		<tr></tr>	

		<tr><td>
		<table width="96%" border="0" align="center" >
		
		<Cfoutput>
		<tr><td colspan="6">In addition to the six United Nations Official Languages, list any other languages you know.</td></tr>
		</Cfoutput>
		<tr></tr>

		<cfif NonUNLanguage.RecordCount gt "0">
		<tr>
			<td width="10%"><i>Language</i></td>
			<td width="20%" align="center"><i>Mother Tongue</i></td>
			<td width="20%" align="center"><i>Speak</i></td>
			<td width="20%" align="center"><i>Read</i></td>
			<td width="20%" align="center"><i>Write</i></td>
			<td width="10%" align="center"><i>Understand</i></td>
		</tr>
		<tr><td colspan="6" bgcolor="333333"><td></td></tr>
		<cfloop query="NonUNLanguage"> 
		<tr>
			<cfoutput>
			<td><b>#NonUNLanguage.LanguageName#</b></td>
			<td align="center"><b><cfif NonUNLanguage.MotherTongue>Yes<cfelse>No</cfif></b></td>
			<td align="center"><b><cfif NonUNLanguage.LevelSpeak eq "1">Easily<cfelse>Not easily</cfif></b></td>
			<td align="center"><b><cfif NonUNLanguage.LevelRead eq "1">Easily<cfelse>Not easily</cfif></b></td>
			<td align="center"><b><cfif NonUNLanguage.LevelWrite eq "1">Easily<cfelse>Not easily</cfif></b></td>
			<td align="center"><b><cfif NonUNLanguage.LevelUnderstand eq "1">Easily<cfelse>Not easily</cfif></b></td>
			</cfoutput>
		</tr>
		</cfloop>
		<tr><td colspan="6" bgcolor="333333"><td></td></tr>
		</cfif>
		</table>
		</td></tr>
		
</table>

