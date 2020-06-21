
<!--- trigger stored procedure which also triggers if needed an EDI action --->

<cfinvoke component = "Service.Process.Materials.POS"  
	   method           = "purgeTransaction" 
	   mode             = "void"
	   batchid          = "#url.id#"
	   terminal         = "#url.terminal#"
	   triggerEDI       = "Yes">
	   
   
<cfoutput>
	<script>
		ptoken.navigate('#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/applyCustomer.cfm?warehouse=#url.warehouse#','customerbox');
	</script>
</cfoutput>