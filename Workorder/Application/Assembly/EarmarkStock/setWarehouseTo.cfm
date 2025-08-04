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

<cfparam name="url.itemno" default="">

<table cellspacing="0" cellpadding="0">
	  
	  <tr> 
	  
	  <td class="labelmedium" style="padding-left:10px;padding-right:10px"><cf_tl id="Warehouse">:</td>
	  
	  <td style="padding-left:3px;padding-right:10px">
															
					<cfquery name="warehouse" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					  	SELECT   * 
						FROM     Warehouse
						WHERE    Mission = '#url.mission#'
						AND      Operational = 1			
						AND     ( Warehouse IN (SELECT Warehouse
						                       FROM   WarehouseCategory
											   WHERE  Operational = 1
											   AND    Category IN (SELECT Category FROM Item WHERE ItemNo = '#url.itemno#'))            	
								OR    					   
								
								Warehouse = '#url.warehouse#'
								
								)
						ORDER BY WarehouseDefault DESC				 
					</cfquery>  
					
					<cfoutput>	
											
						<select name="warehouseto" id="warehouseto"
						    class="regularh" style="font-size:17px;height:36px;width:250"
							onchange="ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/setWarehouseLocationTo.cfm?itemno=#url.itemno#&warehouse=#url.warehouse#&warehouseto='+this.value,'boxlocationto')">
							<cfloop query="Warehouse">
								<option value="#Warehouse#" <cfif url.warehouse eq warehouse>selected</cfif>>#WarehouseName#</option>
							</cfloop>
						</select>			
					</cfoutput>	
									   							
				</td>				
			  
		<td style="padding-left:3px;padding-right:10px" class="labelmedium"><cf_tl id="Location">:</td>
		
		<td id="boxlocationto">
		
			<cfset url.warehouseto = url.warehouse>
			<cfinclude template="setWarehouseLocationTo.cfm">
		
		</td>
	  
	  </tr>
		  
</table>