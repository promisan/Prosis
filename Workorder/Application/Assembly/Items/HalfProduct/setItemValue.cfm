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

<cfif url.field neq "Warehouse" and url.field neq "TransactionLot" and url.field neq "Memo" and url.field neq "asDefault" and url.field neq "Copy">

	<cfif not LSIsNumeric(url.value)>
	
		<script>
		    alert('Incorrect numeric value')
		</script>	 		
		<cfabort>
	
	</cfif>

</cfif>

<cfif url.field eq "copy">

	<cfquery name="get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  * 
			FROM   userTransaction.dbo.FinalProduct_#session.acc#
			WHERE  WorkOrderItemid   = '#url.workorderItemId#'			
	</cfquery>	

	<cfquery name="getDefault" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  * 
			FROM   userTransaction.dbo.FinalProduct_#session.acc#
			WHERE  WorkOrderId   = '#get.workorderid#'
			AND    WorkOrderLine = '#get.workorderline#'
			AND    ItemNo        = '#get.ItemNo#'
			AND    asDefault = 1 			
	</cfquery>	
	
	<cfif getDefault.recordcount eq "1">
	
		<cfquery name="set" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE userTransaction.dbo.FinalProduct_#session.acc#
				SET Quantity = '#getDefault.quantity#', Price = '#getDefault.Price#', Memo = '#getDefault.Memo#'			
				WHERE  WorkOrderItemid   = '#url.workorderItemId#'			
		</cfquery>	
		
		<cfoutput>
		
		<script>
		document.getElementById('price_#url.workorderItemId#').value    = "#numberformat(getDefault.Price,",.__")#"
		document.getElementById('quantity_#url.workorderItemId#').value = "#numberformat(getDefault.Quantity,"__")#"	
		</script>
		
		</cfoutput>
	
	</cfif>

<cfelseif url.field eq "asDefault">
	
	<cfquery name="update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE userTransaction.dbo.FinalProduct_#session.acc#
			SET    #url.field# = 0				
	</cfquery>
	
	<cfquery name="update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE userTransaction.dbo.FinalProduct_#session.acc#
			SET    #url.field# = 1
			WHERE  WorkOrderItemId  = '#url.workorderItemid#'			
	</cfquery>

<cfelse>
	
	<cfquery name="update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE userTransaction.dbo.FinalProduct_#session.acc#
			SET    #url.field# = '#url.value#'
			WHERE  WorkOrderItemId  = '#url.workorderItemid#'			
	</cfquery>

</cfif>

<!--- now we also refresh the selections made --->

<cfoutput>

<script>   
	_cf_loadingtexthtml="";	
	ptoken.navigate('HalfProductSelected.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#','selecteditems')		
</script>	

</cfoutput>