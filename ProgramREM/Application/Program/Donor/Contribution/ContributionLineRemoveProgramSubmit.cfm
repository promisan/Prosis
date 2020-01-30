<cfquery name="qLines" 
    datasource="AppsProgram" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	DELETE FROM ContributionLineProgram
	WHERE ContributionLineId = '#URL.lineid#'
	AND ProgramCode = '#URL.ProgramCode#'
</cfquery>	

<cfoutput>
<script>
	$('##pl_#URL.ProgramCode#_#URL.LineId#').remove();
	$('##pld_#URL.ProgramCode#_#URL.LineId#').remove();	
</script>
</cfoutput>
