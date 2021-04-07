
<!--- set location to --->

<!--- if the warehouse is the same allow to not change the location or to set a location, 
 if the warehouse is different enforce the selection of the location. --->
 
<cfparam name="url.warehouse" default="">
  
<cfquery name="Location" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM       WarehouseLocation
			WHERE      Warehouse = '#url.warehouse#'
			AND        Operational = '1'
			ORDER BY   ListingOrder
</cfquery>

<cfoutput>		
						
	<select name="location" id="location"
	    class="regularxxl" style="width:250px">		
		<cfloop query="Location">
			<option value="#Location#">#Description#</option>
		</cfloop>
	</select>	
			
</cfoutput>	


