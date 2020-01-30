<cfquery name="Candidacy" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM  ApplicantFunction
	WHERE ApplicantNo = '#client.applicantNo#'
	AND   FunctionId  = '#URL.ID#' 
</cfquery>	

<tr><td colspan="6"></td></tr>
<tr><td></td><td colspan="5" class="labelmedium" bgcolor="FFBFBF"><b><font color="FF0000">Attention:</font>&nbsp;Your candidacy was withdrawn</b></td></tr>	
<tr><td colspan="6"></td></tr>