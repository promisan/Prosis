<cfquery name="Candidacy" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM  ApplicantFunction
	WHERE ApplicantNo = '#client.applicantNo#'
	AND   FunctionId  = '#URL.ID#' 
</cfquery>	

<table width="80%" align="center">
<tr>
	<td colspan="5" class="labelit"><font color="FF0000"><cf_tl id="Your interest has been withdrawn"></b></td>
</tr>	
</table>

<cfoutput>
	<script>
		if ($('.shortApplyContainer_#url.id#').length == 1) {
			$('.shortApplyContainer_#url.id#').show();
		}
	</script>
</cfoutput>