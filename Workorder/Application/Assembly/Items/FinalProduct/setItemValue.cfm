
<!--- set item value --->

<cfif url.field neq "Memo" and url.field neq "asDefault" and url.field neq "Copy">

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
				SET    Quantity   = '#getDefault.quantity#', 
				       Price      = '#getDefault.Price#', 
					   Memo       = '#getDefault.Memo#'			
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
	ptoken.navigate('FinalProductSelected.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#','selecteditems')		
</script>	

</cfoutput>