<!--
    Copyright © 2025 Promisan B.V.

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
					'O - ')
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
					'O - '
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