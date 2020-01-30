<cfquery name="qSource" 
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
        password="#SESSION.dbpw#">
		DELETE 
		FROM userTransaction.dbo.FinalProduct_#session.acc#
		WHERE WorkorderItemId = '#URL.WorkorderItemId#'
</cfquery>

<cfoutput>
	<script>
	    
		_cf_loadingtexthtml='';	
		ptoken.navigate('FinalProductSelected.cfm?workorderid=#url.workOrderId#&workorderline=#url.workOrderLine#','selecteditems');
	</script>
</cfoutput>