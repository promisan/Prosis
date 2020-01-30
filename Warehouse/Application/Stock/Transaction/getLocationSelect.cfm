
<cfparam name="url.init" default="0">

<cfquery name="loc" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   W.*, R.Description as LocationClassName
		FROM     WarehouseLocation W, Ref_WarehouseLocationClass R
		WHERE    Warehouse = '#url.warehouse#'		
		AND      W.LocationClass = R.Code
		AND      Location IN (SELECT Location 
		                      FROM   ItemWarehouseLocation IWL
							  WHERE  Warehouse = '#url.warehouse#' 
							  AND    Location  = W.Location
							  AND    ItemNo IN (SELECT ItemNo FROM Item WHERE ItemNo = IWL.ItemNo AND Destination = 'Distribution')
							  )
		AND      Distribution != '9'
		AND      Operational   = 1
		AND      Location IN (SELECT Location 
		                      FROM   ItemWarehouseLocationTransaction 
							  WHERE  Warehouse       = '#url.warehouse#' 
							  AND    Location        = W.Location 
							  AND    TransactionType = '2' 
							  AND    Operational     = 1)
		ORDER BY LocationClass
</cfquery>

<cfif loc.recordcount eq "0">
	
	<cfquery name="loc" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   W.*, R.Description as LocationClassName
			FROM     WarehouseLocation W, Ref_WarehouseLocationClass R
			WHERE    Warehouse = '#url.warehouse#'		
			AND      W.LocationClass = R.Code
			AND      Location IN (SELECT Location 
			                      FROM   ItemWarehouseLocation IWL
								  WHERE  Warehouse = '#url.warehouse#' 
								  AND    Location  = W.Location
								  AND    ItemNo IN (SELECT ItemNo FROM Item WHERE ItemNo = IWL.ItemNo AND Destination = 'Distribution')
								  )
			AND      Distribution != '9'
			AND      Operational = 1		
			ORDER BY LocationClass
			
	</cfquery>

</cfif>

<cfset url.location = loc.location>

<cfoutput>

	<cfif loc.recordcount eq "0">
	
		<font color="FF0000">No storage locations found with items to be internally issued</font> 
	
	<cfelse>
	
		<select name="location" id="location" class="enterastab regularxl"
		  onchange="ColdFusion.navigate('../Transaction/getItemSelect.cfm?tratpe=#url.tratpe#&mode=#url.mode#&warehouse=#url.warehouse#&location='+this.value,'itembox');ColdFusion.navigate('../Transaction/TransactionLogSheetPDF.cfm?warehouse=#url.warehouse#&location='+this.value,'inputboxpdf');">
			<cfloop query="loc">
				<option value="#Location#">#Description# #StorageCode#</option>
			</cfloop>
		</select>	
		
	</cfif>	
	
	<cfif url.init eq "0">
		
		<script>			
			ColdFusion.navigate('../Transaction/getItemSelect.cfm?tratpe=#url.tratpe#&mode=#url.mode#&warehouse=#url.warehouse#&location=#url.location#','itembox')	
		</script>
	
	</cfif>

</cfoutput>	

