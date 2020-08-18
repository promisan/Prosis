<!--- Get items for which oversale is not allowed --->

<!--- Make transfers requested for this sale --->

<cf_tl id="Error: oversale is not enabled for this category." var="lOversale">
<cf_tl id="Not enough stock for item:" var="lOversaleItem">

<cftransaction>
	
	<!--- we apply the the transfer to see if we have enough --->
	
	<cfinclude template="doTransfer.cfm">
		
	<cfquery name="getLines"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   S.Mission,
			         S.Warehouse,
			         ItemNo, 
					 TransactionUoM, 
					 TransactionLot, 
					 SUM(TransactionQuantity) AS Quantity
			FROM     vwCustomerRequest S
					 INNER JOIN WarehouseCategory WC	ON WC.Warehouse = S.Warehouse AND WC.Category = S.ItemCategory AND (WC.Oversale = 0 OR WC.SelfService = 0)
			WHERE    S.RequestNo = '#url.RequestNo#'			
			AND      S.ItemClass   = 'Supply'
			GROUP BY S.Warehouse,Mission,ItemNo, TransactionUoM, TransactionLot
	</cfquery>	
	
	<!--- Check if there is stock available for those items to be sold --->
	
	<cfloop query="getLines">
			
		<cfquery name="batch"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM    Materials.dbo.WarehouseBatch
				<cfif url.batchId neq "">
				WHERE   BatchId = '#url.batchId#'
				<cfelse>
				WHERE   1=0
				</cfif>		
		</cfquery>		
		
		<cfinvoke component = "Service.Process.Materials.Stock"  
		   method           = "getStock" 
		   Mission			= "#getLines.Mission#"
		   warehouse        = "#url.Warehouse#" 							  
		   ItemNo           = "#getLines.ItemNo#"
		   UoM              = "#getLines.TransactionUoM#"		
		   TransactionLot   = "#getLines.TransactionLot#"		
		   ExcludeBatchNo   = "#batch.batchno#"			  
		   returnvariable   = "stock">							
			
		<cfif getLines.Quantity gt stock.onhand>
	
			<cfquery name="getItem" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">			
					SELECT I.ItemDescription, 
					       UoM.ItemBarCode,
						   UoM.UoMCode
					FROM   Materials.dbo.Item I WITH(NOLOCK) INNER JOIN Materials.dbo.ItemUoM UoM WITH(NOLOCK) ON I.ItemNo = UoM.ItemNo AND UoM.UoM= '#getLines.TransactionUoM#'
					WHERE  I.ItemNo =  '#getLines.ItemNo#'
			</cfquery>
	
			<cfoutput>				
				<script>
				    
					alert("#lOversale# #lOversaleItem# #getLines.ItemNo# - #getItem.ItemBarCode# - #getItem.UoMCode# - #getItem.ItemDescription#");					
					try { ProsisUI.closeWindow('wsettle',true)} catch(e){};
				</script>		
				<cfabort>
			</cfoutput>
			 
		</cfif>
	
	</cfloop>

</cftransaction>

