	
<cfquery name="Warehouse" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Warehouse
	WHERE Warehouse = '#URL.warehouse#'	
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
			
	<cfoutput>
	
	<cfparam name="url.systemfunctionid" default="">
	
	<tr><td colspan="7" style="height:43px;font-size:20px;padding-left:24px" align="left" class="labelmedium">
	<a href="javascript:ColdFusion.navigate('#SESSION.root#/Warehouse/Maintenance/WarehouseLocation/RecordListing.cfm?idmenu=#url.systemfunctionid#&systemfunctionid=#url.systemfunctionid#&box=#url.box#&warehouse=#url.warehouse#','#url.box#')">
	<font color="0080C0">Show Locations in Listing</font>
	</a>
	</td></tr>			
   		
	<tr><td align="center" style="padding-top:1px">
	
	<cfparam name="url.mode" default="portal">
	
	<cfif url.mode eq "maintain">				
	   <cfset ht = url.height-166>
	   <cfset wd = url.width-20>		   
	<cfelse>	
	   <cfset ht = url.height-105>
	   <cfset wd = url.width-290>
	</cfif>
	
		<cfmap name="location"
		    centerlatitude="#warehouse.latitude#" 
		    centerlongitude="#warehouse.longitude#" 	
		    doubleclickzoom="true" 
			collapsible="false" 			
		    overview="true" 
			height="#ht#"
			width="#wd#"
			typecontrol="advanced" 
			zoomcontrol="large3d"
			hideborder="true"
		    scrollwheelzoom="false" 
			showmarkerwindow="true"
		    showscale="true"
			markerbind="url:#SESSION.root#/Warehouse/Maintenance/WarehouseLocation/LocationMAPDetail.cfm?warehouse=#url.warehouse#&location={cfmapname}&cfmapaddress={cfmapaddress}" 
		    tip="Warehouse Storage Locations" 
		    zoomlevel="15"> 	
									
			<cfquery name="Locations" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   WL.Location, WL.Description, L.Latitude, L.Longitude
				FROM     WarehouseLocation AS WL INNER JOIN
				         Location AS L ON WL.LocationId = L.Location
				WHERE    WL.Warehouse = '#url.warehouse#' 
				AND      L.Latitude IS NOT NULL
			</cfquery>
										
			<cfloop query="locations">
															
				<cfif latitude neq "">					
				
					<cfmapitem name="#location#" 
					    latitude="#latitude#" 
					    longitude="#longitude#" 	   
						markercolor="ffffaf"						
					    tip="#Description#"/>								
								
				</cfif>	
			
			</cfloop>	
											
	   </cfmap>
	
	
	</td></tr>
			
		
	</cfoutput>													
				
</table>						

