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

<cfif url.effDate neq "">

	<cfset vyear = mid(url.effDate, 1, 4)>
	<cfset vmonth = mid(url.effDate, 6, 2)>
	<cfset vday = mid(url.effDate, 9, 2)>	
	<cfset vDateEffective = createDate(vyear, vmonth, vday)>

<cfelse>

	<cfset vDateEffective = now()>
	
</cfif>

<cfquery name="Losses" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		  SELECT  	LC.Code as LossClass,
					LC.description as LossClassDescription,
					L.Warehouse,
					L.Location,
					L.ItemNo,
					L.UoM,
					L.DateEffective,
					L.LossCalculation,
					L.TransactionClass,
					L.LossQuantity,
					L.AcceptedPointer,
		 			(SELECT description FROM Ref_TransactionClass WHERE Code = L.TransactionClass) as TransactionClassDescription
		 FROM      	Ref_LossClass LC
		 			LEFT OUTER JOIN ItemWarehouseLocationLoss L 
						ON LC.Code = L.LossClass
						AND		L.Warehouse = '#url.warehouse#'
						AND       	L.Location = '#url.location#'		
						AND		L.ItemNo = '#url.itemNo#'
						AND		L.UoM = '#url.UoM#'
						AND		L.DateEffective = #vDateEffective#
		 ORDER BY L.DateEffective DESC, L.LossClass
</cfquery>

<cfquery name="transType" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		SELECT   *
		FROM     Ref_TransactionClass
		WHERE    Code NOT IN ('Variance','Transfer')
		ORDER BY Code
</cfquery>

<!-- <cfform name="frmLossesByDate" target="processLossesByDate" action="../LocationItemLosses/AcceptableLossesSubmitByDate.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#&effDate=#url.effDate#"> -->
<table width="100%" align="center" class="formpadding">
	<tr>		
		<td class="labelit"><cf_tl id="Class"></td>
		<td class="labelit"><cf_tl id="Calculation"></td>
		<td class="labelit"><cf_tl id="Transaction Class"></td>
		<td class="labelit" align="center"><cf_tl id="Accepted Pointer"></td>
		<cf_tl id="Quantity/Percent" var="1">
		<td class="labelit" align="right"><cf_UIToolTip tooltip="Month losses = Quantity<br>Transaction losses = Percentage"><cfoutput>#lt_text#</cfoutput>.</cf_UIToolTip></td>
	</tr>	
	<tr><td colspan="5" class="line"></td></tr>	
	<cfoutput query="Losses">
	<tr>
		<td class="labelit">
			#LossClassDescription#
			<cfset vLossClassFormatted = replace(LossClass," ","","ALL")>	
			<input type="Hidden" name="lossClass_#vLossClassFormatted#" id="lossClass_#vLossClassFormatted#" value="#LossClass#">
		</td>
		
		<td>
			<select name="lossCalculation_#vLossClassFormatted#" id="lossCalculation_#vLossClassFormatted#" onchange="javascript: changeCalculation(this,'#vLossClassFormatted#');" class="regularxl">
				<option value="Month" <cfif Losses.lossCalculation eq "Month" or Losses.lossCalculation eq "">selected</cfif>>Month</option>
				<option value="Transaction" <cfif Losses.lossCalculation eq "Transaction">selected</cfif>>Transaction</option>
			</select>
		</td>
		
		<td>
			<cfif Losses.lossCalculation eq "Month" or Losses.lossCalculation eq "">
				<cfset vStyle="display:'none';">
				<cfset vlossQuantityWidth = "80px">
			<cfelse>
				<cfset vStyle="display:'block';">
				<cfset vlossQuantityWidth = "69px">
			</cfif>

			<cfselect name="transactionClass_#vLossClassFormatted#" 
					query="transType" 
					value="Code" 
					display="Description" 
					required="No" 
					message="[#LossClassDescription#]: Please, select a valid transaction class." 
					queryposition="below" 
					selected="#TransactionClass#" 
					style="#vStyle#" 
					class="regularxl">
				
			</cfselect>
		</td>
		
		<td align="center">
		
			<cfif Losses.acceptedPointer eq "">
				<cfset vAP = 1>
			<cfelse>
				<cfset vAP = Losses.acceptedPointer>
			</cfif>
			
			<cfinput type="Text" 
					name="acceptedPointer_#vLossClassFormatted#" 
					required="Yes" 
					message="[#LossClassDescription#]: Please, enter a valid integer accepted pointer." 
					validate="integer" 
					size="1"
					maxlength="10"
					value="#vAP#"
					style="text-align:center;"
					class="regularxl">
		</td>
		
		<td align="right">
			<cfset vLossQuantity = LossQuantity>
			<cfif Losses.lossCalculation eq "Transaction">
				<cfset vLossQuantity = LossQuantity * 100>
			</cfif>
			<table width="100%">
				<tr>
					<td width="99%" align="right">
						<cfinput type="Text" 
								name="lossQuantity_#vLossClassFormatted#" 
								required="Yes" 
								message="[#LossClassDescription#]: Please, enter a valid numeric loss quantity." 
								validate="numeric" 
								maxlength="10" 
								value="#vLossQuantity#" 
								style="text-align:right; width:#vlossQuantityWidth#;"
								class="regularxl">
					</td>
					<td>
						<label id="percentage_#vLossClassFormatted#" style="#vStyle#">%</label>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	</cfoutput>
</table>

<!-- </cfform> -->