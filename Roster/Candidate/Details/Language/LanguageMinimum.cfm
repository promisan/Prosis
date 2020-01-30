
<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Parameter
</cfquery>

<cfquery name="Detail" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT ApplicantLanguage.*, Ref_Language.LanguageClass, Ref_Language.ListingOrder, Ref_Language.LanguageName, S.Source
    FROM ApplicantSubmission S, ApplicantLanguage, Ref_Language
	WHERE S.PersonNo = '#URL.ID1#'
	AND S.ApplicantNo = ApplicantLanguage.ApplicantNo
	AND ApplicantLanguage.LanguageId = Ref_Language.LanguageId
	ORDER BY LanguageClass, ListingOrder, LanguageName
</cfquery>

<cfif #Detail.recordcount# lt "#CheckMinimum.MinimumRecords#">
	<cfoutput><tr><td height="16"><font color="FF0000"><b>&nbsp;-&nbsp;</b><cf_tl id="You must at least enter"> <b>#CheckMinimum.MinimumRecords#</b> #Code# <cf_tl id="records">.</font></td></tr></cfoutput>
	<cfset st = 0>
</cfif>
