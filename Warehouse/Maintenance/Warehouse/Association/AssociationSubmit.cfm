
<cftransaction>


	<cfquery name="getMission" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Warehouse
			WHERE	Warehouse = '#url.warehouse#'
	</cfquery>

	<cfquery name="listing" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	SELECT 	*
	    	FROM 	Warehouse
			WHERE	Operational = 1
			AND		Warehouse != '#url.warehouse#'
			AND		Mission = '#getMission.mission#'
	</cfquery>
	
	<cfquery name="clean" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	DELETE
	    	FROM 	WarehouseAssociation
			WHERE	Warehouse = '#url.warehouse#'
			AND		AssociationType = '#url.type#'
	</cfquery>
	
	<cfloop query="listing">
		<cfif isDefined("Form.cb_#warehouse#")>
			<cfset vWA = evaluate("Form.cb_#warehouse#")>
			<cfquery name="insert" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    	INSERT INTO WarehouseAssociation
						(
							Warehouse,
							AssociationType,
							AssociationWarehouse,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
					VALUES
						(
							'#url.warehouse#',
							'#url.type#',
							'#warehouse#',
							'#session.acc#',
							'#session.last#',
							'#session.first#'
						)
			</cfquery>
		</cfif>
	</cfloop>

</cftransaction>

<cfoutput>
	<script>
		ColdFusion.navigate('Association/AssociationListingDetail.cfm?warehouse=#url.warehouse#&type=#url.type#','divAssociation');
	</script>
</cfoutput>