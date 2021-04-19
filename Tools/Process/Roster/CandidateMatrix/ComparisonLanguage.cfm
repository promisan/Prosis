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