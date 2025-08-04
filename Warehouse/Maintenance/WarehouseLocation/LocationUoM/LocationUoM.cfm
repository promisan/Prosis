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

<cfquery name="getWL" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">		 		 	  
	 SELECT  	*
	 FROM      	WarehouseLocation
	 WHERE		Warehouse = '#url.warehouse#'
	 AND       	Location = '#url.location#'		
</cfquery>

<cfquery name="getUoMDet" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT  	*
		 FROM      	ItemUoM
		 WHERE		ItemNo = '#url.itemNo#'
		 AND		UoM = '#url.UoM#'
</cfquery>

<cfquery name="getuom" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT  	U.*,
		 			IU.UoMDescription
		 FROM      	ItemWarehouseLocationUoM U
		 			INNER JOIN ItemUoM IU
						ON U.ItemNo = IU.ItemNo
						AND U.UoM = IU.UoM
		 WHERE		U.Warehouse = '#url.warehouse#'
		 AND       	U.Location = '#url.location#'		
		 AND		U.ItemNo = '#url.itemNo#'
		 AND		U.UoM = '#url.UoM#'
		 ORDER BY U.MovementDefault DESC, U.Created DESC
</cfquery>

<cfif getuom.recordCount eq 0>
			
	<cfquery name="insertDefaultValue" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">		 		 	  
			 INSERT INTO ItemWarehouseLocationUoM
			 	(
					Warehouse,
					Location,
					ItemNo,
					UoM,
					MovementUoM,
					MovementDefault,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName
				)
			VALUES
				(
					'#url.warehouse#',
					'#url.location#',
					'#url.itemNo#',
					'#url.UoM#',
					'#getUoMDet.UoMDescription#',
					1,
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#'
				)
	</cfquery>
	
	<cfquery name="getuom" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">		 		 	  
			 SELECT  	U.*,
			 			IU.UoMDescription
			 FROM      	ItemWarehouseLocationUoM U
			 			INNER JOIN ItemUoM IU
							ON U.ItemNo = IU.ItemNo
							AND U.UoM = IU.UoM
			 WHERE		U.Warehouse = '#url.warehouse#'
			 AND       	U.Location = '#url.location#'		
			 AND		U.ItemNo = '#url.itemNo#'
			 AND		U.UoM = '#url.UoM#'
			 ORDER BY U.MovementDefault DESC, U.Created DESC
	</cfquery>
	
</cfif>

<table width="100%">
	<tr><td height="10"></td></tr>
	
	<tr><td class="labelmedium" style="padding:10px"><font color="808080">Allows you to define in the issuance screen a different UoM for the item being dispatched, so if this Item is managed in UoM = liter, it would allow you
	to issue in Gallons, the transaction will then immediately be posted into the UoM of this item, so it only allows you to issue into a different UoM, not to manages its stock. </td></tr>
	<tr>	
		<td>
			
			<table width="95%" align="center" class="navigation_table">
				<tr class="labelmedium line">
					<td height="23" width="10%" align="center" class="labelmedium">
						<cfoutput>
						<a href="javascript: editMovementUoM('#url.warehouse#','#url.location#','#url.itemNo#','#url.UoM#','');">
							<font color="0080FF">
								[<cf_tl id="Add new">]
							</font>
						</a>
						</cfoutput>
					</td>
					<td class="labelmedium"><cf_tl id="Movement UoM"></td>
					<td align="center" class="labelmedium"><cf_tl id="Multiplier"></td>
					<td align="center" class="labelmedium"><cf_tl id="Default"></td>
				</tr>
									
				<cfoutput query="getuom">
					<tr class="labelmedium navigation_row" bgcolor="">
						<td align="center">
							<table>
								<tr>
									<td><cf_img icon="edit" onclick="editMovementUoM('#url.warehouse#','#url.location#','#url.itemNo#','#url.UoM#','#movementUoM#');"></td>
									<cfif movementDefault neq 1>
									<td width="8"></td>
									<td>
										<cf_img icon="delete" onclick="purgeMovementUoM('#url.warehouse#','#url.location#','#url.itemNo#','#url.UoM#','#movementUoM#');">
									</td>
									</cfif>
								</tr>
							</table>
						</td>		
						<td height="20" class="labelmedium">#MovementUoM#</td>
						<td align="center" class="labelmedium">#lsNumberFormat(MovementMultiplier,",.___")#</td>
						<td align="center" class="labelmedium"><cfif movementDefault eq 1><b>Yes</b><cfelse>No</cfif></td>
					</tr>
				</cfoutput>
			</table>
			
		</td>				
	</tr>			
</table>		

<cfset ajaxonload("doHighlight")>

