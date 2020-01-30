<cfparam name="URL.assetid" default="">

<cfset tableName = "StockTransaction#URL.Warehouse#_#url.mode#"> 
<cf_getPreparationTable warehouse="#url.warehouse#" mode="#url.mode#"> <!--- adjusts #tableName# i.e. preparation can be per user or per warehouse --->

<cfquery name="UpdateLine"
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE   #tableName# 
	SET      AssetId        = '#URL.AssetId#'
	WHERE    TransactionId  = '#URL.TransactionId#'
</cfquery>

<cfoutput>	
	<script language="JavaScript">			
		ColdFusion.navigate('../Transaction/TransactionDetailLines.cfm?tratpe=#url.tratpe#&mode=#url.mode#&warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&UoM=#url.UoM#','detail');
	</script>			
</cfoutput>

