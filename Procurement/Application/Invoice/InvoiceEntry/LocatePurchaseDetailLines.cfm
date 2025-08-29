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
<cfquery name="getLines" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT  P.*, 
	
	        Cl.Description AS OrderClassdescription, 
	        Tp.Description AS OrderTypeDescription, 
			S.Description as ActionDescription,
			
			L.OrderQuantity, 
			L.OrderUoM, 
			L.OrderItem,
			L.Currency, 
			L.OrderAmountCost, 
			L.OrderAmountTax, 
			L.OrderAmount
			
	FROM    Purchase P, 
	        Ref_OrderClass Cl, 
			Ref_OrderType Tp, 
			PurchaseLine L,
			Status S	
			
	WHERE 	P.PurchaseNo   = L.PurchaseNo
	AND     P.OrderType    = Tp.Code		
	AND     P.OrderClass   = Cl.Code				
	AND     P.ActionStatus = S.Status
	AND     S.StatusClass  = 'Purchase'	
	AND     P.PurchaseNo = '#url.purchaseno#' 
	
</cfquery>
	
<table width="100%" cellspacing="0" cellpadding="0">
 
    <!--- lines of the purchase order --->
		
	<cfoutput query="getLines">		
	    
	<tr bgcolor="FBFCDA" class="linedotted cellcontent">			
		<td width="40%" style="padding-left:5px">#OrderItem#</td></td>
	   	<td width="10%" align="right">#OrderQuantity#</td>
		<td width="15%" align="center">#OrderUoM#</td>
		<td width="8%" align="center">#Currency#</td>
		<td width="10%" align="right">
		
			<cfif OrderQuantity neq "0">
			#NumberFormat(OrderAmount/OrderQuantity,",__.__")#
			<cfelse>
			<font color="FF0000">0</font>
			</cfif>
		
		</td>
	    <td width="10%" align="right">#NumberFormat(OrderAmount,",__.__")#</td>
	</tr>	
			
  </cfoutput>
	
</table>
	   