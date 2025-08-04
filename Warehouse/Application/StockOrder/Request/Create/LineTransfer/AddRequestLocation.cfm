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

<cfquery name="checkLocation" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT 	*
		FROM 	WarehouseCategory
		WHERE 	Warehouse = '#url.warehouse#' 
		AND     Category  = (SELECT Category FROM Item WHERE ItemNo = '#url.itemno#')		
		
</cfquery>

<cfif checkLocation.RequestMode eq "1">
	
	<cfquery name="qLocationFirst" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT 	Location
			FROM 	WarehouseLocation WL LEFT OUTER JOIN Ref_WarehouseLocationClass WLC ON WL.LocationClass = WLC.Code
			WHERE 	WL.Warehouse = '#url.warehouse#' 
			<cfif url.geolocationid neq "">
			AND     WL.LocationId = '#url.geolocationid#'
			<cfelse>
			AND     WL.LocationId is NULL
			</cfif>
			AND     Operational = 1
			
			AND     Location IN (SELECT Location 
			                      FROM   ItemWarehouseLocationTransaction IWLT
								  WHERE  Warehouse = WL.Warehouse												
								  AND    Location  = WL.Location											 
								  AND    ItemNo IN (SELECT  ItemNo
											        FROM    Item
													WHERE   ItemNo = IWLT.ItemNo
											        AND     Category = '#CheckLocation.Category#')
								  AND    TransactionType = '9'
								  AND    Operational = 1 
								  )
						
										
	</cfquery>	
		
	<cfif qLocationFirst.recordcount eq "0">
		
		<cfquery name="qLocation" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT 	  Location,
			          isNULL(WL.Description+' '+WL.StorageCode,WL.Description) as LocationDescription,		       
					  WLC.Description as LocationClassDescription
			FROM 	  WarehouseLocation WL LEFT OUTER JOIN Ref_WarehouseLocationClass WLC ON WL.LocationClass = WLC.Code
			WHERE 	  WL.Warehouse = '#url.warehouse#' 
			<cfif url.geolocationid neq "">
			AND       WL.LocationId = '#url.geolocationid#'
			<cfelse>
			AND       WL.LocationId is NULL
			</cfif>
			AND       Operational = 1
			AND		  Location IN
					  (
						SELECT 	Location
						FROM	ItemWarehouseLocation
						WHERE	Warehouse   = WL.Warehouse
						AND     Location    = WL.Location
						AND     ItemNo      = '#url.itemNo#'
						AND     Operational = 1										
					  )
			ORDER BY  WL.LocationClass ASC, WL.Description ASC
			
	   </cfquery>
			
		
		<cfoutput>
		
		<cfif qLocation.recordcount eq "0">
		
			<script>
				document.getElementById('submitbox').className = "hide"
			</script>
		
			<table style="border:1px solid silver"><tr><td style="padding-left:4px;padding-right:4px;height:20"><font size="2" color="FF0000">Selected item is not recorded in any location !</font></td></tr></table>
					
					
		<cfelse>
		
			<script>
				document.getElementById('submitbox').className = "regular"
			</script>
		
			<select name="ShipToLocation" 
				  query="qLocation" 
				  group="LocationClassDescription" 
				  value="Location" 
				  display="LocationDescription"
				  required="Yes" 
				  class="regularxl enterastab"
				  message="Please, select a valid location to ship to."
				  onchange="ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/Request/Create/LineTransfer/AddRequestProductUoM.cfm?mission=#url.mission#&directtowarehouse=#url.directtowarehouse#&warehouse=#url.warehouse#&itemno=#url.itemno#&location='+this.value,'divAddRequestProductUoM');">
				<cfloop query="qLocation">
					  <option value="#Location#">#LocationDescription#</option>				  
				</cfloop>	
			</select>
			
			
		</cfif>	
		
			<script>
				ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/Request/Create/LineTransfer/AddRequestProductUoM.cfm?mission=#url.mission#&directtowarehouse=#url.directtowarehouse#&warehouse=#url.warehouse#&itemno=#url.itemno#&location=#qLocation.Location#','divAddRequestProductUoM');
			</script>
				
		</cfoutput>
			
	<cfelse>
	
		<!--- we take a default location --->
	
		<cfquery name="qLocation" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT 	Location,
				        isNULL(WL.Description+' '+WL.StorageCode,WL.Description) as LocationDescription,		       
						WLC.Description as LocationClassDescription
				FROM 	WarehouseLocation WL LEFT OUTER JOIN Ref_WarehouseLocationClass WLC ON WL.LocationClass = WLC.Code
				WHERE 	WL.Warehouse = '#url.warehouse#' 
				AND     WL.Location = '#qLocationFirst.Location#'			
		</cfquery>			
		
		<cfoutput>
		
			<input type="hidden" name="ShipToLocation" value="#qLocation.Location#">	
			
			<table style="border:1px solid silver"><tr><td style="padding-left:4px;padding-right:4px;height:20"><font size="2">Consolidated</font></td></tr></table>
			
			<script>
				document.getElementById('submitbox').className = "regular"
			</script>
	
			<script>
				ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/Request/Create/LineTransfer/AddRequestProductUoM.cfm?mission=#url.mission#&directtowarehouse=#url.directtowarehouse#&warehouse=#url.warehouse#&itemno=#url.itemno#&location=#qLocation.Location#','divAddRequestProductUoM');
			</script>
			
		</cfoutput>

    </cfif>
		
<cfelse>
	
	<cfquery name="qLocation" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT 	Location,
			        isNULL(WL.Description+' '+WL.StorageCode,WL.Description) as LocationDescription,		       
					WLC.Description as LocationClassDescription
			FROM 	WarehouseLocation WL LEFT OUTER JOIN Ref_WarehouseLocationClass WLC ON WL.LocationClass = WLC.Code
			WHERE 	WL.Warehouse = '#url.warehouse#' 
			<cfif url.geolocationid neq "">
			AND     WL.LocationId = '#url.geolocationid#'
			<cfelse>
			AND     WL.LocationId is NULL
			</cfif>
			AND     Operational = 1
			AND		Location IN
					(
						SELECT 	Location
						FROM	ItemWarehouseLocation
						WHERE	Warehouse   = '#url.warehouse#'
						AND     ItemNo      = '#url.itemNo#'
						AND     Operational = 1										
					)
			ORDER BY WL.LocationClass ASC, WL.Description ASC
			
	</cfquery>			
		
	<cfoutput>
	
		<select name="ShipToLocation" 
			  query="qLocation" 			 
			  required="Yes" 
			  class="regularxl enterastab"
			  message="Please, select a valid location to ship to."
			  onchange="ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/Request/Create/LineTransfer/AddRequestProductUoM.cfm?mission=#url.mission#&directtowarehouse=#url.directtowarehouse#&warehouse=#url.warehouse#&itemno=#url.itemno#&location='+this.value,'divAddRequestProductUoM');">
				<cfloop query="qLocation">
					  <option value="#Location#">#LocationDescription#</option>				  
				</cfloop>		
		</select>
	
		<script>
			ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/Request/Create/LineTransfer/AddRequestProductUoM.cfm?mission=#url.mission#&directtowarehouse=#url.directtowarehouse#&warehouse=#url.warehouse#&itemno=#url.itemno#&location=#qLocation.Location#','divAddRequestProductUoM');
		</script>
			
	</cfoutput>
	
	
</cfif>

