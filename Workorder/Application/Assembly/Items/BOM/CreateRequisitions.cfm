
<cfparam name="FORM.ListId" default="">

<cfif Form.ListId neq "">

	<cfloop list="#Form.ListId#" index="list">
		<cfset item = Replace(List,"'","","all")>
		<cfset id   = Replace(Item,"-","","all")>
		<cfset value = Evaluate("FORM.listQty_#id#")>
		<cfset value = Replace(value,",","","all")>
		<cfset value = Replace(value," ","","all")>
		
		<cfquery name="List" datasource="AppsQuery" >
			UPDATE UserQuery.dbo.itemList#SESSION.acc#_#URL.fileno#
			SET    Quantity = '#Value#'
			WHERE  ListId='#Item#' 
		</cfquery>	
	
	</cfloop>

	<cfquery name="List" datasource="AppsQuery" >
			SELECT * 
			FROM UserQuery.dbo.itemList#SESSION.acc#_#URL.fileno#
			WHERE ListId in (#PreserveSingleQuotes(Form.ListId)#) 
	</cfquery>
	
<cfelse>

	<cfquery name="List" datasource="AppsQuery" >
			SELECT TOP 1 * 
			FROM UserQuery.dbo.itemList#SESSION.acc#_#URL.fileno#
	</cfquery>
</cfif>

<cfset URL.WorkOrderId   = List.workorderid>
<cfset URL.WorkOrderLine = List.workorderline>

<cfquery name="WorkOrder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *  
		FROM     Workorder W,WorkOrderLine WL, 
		         ServiceItemMission S
		WHERE    W.WorkOrderId    = WL.WorkOrderId
		AND      W.ServiceItem    = S.ServiceItem
		AND      S.Mission        = W.Mission
		AND      WL.WorkOrderId   = '#URL.workorderid#' 
		AND      WL.WorkOrderLine = '#URL.workorderline#'
</cfquery>	

<cfset URL.Mission  = WorkOrder.Mission>
<cfset URL.Category = List.Category>

<cfif FORM.ListId neq "">

<cftransaction>

<cfloop query="List">
	
	<cfif Quantity gte "0">
		
		<!----
			Removed by Armin 4/21/2014
		<cfset qty = Quantity-Procurement>
		---->
		
		<cfset qty = Quantity>
		
		<cfif WorkOrder.ProcurementMode eq "0">
		
			<!--- define the correct minimum quantity --->
			
			<cfquery name="Replenish" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Materials.dbo.ItemWarehouse
				WHERE    ItemNo = '#ResourceItemNo#' 
				AND      UoM    = '#ResourceUoM#'
				AND      Warehouse IN (SELECT     TOP 1 Warehouse
				                       FROM       Materials.dbo.Warehouse
				                       WHERE      Mission = '#workorder.Mission#'
				                       ORDER BY   WarehouseDefault DESC)
		    </cfquery>
		
			<cfif replenish.recordcount eq "1" and Replenish.MinReorderQuantity gt "0">
			
				<cfset ratio = ceiling(qty/Replenish.MinReorderQuantity)>
				<cfset qty   = ratio * Replenish.MinReorderQuantity>
			
			</cfif>
			
			<cfif qty gte "1">
			
				<!--- create requisitions --->
				
				<cfif ItemClass eq "Supply">
				
					<!--- supply stock item --->		
				
					<cf_RequisitionEntryLine
						mission          = "#workorder.Mission#"
						orgunit          = "#workorder.OrgUnitImplementer#"
						WorkorderId      = "#url.workorderid#"
						WorkorderLine    = "#url.workorderline#"
						RequirementId    = "#Resourceid#" 
						WarehouseItemNo  = "#ResourceItemNo#"
						WarehouseUoM     = "#ResourceUoM#"
						RequestDescription = "#ItemDescription# #ResourceReference#"
						RequestQuantity  = "#qty#"
						RequestCostPrice = "#costprice#">
				
				<cfelse>
				
					<!--- service item --->		
									
					<cf_RequisitionEntryLine
						mission            = "#workorder.Mission#"
						orgunit            = "#workorder.OrgUnitImplementer#"
						RequirementId      = "#Resourceid#"
						WorkorderId        = "#url.workorderid#"
						WorkorderLine      = "#url.workorderline#"
						RequestDescription = "#ItemDescription# #ResourceReference#"
						QuantityUoM        = "#UoMDescription#"
						Remarks            = "#Memo#"
						ItemMaster         = "#ItemMaster#"					
						RequestQuantity    = "#qty#"
						RequestCostPrice   = "#costprice#">
					
				</cfif>	
					
			</cfif>	
		
		<cfelse>
											
			<cfif qty gt OnHand>
						
				<cfset qty = qty - onhand>			
				
				<cfquery name="Replenish" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     Materials.dbo.ItemWarehouse
					WHERE    ItemNo = '#ResourceItemNo#' 
					AND      UoM    = '#ResourceUoM#'
					AND      Warehouse IN
			                          (SELECT   TOP 1 Warehouse
			                           FROM     Materials.dbo.Warehouse
			                           WHERE    Mission = '#workorder.Mission#'
			                           ORDER BY WarehouseDefault DESC)
			    </cfquery>
			
				<cfif replenish.recordcount eq "1" and Replenish.MinReorderQuantity gt "0">
				
					<cfset ratio = ceiling(qty/Replenish.MinReorderQuantity)>
					<cfset qty   = ratio * Replenish.MinReorderQuantity>
				
				</cfif>			
						
				<!--- create requisitions --->
				
				<!--- create requisitions --->
				
				<cfif ItemClass eq "Supply">
				
					<!--- supply stock item --->		
				
					<cf_RequisitionEntryLine
						mission          = "#workorder.Mission#"
						orgunit          = "#workorder.OrgUnitImplementer#"
						WorkorderId      = "#url.workorderid#"
						WorkorderLine    = "#url.workorderline#"
						RequirementId    = "#Resourceid#" 
						RequestType      = "Warehouse"
						WarehouseItemNo  = "#ResourceItemNo#"
						WarehouseUoM     = "#ResourceUoM#"
						RequestQuantity  = "#qty#"
						RequestCostPrice = "#costprice#">
				
				<cfelse>
				
					<!--- service item --->		
									
					<cf_RequisitionEntryLine
						mission            = "#workorder.Mission#"
						orgunit            = "#workorder.OrgUnitImplementer#"
						RequirementId      = "#Resourceid#"
						WorkorderId        = "#url.workorderid#"
						WorkorderLine      = "#url.workorderline#"
						RequestDescription = "#ItemDescription# #ResourceReference#"
						QuantityUoM        = "#UoMDescription#"
						RequestType        = "Regular"
						Remarks            = "#Memo#"
						ItemMaster         = "#ItemMaster#"					
						RequestQuantity    = "#qty#"
						RequestCostPrice   = "#costprice#">
					
				</cfif>	
							
				<!--- do we need to define the funding : requisitionline funding or will this be picked up by the user (yes) --->			
			
			</cfif>
			
		</cfif>	
	
	</cfif>

</cfloop>

</cftransaction>	

	<!--- refresh the bom listing --->
	<cfinclude template="ItemListingContent.cfm">
	
	<cfquery name="get" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ModuleControl
		WHERE    SystemModule = 'Procurement' 
		AND      FunctionClass = 'Application' AND (FunctionName = 'Requisition Management')
	</cfquery>	
	
		
	<cfoutput>
		<script>		
		 	ptoken.open("#SESSION.root#/Procurement/Application/Requisition/RequisitionView/RequisitionView.cfm?mission=#workorder.mission#&systemfunctionid=#get.systemfunctionid#&workorderid=#url.workOrderId#",  "req", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");
		</script>
	</cfoutput>


<cfelse>
		<!--- refresh the bom listing --->
		<cfinclude template="ItemListingContent.cfm">	
		<script>
				alert("You must select a line to process");
		</script>
		
</cfif>					

	
	

