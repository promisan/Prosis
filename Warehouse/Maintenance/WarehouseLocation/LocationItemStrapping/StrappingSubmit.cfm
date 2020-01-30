
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

<cfquery name="getItem" 
     datasource="AppsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     *
	 FROM       ItemWarehouseLocation 
	 WHERE		Warehouse = '#url.warehouse#'
	 AND       	Location = '#url.location#'		
	 AND		ItemNo = '#url.itemNo#'
	 AND		UoM = '#url.UoM#'
</cfquery>

<cfset strapRelation = 0>
<cfif getItem.strappingIncrementMode eq "Capacity">
	<cfset strapRelation = getItem.highestStock>
</cfif>
<cfif getItem.strappingIncrementMode eq "Strapping">
	<cfset strapRelation = getItem.StrappingScale>
</cfif>

<cfloop from="0" to="#strapRelation#" index="measurement" step="#getItem.strappingIncrement#">

	<cfif isDefined("Form.Quantity#measurement#") and isDefined("Form.Measurement#measurement#")>

		<cfset vQuantity = replace(evaluate("Form.Quantity#measurement#"), ',', '', 'ALL')>
		<cfset vMeasurement = replace(evaluate("Form.Measurement#measurement#"), ',', '', 'ALL')>
		
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
							#vMeasurement#,
							#vQuantity#,
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#'
						)
			</cfquery>
		
			<cfcatch></cfcatch>
		</cftry>
	
	</cfif>

</cfloop>

<cfoutput>
	<script>
		ColdFusion.Window.hide('StrappingEdit');
		ColdFusion.navigate('../LocationItemStrapping/Strapping.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#&showOpenST=1','contentbox2');		
	</script>
</cfoutput>