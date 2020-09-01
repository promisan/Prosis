
<!--- show the text --->

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