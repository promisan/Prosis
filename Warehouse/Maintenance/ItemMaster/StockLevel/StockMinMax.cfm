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
<cfparam name="URL.ID"      default="0001">
<cfparam name="URL.Mission" default="Promisan">

<!--- show all warehouses of the mission/entity 
that carry this item and that are enabled --->


<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Item
		WHERE  ItemNo = '#URL.ID#'				
</cfquery>	

<cfquery name="Warehouse"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	 SELECT DISTINCT Warehouse
		FROM   ItemTransaction I
		WHERE  Mission = '#URL.Mission#'
		AND    ItemNo  = '#URL.ID#'	
		AND    Warehouse IN (SELECT Warehouse 
		                     FROM   Warehouse 
							 WHERE  Warehouse   = I.Warehouse 
							 AND    Operational = 1)		
							 
		UNION 
		
		SELECT DISTINCT Warehouse
		FROM   ItemWarehouse I
		WHERE  ItemNo  = '#URL.ID#'	
		AND    Warehouse IN (SELECT Warehouse 
		                     FROM   Warehouse 
							 WHERE  Warehouse   = I.Warehouse 
							 AND    Mission     = '#url.mission#'
							 AND    Operational = 1)		
	
	    UNION
		
		SELECT DISTINCT Warehouse
		FROM   WarehouseCategory I
		WHERE  Category = '#get.Category#'
		AND    Operational = 1
		AND    Warehouse IN (SELECT Warehouse 
		                     FROM   Warehouse 
							 WHERE  Warehouse   = I.Warehouse 
							 AND    Mission     = '#url.mission#'
							 AND    Operational = 1)	
	    
</cfquery>	

<cfquery name="ItemUoM"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   ItemUoM
		WHERE  ItemNo = '#URL.ID#'		
		AND    Operational = 1		
		ORDER BY UoM
</cfquery>	

<cfquery name="TaxList"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_Tax
		
</cfquery>	

<table width="100%">
    <tr><td height="10"></td></tr>
	<tr>
		<td valign="middle" class="labellarge" style="font-size:17px">
			<cfoutput>
				<a href="javascript:toggleAllStockLevelWarehouse();">
					<img src="#SESSION.root#/Images/expand1.gif" id="twistie" height="18">&nbsp;<cf_tl id="Expand / collapse all facilities"></span>
				</a>
			</cfoutput>
		</td>
	</tr>
	<tr><td height="10"></td></tr>
</table>

<cfform method="POST" id="inputform">

<table id="stockListing" width="99%" align="center">

	<cfset row = 0>

	<cfoutput query="warehouse">	
			
	<cfquery name="get"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM   Warehouse
			WHERE  Warehouse = '#warehouse#'				
	</cfquery>	
	
	<cfset w = warehouse>
	
	<cfinvoke 
		component		= "Service.Presentation.Presentation"
       	method			= "highlight2"
		tableListingId 	= "stockListing"
		multiselect		= "no"
		rowCounter		= "#warehouse.currentrow#"
    	returnvariable	= "highlightStyle">
		
	<tr #highlightStyle# class="line">
		<td colspan="2" style="height:35px;font-size:19px;padding-left:4px;cursor:pointer;" onclick="toggleStockLevelWarehouse('#w#');">
			<img src="#SESSION.root#/Images/arrow.gif" class="twistie" id="twistie_#w#" height="11"> &nbsp;
			#get.WarehouseName# <font face="Calibri" size="2">[#w#]</font>
		</td>			
	</tr>
		
	<tr id="trDetail_#w#" style="display:none;" class="trDetail">
	
		<td width="20"></td>
		<td width="100%">
			<table width="100%" align="center" class="formspacing">
			
			<cfloop query="ItemUoM">
	
			    <cfset row = row + 1>
			
				<cfquery name="whs"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
					FROM   ItemWarehouse
					WHERE  Warehouse = '#W#'
					AND    ItemNo    = '#URL.ID#'
					AND    UoM       = '#UoM#'
					AND    Operational = 1
				</cfquery>	
							
				<tr class="labelmedium">
					<td style="padding-top:4px;font-weight:bold;padding-left:15px;font-size:17px">#UoMDescription# (#UoM#)</td>
				</tr>	
				
				<tr>
					
					<td style="padding-left:10px">
						<table width="100%"  align="center">
													
							<tr class="labelmedium2">
								<cfif whs.MinimumStock gt whs.MaximumStock>
									<cfset cl = "yellow">
								<cfelse>
									<cfset cl = "">
								</cfif>
								
								<td style="padding-left:5px;" width="18%"><cf_tl id="Minimum Stock">:</td>
								
								<td bgcolor="#cl#" align="left">
											
									<cfinput type="Text" 
										name="MinimumStock_#row#" 
										message="Please enter a numeric value"
										value="#whs.MinimumStock#"
										class="regularxxl"				
										required="Yes"
										style="border:0px;background-color:e1e1e1;text-align:center;width:50"				
										visible="Yes" enabled="Yes">
										
								</td>	
								
								<cfif whs.MinimumStock gt whs.MaximumStock>
									<td>
									<img src="#SESSION.root#/images/alert.gif" alt="Exceeds maximum" border="0">				
									</td>
								<cfelse>
								    <td></td>					
								</cfif>	
								
								<td style="padding-left:10px;min-width:170px"><cf_tl id="Maximum Stock">:</td>				
								<td colspan="2" align="left">
								
									<cfinput type="Text" 
										name="MaximumStock_#row#" 				
										message="Please enter a numeric value"
										value="#whs.MaximumStock#"				
										required="Yes"
										class="regularxxl"
										style="border:0px;background-color:e1e1e1;text-align:center;width:50"
										visible="Yes" enabled="Yes">
								</td>
							</tr>
																					
							<tr class="labelmedium2">
								
								<td style="padding-left:5px;"><cf_tl id="Tax">:</td>
								<td colspan="2">
								
								<cfselect name="TaxCode_#row#"
							          query="taxlist"
							          value="TaxCode"
							          display="Description"
							          selected="#whs.TaxCode#"
							          visible="Yes"
							          enabled="Yes"
							          required="Yes"
							          type="Text"
									  style="border:0px;background-color:e1e1e1;font:10px"
							          class="regularxxl"/>									
								
								</td>
								
								<td style="padding-left:10px;"><cf_tl id="Min Order">:</td>
								    <cfif whs.MinReorderQuantity gt whs.MaximumStock>
										<cfset cl = "yellow">
									<cfelse>
										<cfset cl = "">
									</cfif>
								
								<td bgcolor="#cl#">
								
									<cfinput type="Text" 
									    name     = "MinReorderQuantity_#row#" 				
										value    = "#whs.MinReorderQuantity#"
										required = "Yes"
										message  = "Please enter a numeric value"				
										class    = "regularxxl"
										style    = "border:0px;background-color:e1e1e1;text-align:center;width:50px"
										visible  = "Yes" 
										enabled  = "Yes">
									
								</td>
								
								<cfif whs.MinReorderQuantity gt whs.MaximumStock>
									<td style="padding-left:3px">
									<img src="#SESSION.root#/images/alert.gif" alt="Exceeds maximum" border="0"></td>
								<cfelse>
									<td></td>
								</cfif>
								
							</tr>							
																						
							<tr class="labelmedium2">	
								<td style="height:26;padding-left:5px;"><cf_tl id="Replenishment">:</td>
								<td colspan="2">			
									<input type="checkbox" class="radiol"
									       name="ReorderAutomatic_#row#" 
										   id="ReorderAutomatic_#row#"
										   <cfif whs.ReorderAutomatic eq "1">checked</cfif>
										   value="#whs.reorderautomatic#">
										   
								</td>
													
								<td colspan="4" style="padding-left:10px;">								
								<table>
								<tr>
								    <td><cf_tl id="Through">:</td>
									<td><input type="radio" class="radiol" name="Restocking_#row#" id="Restocking_#row#" value="Procurement" <cfif whs.Restocking neq "Warehouse">checked</cfif>></td>
									<td style="padding-left:4px"><cf_tl id="Procurement"></td>
									<td style="padding-left:4px"><input type="radio" class="radiol" name="Restocking_#row#" id="Restocking_#row#" value="Warehouse" <cfif whs.Restocking eq "Warehouse">checked</cfif>></td>
									<td style="padding-left:4px"><cf_tl id="Parent Warehouse"></td>								
								</tr>
								</table>	
								</td>					
								
							</tr>								
																					
							<tr class="labelmedium2">	
								<td style="padding-left:5px;"><cf_tl id="Request">:</td>
								<td colspan="4">
								<table><tr class="labelmedium2">
								<td>
								<input type="radio" class="radiol" name="RequestType_#row#" id="RequestType_#row#" value="Regular" <cfif whs.RequestType neq "Pickticket">checked</cfif>>
								</td>
								<td style="padding-left:4px"><cf_tl id="Regular"></td>
								<td style="padding-left:6px"><input type="radio" class="radiol" name="RequestType_#row#" id="RequestType_#row#" value="Pickticket" <cfif whs.RequestType eq "Pickticket">checked</cfif>></td>
								<td style="padding-left:4px"><cf_tl id="Pickticket"></td>	
								</tr></table>
								
							</tr>							
																					
							<tr class="labelmedium2">	
								<td title="Record the number of days over which the average comsumption will be calculated" 
								style="padding-left:5px;"><cf_tl id="Average Days">:</td>
								<td colspan="2">
									<cfinput type="Text" 
										name="AveragePeriod_#row#" 				
										value="#whs.AveragePeriod#"
										required="Yes"
										message="Record the number of days over which the average comsumption will be calculated" 
										validate="integer"
										class="regularxxl" 
										size="3" 
										maxlength="3"
										style="text-align:center;border:0px;background-color:e1e1e1;"
										visible="Yes" enabled="Yes">
								</td>
								
								<!---
								<td><cf_tl id="Average">:</td>
								<td colspan="2">
									
									<!---
									<b>#lsNumberFormat(whs.distributionAverage,",.___")#</b>
									--->
									
									
									
								</td>
								
								--->
								
							</tr>	
							
							<cfquery name="stockC"
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT 	C.*,
												ISNULL((SELECT TargetQuantity FROM ItemWarehouseStockClass WHERE Warehouse = '#w#' AND ItemNo = '#url.id#' AND UoM = '#uom#' AND StockClass = C.Code),0) as TargetQuantity
										FROM   	Ref_StockClass C
										ORDER BY C.ListingOrder ASC
									</cfquery>
									
							<cfif stockC.recordcount gte "1">	
														
								<tr class="labelmedium2">	
									<td style="padding-left:5px;"><cf_tl id="Stock Class">:</td>
									<td colspan="5">
																		
										<table>
											<tr>
												<cfloop query="stockC">
													<td class="labelmedium2">#Description#:</td>
													<td style="padding-left:4px;padding-right:10px">
														<cfinput type="Text" 
															name="TargetQuantity_#row#_#code#" 				
															value="#targetQuantity#"
															required="Yes"
															message="Please enter an integer average days value" 
															validate="numeric"
															class="regularxxl" 
															size="4" 
															maxlength="10"
															style="text-align:right; padding-right:2px;">
													</td>												
												</cfloop>
											</tr>
										</table>
										
									</td>
								</tr>
							
							</cfif>
							
							<tr><td colspan="6" style="padding-right:40px">
							
							<cfset mode = "Warehouse">
							<cfinclude template="ItemUoMTopic.cfm">
							
							</td>
							</tr>
							
							<tr><td style="padding-top:4px"></td></tr>								
							<tr class="labelmedium2">	
								<td style="padding-left:5px;"><cf_tl id="Shipping Memo">:</td>
								<td colspan="6">
								<input type="text" name="ShippingMemo_#row#" id="ShippingMemo_#row#" value="#whs.ShippingMemo#" style="border:0px;background-color:e1e1e1;f1f1f1;width:90%;height:25;font-size:14px;padding:3px" class="regular">
								</td>
							</tr>	
							
							<tr style="height:6px"><td></td></tr>						
														
						</table>
					</td>
				</tr>
							
				</cfloop>
				
			</table>
		</td>
	</tr>
	
	</cfoutput>
		
	<tr>
		<td colspan="2" align="center" style="height:40px">
			<input type="button" style="width:140px" class="button10g" name="Save" id="Save" value="Save" onclick="itmlevelsubmit()">
		</td>
	</tr>
	
</table>

</cfform>



