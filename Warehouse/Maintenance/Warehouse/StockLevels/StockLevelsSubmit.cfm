<!--
    Copyright © 2025 Promisan B.V.

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
<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
	    SELECT DISTINCT
				W.Warehouse,
				C.Category,
				C.Description as CategoryDescription,
				I.ItemNo,
				I.ItemDescription,
				U.UoM,
				U.UoMDescription
		FROM	ItemWarehouse IW
				INNER JOIN Warehouse W
					ON IW.Warehouse = W.Warehouse
				INNER JOIN Item I
					ON IW.ItemNo = I.ItemNo
				INNER JOIN ItemUoM U
					ON IW.ItemNo = U.ItemNo
					AND IW.UoM = U.UoM
				INNER JOIN ItemUoMMission UM
					ON IW.ItemNo = UM.ItemNo
					AND IW.UoM = UM.UoM
					AND	W.Mission = UM.Mission
				INNER JOIN Ref_Category C
					ON I.Category = C.Category
				INNER JOIN WarehouseCategory WC
					ON WC.Warehouse = IW.Warehouse
					AND WC.Category = I.Category
		WHERE	UM.EnableStockClassification = 1
		AND		IW.Warehouse = '#url.warehouse#'
		ORDER BY C.Description, I.ItemDescription, U.UoMDescription
	    
</cfquery>

<cfquery name="getClasses" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT 	  *
		FROM 	  Ref_StockClass
		ORDER BY  ListingOrder
		
</cfquery>

<cftransaction>

	<cfquery name="clear" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
			DELETE
			FROM 	ItemWarehouseStockClass 
			WHERE 	Warehouse = '#url.Warehouse#' 
	
	</cfquery>
	
	<cfloop query="get">
		
		<cfloop query="getClasses">
			
			<cfif isDefined("Form.class_#get.itemNo#_#get.uom#_#code#")>
				
				<cfset vQuantity = trim(evaluate("Form.class_#get.itemNo#_#get.uom#_#code#"))>
				<cfset vQuantity = replace(vQuantity,",","","all")>
				
				<cfif vQuantity neq "">
				
					<cfquery name="insert" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					
							INSERT INTO ItemWarehouseStockClass
								(
									Warehouse,
									ItemNo,
									UoM,
									StockClass,
									TargetQuantity,
									OfficerUserId,
									OfficerLastName,
									OfficerFirstName
								) 
							VALUES
								(
									'#url.warehouse#',
									'#get.itemNo#',
									'#get.uom#',
									'#code#',
									#vQuantity#,
									'#session.acc#',
									'#session.last#',
									'#session.first#'
								) 
					
					</cfquery>
				
				</cfif>
				
			</cfif>
			
		</cfloop> 
		
	</cfloop>

</cftransaction>

<cfoutput>
	<script>
		ColdFusion.navigate('StockLevels/StockLevelsListing.cfm?warehouse=#url.warehouse#','contentbox2');
	</script>
</cfoutput>