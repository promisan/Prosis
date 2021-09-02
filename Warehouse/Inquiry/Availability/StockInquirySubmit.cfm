
<cfparam name="url.mission" default="Mariscal">

<cfquery name="get" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		
		SELECT     TOP 400 Mission, Warehouse, WarehouseName,
		           ItemNo, ItemDescription, Category, UoM, UoMName, MinReorderQuantity,
				   PriceSchedule, PriceScheduleDescription, Promotion, Currency, SalesPrice, PriceDate, 
				   QuantityForSale, QuantityReserved
				   
		FROM       (SELECT        L.Mission, W.Warehouse, N.WarehouseName, L.ItemNo, I.ItemDescription, L.Category, L.UoM, L.UoMName, L.PriceSchedule, L.PriceScheduleDescription, L.Promotion, L.Currency, L.SalesPrice, L.PriceDate,
		                          MinReorderQuantity,
		
                                  (SELECT       ISNULL(SUM(TransactionQuantity),0) AS stockOnHand
                                   FROM            ItemTransaction
                                   WHERE        (Mission = L.Mission) AND (Warehouse = W.Warehouse) AND (ItemNo = L.ItemNo) AND (TransactionUoM = L.UoM) AND (WorkOrderId IS NULL)) AS QuantityForSale,
								   
                                  (SELECT       ISNULL(SUM(TransactionQuantity),0) AS stockOnHand
                                   FROM            ItemTransaction AS ItemTransaction_1
                                   WHERE        (Mission = L.Mission) AND (Warehouse = W.Warehouse) AND (ItemNo = L.ItemNo) AND (TransactionUoM = L.UoM) AND (WorkOrderId IS NOT NULL)) AS QuantityReserved
								   
                    FROM           skMissionItemPrice AS L INNER JOIN
                                   ItemWarehouse AS W ON L.ItemNo = W.ItemNo AND L.UoM = W.UoM INNER JOIN
								   Item I ON L.ItemNo = I.ItemNo INNER JOIN
								   Warehouse N ON W.Warehouse = N.Warehouse
					
							   
                    <cfif form.warehouse neq "">
					AND            W.Warehouse = '#form.Warehouse#'
					</cfif>
					<cfif form.category neq "">
					AND            I.Category = '#form.Category#'
					</cfif>
					<cfif Form.itemNo neq "">
					AND            I.ItemNo LIKE '%#form.ItemNo#' 
					</cfif>
					
					<!--- apply the fuzzy search for the name and apply support for spanish sign --->	
					
					<cfif Form.itemName neq "">
					AND            I.ItemDescription LIKE '%#form.ItemName#%' 
					</cfif>
					
					AND            W.Operational   = 1 
					AND            L.PriceSchedule = '3' 
					AND            I.Operational   = 1 ) AS D
					
		WHERE       QuantityForSale IS NOT NULL
		ORDER BY    Mission, Warehouse
		
</cfquery>

<table style="width:98.5%" class="formpadding navigation_table">
		
		<cfoutput>
		<tr class="labelmedium2 fixrow">		
			<td style="padding-left:4px;min-width:170px"><cf_tl id="Store"></td>
			
			<td style="min-width:100px" align="right"><cf_tl id="Sale UoM"></td>
			<td style="min-width:80px" align="right"><cf_tl id="Price"></td>
			<td style="min-width:80px" align="right"><cf_tl id="Promotion"></td>
			
			<td style="min-width:60px" align="right"><cf_tl id="UoM"></td>			
			<td style="min-width:70px" align="right"><cf_tl id="Reserved"></td>
			<td style="min-width:70px" align="right"><cf_tl id="Exhibition"></td>
			<td style="min-width:70px" align="right"><cf_tl id="Disposed"></td>
			<td style="min-width:100px;padding-right:4px;" align="right"><cf_tl id="Available"></td>
		</tr>
		</cfoutput>
		
		<cfoutput query="get" group="ItemDescription">
		
			<cfif form.warehouse eq "">		
			<tr style="height:35px" class="labelmedium2 fixrow2">
				<td colspan="7" style="border-radius:6px;padding-left:13px;background-color:##e6e6e6;font-weight:bold;color:000000;font-size:16px">#ItemNo# : #ItemDescription#</td>	
				<td colspan="2" align="right" style="font-size:18px">#Category#</td>
			</tr>
			
			</cfif>
			
			<!---  not needed
			
			<tr class="labelmedium2 line">
				<td colspan="5" style="padding-left:4px;font-size:12px">last updated </td>	
				<td colspan="4" align="right"  id="box#itemno#" style="font-size:12px">: #dateformat(created,"#client.dateformatshow#")# #timeformat(created,"HH:MM:SS")# 
				   <a href="javascript:stockrefresh('#url.mission#','#warehouse#','#itemno#','box#itemno#')">[refresh]</a>
				</td>
			</tr>
			
			--->
		
			<cfoutput>
			
			<tr class="labelmedium2 line navigation_row">	
   			    <cfif form.warehouse eq "">						
				<td style="font-size:17px;background-color:##f1f1f150;padding-left:18px">#WarehouseName#</td>						
				<cfelse>
				<td style="background-color:##f1f1f150;padding-left:3px">#ItemNo# : #ItemDescription#</td>	
				</cfif>
				<td style="background-color:##B0D8FF50;padding-right:3px" align="right">#MinReorderQuantity#</td>
				<td style="background-color:##B0D8FF50;padding-right:3px" align="right">#numberformat(SalesPrice,',.__')#</td>
				<td style="background-color:##B0D8FF50;padding-right:3px;font-weight:bold" align="right">
				<cfif promotion eq "0">--<cfelse>#numberformat(SalesPrice,',.__')#</cfif></td>		
				<td style="padding-right:3px" align="right">#UoM#</td>									
				<cfif quantityreserved eq "0">
					<td style="font-size:14px;background-color:##e1e1e1;padding-right:3px;" align="right">--</td>
				<cfelse>
					<td style="font-size:15px;background-color:red;padding-right:3px;" align="right">
					<a style="color:white" href="javascript:stockreserve('#warehouse#','#itemno#')">#numberformat(quantityreserved,',.__')#</a>
					</td>
				</cfif>
				
				<td style="backgtround-color:##ffffaf50;padding-right:3px" align="right">
				<!--- <cfif stockexhibited eq "0">--<cfelse>#numberformat(StockExhibited,',.__')#</cfif> --->
				</td>
				<td style="background-color:##ffffaf50;padding-right:3px" align="right">				
				<!--- <cfif stockdisposed eq "0">--<cfelse>#numberformat(StockDisposed,',.__')#</cfif> --->				
				</td>
				<td style="font-size:17px;background-color:##f1f1f150;padding-right:3px;font-weight:bold" align="right">
				<cfif QuantityForSale eq "0">--<cfelse>#numberformat(QuantityForSale,',.__')#</cfif></td>							
			</tr>
			
			</cfoutput>
		
		</cfoutput>
	
	</table>

	<cfset ajaxonload("doHighlight")>
