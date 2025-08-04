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
<cfquery name="getLocations" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		 SELECT     WL.*,
		 			W.WarehouseName,
		 			I.ItemLocationId,
		 			I.ItemNo,
					(SELECT ItemDescription FROM Item WHERE ItemNo = I.ItemNo) as ItemDescription,
					I.UoM,
					(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = I.ItemNo AND UoM = I.UoM) as UoMDescription
		 FROM       WarehouseLocation WL
		 			INNER JOIN Warehouse W
						ON WL.Warehouse = W.Warehouse
		 			INNER JOIN ItemWarehouseLocation I
						ON 		WL.Warehouse = I.Warehouse
						AND     WL.Location = I.Location
		 <!--- WITHIN THE SAME CONDITIONS --->
		 WHERE		WL.LocationClass = '#url.locationclass#'
		 AND		I.ItemNo = '#url.itemNo#'
		 AND		I.UoM = '#url.uom#'
		 <!--- WITHIN THE SAME MISSION --->
		 AND		W.Mission = '#url.Mission#'
		 <!--- AND NOT THE SAME ITEMLOCATION --->
		 AND		I.ItemLocationId != '#url.itemLocationId#'
		 ORDER BY WarehouseName, StorageCode
</cfquery>

<cfset vUpdatedLocations = 0>

<cfif getLocations.recordcount gt 0>

	<cfloop query="getLocations">
	
		<cfset vItemLocationId = replace(ItemLocationId,"-","","ALL")>
		<cfif isDefined("form.LossDefinition_#vItemLocationId#")>
		
			<cfset vUpdatedLocations = vUpdatedLocations + 1>
		
			<cfquery name="clear" 
			    datasource="AppsMaterials" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				DELETE 
				FROM 	ItemWarehouseLocationLoss
				WHERE 	Warehouse = '#warehouse#'
				AND		Location = '#location#'
				AND		ItemNo = '#itemNo#'
				AND		UoM = '#uom#'
			</cfquery>
			
			<cfquery name="insert" 
			    datasource="AppsMaterials" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">		 		 	  
					 INSERT INTO ItemWarehouseLocationLoss
					 	(
							Warehouse,
							Location,
							ItemNo,
							UoM,
							DateEffective,
							LossClass,
							LossCalculation,
							TransactionClass,
							LossQuantity,
							AcceptedPointer,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
					 SELECT
					 		'#warehouse#',
							'#location#',
							L.ItemNo,
							L.UoM,
							LL.dateEffective,
							LL.LossClass,
							LL.LossCalculation,
							LL.TransactionClass,
							LL.LossQuantity,
							LL.AcceptedPointer,
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#'
					FROM	ItemWarehouseLocation L
							INNER JOIN ItemWarehouseLocationLoss LL
								ON 		L.Warehouse = LL.Warehouse
								AND		L.Location = LL.Location
								AND		L.ItemNo = LL.ItemNo
								AND		L.UoM = LL.UoM
					WHERE	L.ItemLocationId = '#url.itemLocationId#'
			</cfquery>
		
		</cfif>
		
	</cfloop>

</cfif>


<cf_tl id="Acceptable Variance Definition" var="vTitle">
<cf_tl id="Copy to locations" var="vTitle2">

<cf_screentop 
	height="100%" 
	scroll="No" 
	html="Yes" 
	label="#vTitle#" 
	option="#vTitle2#" 
	layout="webapp" 
	banner="yellow" 
	user="no">

<table width="100%" align="center">
	<tr>
		<td align="center" height="100" valign="middle" style="font-size:15px;"><cfoutput>#vUpdatedLocations# locations were updated with this loss definition.</cfoutput></td>
	</tr>
	<tr>
		<td align="center">
			<cf_tl id="Close" var="1">
			<cf_button 
				mode        = "silver"
				label       = "#lt_text#" 
				onClick     = "ColdFusion.Window.hide('LossesCopy');"					
				id          = "close"
				width       = "100px" 					
				color       = "636334"
				fontsize    = "11px">
		</td>
	</tr>
</table>