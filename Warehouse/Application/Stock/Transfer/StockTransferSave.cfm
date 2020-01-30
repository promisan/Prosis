<!--- get location data --->

<cfoutput>

<cfparam name="itemuomid" default="">

<cfif url.itemuomid neq "">

	<cfquery name="getUoM"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  * 
		FROM    ItemUoM	
		WHERE   ItemUoMId = '#URL.ItemUoMId#'
	</cfquery>

</cfif>

<cfif url.quantity eq "" or url.warehouse eq "">

   <font color="FF0000"><cf_tl id="Error"></font>
   <cfabort>

</cfif>

<cfif not IsNumeric(URL.quantity)>

  <font color="FF0000"><b>#URL.quantity#</font>
  
<cfelse>  
	
	<cftransaction>
				
	<cfset dateValue = "">
	<cfif url.date neq "" and url.date neq "undefined">
		<CF_DateConvert Value="#url.date#">
		<cfset DTE = dateValue>
		
		<cfset dte = DateAdd("h","#url.hour#", dte)>
		<cfset dte = DateAdd("n","#url.minute#", dte)>
	</cfif>	
						
	<cfquery name="Update"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE userTransaction.dbo.Transfer#URL.Whs#_#SESSION.acc#
			SET    TransferQuantity  = '#URL.quantity#', 
				  <cfif url.itemuomid neq "">
					   TransferItemNo    = '#getUoM.ItemNo#',
					   TransferUoM       = '#getUoM.UoM#',				   
				   </cfif>
				   <cfif url.date neq "" and url.date neq "undefined">
				   TransactionDate   = #dte#,
				   <cfelse>
				   TransactionDate   = #now()#,
				   </cfif>
			       TransferWarehouse = '#URL.Warehouse#',
			       TransferLocation  = '#URL.Location#',
				   MeterName         = '#URL.meter#', 
				   MeterInitial      = '#URL.initial#',
				   MeterFinal        = '#URL.final#', 
				   TransferMemo      = '#URL.Memo#'
			WHERE  TransactionId = '#URL.Id#'
			
	</cfquery>

	<cfquery name="UpdateItemPrecision"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE userTransaction.dbo.Transfer#URL.Whs#_#SESSION.acc#
			SET    TransferQuantity  	= ROUND(TransferQuantity,ItemPrecision), 
				   Quantity 			= ROUND(Quantity,ItemPrecision)
			WHERE  TransactionId = '#URL.Id#'
			
	</cfquery>
		
		<cfquery name="check"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  * 
			FROM    userTransaction.dbo.Transfer#URL.Whs#_#SESSION.acc#		
			WHERE   TransactionId = '#URL.Id#'
		</cfquery>
		
		<cfif check.quantity lte "0">
		
			<script>
				alert("You may not transfer once the existing book stock falls below ZERO!. Transaction aborted.")
				ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/Transfer/StockTransfer.cfm?mode=delete&warehouse=#url.whs#&id=#url.id#','transfer#url.id#')
			</script>	
			
			<cfquery name="Correction"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE userTransaction.dbo.Transfer#URL.Whs#_#SESSION.acc#
				SET    TransferQuantity = 0 
				WHERE  TransactionId = '#URL.Id#'
			</cfquery>
					 
		<cfelseif check.TransferQuantity gt check.Quantity>
		
			<script>
				alert("Transfer quantity exceeds the available quantity !. Quantity will be reset to maximum quantity.")
				document.getElementById('transferquantity#url.id#').value = '#check.quantity#'
			</script>	
			
			<cfquery name="Correction"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE userTransaction.dbo.Transfer#URL.Whs#_#SESSION.acc#
				SET    TransferQuantity = Quantity 
				WHERE  TransactionId = '#URL.Id#' and TransferQuantity > Quantity
			</cfquery>
				
		</cfif>
						
	</cftransaction>
	
	<cf_img icon="delete"  onclick="ptoken.navigate('#SESSION.root#/warehouse/application/stock/Transfer/StockTransfer.cfm?mode=delete&warehouse=#url.whs#&id=#url.id#','transfer#url.id#')">			
				 
	<script language="JavaScript">
		    try {
			document.getElementById("save").className = "regular" } catch(e) {}
	</script> 
			
</cfif>

</cfoutput>



