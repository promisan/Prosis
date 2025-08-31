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
<cfparam name="Attributes.Warehouse"       default="">
<cfparam name="Attributes.Location"        default="">
<cfparam name="Attributes.ItemNo"          default="">
<cfparam name="Attributes.UoM"             default="">
<cfparam name="Attributes.ShowTank"        default="0">
<cfparam name="Attributes.fontSize"        default="10">
<cfparam name="Attributes.showStrap"       default="1">
<cfparam name="Attributes.StrappingLevel"  default="0">
<cfparam name="Attributes.showTooltip"     default="1">
<cfparam name="Attributes.showUllage"      default="1">
<cfparam name="Attributes.tooltipfontsize" default="10">
<cfparam name="Attributes.viewPort"        default="350">
<cfparam name="Attributes.ShowLocationDescription"  default="1">

<cfquery name="WarehouseLocation" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT    	L.*, W.warehouseName		 
		 FROM      	WarehouseLocation L,
		 			Warehouse W
		 WHERE     	W.warehouse = L.warehouse
		 AND		W.Warehouse = '#Attributes.warehouse#'
		 AND       	L.Location  = '#Attributes.location#'		
</cfquery>

<cfquery name="getItem" 
     datasource="AppsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     *,
			    (SELECT ISNULL(COUNT(*),0) FROM ItemWarehouseLocationStrapping WHERE Warehouse = '#Attributes.warehouse#' AND Location = '#Attributes.location#' AND ItemNo = '#Attributes.itemNo#' AND UoM = '#Attributes.UoM#') AS Strapping,				
	 			(SELECT ItemDescription FROM Item   WHERE ItemNo = '#Attributes.itemNo#') as ItemDescription,
				(SELECT ItemPrecision FROM Item     WHERE ItemNo = '#Attributes.itemNo#') as ItemPrecision,
				(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = '#Attributes.itemNo#' AND UoM = '#Attributes.uom#') as UoMDescription
	 FROM       ItemWarehouseLocation 
	 WHERE		Warehouse = '#Attributes.warehouse#'
	 AND       	Location  = '#Attributes.location#'		
	 AND		ItemNo    = '#Attributes.itemNo#'
	 AND		UoM       = '#Attributes.UoM#'
</cfquery>

<cfquery name="getUoM" 
     datasource="AppsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     *
	 FROM       ItemUoM
	 WHERE		ItemNo = '#Attributes.itemNo#'
	 AND		UoM    = '#Attributes.UoM#'
</cfquery>

<cfquery name="Strapping" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT 	*
		 FROM      	ItemWarehouseLocationStrapping
		 WHERE		Warehouse = '#Attributes.warehouse#'
		 AND       	Location  = '#Attributes.location#'		
		 AND		ItemNo    = '#Attributes.itemNo#'
		 AND		UoM       = '#Attributes.UoM#'
		 ORDER BY Measurement ASC
</cfquery>

<cfquery name="OnHand" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT   ISNULL(SUM(TransactionQuantityBase),0) as Stock
        FROM     ItemTransaction
        WHERE    Warehouse      = '#Attributes.warehouse#'
		AND      Location       = '#Attributes.location#'
		AND      ItemNo         = '#Attributes.itemNo#'
		AND      TransactionUoM = '#Attributes.UoM#'
</cfquery>

<cfoutput>	

<table width="100%" align="center" height="100%" class="clsPrintable">
			
	<!--- 
	Conditions to show a tank:
	1. WarehouseLocation.StorageShape must be defined
	2. WarehouseLocation.StorageWidth must be defined
	3. WarehouseLocation.StorageHeight must be defined
	4. WarehouseLocation.StorageDepth must be defined
	5. Must have at least one ItemWarehouseLocation defined
	6. Must have a strapping table defined for the ItemWarehouseLocation defined
	 --->
	
	<cfif lcase(WarehouseLocation.StorageShape) eq "n/a" 
				or WarehouseLocation.StorageWidth    eq "" 
				or WarehouseLocation.StorageHeight   eq ""
				or WarehouseLocation.StorageDepth    eq ""				
				or getItem.Strapping  eq 0>
				
		<cfset validationMessage = "">
		
		<cfif lcase(WarehouseLocation.StorageShape) eq "n/a">
			  <cfset validationMessage = validationMessage & " <li><font color='ff0000'>Storage shape must be defined.</font></li>">
		</cfif>
		
		<cfif WarehouseLocation.StorageWidth eq "" or WarehouseLocation.StorageHeight eq "" or WarehouseLocation.StorageDepth eq "">
			  <cfset validationMessage = validationMessage & " <li><font color='ff0000'>Storage measurements (width, height and depth) must be defined.</font></li>">
		</cfif>
		
		<!---
		<cfif WarehouseLocation.ItemLocationId eq "">
			  <cfset validationMessage = validationMessage & " <li><font color='ff0000'>The location must have at least one product defined.</font></li>">
		</cfif>
		--->
		
		<cfif getItem.Strapping eq 0>
			  <cfset validationMessage = validationMessage & " <li><font color='ff0000'>The strapping table must be defined.</font></li>">
		</cfif>												
														
		<cfset vColorStatus = "47D51E"> <!--- green = ok --->
		<cfset vStatus = "OK">
		
		<!---
		<cfif OnHand lte MinimumStock>
			<cfset vColorStatus = "E1686B"> <!--- red = under minimum --->
			<cfset vStatus = "Under Minimum">
		</cfif>
		--->
					
			<tr>
				<td colspan="2" height="30" valign="top">
					<table>
						<tr>
							<!--- <td valign="bottom">																	
								<img src="#SESSION.root#/images/logos/warehouse/gauge.png" height="40" title="Levels" border="0">
							</td> --->
							<td width="6"></td>
							<td valign="top" class="labellarge">																	
									<cfif attributes.showLocationDescription eq 1>#WarehouseLocation.location# #WarehouseLocation.Description#: </cfif>#getItem.ItemDescription# <cf_tl id="in"> #getItem.UoMDescription#									
									<br>
									<font size="2">
										<cf_tl id="Status">: <span style="color:#vColorStatus#; font-weight:bold;">#vStatus#</span>
									</font>
								<br>
							</td>
						</tr>		
					</table>
				</td>
			</tr>
						
			<tr><td height="15"></td></tr>
			<tr>
				<td width="5"></td>
				<td class="label" valign="top">
					<font color="808080">#validationMessage#</b></font>
				</td>
			</tr>
			<tr><td height="15"></td></tr>
			<tr>
				<td width="10"></td>
				<td valign="top">
					<table width="40%" align="left">
						<cf_precision number = getItem.ItemPrecision> <!--- returns pformat --->
						<cfset vColor = "808080">
						
						<!--- pending 
						
						<tr>
							<td class="label" style="color:#vColor#;"><cf_tl id="Official Capacity">:</td>
							<td style="color:#vColor#;" align="right">#lsNumberFormat(HighestStock,pformat)#</td>
						</tr>
						<tr>
							<td class="label" style="color:#vColor#;"><cf_tl id="Actual Capacity">:</td>
							<td style="color:#vColor#;" align="right">#lsNumberFormat(MaximumStock,pformat)#</td>
						</tr>
						<tr>
							<td class="label" style="color:#vColor#;"><cf_tl id="Minimum Stock">:</td>
							<td style="color:#vColor#;" align="right">#lsNumberFormat(MinimumStock,pformat)#</td>
						</tr>
						
						--->
						
						<tr>
							<td class="label" style="color:#vColor#;"><cf_tl id="Stock On Hand">:</td>
							<td style="color:#vColor#;" class="labellarge"  align="right">#lsNumberFormat(OnHand.Stock,pformat)#</td>
						</tr>
						
						
					</table>
				</td>
			</tr>
			<tr><td height="15"></td></tr>		
			
<cfelse>	

	<cfset gGraphType  = "strapping">
	<cfset vCapType    = "Official">
	<cfset vShowStrap  = attributes.showStrap>
	
	<cfset vGSize           = WarehouseLocation.StorageHeight>
	<cfset vGSizeHorizontal = WarehouseLocation.StorageWidth>
	<cfset tankDepth        = WarehouseLocation.StorageHeight>
	
	<cfif vGSize gt vGSizeHorizontal>
		<cfset vScale = Attributes.viewPort / vGSize>
	<cfelse>
		<cfset vScale = Attributes.viewPort / vGSizeHorizontal>
	</cfif>		
	
	<cfset vWarehouseName  = WarehouseLocation.WarehouseName>
	<cfset vLocationName   = WarehouseLocation.Description>
	<cfset vUoMDescription = getUoM.UoMDescription>		
	
	<!--- Tank capacity --->
	<cfset gCapacity    = getItem.highestStock>
	
	<!--- Tank type (circle, rectangle) --->
	<cfset vGTankType   = lcase(warehouseLocation.storageShape)>
	
	<!--- Acual Tank capacity in uom and percentage --->
	<cfset vGCapActual  = getItem.MaximumStock>
	<cfset vActual      = getItem.MaximumStock>
	<cfset vActualLabel = getItem.MaximumStock>		
	
	<cf_getStrappingValue
		id = "#getItem.ItemLocationId#"
		lookupValue = "#getItem.MaximumStock#"
		getType = "measurement">
		
	<cfset vActualLabel = resultStrappingValue>
	<cfif vActualLabel neq -1>
		<cfset vActual = (resultStrappingValue * WarehouseLocation.storageHeight / getItem.strappingScale) / tankDepth>
	</cfif>
	
	<!--- Minimum Tank capacity in uom and percentage --->
	<cfset vGCapMinimum 	= getItem.MinimumStock>
	<cfset vMinimum     	= getItem.MinimumStock>
	<cfset vMinimumLabel	= getItem.MinimumStock>		
	
	<cf_getStrappingValue
		id = "#getItem.ItemLocationId#"
		lookupValue = "#getItem.MinimumStock#"
		getType = "measurement">
		
	<cfset vMinimumLabel = resultStrappingValue>
	<cfif vMinimumLabel neq -1>
		<cfset vMinimum = (resultStrappingValue * WarehouseLocation.storageHeight / getItem.strappingScale) / tankDepth>
	</cfif>
	
	<!--- Graph Fuel level --->
	<cfset vQuantity = OnHand.Stock>
	<cfset balance   = vQuantity>
	<cfset fill      = 0>	
	<cfset filllabel = 0>		
	
	<cf_getStrappingValue
		id          = "#getItem.ItemLocationId#"
		lookupValue = "#balance#"
		getType     = "measurement">
		
	<cfset filllabel = resultStrappingValue>
	<cfif filllabel neq -1>
		<cfset fill = (resultStrappingValue * WarehouseLocation.storageHeight / getItem.strappingScale) / tankDepth>
	</cfif>
	
	<!--- Item Precision --->
	
	<cfset vItemPrecision = ",">

	<cfif getItem.ItemPrecision gt 0>
		<cfset vItemPrecision = vItemPrecision & ".">
		<cfloop index="i" from="1" to="#getItem.ItemPrecision#">
			<cfset vItemPrecision = vItemPrecision & "_">
		</cfloop>
	</cfif>			
		
	<!--- Tank Status --->
	
	<cfset vColorStatus = "47D51E"> <!--- green = ok --->
	<cfset vStatus = "OK">
	<cfif OnHand.Stock lte getItem.MinimumStock>
		<cfset vColorStatus = "E1686B"> <!--- red = under minimum --->
		<cfset vStatus = "Under Minimum">
	</cfif>
	
	<cfif attributes.showTank eq 0>
	
		<tr>
			<td colspan="3" align="center" valign="top" class="labellarge">
				<b><cf_tl id="Strapping Reference Table for" class="message"> #getItem.ItemDescription#</b></font>
				<br>
				<font size="2">(Unit = #getItem.UoMDescription#)</font>
				<br>
				<br>
			</td>
		</tr>
		
	<cfelse>
	
		<tr>
			<td valign="top">
				<table>
					<tr>
						<!--- <td valign="bottom">
							<img src="#SESSION.root#/images/logos/warehouse/gauge.png" height="40" title="Levels" border="0">
						</td> --->
						<td width="6"></td>
						<td valign="top" class="labellarge">							
							<cfif attributes.showLocationDescription eq 1>#WarehouseLocation.location# #vLocationName#: </cfif>#getItem.ItemDescription# <cf_tl id="in"> #getUoM.UoMDescription#
							<br>
							<font size="1">
								<cf_tl id="Status">: <span style="color:#vColorStatus#; font-weight:bold;">#vStatus#</span>
							</font>
							<br>
						</td>
					</tr>		
				</table>
			</td>
		</tr>
		<tr><td height="15"></td></tr>
		
	</cfif>
	
	<tr>
		<td align="center" valign="top">	
		
			<cfset vShowTooltip = Attributes.showTooltip>
			
		    <cfif attributes.showTank eq 0>
				<cf_space spaces="110">
			</cfif>			
			
			<!--- Strap quantity --->
			<cfset vStrapQuantity    = 0>
			<cfset vStrapFill        = 0>
			<cfset vStrapLabel       = 0>
			<cfset vIsStrappingTable = 0>
			
			<cfif Strapping.recordCount neq 0>
			
				<cfset vIsStrappingTable = 1>
				<cfset vStrapFill = 0>
			
				<cf_getStrappingValue
					id          = "#getItem.ItemLocationId#"
					lookupValue = "#Attributes.StrappingLevel#"
					getType     = "quantity">
				
				<cfset vStrapQuantity = resultStrappingValue>
				<cfif vStrapQuantity neq -1>
					<cfset vStrapFill = (Attributes.StrappingLevel * WarehouseLocation.storageHeight / getItem.strappingScale) / tankDepth>
				</cfif>
			
				<cfset vStrapLabel = Attributes.StrappingLevel>
				
			</cfif>
			
			<!--- here we show the graph itself -which we need to streamline --->
			<cfset vLink = "#SESSION.root#/Tools/StockTank/StockTankContent.cfm">				
			<cfset vParameters = "">
			<cfset vParameters = vParameters & "gGraphType=#gGraphType#">
			<cfset vParameters = vParameters & "&gCapacityType=#vCapType#">
			<cfset vParameters = vParameters & "&gCapacity=#gCapacity#">
			<cfset vParameters = vParameters & "&gTankType=#vGTankType#">
			<cfset vParameters = vParameters & "&gSize=#vGSize#">
			<cfset vParameters = vParameters & "&gSizeHorizontal=#vGSizeHorizontal#">
			<cfset vParameters = vParameters & "&gScale=#vScale#">
			<cfset vParameters = vParameters & "&warehouseName=#vWarehouseName#">
			<cfset vParameters = vParameters & "&locationName=#vLocationName#">
			<cfset vParameters = vParameters & "&uomDescription=#vUoMDescription#">
			<cfset vParameters = vParameters & "&balance=#balance#">
			<cfset vParameters = vParameters & "&fill=#fill#">
			<cfset vParameters = vParameters & "&filllabel=#filllabel#">
			<cfset vParameters = vParameters & "&gActual=#vActual#">
			<cfset vParameters = vParameters & "&gActualLabel=#vActualLabel#">
			<cfset vParameters = vParameters & "&gCapActual=#vGCapActual#">
			<cfset vParameters = vParameters & "&gMinimum=#vMinimum#">
			<cfset vParameters = vParameters & "&gMinimumLabel=#vMinimumLabel#">
			<cfset vParameters = vParameters & "&gCapMinimum=#vGCapMinimum#">
			<cfset vParameters = vParameters & "&showstrap=#vShowStrap#">
			<cfset vParameters = vParameters & "&strapbalance=#vStrapQuantity#">
			<cfset vParameters = vParameters & "&strapfill=#vStrapFill#">
			<cfset vParameters = vParameters & "&straplabel=#vStrapLabel#">
			<cfset vParameters = vParameters & "&tWidth=#warehouselocation.storageWidth#">
			<cfset vParameters = vParameters & "&tHeight=#warehouselocation.storageHeight#">
			<cfset vParameters = vParameters & "&tDepth=#warehouselocation.storageDepth#">
			<cfset vParameters = vParameters & "&itemlocationid=#getItem.ItemLocationId#">
			<cfset vParameters = vParameters & "&tooltipfontsize=#attributes.tooltipfontsize#">
			<cfset vParameters = vParameters & "&showTank=#attributes.showTank#">
			<cfset vParameters = vParameters & "&strappingScale=#getItem.strappingScale#">
			<cfset vParameters = vParameters & "&strappingIncrement=#getItem.strappingIncrement#">
			<cfset vParameters = vParameters & "&itemPrecision=#vItemPrecision#">
			<cfset vParameters = vParameters & "&showtooltip=#vShowTooltip#">
			<cfset vParameters = vParameters & "&isstrappingtable=#vIsStrappingTable#">
			<cfset vParameters = vParameters & "&showUllage=#attributes.showUllage#">
			<cfset vParameters = vParameters & "&viewPort=#attributes.viewPort#">
			<cfset vParameters = vParameters & "&fontSize=#attributes.fontSize#">

			<cfdiv bind="url:#vLink#?#vParameters#" id="divStrapGraphOfficial#attributes.tankid#">
															   
		</td>			
		
	</tr>	
	
</cfif>			
		
</table>	
	
</cfoutput>
