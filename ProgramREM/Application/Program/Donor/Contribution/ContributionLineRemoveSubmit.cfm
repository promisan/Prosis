
<cftransaction>
	
	<cfquery name="qLines" 
	    datasource="AppsProgram" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		DELETE FROM ContributionLinePeriod
		WHERE  ContributionLineId = '#URL.ContributionLineId#'		   
	</cfquery>	
	
	<cfquery name="qLines" 
	    datasource="AppsProgram" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		DELETE FROM ContributionLineLocation
		WHERE  ContributionLineId = '#URL.ContributionLineId#'		   
	</cfquery>	
	
	<cfquery name="qLines" 
	    datasource="AppsProgram" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		DELETE FROM ContributionLineProgram
		WHERE  ContributionLineId = '#URL.ContributionLineId#'		   
	</cfquery>	
	
	<cfquery name="qLines" 
	    datasource="AppsProgram" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		DELETE FROM ContributionLine
		WHERE  ContributionLineId = '#URL.ContributionLineId#'		   
	</cfquery>	

</cftransaction>

<cfoutput>
<script>
	$('##r_#URL.ContributionLineId#').hide();
	$('##l_#URL.ContributionLineId#').remove();
</script>
</cfoutput>