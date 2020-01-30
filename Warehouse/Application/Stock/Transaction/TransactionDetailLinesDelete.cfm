<cfset tableName = "StockTransaction#URL.Warehouse#_#url.mode#"> 
<cf_getPreparationTable warehouse="#url.warehouse#" mode="#url.mode#"> <!--- adjusts #tableName# i.e. preparation can be per user or per warehouse --->


<cfquery name="qDeleteLines" 
	datasource="AppsTransaction" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	DELETE FROM #tableName#
	WHERE TransactionId = '#URL.id#'		   
</cfquery>	

<cfoutput>
	
	<script language="JavaScript">
		$('##line_#URL.id#').remove();
		$('##line_#URL.id#_asset').remove();
		$('##line_#URL.id#_location').remove();
		$('##line_#URL.id#_remarks').remove();
		$('##line_#URL.id#_dot').remove();		
		$('##line_#URL.id#_attach').remove();	
		
	</script>
	
</cfoutput>