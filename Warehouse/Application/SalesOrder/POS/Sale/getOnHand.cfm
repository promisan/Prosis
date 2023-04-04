<!--- set stock --->

<cfparam name="url.itemStock" default="0">
<cfparam name="url.action" default="">

<cfquery name="get"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   vwCustomerRequest
	WHERE  TransactionId = '#url.id#'		
</cfquery>

<cfquery name="Item"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   * 			 				 
		FROM     Item								
		WHERE    ItemNo = '#get.ItemNo#' 				
</cfquery>

<cf_precision number="#Item.ItemPrecision#">

<cfif url.itemStock eq "0">

	<cfquery name="getStock" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		    SELECT    ROUND(SUM(TransactionQuantity),#Item.ItemPrecision#) as OnHand
			FROM      ItemTransaction
			WHERE     Warehouse       = '#get.warehouse#'
			AND       ItemNo          = '#get.ItemNo#'
			AND       TransactionUoM  = '#get.TransactionUoM#'
			<!--- added the transactionlot --->   	
			AND       TransactionLot  = '#get.TransactionLot#'						   		      
	</cfquery>
	
	<cfset itemStock = getStock.onHand>

	<cfquery name="getStockEntity" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		    SELECT    ROUND(SUM(TransactionQuantity),#Item.ItemPrecision#) as OnHand
			FROM      ItemTransaction
			WHERE     Mission         = '#get.Mission#'
			AND       ItemNo          = '#get.ItemNo#'
			AND       TransactionUoM  = '#get.TransactionUoM#'			
	</cfquery>
	
	<cfset itemEntityStock = getStockEntity.onHand>

<cfelse>

	<cfset itemStock = url.itemStock>
	<cfset itemEntityStock = url.itemStock>
	
</cfif>

<cfoutput>

<cfif get.ItemClass eq "Service" or (itemStock gte get.TransactionQuantity and get.TransactionQuantity gt 0)>
	
	<script>
		document.getElementById('line_#url.line#').className = "labelmedium line"
	</script>
	
	<cfif get.ItemClass eq "Service">
		-
	<cfelse>
		#numberformat(itemStock,'#pformat#')#				
	</cfif>	
	
	<cfif url.action eq "quantity">
	
	<cfquery name="clearTransfer" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		    DELETE    
			FROM      CustomerRequestLineTransfer
			WHERE     TransactionId  = '#get.TransactionId#'
	  </cfquery>
	  
	  </cfif>

<cfelse>
	
	<script>
		document.getElementById('line_#url.line#').className = "labelmedium line highlight3"
	</script>
		
	<font color="FF0000">#numberformat(itemStock,'#pformat#')#</font>	
	
	<cfif (itemEntityStock gte get.TransactionQuantity and get.TransactionQuantity gt 0)>
	
		<span class="clsNoPrint clsDetailLineCell" id="transfer_#get.transactionid#" style="padding-bottom:2px;min-width:200px"></span>	
		
			<button style="width:90px;height:29px;font-size:13px!important;background:##f8f9fa;;border:1px solid gray" 
				type="button" id="btransfer_#url.line#" name="btransfer_#url.line#" onclick="salesTransfer('#URL.id#','#URL.warehouse#')">
			     <cf_tl id="Transfer"><i class="fas fa-share-square"></i>
			</button>
		
	<cfelse>
	
		<!--- we clean any possible requested transfers --->
		
		<cfif url.action eq "quantity">
		
			<cfquery name="clearTransfer" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				    DELETE    
					FROM      CustomerRequestLineTransfer
					WHERE     TransactionId  = '#get.TransactionId#'
			  </cfquery>
		  
		  </cfif>
	
	</cfif>

</cfif>

</cfoutput>