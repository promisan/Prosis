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
			FROM 	ItemPriceSchedule 
			WHERE 	ItemNo = '#url.itemno#'
			AND		Mission = '#url.mission#'
	</cfquery>
	
	<cfloop query="Schedule">
	
		<cfloop query="Currency">
		
			<cfif isDefined("Form.cb_#Schedule.code#_#Currency.Currency#")>
			
				<cfquery name="insert" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO ItemPriceSchedule 
							(
								ItemNo,
								Mission,
								PriceSchedule,
								Currency,
								Operational,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName
							)
						VALUES
							(
								'#url.itemno#',
								'#url.mission#',
								'#Schedule.code#',
								'#Currency.currency#',
								1,
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#'
							)
				</cfquery>
			
			</cfif>
		
		</cfloop>
	
	</cfloop>
	
	<cfif isDefined("Form.inherit") or isDefined("Form.sync")>
		<cfinclude template="ItemPriceShceduleInherit.cfm">
	</cfif>

</cftransaction>

<cfoutput>
	<script>
		ColdFusion.navigate('PriceSchedule/ItemPriceScheduleDetailForm.cfm?itemNo=#url.itemno#&mission=#url.mission#','divItemPriceSchedule');
	</script>
</cfoutput>