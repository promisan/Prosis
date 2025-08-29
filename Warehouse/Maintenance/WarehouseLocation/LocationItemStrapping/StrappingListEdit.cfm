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
<cfparam name="url.isReadonly" default="0">

<cfquery name="getItem" 
     datasource="AppsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     *,
	 			(SELECT ItemDescription FROM Item WHERE ItemNo = '#url.itemNo#') as ItemDescription,
				(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = '#url.itemNo#' AND UoM = '#url.UoM#') as UoMDescription,
				(SELECT WarehouseName FROM Warehouse WHERE Warehouse = '#url.warehouse#') as WarehouseName,
				(SELECT Description FROM WarehouseLocation WHERE Warehouse = '#url.warehouse#' AND Location = '#url.location#') as WarehouseLocationName
	 FROM       ItemWarehouseLocation 
	 WHERE		Warehouse = '#url.warehouse#'
	 AND       	Location = '#url.location#'		
	 AND		ItemNo = '#url.itemNo#'
	 AND		UoM = '#url.UoM#'
</cfquery>

<cfquery name="Strapping" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT 	*
		 FROM      	ItemWarehouseLocationStrapping
		 WHERE		Warehouse = '#url.warehouse#'
		 AND       	Location = '#url.location#'		
		 AND		ItemNo = '#url.itemNo#'
		 AND		UoM = '#url.UoM#'
</cfquery>

<cfset vOption = "Maintain Strapping Reference Table for #getItem.ItemDescription#">

<cfif url.isReadonly eq 1>
	<cfset vOption = "#getItem.WarehouseName# / #getItem.WarehouseLocationName#  -  #getItem.ItemDescription# / #getItem.UoMDescription#">
</cfif>

<cf_screentop height="100%" scroll="No" close="parent.ColdFusion.Window.destroy('mydialog',true)" html="Yes" label="Strapping Reference Table" option="#vOption#" layout="webapp" banner="gray">

<cfform name="frmStrapping" 
   action="../LocationItemStrapping/StrappingSubmit.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#&height=#url.height#&strappingScale=#getItem.StrappingScale#&step=#getItem.StrappingIncrement#">

<cfoutput>
<table width="95%" align="center">
	<tr><td height="15"></td></tr>
	<tr>
		<td valign="top">
		<table width="100%" align="center">
			<tr>
				<cfset straprows = 25>
				<cfset rowCount = 1>
				<cfset strapRelation = 0>
				<cfif getItem.strappingIncrementMode eq "Capacity">
					<cfset strapRelation = getItem.highestStock>
				</cfif>
				<cfif getItem.strappingIncrementMode eq "Strapping">
					<cfset strapRelation = getItem.StrappingScale>
				</cfif>
				
				<cfloop from="0" to="#strapRelation#" index="measurement" step="#getItem.StrappingIncrement#">					
					<cfif measurement eq 0>
					<td valign="top">
					<table width="100%" align="center">
						<tr>
							<td valign="top">
					</cfif>	
						<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
						<tr class="labelit" bgcolor="FFFFFF">
							<td align="center" width="75">				
								<cfoutput>
								<cfif measurement eq 0>
									0
									<input type="hidden" name="measurement#measurement#" id="measurement#measurement#" value="0">
								<cfelseif measurement eq strapRelation>
									<cfif url.isReadonly eq 0>	
										<!--- <cfif getItem.strappingIncrementMode eq "Capacity">
											<cfinput type="Text" 
											   name="measurement#measurement#" 
											   required="Yes" 
											   message="[Qty: #lsNumberFormat(measurement,",")#]: Enter a numeric measurement between 0 and #strapRelation#." 
											   validate="numeric" 
											   class="regular"
											   size="2" 
											   maxlength="10"
											   value="#getItem.StrappingScale#" 
											   range="0,#strapRelation#" 
											   style="text-align:center;">
										</cfif>
										<cfif getItem.strappingIncrementMode eq "Strapping">
											#lsNumberFormat(getItem.StrappingScale,",._")#
											<input type="hidden" name="measurement#measurement#" id="measurement#measurement#" value="#getItem.StrappingScale#">
										</cfif> --->
										#lsNumberFormat(getItem.StrappingScale,",._")#
										<input type="hidden" name="measurement#measurement#" id="measurement#measurement#" value="#getItem.StrappingScale#">
									<cfelse>
										#lsNumberFormat(getItem.StrappingScale,",._")#
										<input type="hidden" name="measurement#measurement#" id="measurement#measurement#" value="#getItem.StrappingScale#">
									</cfif>
									
								<cfelse>
								
									<cfquery name="getStrapping" dbtype="query">
										SELECT 	*
										FROM	Strapping
										WHERE	Quantity = #Measurement#
									</cfquery>
									
									<cfset vMea = 0>
									<cfif getStrapping.recordCount gt 0>
										<cfset vMea = getStrapping.measurement>
									</cfif>
										
									<cfif url.isReadonly eq 0>	
									
										<cfif getItem.strappingIncrementMode eq "Capacity">
										
											<cfinput type="Text" 
											   name="measurement#measurement#" 
											   required="Yes" 
											   message="[Qty: #lsNumberFormat(measurement,",")#]: Enter a numeric measurement between 0 and #strapRelation#." 
											   validate="numeric" 											  
											   size="2" 
											   maxlength="10"
											   value="#vMea#" 
											   range="0,#strapRelation#" 
											   class="enterastab regular"
											   style="text-align:center;">
											   
										</cfif>
										<cfif getItem.strappingIncrementMode eq "Strapping">
											#lsNumberFormat(measurement,",._")#
											<input type="hidden" name="measurement#measurement#" id="measurement#measurement#" value="#measurement#">
										</cfif>
									<cfelse>
										#lsNumberFormat(vMea,",._")#
										<input type="hidden" name="measurement#measurement#" id="measurement#measurement#" value="#measurement#">
									</cfif>
								
								</cfif>
								</cfoutput>
							</td>
							<td align="center" style="padding-left:10px;padding-right:10px">=</td>
							<td align="center" width="75">
								<cfif measurement eq 0>
									0
									<input type="hidden" name="quantity#measurement#" id="quantity#measurement#" value="0">
								<cfelseif measurement eq strapRelation>
									#lsNumberFormat(getItem.highestStock,",")#
									<input type="hidden" name="quantity#measurement#" id="quantity#measurement#" value="#getItem.highestStock#">
								<cfelse>
									
									<cfquery name="getStrapping" dbtype="query">
										SELECT 	*
										FROM	Strapping
										WHERE	Measurement = #Measurement#
									</cfquery>
									<cfset vQuantity = 0>
									<cfif getStrapping.recordCount gt 0>
										<cfset vQuantity = getStrapping.quantity>
									</cfif>
									
									<cfif url.isReadonly eq 0>
										<cfif getItem.strappingIncrementMode eq "Strapping">
											<cfinput type="Text" 
											   name="quantity#measurement#" 
											   required="Yes" 
											   message="[#measurement#]: Enter a numeric quantity between 0 and #getItem.highestStock#." 
											   validate="numeric" 
											   class="regular"
											   size="2" 
											   maxlength="10"
											   value="#vQuantity#" 
											   range="0,#getItem.highestStock#" 
											   style="text-align:center;">
										</cfif>
										<cfif getItem.strappingIncrementMode eq "Capacity">
											#lsNumberFormat(measurement,",")#
											<input type="hidden" name="quantity#measurement#" id="quantity#measurement#" value="#measurement#">
										</cfif>   
									 <cfelse>
									 
									 	#lsNumberFormat(vQuantity,",")#
									 	<input type="hidden" name="quantity#measurement#" id="quantity#measurement#" value="#vQuantity#">
										
									 </cfif>
								 </cfif>
							</td>
						</tr>		
								
						</table>								
					<cfif measurement eq strapRelation or rowCount eq straprows>
						</td>
						<td width="2"></td>				
						<td valign="top">
						<cfset rowCount = 0>
					</cfif>
					<cfif measurement eq strapRelation>
						</tr>
					</table>
					</td>
					</cfif>																
					<cfset rowCount = rowCount + 1>					
				</cfloop>
				<td>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	
	<tr>
		<td align="center">
			<cfif url.isReadonly eq 0>			
			
			<cf_button 
				mode        = "silver"
				label       = "Update Strapping List" 
				onClick     = "ColdFusion.navigate('../LocationItemStrapping/StrappingSubmit.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#&height=#url.height#&strappingScale=#getItem.StrappingScale#&step=#getItem.StrappingIncrement#','StrappingEdit','','','POST','frmStrapping')"
				id          = "save"
				width       = "190px" 
				height      = "24"
				color       = "636334"
				fontsize    = "11px">   
				
			</cfif>
		</td>
	</tr>	
</table>
</cfoutput>

</cfform>
