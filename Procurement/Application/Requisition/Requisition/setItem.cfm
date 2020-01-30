
<!--- set item value --->

<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 * 
		FROM   Item I, ItemUoM U
		WHERE  ItemUoMId = '#url.itemuomid#'
		AND    I.ItemNo = U.ItemNo		
	</cfquery>	
	
	<cfoutput>
	
	<script>
	
		// apply the selected item and price
		
		document.getElementById('itemno').value             = '#get.ItemNo#'
		document.getElementById('itemdescription').value    = '#get.ItemDescription#'
		document.getElementById('requestdescription').value = '#get.ItemDescription#'
		document.getElementById('requestcostprice').value   = '#numberformat(get.StandardCost,'__.__')#'
		 
	 	try {
			document.getElementById("requestcurrencyprice").value = '#numberformat(get.StandardCost,'__.__')#'		
		} catch(e) {}
		
		
		document.getElementById('quantityuom').value      = '#get.UoMDescription#'		
		document.getElementById('warehouseuom').value   = '#get.UoM#'
			// set the UoM stuff
		
		ColdFusion.navigate('#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEntryWarehouseUoM.cfm?itemno=#get.ItemNo#&uom=#get.UoM#','setuom')
				
		// adjust the pricing of the requisition 
																						
		if (#url.access# == 1) {	
			try { 								
			qty = document.getElementById("requestquantity").value																		
			base2(document.getElementById('reqno').value,'#numberformat(get.StandardCost,'__.__')#',qty)									
			} catch(e) {}   
		}	  			
		
	</script>
	
	</cfoutput>
	
