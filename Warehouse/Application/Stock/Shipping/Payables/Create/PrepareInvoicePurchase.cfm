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
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ParameterMission
		WHERE    Mission = '#URL.Mission#'
</cfquery>

<cfquery name="ResultSet" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT   P.*, 
	         OC.Description AS OrderClassdescription, 
			 OT.Description AS OrderTypeDescription, 
			 S.Description AS ActionDescription, 
			 
			 
		    (SELECT SUM(OrderAmount) 
			 FROM   PurchaseLine
			 WHERE  PurchaseNo = P.PurchaseNo) AS TotalOrderAmount, 	
			
			(SELECT MIN(DeliveryStatus) 
			 FROM      PurchaseLine
			 WHERE  PurchaseNo = P.PurchaseNo) AS PurchaseDeliveryStatus,	  	
			
    	    
			 PL.OrderQuantity, 
			 PL.OrderUoM, 
			 PL.OrderItem, 
             PL.Currency, 
			 PL.OrderAmountCost, 
			 PL.OrderAmountTax, 
			 PL.OrderAmount, 			 
             S.StatusClass
    FROM     Purchase P INNER JOIN
             PurchaseLine PL ON P.PurchaseNo = PL.PurchaseNo INNER JOIN
             Ref_OrderClass OC ON P.OrderClass = OC.Code INNER JOIN
             Ref_OrderType OT ON P.OrderType = OT.Code INNER JOIN
             Status S ON P.ActionStatus = S.Status
    WHERE    P.Mission       = '#url.mission#' 
	
	AND      P.OrgUnitVendor IN (SELECT OrgUnitVendor FROM Materials.dbo.WarehouseLocation WHERE Warehouse = '#url.warehouse#') 	
	
	AND      S.StatusClass   = 'Purchase'
	
	AND      P.OrderType IN (SELECT FundingOrderType FROM Materials.dbo.Ref_ParameterMission WHERE Mission = '#url.mission#')
		
</cfquery>

<table width="100%" border="0" bgcolor="white">
	
	<tr><td>
	
	<table width="98%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	
	<tr>
		<td height="20" width="5%"></td>		
		<td class="labelit">Purchase No</td>
		<td class="labelit">Class</td>
		<td class="labelit">Type</td>
		<td class="labelit">Status</td>
		<td></td>
		<td class="labelit">Curr.</td>
		<td class="labelit" align="right">Amount</td>
		<td></td>
	</tr>
	
	<tr><td height="1" class="linedotted" colspan="9"></td></tr>
	
	<cfif ResultSet.recordcount eq "0">
	
	<tr><td colspan="9" class="labelmedium" style="height:30px" align="center"><font color="FF6464">No valid purchase orders available</font></td></tr>
	<tr><td class="linedotted" colspan="10"></td></tr>
	
	</cfif>	
	
	<input type="hidden" id="purchasenoselect" name="purchasenoselect" value="<cfoutput>#ResultSet.PurchaseNo#</cfoutput>">
	
	<cfoutput query="ResultSet" group="PurchaseNo">
		
		<tr id="p#currentrow#" style="cursor: pointer;" class="cellcontent navigation_row">
			
		<td width="5%" align="center" style="height:20;padding-left:10px">
		
				<input type="radio" class="navigation_action" onclick="document.getElementById('purchasenoselect').value='#PurchaseNo#'" name="PurchaseNo" value="#PurchaseNo#" <cfif currentrow eq "1">checked</cfif>>
					
		</td>
				
		<td style="padding-left:8px"><a href="javascript:ProcPOEdit('#Purchaseno#','view')">
		
			<cfparam name="ResultSet.Userdefined#Parameter.PurchaseCustomField#" default="">
						
			<cfif Parameter.PurchaseCustomField	eq "">
				<font color="6688aa">#PurchaseNo#</font>
			<cfelse>
				<font color="6688aa">		
				<cfif evaluate("ResultSet.Userdefined#Parameter.PurchaseCustomField#") neq "">
				#evaluate("ResultSet.Userdefined#Parameter.PurchaseCustomField#")#<cfelse>#PurchaseNo#</cfif>		
				</font>
			</cfif>
						
		</td>
		
		<td onClick="javascript:invoiceentry('#orgunitvendor#','#PurchaseNo#','#PersonNo#')">#OrderClassDescription#</td>
		<td onClick="javascript:invoiceentry('#orgunitvendor#','#PurchaseNo#','#PersonNo#')">#OrderTypeDescription#</td>
		<td>#ActionDescription# <cfif ActionStatus eq "3">on: <u>#DateFormat(OrderDate, CLIENT.DateFormatShow)#</u></cfif></td>
		<td></td>
		
		<td width="50">#currency#</td>
		<td width="100" align="right" onClick="javascript:invoiceentry('#orgunitvendor#','#PurchaseNo#')">#NumberFormat(TotalOrderAmount,",__.__")#</td>
		<td align="center"></td>
		</tr>
		
		<tr id="#purchaseno#" bgcolor="f6f6f6" class="hide">
		<td bgcolor="white"></td>
		
		<td colspan="8">
		
		  <table width="100%">
		 
		    <!--- lines of the purchase order --->
			
			<cfoutput>
			    <tr><td></td><td colspan="5" class="linedotted"></td></tr>
				<tr class="cellcontent">			
					<td width="30%">#OrderItem#</td></td>
				   	<td width="10%" align="right">#OrderQuantity#</td>
					<td width="20%" align="center">#OrderUoM#</td>
					<td width="10%" align="center">#Currency#</td>
					<td width="12%" align="right">#NumberFormat(OrderAmount/OrderQuantity,",__.__")#</td>
				    <td width="12%" align="right">#NumberFormat(OrderAmount,",__.__")#</td>
				</tr>		
			</cfoutput>
			
		   </table>
		   </td>
		</tr>
		
		<tr><td colspan="9" class="linedotted"></td></tr>
		
	</cfoutput>
		
	</table>
	
	</td></tr>
	
</table>
	
<cfset ajaxonload("doHighlight")>