<cf_compression>

<cfquery name="removeItem"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		UPDATE	Receipt#URL.Warehouse#_#SESSION.acc#
		SET		Selected = '0',
				TransferWarehouse = null,
				TransferLocation = null,
				TransferQuantity = Quantity,
				TransferItemNo = null,
				TransferUoM = null,
				TransferMemo = null
		WHERE   TransactionId = #url.id#
		
</cfquery>

<cfoutput>
	<script>
		ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/receipt/StockreceiptProcessView.cfm?mission=#url.mission#&warehouse=#url.warehouse#','contentbox1');
	</script>
</cfoutput>