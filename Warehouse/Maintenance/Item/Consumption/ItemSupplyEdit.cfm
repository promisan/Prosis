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
<cfparam name="url.type" default="Item">

<cfset vField = "ItemNo">
<cfset vPrefix = "">
<cfset vLabel = "Master">

<cfif url.type eq "AssetItem">
	<cfset vField = "AssetId">
	<cfset vPrefix = "Asset">
	<cfset vLabel = "Asset">
</cfif>

<cfif url.supply neq "">

	<cf_screentop height="100%" 
	   scroll="Yes" 
	   html="No" 
	   label="Supplies #vLabel# Item" 
	   option="Maintain Supply Item" 
	   layout="webapp" 
	   banner="gray" 
	   bannerheight="50"
	   user="no">

<cfelse>

	<cf_screentop height="100%" 
	   scroll="Yes" 
	   html="No" 
	   label="Supplies #vLabel# Item" 	   	
	   layout="webapp"    
	   banner="gray" 
	   bannerheight="50"
	   user="no">
	
</cfif>

<cfparam name="url.mode" default="edit">

<cfquery name="ItemSupply" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	I.*,
			(SELECT ItemDescription FROM Item WHERE ItemNo = I.SupplyItemNo) as SupplyItemDescription,
			(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = I.SupplyItemNo AND UoM = I.SupplyItemUoM) as SupplyItemUoMDescription
	FROM 	#vPrefix#ItemSupply I
	WHERE 	I.#vField# = '#URL.ID#'
	AND 	I.SupplyItemNo = '#URL.supply#'
	AND		I.SupplyItemUoM = '#URL.uom#'
</cfquery>

<table class="hide">
	<tr><td><iframe name="processItemSupply" id="processItemSupply" frameborder="0"></iframe></td></tr>
</table>

<cfform action="#session.root#/warehouse/maintenance/item/Consumption/ItemSupplyEditSubmit.cfm?id=#url.id#&supply=#url.supply#&uom=#url.uom#&type=#url.type#" method="POST" name="frmItemSupply" target="processItemSupply">
		
<table width="95%" align="center" class="formpadding">

<cfoutput>
	<tr><td height="15"></td></tr>    			
    <TR>	    	  
		<TD width="15%" class="labelmedium"><cf_tl id="Supply">&nbsp;<cf_tl id="Item">:&nbsp;&nbsp;&nbsp;&nbsp;</TD>
		
			<cfif url.supply eq "">
			
				<td style="padding-top:3px;padding-right:4px">
			
			 	<cf_img icon="open" onclick="selectitemlocal('itemno','itembox');">
				
				</td>
							
				<td id="itembox" width="95%">
				
					<cfinput type="text" 
					     name="itemno" 
						 id="itemno"
						 size="4" 
						 value="#ItemSupply.SupplyItemNo#" 
						 required="Yes" 
						 message="Please, select a valid Supply Item/UoM" 
						 class="regularxl" 
						 readonly style="text-align: center;">
						 
				    <input type="text" name="itemdescription"  id="itemdescription"
					     value="#ItemSupply.SupplyItemDescription#" 
						 class="regularxl" size="30" readonly 
						 style="text-align: center;">						 		
					
					<input type="Hidden" name="itemuom" id="itemuom" value="#ItemSupply.SupplyItemUoM#">
					
					(
					<input type="text" name="itemuomdescription" id="itemuomdescription"
					     value="#ItemSupply.SupplyItemUoMDescription#" 
						 class="regularxl" 
						 size="10" 
						 readonly 
						 style="text-align: center;"> )
						 
				</td>
				
				<cfset uom = "">
				
			<cfelse>
			
				<td id="itembox" class="labelmedium">
				
				#ItemSupply.SupplyItemNo# #ItemSupply.SupplyItemDescription# (#ItemSupply.SupplyItemUoMDescription#)
				
				<input type="Hidden" name="itemno" id="itemno" value="#ItemSupply.SupplyItemNo#">
				<input type="Hidden" name="itemuom" id="itemuom" value="#ItemSupply.SupplyItemUoM#">
				
				</td>
				
				<cfset uom = ItemSupply.SupplyItemUoMDescription>
			
			
			</cfif>	
		
	</TR>
	
</cfoutput>

	<cfif url.type eq "AssetItem">
		<tr>
			<td height="23" class="labelmedium"><cf_UIToolTip tooltip="Blank for any warehouse">Is supplied through</cf_UIToolTip>:</td>
			<td colspan="2" class="labelmedium" style="height:28px">
				<cfdiv id="divAssetItemSupplyWarehouse" bind="url:#session.root#/warehouse/maintenance/item/Consumption/AssetItem/AssetItemSupplyWarehouse.cfm?itemno=#url.id#&supply={itemno}&uom={itemuom}">
			</td>
			<td class="hide"><input type="Hidden" name="autoInserted" id="autoInserted" value="0"></td>
		</tr>
	</cfif>


	<tr>
		<td class="labelmedium"><cf_tl id="Capacity">:</td>
		<td colspan="2" style="height:28px">
			<cfset vSupplyCapacity = ItemSupply.SupplyCapacity>
			<cfif ItemSupply.SupplyCapacity eq "">
				<cfset vSupplyCapacity = 0>
			</cfif>
			
			<cfinput type="Text"
		       name="SupplyCapacity"
		       value="#vSupplyCapacity#"
		       validate="numeric"
			   message="Please, enter a valid numeric capacity."
		       required="Yes"
		       size="5"
		       class="regularxl"       
		       style="text-align: center;">
			   
			   <cfoutput>#uom#</cfoutput>
			   
			   			   
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium" width="20%"><cf_tl id="Estimated Daily Usage">:</td>
		<td colspan="2" style="height:28px">
			<cfset vSupplyDailyUsage = ItemSupply.SupplyDailyUsage>
			<cfif ItemSupply.SupplyDailyUsage eq "">
				<cfset vSupplyDailyUsage = 0>
			</cfif>
			
			<cfinput type="Text"
		       name="SupplyDailyUsage"
		       value="#vSupplyDailyUsage#"
		       validate="numeric"
			   message="Please, enter a valid numeric daily usage."
		       required="Yes"
		       size="5"
		       class="regularxl"       
		       style="text-align: center;">
			   
			    <cfoutput>#uom#</cfoutput>
				
		</td>
	</tr>
	
	<tr><td height="5"></td></tr>	
	<tr><td colspan="3" class="line"></td></tr>
	<tr><td height="5"></td></tr>
	
	<tr>
		<td class="labelmedium" valign="top" style="padding-top:15px;border-right:0px dashed silver"><cf_tl id="Metrics">:</td>
	</tr>
	<tr>	
		<td colspan="3" style="padding-left:20px;padding-top:4px">
		
			<cfset numberOfColumns = 1>
			
			<table width="90%" cellspacing="0" align="center" class="formpadding">
			
				<cfquery name="Metric" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	M.*,
							(SELECT MetricQuantity  FROM #vPrefix#ItemSupplyMetric WHERE Metric = M.Code AND #vField# = '#URL.ID#' AND SupplyItemNo = '#URL.SUPPLY#' AND SupplyItemUoM = '#URL.UOM#') as MetricQuantity,
							(SELECT TargetDirection FROM #vPrefix#ItemSupplyMetric WHERE Metric = M.Code AND #vField# = '#URL.ID#' AND SupplyItemNo = '#URL.SUPPLY#' AND SupplyItemUoM = '#URL.UOM#') as TargetDirection,
							(SELECT TargetRange     FROM #vPrefix#ItemSupplyMetric WHERE Metric = M.Code AND #vField# = '#URL.ID#' AND SupplyItemNo = '#URL.SUPPLY#' AND SupplyItemUoM = '#URL.UOM#') as TargetRange,
							(SELECT TargetRatio     FROM #vPrefix#ItemSupplyMetric WHERE Metric = M.Code AND #vField# = '#URL.ID#' AND SupplyItemNo = '#URL.SUPPLY#' AND SupplyItemUoM = '#URL.UOM#') as Selected
					FROM	Ref_Metric M
					ORDER BY Measurement, Created
				</cfquery>

				<cfset metricCount = 0>
				<cfoutput query="Metric">
				
				
				<tr>
					<td height="15" width="50%" 
					    style="border:1px dotted silver;padding-top:2px;padding-bottom:2px" 						
						id="rowmet_#code#" <cfif selected neq "">style="background-color:E1EDFF"</cfif>>
						
						<cfset vRatio = 0>
						<cfset vMetricQuantity = 1>
						<cfset vTargetDirection = "Up">
						<cfset vTargetRange = 10>
						<cfif selected neq "">
							<cfset vRatio = selected>
							<cfset vMetricQuantity = MetricQuantity>
							<cfset vTargetDirection = TargetDirection>
							<cfset vTargetRange = TargetRange>
						</cfif>
						
						<table cellspacing="0" cellpadding="0">
							<tr>
								<td width="350" style="padding-left:6px" class="labelmedium">
								
									<table>
										<tr>
											<td>
												<input type="checkbox" 
														name="met_#code#" 
														id="met_#code#"
														value="#code#" 
														class="radiol" 
														onclick="javascript: selectMetric('rowmet_#code#', 'tbl_#code#', 'ratio_#code#', 'lbl_#code#', 'tbl2_#code#', this);" 
														<cfif selected neq "">checked</cfif>>
											</td>	
											<td style="padding-left:4px" class="labelit">
												<a id="lbl_#code#" <cfif selected eq "">style="display:none;"</cfif>>
													
													<cfset vUoMDescription = "(UoMs)">						
													<cfif trim(ItemSupply.SupplyItemUoMDescription) neq "">
														<cfset vUoMDescription = ItemSupply.SupplyItemUoMDescription>	
													</cfif>
													
													<cfinput type="Text"
												       name="ratio_#code#"
												       value="#lsNumberFormat(vRatio * vMetricQuantity, ',.__')#"
												       validate="numeric"
												       required="Yes"
													   message="Please enter a valid numeric consumption ratio for #code#"
												       size="3"
													   style="text-align:center"
												       maxlength="10"
												       class="regularxl">
													   
													<font color="00006A">&nbsp; #vUoMDescription#&nbsp;&nbsp;<b><span style="font-size:16px; font-weight:bold;">/</span></b>&nbsp;&nbsp;</font>
													
													<cfinput type="Text"
												       name="metricQuantity_#code#"
												       value="#vMetricQuantity#"
												       validate="integer"
												       required="Yes"
													   message="Please enter a valid integer (greater than 0) metric quantity for #code#"
												       size="3"
													   style="text-align:center"
												       maxlength="10" 
													   range="1"
												       class="regularxl">
													 
													 &nbsp;
												</a>
											</td>
											<td class="labelit">
												#Description# 
											</td>
										</tr>
									</table>
							
								</td>
							
								<td>
							
									<table width="100%" align="center" id="tbl_#code#" style="<cfif selected eq ''>display:none;</cfif>">
																	
										<tr>
											<td width="20"></td>
											<td width="10%" class="labelmedium"><cf_tl id="Direction">:</td>
											<td>
												<select name="TargetDirection_#code#" id="TargetDirection_#code#" class="regularxl">
													<option value="Up" <cfif lcase(vTargetDirection) eq "up">selected</cfif>>Up
													<option value="Down" <cfif lcase(vTargetDirection) eq "down">selected</cfif>>Down
												</select>
											</td>
										
											<td width="20"></td>
											<td width="10%" class="labelmedium"><cf_tl id="Range">:</td>
											<td>
												<cfinput type="Text"
											       name="TargetRange_#code#"
											       value="#vTargetRange#"
											       validate="integer"
											       required="Yes"
												   message="Please enter a valid integer target range for metric #code#."
											       size="3"
											       maxlength="10"
											       class="regularxl" style="text-align=center;">
											</td>
										
										</tr>
										
									</table>			
								
								</td>	
				
							</tr>
							
														
							<cfif url.supply neq "">
							<tr><td height="2"></td></tr>
							<tr>
								<td colspan="2">
									<table width="100%" id="tbl2_#code#" style="<cfif selected eq ''>display:none;</cfif>">
										<tr>
											<td width="25"></td>
											<td valign="top" width="15%" class="labelmedium">
												<cfif url.type eq "Item">
													<cf_tl id="By Location">
												</cfif>
												<cfif url.type eq "AssetItem">
													<cf_tl id=" By Date">
												</cfif>
												:
											</td>
											<td>
												<cfset vTId = evaluate("itemsupply.#vField#")>
												<cfdiv id="divSupplyMetricTarget_#code#" bind="url:#session.root#/warehouse/maintenance/item/Consumption/ItemSupplyMetricTargetListing.cfm?id=#vTId#&supplyitemno=#itemsupply.supplyitemno#&supplyitemuom=#itemsupply.supplyitemuom#&supplyitemuomdescription=#itemsupply.supplyitemuomdescription#&metric=#code#&type=#url.type#">
											</td>
										</tr>
									</table>
								</td>
							</tr>
							</cfif>
							
							<cfset metricCount = metricCount + 1>
					</table>
				</td>
				</tr>
																			
				<cfif metricCount eq numberOfColumns>
					</tr>
					<tr>
					<cfset metricCount = 0>
				</cfif>
				</cfoutput>
				</tr>
				
				<tr><td height="5" colspan="#numberOfColumns#"></td></tr>		
					
			</table>			
		</td>
	</tr>

	<tr><td class="line" colspan="3"></td></tr>
		
	<tr>
	<cfif url.supply neq "">
			
		<td align="center" style="height:30" colspan="3">
			<input class="button10s" style="width:140;height:24" type="submit" name="Update" id="Update" value="Save">
		</td>	
		
	<cfelse>
	
		<td align="center" style="height:30" colspan="3">
	    	<input class="button10s" style="width:140;height:24" type="submit" name="Insert" id="Insert" value="Save">
		</td>	
		
	</cfif>	
	
	</tr>
	
</table>

</cfform>	