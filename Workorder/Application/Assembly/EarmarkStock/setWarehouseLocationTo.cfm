
<!--- set location to --->

<!--- if the warehouse is the same allow to not change the location or to set a location, 
 if the warehouse is different enforce the selection of the location. --->
 
<cfparam name="url.warehouse" default="">
<cfparam name="url.warehouseto" default="">
  
<cfquery name="Location" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM       WarehouseLocation
		WHERE      Warehouse = '#url.warehouseto#'
		AND        Operational = '1'
		ORDER BY   ListingOrder
</cfquery>

<cfoutput>					
						
	<select name="locationto" id="locationto"
	    class="regularxl" style="font-size:15px;height:36px;width:250px">
		<cfif url.warehouse eq url.warehouseto>
		  <option value="" selected><cf_tl id="Do not change"></option>		
		</cfif>
		<cfloop query="Location">
			<option value="#Location#">#Description#</option>
		</cfloop>
	</select>	
			
</cfoutput>	


