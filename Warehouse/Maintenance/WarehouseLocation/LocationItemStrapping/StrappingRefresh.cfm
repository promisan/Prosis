
<cfparam name="url.redirect" default="1">

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

<cfquery name="warehouseLocation" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT 	* 
	FROM 	WarehouseLocation
	WHERE 	Warehouse = '#url.warehouse#'
	AND		Location = '#url.location#'
</cfquery>

<cfquery name="get" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT 	* 
	FROM 	ItemWarehouseLocation
	WHERE 	Warehouse = '#url.warehouse#'
	AND		Location = '#url.location#'
	AND		ItemNo = '#url.itemNo#'
	AND		UoM = '#url.uom#'
</cfquery>

<cfloop from="0" to="#get.StrappingScale#" index="measurement" step="#get.StrappingIncrement#">

	<cftry>
		
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
				 VALUES
				 	(
						'#url.warehouse#',
						'#url.location#',
						'#url.itemNo#',
						'#url.uom#',
						#measurement#,
						0,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
		</cfquery>
		
		<cfcatch></cfcatch>
	
	</cftry>

</cfloop>

<cfquery name="Strapping" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	ItemWarehouseLocationStrapping
	WHERE 	Warehouse = '#url.warehouse#'
	AND		Location = '#url.location#'
	AND		ItemNo = '#url.itemNo#'
	AND		UoM = '#url.uom#'
</cfquery>

<cfset cntStrap = 1>
<cfloop query="Strapping">
	
	<cfif cntStrap eq Strapping.recordcount>
		<cfquery name="update" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			UPDATE 	ItemWarehouseLocationStrapping
			SET		Quantity = #get.HighestStock#
			WHERE 	Warehouse = '#url.warehouse#'
			AND		Location = '#url.location#'
			AND		ItemNo = '#url.itemNo#'
			AND		UoM = '#url.uom#'
			AND		Measurement = '#Strapping.Measurement#'
		</cfquery>
	</cfif>
	<cfset cntStrap = cntStrap + 1>
</cfloop>


<cfif url.redirect eq 1>
	<cfoutput>
		<script>
			ColdFusion.navigate('../LocationItemStrapping/Strapping.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#','contentbox2');
		</script>
	</cfoutput>
</cfif>