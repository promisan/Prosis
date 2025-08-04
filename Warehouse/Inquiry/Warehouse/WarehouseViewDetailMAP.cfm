<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfquery name="Warehouse"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		
	SELECT     IW.Warehouse,
	           W.WarehouseName, 
			   W.Latitude,
			   W.Longitude, 
			   W.City,
	           SUM(IW.MinimumStock) AS StockMinimum,			   
               (
				    SELECT   SUM(TransactionQuantity) 
    	            FROM     ItemTransaction
        	        WHERE    Warehouse      = IW.Warehouse
					AND      ItemNo         = '#url.itemno#' 
					AND      TransactionUoM = '#url.uom#'
				) AS StockOnHand 
					
	FROM         ItemWarehouseLocation IW INNER JOIN
	                      Warehouse W ON IW.Warehouse = W.Warehouse
	WHERE     W.Mission = '#url.mission#' 
	AND       IW.ItemNo = '#url.itemno#' 
	AND       IW.UoM = '#url.uom#'
	AND       W.Operational = 1
	AND       W.Latitude != ''
	GROUP BY  IW.Warehouse, 
	          W.WarehouseName, 
			  W.Latitude, 
			  W.Longitude, 
			  W.City
		
</cfquery>	

<!--- define stock on hand and minimum for an item/uom --->

<cfquery name="MainWarehouse"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT   *
	FROM     Warehouse
	WHERE    Mission = '#url.mission#'	
	ORDER BY WarehouseDefault DESC   
</cfquery>	

<!---
	<cfinvoke component="service.maps.googlegeocoder3" method="googlegeocoder3" returnvariable="details">	  
	  <cfinvokeargument name="address" value="The Netherlands, Delft">
	  <cfinvokeargument name="ShowDetails" value="false">
	</cfinvoke>	
	
--->
<!---
<td bgcolor="#00FF00"></td>
--->

<cfif MainWarehouse.latitude eq "">

<cfoutput>
<table><tr><td align="center"><font face="Verdana" size="3">Google MAP View has not been enabled yet for the main site #MainWarehouse.WarehouseName#</font></td></tr></table>
</cfoutput>

<cfelse>
						
	<cfmap name="#MainWarehouse.warehouse#"
		    centerlatitude="#MainWarehouse.latitude#" 
		    centerlongitude="#MainWarehouse.longitude#" 	
		    doubleclickzoom="true" 
			collapsible="false" 			
		    overview="true" 
			height="#url.height-5#"
			width="#url.width-150#"
			typecontrol="advanced" 
			zoomcontrol="large3d"			
			hideborder="true"
		    scrollwheelzoom="false" 
			showmarkerwindow="true"
		    showscale="true"
			markerbind="url:WarehouseViewDetailMAPDrill.cfm?cfmapname={cfmapname}&cfmapaddress={cfmapaddress}&itemno=#url.itemno#&uom=#url.uom#" 
		    tip="Mission Stock Presentation" 
		    zoomlevel="11"> 	
					
			<cfloop query="warehouse">
			   				 
				<cfif latitude neq "">	
				
					<cfif stockonhand lte 0>
					
					  <cfmapitem name="#warehouse#" 
						    latitude="#latitude#" 
					        longitude="#longitude#" 	   
							markericon="Icons/Red.png"	
						    tip="ALERT : #WarehouseName# in #City#"/>			
				 
					<cfelseif stockonhand lte stockminimum>
									  
					  <cfmapitem name="#warehouse#" 
						    latitude="#latitude#" 
					        longitude="#longitude#" 	   
							markericon="Icons/Yellow.png"	
						    tip="ALERT : #WarehouseName# in #City#"/>			
					  
					<cfelse>
					
					  <cfmapitem name="#warehouse#" 
						    latitude="#latitude#" 
					        longitude="#longitude#" 	   
							markericon="Icons/Green.png"	
						    tip="#WarehouseName# in #City#"/>			
					  	
					</cfif>  
				
				</cfif>					
							
					
			</cfloop>
											
	</cfmap>
	
</cfif>	