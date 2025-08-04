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

<cfif url.effectiveDate neq "" and url.class neq "">

	<cfset vyear = mid(url.effectivedate, 1, 4)>
	<cfset vmonth = mid(url.effectivedate, 6, 2)>
	<cfset vday = mid(url.effectivedate, 9, 2)>	
	<cfset vDateEffective = createDate(vyear, vmonth, vday)>
	
</cfif>

<cfquery name="Losses" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT  	L.*,
		 			(SELECT description FROM Ref_LossClass WHERE Code = L.LossClass) as LossClassDescription,
		 			(SELECT description FROM Ref_TransactionClass WHERE Code = L.TransactionClass) as TransactionClassDescription
		 FROM      	ItemWarehouseLocationLoss L
		 WHERE		L.Warehouse  = '#url.warehouse#'
		 AND       	L.Location   = '#url.location#'		
		 AND		L.ItemNo     = '#url.itemNo#'
		 AND		L.UoM        = '#url.UoM#'
		 <cfif url.effectiveDate neq "" and url.class neq "">
		 AND		L.DateEffective = #vDateEffective#
		 AND		L.LossClass  = '#url.class#'
		 <cfelse>
		 AND		1 = 0
		 </cfif>
		 ORDER BY L.Created DESC
</cfquery>

<cfoutput>

<cf_tl id="Acceptable Losses" var = "vLabel">

<cfif url.effectiveDate neq "" and url.class neq "">
    <cf_tl id="Maintain acceptable loss" var = "vOption">
	<cf_screentop height="100%" label="#vLabel#" layout="webapp" banner="yellow" scroll="yes">
<cfelse>
    <cf_tl id="Add acceptable loss" var = "vOption">
	<cf_screentop height="100%" label="#vLabel#" layout="webapp" scroll="yes">
</cfif>

<table class="hide">
	<tr><td><iframe name="processLosses" id="processLosses" frameborder="0"></iframe></td></tr>
</table>

<cfform name="frmLosses" target="processLosses" action="../LocationItemLosses/AcceptableLossesSubmit.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#&effDate=#url.effectiveDate#&class=#url.class#">	

<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td height="4"></td></tr>
	
	<tr>
		<td width="30%"><cf_tl id="Effective">:</td>
		<td>
		
			<cfset vSelectedDate = now()>
			<cfif url.effectiveDate neq "" and url.class neq "">
				<cfset vSelectedDate = Losses.DateEffective>
			</cfif>
			
			<cf_intelliCalendarDate9
					FieldName="DateEffective"
					Message="Select a valid Effective Date"
					class="regularxl"
					Default="#dateformat(vSelectedDate, CLIENT.DateFormatShow)#"
					AllowBlank="False">
		</td>
	</tr>
	<tr>
		<td><cf_tl id="Class">:</td>
		<td>
			<cfquery name="lossC" 
			     datasource="AppsMaterials" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">		 
				 SELECT   *
				 FROM     Ref_LossClass				
			</cfquery>
			
			<cfselect name="lossClass" 
				query="lossC" 
				value="Code" 
				display="Description" 
				required="Yes" 
				message="Please, select a valid loss class." 
				selected="#Losses.lossClass#">
			</cfselect>
		</td>
	</tr>
	<tr>
		<td><cf_tl id="Calculation">:</td>
		<td>
			<select name="lossCalculation" id="lossCalculation" onchange="javascript: changeCalculationNormal(this,'#Losses.TransactionClass#');">
				<option value="Month" <cfif Losses.lossCalculation eq "Month">selected</cfif>>Month</option>
				<option value="Transaction" <cfif Losses.lossCalculation eq "Transaction">selected</cfif>>Transaction</option>
			</select>
		</td>
	</tr>
	
	<cfif Losses.lossCalculation eq "Month">
	   <cfset cl = "hide">
	<cfelse>
	    <cfset cl = "regular">  
	</cfif>	
		
	<tr id="trTransactionClass" class="#cl#">
	
		<td><cf_tl id="Transaction Class">:</td>
		<td>
		
			<cfquery name="transType" 
			     datasource="AppsMaterials" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">		 
				 SELECT   *
				 FROM     Ref_TransactionClass
				 WHERE    Code NOT IN ('Variance','Transfer')
				 ORDER BY Code
			</cfquery>
			
			<cfselect name   = "TransactionClass" 
					query    = "transType" 
					value    = "Code" 
					display  = "Description" 
					required = "No" 
					message  = "Please, select a valid transaction class." 					
					selected = "#Losses.TransactionClass#">
				
			</cfselect>			
			
		</td>
	</tr>
	
	<tr>
		<td><cf_tl id="Loss Quantity">:</td>
		<td>
			<cfinput type="Text" 
					name="lossQuantity" 
					required="Yes" 
					message="Please, enter a valid numeric loss quantity." 
					validate="numeric" 
					size="10" 
					maxlength="10" 
					value="#Losses.LossQuantity#">
		</td>
	</tr>
	<tr>
		<td><cf_tl id="Accepted Pointer">:</td>
		<td>
			<cfinput type="Text" 
					name="acceptedPointer" 
					required="Yes" 
					message="Please, enter a valid integer accepted pointer." 
					validate="integer" 
					size="5"
					maxlength="10"
					value="#Losses.acceptedPointer#">
		</td>
	</tr>
	
	<tr><td height="3"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td height="3"></td></tr>
	<tr>
		<td colspan="2" align="center">
			<cf_tl id = "Save" var="vSave">
			<input type="Submit" class="button10g" name="save" id="save" value="#vSave#">
		</td>
	</tr>
	
</table>

</cfform>	

<cfset ajaxonload("doCalendar")>

<script>
	changeCalculation(document.getElementById('lossCalculation'), '#Losses.TransactionClass#');
</script>

</cfoutput>