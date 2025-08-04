<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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
		document.getElementById('requestcostprice').value   = '#numberformat(get.StandardCost,'.__')#'
		 
	 	try {
			document.getElementById("requestcurrencyprice").value = '#numberformat(get.StandardCost,'.__')#'		
		} catch(e) {}		
		
	//	document.getElementById('quantityuom').value      = '#get.UoMDescription#'		
	//	document.getElementById('warehouseuom').value     = '#get.UoM#'
		// set the UoM stuff
		
		ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEntryWarehouseUoM.cfm?itemno=#get.ItemNo#&uom=#get.UoM#','setuom')
				
		// adjust the pricing of the requisition 
																						
		if (#url.access# == 1) {	
			try { 								
			qty = document.getElementById("requestquantity").value																		
			base2(document.getElementById('reqno').value,'#numberformat(get.StandardCost,'__.__')#',qty)									
			} catch(e) {}   
		}	  			
		
	</script>
	
	</cfoutput>
	
