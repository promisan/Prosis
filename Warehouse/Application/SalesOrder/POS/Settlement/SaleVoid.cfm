
<cfparam name="url.batchid"    default="">

<cfinvoke component = "Service.Process.Materials.POS"  
	   method           = "PurgeTransaction" 
	   batchid          = "#url.batchid#"
	   mode             = "void">		

<cfoutput>

<!--- refresh the screen and sets the new customer --->

<script>  
	// try { ColdFusion.Window.destroy('settlement',true)} catch(e){};	
	ptoken.open("#SESSION.root#/warehouse/application/salesorder/pos/settlement/SaleInvoice.cfm?batchid=#url.batchid#, "_blank", "left=30, top=30, width=800, height=800, status=yes, toolbar=no, scrollbars=no, resizable=yes");		
    ptoken.navigate('#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/applyCustomer.cfm?warehouse=#url.warehouse#','customerbox')
</script>

</cfoutput>	   

	
	