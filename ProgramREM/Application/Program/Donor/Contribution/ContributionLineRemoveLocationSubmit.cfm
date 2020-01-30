<cfquery name="qLines" 
    datasource="AppsProgram" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	DELETE FROM ContributionLineLocation
	WHERE ContributionLineId = '#URL.lineid#'
	AND LocationCode = '#URL.LocationCode#'
</cfquery>	

<cfoutput>
<script>
	$('##pl_#URL.LocationCode#_#URL.LineId#').remove();
	$('##pld_#URL.LocationCode#_#URL.LineId#').remove();	
</script>
</cfoutput>
