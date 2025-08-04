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

<!--- show the purchase line logging --->

<cfquery name="Amendment" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     PurchaseLineAmendment
	WHERE    RequisitionNo = '#url.requisitionno#'
	ORDER BY Created 
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0">

<tr><td class="labelit" align="center" style="padding:20px">
Attention: This log contains the purchase line value as it has been prior to each amendments that took place in the course of the purchase order validity.<br> Use the pencil
to record any additional information to be logged (reference and description)</td></tr>

<tr><td style="padding:10px">

	<table width="95%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	
	<tr>
	  <td class="labelit"><cf_space spaces="5"></td>
	  <td class="labelit"><cf_space spaces="28">No</td>
	  <td class="labelit"><cf_space spaces="60">Description</td>
	  <td class="labelit"><cf_space spaces="35">Officer</td>
	  <td class="labelit" align="center"><cf_space spaces="18">Date</td>
	  <td class="labelit" align="right"><cf_space spaces="20">Cost</td>
	  <td class="labelit" align="right"><cf_space spaces="15">Tax</td>
	  <td class="labelit" align="right"><cf_space spaces="20">Amount</td>
	  <td></td>
	</tr>
	
	<tr><td colspan="9" class="line"></td></tr>
	
	<cfoutput query="Amendment">
	
		<cfset url.mode  = "view">
		<cfset url.id    = amendmentid>
	
		<tr class="navigation_row">
			<td height="20" class="labelit" style="padding:3px">#currentrow#</td>
			<td id="boxreference_#amendmentid#" class="labelit">
			
				<cfset url.field = "reference">			
			    <cfinclude template="PurchaseLineEditLogField.cfm">
				
			</td>
			<td id="boxmemo_#amendmentid#" class="labelit">
			    <cfset url.field = "memo">			
			    <cfinclude template="PurchaseLineEditLogField.cfm">
			</td>
			<td class="labelit">#officerLastName#</td>
			<td align="center" class="labelit">#dateformat(created,CLIENT.DateFormatShow)#</td>
			<td align="right" class="labelit"><cfif amountcost lt 0><font color="FF0000"></cfif>#numberformat(amountCost,"__,__.__")#</td>
			<td align="right" class="labelit"><cfif amounttax lt 0><font color="FF0000"></cfif>#numberformat(amountTax,"__,__.__")#</td>
			<td align="right" class="labelit"><cfif amount lt 0><font color="FF0000"></cfif>#numberformat(amount,"__,__.__")#</td>		
		</tr>
		<tr><td colspan="9" class="line"></td></tr>
		
	</cfoutput>
	
	</table>

</td></tr>

</table>

<cfset AjaxOnLoad("doHighlight")>	
