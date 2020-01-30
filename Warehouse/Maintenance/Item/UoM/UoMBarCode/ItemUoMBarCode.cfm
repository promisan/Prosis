<table width="400" align="center" class="formpadding">
	<tr><td height="30"></td></tr>
	
	<tr>
	<td align="center" class="labellarge">
		<cfdiv id="dBarcode" bind="url:UoMBarCode/getBarCode.cfm?id=#url.id#&uom=#url.uom#&whs={sWarehouse}">
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
						<cfdiv bind="url:UoMBarCode/getTransactionLot.cfm?id=#url.id#&uom=#url.uom#&warehouse=#qWarehouse.Mission#">												
					</td>
				</tr>	
				
				<tr>
					<td class="labelit">
						<cf_tl id="How many labels would you like to print">?
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
							<cfdiv id="buttonPrint" bind="url:UoMBarCode/ButtonPrint.cfm?itemno=#url.id#&uom=#url.uom#&labels=1&whs={sWarehouse}">
						</div>
						<div style="style="display:#vshow_btn2#">						
							<cfdiv id="buttonPrintEPL" bind="url:UoMBarCode/ButtonPrintEPL.cfm?itemno=#url.id#&uom=#url.uom#&labels=1&whs={sWarehouse}">
						</div>		
					</td>
				</tr>	
			</table>		
		</td>
		
	</tr>
		
	</cfoutput>
	
</table>
