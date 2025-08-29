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
<table width="400" align="center" class="formpadding">
	<tr><td height="30"></td></tr>
	
	<tr>
	<td align="center" class="labellarge">
		<cf_securediv id="dBarcode" bind="url:UoMBarCode/getBarCode.cfm?id=#url.id#&uom=#url.uom#&whs={sWarehouse}">
	</td>		
	</tr>
	
	<cfoutput>
		
	<tr>
		<td height="15px"></td>
	</tr>
	
	<tr>
		<td align="center">	
			<table align="center" class="formpadding">
									
				<cfquery name="qWarehouse" 
						datasource="AppsMaterials" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							SELECT Mission,Warehouse,WarehouseName
							FROM   Warehouse
							WHERE  Mission IN (
									SELECT DISTINCT  Mission
									FROM   ItemUoMMission
									WHERE  ItemNo = '#url.ID#'
									AND    UoM    = '#url.UoM#'
							)
							ORDER BY Mission,WarehouseName
				</cfquery>

				<tr>
					<td class="labelit">
						<cf_tl id="Warehouse">:
					</td>
					<td style="padding-left:8px;">
						<cfform>
							<cfselect name="sWarehouse"
							   class="regularxl" 
							   id="sWarehouse" 
							   group="Mission"
							   Query="qWarehouse"
							   Value="warehouse"
							   Display="WarehouseName"
							   onChange="updateButton('#url.id#','#url.uom#',document.getElementById('labels').value,this.value)"/>								
						</cfform>
					</td>
				</tr>		
			
				<tr>
					<td class="labelit">
						<cf_tl id="Lot">:
					</td>
					<td class="labelmedium" style="padding-left:8px;">					
						<cf_securediv bind="url:UoMBarCode/getTransactionLot.cfm?id=#url.id#&uom=#url.uom#&warehouse=#qWarehouse.Mission#">												
					</td>
				</tr>	
				
				<tr>
					<td class="labelit" style="min-width:300px">
						<cf_tl id="How many labels to print">?
					</td>
					<td style="padding-left:8px;">
						<select name="labels" class="regularxl" id="labels" onChange="updateButton('#url.id#','#url.uom#',this.value,document.getElementById('sWarehouse').value)">
							<cfloop index="i" from="1" to="32" step="1">
								<option value="#i#">#i#</option>
							</cfloop>
						</select>
					</td>
				</tr>
												
						
			</table>
		</td>
	</tr>
	
	<tr>
		<td height="15">
		</td>
	</tr>
	
	<tr>
		<td align="center">
			<table width="100%"
				<tr align="center">
					<cfset vshow_btn1 = "block">
					<cfset vshow_btn2 = "block">
					
					<td  width="100%" align="center">
						<div style="display:#vshow_btn1#">
							<cf_securediv id="buttonPrint" bind="url:UoMBarCode/ButtonPrint.cfm?itemno=#url.id#&uom=#url.uom#&labels=1&whs={sWarehouse}">
						</div>						
						<div style="padding-top:4px;display:#vshow_btn2#">						
							<cf_securediv id="buttonPrintEPL" bind="url:UoMBarCode/ButtonPrintEPL.cfm?itemno=#url.id#&uom=#url.uom#&labels=1&whs={sWarehouse}">
						</div>		
					</td>
				</tr>	
			</table>		
		</td>
		
	</tr>
		
	</cfoutput>
	
</table>
