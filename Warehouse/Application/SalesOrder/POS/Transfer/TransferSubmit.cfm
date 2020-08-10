<cfquery name="get"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   vwCustomerRequest  
	WHERE  TransactionId = '#form.transactionid#'		
</cfquery>

<cfquery name="ItemList" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT 	 IW.* 					
			FROM     ItemWarehouseLocation IW 
					 INNER JOIN Warehouse W ON IW.Warehouse = W.Warehouse 
			WHERE    W.Mission     = '#Get.mission#'
			AND      IW.ItemNo     = '#Get.itemno#'
			AND      IW.UoM        = '#Get.TransactionUoM#'
			AND      IW.Warehouse != '#Get.Warehouse#'
			AND      IW.Operational = 1
			AND      W.Operational  = 1
			-- AND      SaleMode       = '2'			 			
</cfquery>

<cfquery name="clear" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM CustomerRequestLineTransfer
	WHERE Transactionid = '#get.TransactionId#' 				   			
</cfquery>

<cfloop query="ItemList">

	<cfparam name           = "transferquantity#itemNo#_#Warehouse#_#Location#_#UoM#"    default="">
	<cfparam name           = "transactionquantity#itemNo#_#Warehouse#_#Location#_#UoM#" default="">
	
	<cfset valueTransfer    = evaluate("transferquantity#ItemNo#_#Warehouse#_#Location#_#UoM#")>
	<cfset valueTransfer    = replace(valueTransfer,",","","all")> 
	
	<cfset valueTransaction = evaluate("transactionquantity#ItemNo#_#Warehouse#_#Location#_#UoM#")>
	<cfset valueTransaction = replace(valueTransaction,",","","all")>
	
	<cfif valueTransaction gte valueTransfer>
		<cfset valuetransfer = valueTransaction>
	</cfif>
	
	<cfif valueTransfer neq "" and valueTransaction neq "0">
				
		<cfquery name="Insert" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO CustomerRequestLineTransfer ( 				   
						TransactionId, 
						Warehouse,
						Location,
						ItemNo,
						TransactionUoM,
						TransactionLot,
						TransactionTransfer,
						TransactionQuantity, 	
						TransactionLocation,					
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName ) 							
				VALUES ('#get.TransactionId#',
						'#Warehouse#', 
						'#Location#', 
						'#ItemNo#',
						'#UoM#', 
						'0',
						'#ValueTransfer#',
						'#ValueTransaction#',
						'#Form.LocationTo#', 						
						'#session.acc#',
						'#session.last#',
						'#session.first#' )		  
			</cfquery>
				
	</cfif>			
 		
</cfloop>

<cfoutput>
<script>
	ProsisUI.closeWindow('wtransfer');
	_cf_loadingtexthtml='';
	ptoken.navigate('#SESSION.root#/Warehouse/Application/salesOrder/POS/Transfer/setTransfer.cfm?warehouse=#url.warehouse#&transactionid=#get.transactionid#','transfer_#get.transactionid#')
</script>	
</cfoutput>


