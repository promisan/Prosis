<cfquery name="Schedule" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_PriceSchedule
</cfquery>

<cfquery name="Currency" 
	datasource="appsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Currency
		WHERE	EnableProcurement = 1
		AND		Operational = 1 
</cfquery>

<cftransaction>

	<cfquery name="clear" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE
			FROM 	WarehouseCategoryPriceSchedule 
			WHERE 	Warehouse = '#url.warehouse#'
			AND		Category = '#url.category#'
	</cfquery>
	
	<cfloop query="Schedule">
	
		<cfloop query="Currency">
		
			<cfif isDefined("Form.cb_#Schedule.code#_#Currency.Currency#")>
			
				<cfset vCostPriceMultiplier = Evaluate("Form.CostPriceMultiplier_#Schedule.code#_#Currency.Currency#")>
				<cfset vCostPriceMultiplier = replace(vCostPriceMultiplier,",","","ALL")>
				
				<cfset vCostPriceCeiling = Evaluate("Form.CostPriceCeiling_#Schedule.code#_#Currency.Currency#")>
				<cfset vCostPriceCeiling = replace(vCostPriceCeiling,",","","ALL")>
			
				<cfquery name="insert" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO WarehouseCategoryPriceSchedule 
							(
								Warehouse,
								Category,
								PriceSchedule,
								Currency,
								CostPriceMultiplier,
								CostPriceCeiling,
								Operational,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName
							)
						VALUES
							(
								'#url.warehouse#',
								'#url.category#',
								'#Schedule.code#',
								'#Currency.currency#',
								#vCostPriceMultiplier#,
								#vCostPriceCeiling#,
								1,
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#'
							)
				</cfquery>
			
			</cfif>
		
		</cfloop>
	
	</cfloop>

</cftransaction>

<cfoutput>
	<script>
		ColdFusion.navigate('Category/PriceSchedule/PriceScheduleForm.cfm?warehouse=#url.warehouse#&category=#url.category#','divWHPriceSchedule');
	</script>
</cfoutput>