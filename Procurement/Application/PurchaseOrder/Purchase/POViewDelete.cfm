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
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   PurchaseLine
		WHERE  RequisitionNo = '#URL.ReqNo#'
</cfquery>

<cfquery name="purchase" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Purchase
		WHERE  PurchaseNo = '#get.PurchaseNo#'
	</cfquery>

<cfquery name="CheckReceipt" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   PurchaseLineReceipt
		WHERE  RequisitionNo = '#URL.ReqNo#'
		AND    ActionStatus IN ('1','2','3')
	</cfquery>

<cfoutput>

<table width="100%">

<cfif checkreceipt.recordcount gte "0" and getAdministrator("*") eq "0">

	<tr class="labelmedium">
	<td colspan="2" style="font-weight:350">You may not remove the purchase line since there are one or more confirmed receipts</td>
	</tr>
	
	<tr><td colspan="2" align="center" style="padding-top:30px">
	
	   <cf_tl id="close" var="1">
	   <cfset vClose="#lt_text#">	
		
		
	<input type="button" class="button10g" name="Close" value="#vClose#" onclick="ProsisUI.closeWindow('linedecision')">
		
	</td>
	</tr>
	
<cfelseif purchase.actionstatus gte "2">

	<tr class="labelmedium">
	<td colspan="2" style="font-weight:350">You may not remove the purchase line since the order has been approved</td>
	</tr>
	
	<tr><td colspan="2" align="center" style="padding-top:30px">
	
	   <cf_tl id="close" var="1">
	   <cfset vClose="#lt_text#">	
		
		
	<input type="button" class="button10g" name="Close" value="#vClose#" onclick="ProsisUI.closeWindow('linedecision')">
		
	</td>
	</tr>	
	
<cfelse> 
	
	<tr class="labelmedium">
	<td colspan="2" style="font-weight:350;padding-bottom:10px">This option allows you to send back the requisition to the Buyer who created this obligation in order to modify and resubmit.</td>
	</tr>
	
	<cfif url.no eq "1">
	<tr class="labelmedium">
	<td style="font-weight:350"><cf_tl id="Remove also the obligation">#get.PurchaseNo#:</td>
	<td>
	<input class="radiol" type="checkbox" id="removepo" value="1"></td>
	<cfelse>
	<input type="hidden" id="removepo" value="1">
	</cfif>
	</tr>
	
	<cfif url.no eq "1">
	<tr class="labelmedium">
	<td style="font-weight:350"><cf_tl id="Reinstate requisition for Buyer">:</td>
	<td>
	<input class="radiol" type="checkbox" id="reinstatereq" checked value="1"></td>
	<cfelse>
	<input type="hidden" id="reinstatereq" value="1">
	</cfif>
	</tr>
	
	<tr><td colspan="2" align="center" style="padding-top:18px">
	
	   <cf_tl id="close" var="1">
	   <cfset vClose="#lt_text#">	
		
	   <cf_tl id="Send back" var="1">
	   <cfset vRemove="#lt_text#">	
	
	<table>
	<tr>
	<td>
	<input type="button" class="button10g" name="Close" value="#vClose#" onclick="ProsisUI.closeWindow('linedecision')">
	</td>
	<td>
	<input type="button" class="button10g" name="Delete" value="#vRemove#" 
	  onclick="ptoken.location('#session.root#/Procurement/Application/PurchaseOrder/Purchase/POViewProcess.cfm?reinstatereq='+document.getElementById('reinstatereq').checked+'&removepo='+document.getElementById('removepo').checked+'&Role=#URL.Role#&ID1=#URL.ID1#&Sort=#URL.Sort#&reqno=#url.reqno#')">
	</td>
	</table>
	
	</td></tr>

</cfif>

</table>

</cfoutput>

