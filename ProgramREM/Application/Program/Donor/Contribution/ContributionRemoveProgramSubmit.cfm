<cfquery name="qLines" 
    datasource="AppsProgram" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	DELETE FROM ContributionProgram
	WHERE ContributionId = '#URL.contributionid#'
	AND ProgramCode = '#URL.ProgramCode#'
</cfquery>	

<cfoutput>
<script>
	$('##pl_#URL.ProgramCode#_#URL.contributionid#').remove();
	$('##pld_#URL.ProgramCode#_#URL.contributionid#').remove();	
</script>
</cfoutput>
