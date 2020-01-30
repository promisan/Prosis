
<cfquery name="Competence" 
datasource="AppsSelection" 
username="#SESSION.login#" 
    password="#SESSION.dbpw#">
SELECT A.Created as LastUpdated, R.*
FROM ApplicantSubmission S, ApplicantCompetence A, Ref_Competence R
WHERE A.CompetenceId = R.CompetenceId
 AND S.ApplicantNo = A.ApplicantNo
 AND S.PersonNo = '#URL.ID1#'
 ORDER BY CompetenceCategory, ListingOrder
</cfquery>

<cfif #Competence.recordcount# lt "#CheckMinimum.MinimumRecords#">
	<cfoutput><tr><td height="16"><font color="FF0000"><b>&nbsp;-&nbsp;</b>You must at least enter <b>#CheckMinimum.MinimumRecords#</b> #Code# records.</font></td></tr></cfoutput>
	<cfset st = 0>
</cfif>
