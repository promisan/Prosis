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
<cfquery name="get" 
     datasource="AppsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT *
	 FROM Warehouse
	 WHERE Warehouse = '#url.warehouse#'
</cfquery>	 

<cfquery name="Purchase" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 
	    SELECT       PL.PurchaseNo, P.OrderDate, PLR.ReceiptNo, PLR.RequisitionNo, PL.Currency, 
		             RL.Warehouse, RL.WarehouseItemNo, RL.WarehouseUoM, 
		             PL.OrderQuantity, PL.OrderAmountCost, 
		             PLR.ReceiptOrder,
					 
					  (SELECT ReceiptDate FROM Receipt WHERE ReceiptNo = PLR.ReceiptNo) as ReceiptDate, 
					  PLR.WarehouseCurrency, 
                     PLR.WarehousePrice, PLR.ReceiptMultiplier, PLR.ReceiptWarehouse, PLR.TransactionLot, PLR.ReceiptAmountCost, PLR.ReceiptAmountTax, PLR.ReceiptAmount 
        FROM         Purchase AS P INNER JOIN
                     PurchaseLine AS PL ON P.PurchaseNo = PL.PurchaseNo INNER JOIN
                     RequisitionLine AS RL ON PL.RequisitionNo = RL.RequisitionNo LEFT OUTER JOIN
                     PurchaseLineReceipt AS PLR ON PL.RequisitionNo = PLR.RequisitionNo AND PLR.ActionStatus = '0'
        WHERE        P.Mission = '#get.mission#' 
		AND          PL.DeliveryStatus IN ('1', '2')
		AND          RL.Warehouse       = '#url.warehouse#'
		AND          RL.WarehouseItemNo = '#url.itemno#'
        ORDER BY     P.OrderDate, PL.PurchaseNo DESC						
						
</cfquery>

<!--- get price fileds --->

<table width="100%">

	<cfoutput>
	
		<tr class="labelmedium2 fixlengthlist line fixrow">
		    <td><cf_tl id="ReceiptNo"></td>
			<td><cf_tl id="Started"></td>			
			<td align="right"><cf_tl id="In Transit">##</td>
			<td></td>
			<td align="right"><cf_tl id="FOB"></td>	
			<td align="right"><cf_tl id="Transit Cost"></td>	
			<td align="right"><cf_tl id="Est Price"></td>
			<td align="right"><cf_tl id="ETA"></td>		
		</tr>
		
		</cfoutput>
	
		<cfoutput query="Purchase" Group="purchaseno">	
		
		<tr class="labelmedium2 fixlengthlist line">
			
			 <td>#Purchaseno#</td>
			 <td>#dateformat(OrderDate,client.dateformatshow)#</td>				
			 <td align="right">#numberformat(OrderQuantity,',.__')#</td>											
			 <td align="right">#Currency#</td>				
			 <td align="right">#numberformat(OrderAmountCost/OrderQuantity,',.__')#</td>
				
		</tr>				
		
		<cfoutput>		
		
		    <cfif ReceiptOrder neq "">		
						
			<tr class="labelmedium2 fixlengthlist line">
			
			    <td><a href="javascript:receipt('#receiptNo#','receipt')">#receiptNo#</a></td>
				<td>#dateformat(ReceiptDate,client.dateformatshow)#</td>				
				<td align="right">#numberformat(ReceiptWarehouse,',.__')#</td>											
				<td align="right">#Currency#</td>				
				<td align="right">#numberformat(ReceiptAmountCost/ReceiptWarehouse,',.__')#</td>
				
				<cfset cost = ReceiptAmountCost>
				
				<cftry>
										
				<cfquery name="Additional" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					SELECT     SUM(CAST(OOI.DocumentItemValue as Numeric)) as Cost
					FROM       Ref_EntityDocument AS R INNER JOIN
				               OrganizationObjectInformation AS OOI ON R.DocumentId = OOI.DocumentId INNER JOIN
				               OrganizationObject AS OO ON OOI.ObjectId = OO.ObjectId
					WHERE      R.EntityCode = 'ProcReceipt' 
					AND        R.ObjectUsage = 'Price' 
					AND        OO.ObjectKeyValue1 = '#ReceiptNo#'
				</cfquery>	
				
				<cfcatch>
				
				<cfparam name="additional.cost" default=""> 
				
				</cfcatch>
				
				</cftry>
				
				<cfif additional.cost eq "">
				
					<td align="right">n/a</td>	
					<td align="right">n/a</td>
	
				<cfelse>
				
					<cfset cost = (cost + additional.cost)/ReceiptWarehouse>		
					<td align="right">#numberformat(cost,',.__')#</td>	
					
					<cfquery name="Margin" 
					  datasource="AppsOrganization" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						SELECT     TOP 1 CAST(OOI.DocumentItemValue as Float) as Margin
						FROM       Ref_EntityDocument AS R INNER JOIN
					               OrganizationObjectInformation AS OOI ON R.DocumentId = OOI.DocumentId INNER JOIN
					               OrganizationObject AS OO ON OOI.ObjectId = OO.ObjectId
						WHERE      R.EntityCode = 'ProcReceipt' 
						AND        R.ObjectUsage = 'Margin' 
						AND        OO.ObjectKeyValue1 = '#ReceiptNo#'
					</cfquery>	
					
					<cfif Margin.recordcount eq "0">
					
					  <td align="right">n/a</td>
					
					<cfelse>
					
					  <cfset price = cost + (cost * margin.margin)> 
					  <td align="right">#numberformat(price,',.__')#</td>	
					
					</cfif>
								
				</cfif>	
				
				<cfquery name="ETA" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					SELECT     TOP 1 OOI.DocumentItemValue as ETA
					FROM       Ref_EntityDocument AS R INNER JOIN
				               OrganizationObjectInformation AS OOI ON R.DocumentId = OOI.DocumentId INNER JOIN
				               OrganizationObject AS OO ON OOI.ObjectId = OO.ObjectId
					WHERE      R.EntityCode = 'ProcReceipt' 
					AND        OO.Operational = 1
					AND        R.ObjectUsage = 'ETA' 
					AND        OO.ObjectKeyValue1 = '#ReceiptNo#'
				</cfquery>	
				
				<cfif ETA.recordcount eq "1">
				
				<td align="right">#dateformat(ETA.ETA,'#client.dateformatshow#')#</td>	
				
				<cfelse>
				
				<td align="right">n/a</td>
				
				</cfif>				
					
			</tr>
			
			</cfif>	
			
		</cfoutput>
		
	</cfoutput>	
	
</table>