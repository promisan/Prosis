

<!--- Determine if exists new Rates begining today --->

<cfquery name="ServiceItemUnitMission" 
	datasource="NovaWorkOrder" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	
	SELECT *
	FROM ServiceItemUnitMission
	WHERE  ServiceItem IN (
		SELECT Code
		FROM ServiceItem
		WHERE Operational = 1)
	AND DateAdd(day, DateDiff(day, 0, DateEffective), 0) = '2014-01-01' <!---= DateAdd(day, DateDiff(day, 0, getdate()), 0)--->
	AND ServiceItem ='WO201'
	AND ServiceItemUnit='RTU1'

</cfquery>


<!--- Loop through the new rates --->
<cfloop query ="ServiceItemUnitMission">

	<!--- Get the active billing records for the rate --->
	<cfquery name="WorkOrderLineBilling" 
		datasource="NovaWorkOrder" 
		username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		
		SELECT *
		FROM WorkOrderLineBilling B
		WHERE ((B.BillingExpiration IS NULL) OR (B.BillingExpiration > DateAdd(day, DateDiff(day, 0, getdate()), 0)))
		AND EXISTS (
			SELECT *
			FROM WorkOrderLineBillingDetail D 
			WHERE B.WorkOrderId = D.WorkOrderId 
			AND B.WorkOrderLine = D.WorkOrderLine 
			AND B.BillingEffective = D.BillingEffective
			AND D.ServiceItem = '#ServiceItemUnitMission.ServiceItem#'
			AND D.ServiceItemUnit = '#ServiceItemUnitMission.ServiceItemUnit#')
	
	</cfquery>
	
	<cfloop query ="WorkOrderLineBilling">
	
		<!--- Check that the billing period does not exist --->
		<cfquery name="CheckBilling" 
			datasource="NovaWorkOrder" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT *
			FROM WorkOrderLineBilling
			WHERE WorkOrderId = '#WorkOrderLineBilling.WorkOrderId#'
			AND WorkOrderLine = '#WorkOrderLineBilling.WorkOrderLine#'
			AND BillingEffective = '#ServiceItemUnitMission.DateEffective#'
		</cfquery>
		
		<cfif CheckBilling.recordcount eq "0">
		
			<!--- Create New billing record --->
			<cfquery name="NewBilling" 
				datasource="NovaWorkOrder" 
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			
				INSERT INTO WorkOrderLineBilling (
					WorkOrderId,
					WorkOrderLine,
					BillingEffective,
					BillingExpiration,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName) 
				VALUES (
					'#WorkOrderLineBilling.WorkOrderId#',
					'#WorkOrderLineBilling.WorkOrderLine#',
					'#ServiceItemUnitMission.DateEffective#',
					'#ServiceItemUnitMission.DateExpiration#',
					'administrator',
					'NOVA Administrator',
					'OICT - ')								
			</cfquery>
	
	
			<!--- create Billing Details for the new billing period --->		
			<cfquery name="NewBillingDetails" 
				datasource="NovaWorkOrder" 
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
	
				INSERT INTO WorkOrderLineBillingDetail (
					WorkOrderId,
					WorkOrderLine,
					BillingEffective,
					ServiceItem,
					ServiceItemUnit,
					Frequency,
					BillingMode,
					Charged,
					Quantity,
					Currency,
					Rate,
					Operational,				
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName) 
								
				SELECT	WorkOrderId,
						WorkOrderLine,
						'#ServiceItemUnitMission.DateEffective#',
						ServiceItem,
						ServiceItemUnit,
						Frequency,
						BillingMode,
						Charged,
						Quantity,
						Currency,
						CASE ServiceItemUnit
							WHEN '#ServiceItemUnitMission.ServiceItemUnit#' THEN
								CASE 
									WHEN Rate > #ServiceItemUnitMission.StandardCost# THEN Rate
								ELSE #ServiceItemUnitMission.StandardCost#
								END 
							ELSE
								Rate
						END AS Rate,
						1 AS Operational,
					'administrator',
					'NOVA Administrator',
					'OICT - '																		
				FROM WorkOrderLineBillingDetail
				WHERE WorkOrderId = '#WorkOrderLineBilling.WorkOrderId#'
				AND WorkOrderLine = '#WorkOrderLineBilling.WorkOrderLine#'
				AND BillingEffective = '#WorkOrderLineBilling.BillingEffective#'
				AND ServiceItem = '#ServiceItemUnitMission.ServiceItem#'
<!---				AND ServiceItemUnit = '#ServiceItemUnitMission.ServiceItemUnit#'--->
				
			</cfquery>
		
		</cfif>
		
		<!--- Expire the old billing period --->		
		<cfquery name="OldBilling" 
			datasource="NovaWorkOrder" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		
			UPDATE WorkOrderLineBilling
			SET    BillingExpiration = DateAdd(day, DateDiff(day, 0, getdate()-1), 0)
			WHERE  WorkOrderId = '#WorkOrderLineBilling.WorkOrderId#'
			AND    WorkOrderLine = '#WorkOrderLineBilling.WorkOrderLine#'
			AND    BillingEffective = '#WorkOrderLineBilling.BillingEffective#'
			
		</cfquery>	
		
	</cfloop>		
</cfloop>