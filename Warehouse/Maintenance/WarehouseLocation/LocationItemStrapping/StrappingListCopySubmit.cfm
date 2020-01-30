
<cfif isDefined("form.StrappingTable")>

	<cfquery name="clear" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		DELETE 
		FROM 	ItemWarehouseLocationStrapping
		WHERE 	Warehouse = '#url.warehouse#'
		AND		Location = '#url.location#'
		AND		ItemNo = '#url.itemNo#'
		AND		UoM = '#url.uom#'
	</cfquery>
	
	<cfquery name="insert" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">		 		 	  
			 INSERT INTO ItemWarehouseLocationStrapping
			 	(
					Warehouse,
					Location,
					ItemNo,
					UoM,
					Measurement,
					Quantity,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName
				)
			 SELECT
			 		'#url.warehouse#',
					'#url.location#',
					'#url.itemNo#',
					'#url.uom#',
					S.measurement,
					S.quantity,
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#'
			FROM	ItemWarehouseLocation L
					INNER JOIN ItemWarehouseLocationStrapping S
						ON 		L.Warehouse = S.Warehouse
						AND		L.Location = S.Location
						AND		L.ItemNo = S.ItemNo
						AND		L.UoM = S.UoM
			WHERE	ItemLocationId = '#form.StrappingTable#'
	</cfquery>
	
	
	<cfoutput>
		<script>
			ColdFusion.Window.hide('StrappingCopy');
			ColdFusion.navigate('../LocationItemStrapping/Strapping.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#&showOpenST=1','contentbox2');		
		</script>
	</cfoutput>

</cfif>