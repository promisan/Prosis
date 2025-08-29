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
<cfquery name="getWL" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">		 		 	  
	 SELECT  	*
	 FROM      	WarehouseLocation
	 WHERE		Warehouse = '#url.warehouse#'
	 AND       	Location = '#url.location#'		
</cfquery>

<table width="100%">
	<tr>
		<td width="100%" height="30" align="center">				
			<font size="3"><cf_tl id="Acceptable Variance" class="message"></font>				
		</td>
	</tr>
	<tr>
		<td align="center">
			<cf_tl id="Copy this loss definition to other locations" var="1">
			<cfoutput>
			<a title="#lt_text#" href="javascript: ColdFusion.Window.show('LossesCopy');">
				<font color="0080FF">
					[#lt_text#]
				</font>
			</a>
			</cfoutput>
		</td>
	</tr>
	<tr><td height="15"></td></tr>
	<tr>	
		<td>
			
			<cfquery name="Losses" 
			    datasource="AppsMaterials" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">		 		 	  
					 SELECT  	L.*,
					 			(SELECT description FROM Ref_LossClass WHERE Code = L.LossClass) as LossClassDescription,
					 			(SELECT description FROM Ref_TransactionClass WHERE Code = L.TransactionClass) as TransactionClassDescription
					 FROM      	ItemWarehouseLocationLoss L
					 WHERE		L.Warehouse = '#url.warehouse#'
					 AND       	L.Location = '#url.location#'		
					 AND		L.ItemNo = '#url.itemNo#'
					 AND		L.UoM = '#url.UoM#'
					 ORDER BY L.DateEffective DESC, L.LossClass
			</cfquery>
			
			<script>
				lastRow = null;
			</script>
			
			<table width="95%" align="center">
				<tr><td colspan="6" class="line"></td></tr>
				<tr>
					<td height="23" width="10%" align="center" class="labelit">
						<cfoutput>
						<a href="javascript: editLossByDate('#url.warehouse#','#url.location#','#url.itemNo#','#url.UoM#','','');">
							<font color="0080FF">
								[<cf_tl id="Add new">]
							</font>
						</a>
						</cfoutput>
					</td>
					<td class="labelit"><cf_tl id="Class"></td>
					<td class="labelit" align="left"><cf_tl id="Calculation"></td>
					<td class="labelit" align="left"><cf_tl id="Transaction Class"></td>
					<td class="labelit" align="left"><cf_tl id="Pointer"></td>
					<cf_tl id="Quantity/Percent" var="1">
					<td class="labelit" align="right"><cf_UIToolTip tooltip="Month losses = Quantity<br>Transaction losses = Percentage"><cfoutput>#lt_text#</cfoutput>.</cf_UIToolTip></td>
				</tr>
				<tr><td colspan="6" class="line"></td></tr>	
					
				<cfoutput query="Losses" group="DateEffective">
					<cfset vDateEffective = "#lsDateFormat(DateEffective, 'yyyy-mm-dd')#">
					<tr>
						<td colspan="6" height="25" valign="middle">
							<font size="2">#lsDateFormat(DateEffective, CLIENT.DateFormatShow)#</b>
							&nbsp;
							<img src="#SESSION.root#/Images/edit.gif" title="edit" style="cursor: pointer;" width="11" height="11" border="0" align="middle" 
								onClick="editLossByDate('#url.warehouse#','#url.location#','#url.itemNo#','#url.UoM#','#vDateEffective#','#lossClass#');">
							&nbsp;
							<img src="#SESSION.root#/Images/delete5.gif" title="remove" style="cursor: pointer;" width="11" height="11" border="0" align="middle" 
								onClick="if (confirm('Do you want to remove this complete loss reference ?')) {ColdFusion.navigate('../LocationItemLosses/AcceptableLossesDeleteByDate.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#&dateEffective=#vDateEffective#','contentbox2');}">
						</td>
					</tr>
					<cfoutput>
					<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor='FFFFFF'" bgcolor="FFFFFF" id="lossRow#currentRow#">
						<td></td>		
						<td class="labelit" height="20">#LossClassDescription#</td>
						<td class="labelit" align="left">#LossCalculation#</td>
						<td class="labelit" align="left">#TransactionClassDescription#</td>
						<td class="labelit" align="left">#lsNumberFormat(AcceptedPointer,",")#</td>
						<td class="labelit" align="right">
						<cfif LossCalculation eq "month">
						#lsNumberFormat(LossQuantity,",._____")#
						<cfelse>
						#lsNumberFormat(LossQuantity*100,",.___")#%
						</cfif>
						</td>
					</tr>
					</cfoutput>
				</cfoutput>
			</table>
			
		</td>				
	</tr>			
</table>		

