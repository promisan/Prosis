<cftransaction>
	<cfquery name="qUpdate"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE CustomerPayer
		SET Status = 9 
		WHERE PayerId        = '#URL.PayerId#'
	</cfquery>		
</cftransaction>

<cfoutput>
	<script>
		ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/Medical/Insurance/PayerListingDetail.cfm?owner=#URL.owner#&id=#URL.id#','dPayerListing')
	</script>		
</cfoutput>