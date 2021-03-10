<cfset dateValue = "">
<cf_dateConvert value="#form.dateeffective#">
<cfset vDateEffective = dateValue>

<cftransaction>

	<cfquery name="delete" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE
			FROM	CustomerSchedule
			WHERE	CustomerId = '#url.CustomerId#'
			AND		DateEffective = #vDateEffective#
	</cfquery>
	
	<cfquery name="customer" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM	Customer
			WHERE	CustomerId = '#url.CustomerId#'			
	</cfquery>
	
	<cfquery name="getmission" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT DISTINCT Mission
			FROM   WarehouseBatch
			WHERE CustomerId = '#url.CustomerId#'			
	</cfquery>
	
	<cfquery name="categories" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT R.TabOrder,
					R.Category, 
					R.Description,
					(	SELECT 	PriceSchedule
						FROM	CustomerSchedule
						WHERE	CustomerId = '#url.CustomerId#'
						AND		Category = R.Category
						AND		DateEffective = #vDateEffective#
					) AS Selected
			FROM   Ref_Category R
			WHERE  R.Category IN (SELECT WC.Category
			                      FROM   Warehouse W INNER JOIN WarehouseCategory WC ON W.Warehouse = WC.Warehouse
								  WHERE  W.Mission IN ('#customer.Mission#'<cfif getMission.recordcount gte "1">,#quotedValueList(getMission.Mission)#</cfif>)
								)
			AND	   R.Operational = 1
			AND    R.FinishedProduct = 1				   			
			ORDER BY R.TabOrder			
	</cfquery>
	
	<cfloop query="categories">
	
		<cfif isDefined("Form.PriceSchedule_#trim(Category)#")>
		
			<cfset vPriceSchedule = evaluate("Form.PriceSchedule_#trim(Category)#")>
			
			<cfif vPriceSchedule neq "">
			
				<cfquery name="insert" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO CustomerSchedule
							(
								CustomerId,
								Category,
								DateEffective,
								PriceSchedule,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName
							)
						VALUES
							(
								'#url.CustomerId#',
								'#Category#',
								#vDateEffective#,
								'#vPriceSchedule#',
								'#session.acc#',
								'#session.last#',
								'#session.first#'
							)
				</cfquery>
				
			</cfif>
			
		</cfif>
		
	</cfloop>

</cftransaction>


<cfoutput>
	<script>
		ColdFusion.navigate('#session.root#/Warehouse/Application/Customer/PriceSchedule/RecordListing.cfm?customerId=#url.customerId#&mission=#url.mission#','contentbox3');
	</script>
</cfoutput>