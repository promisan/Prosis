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

<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_OrderType
	WHERE Code = '#URL.code#'
</cfquery>

<table cellspacing="0" width="480" cellpadding="0" style="border:1px dotted silver" class="formpadding">

<cfif get.InvoiceWorkflow eq "1">
	<tr bgcolor="DFEFFF">
		<td width="20" align="center">-</td><td colspan="1" class="labelit">
			<cf_tl id="For this purchase order invoices will be processed through a workflow" class="message">. <cf_tl id="When selected the receipt registration option is disabled" class="message">
		</td>
	</tr>
</cfif>

<cfif get.ReceiptEntry eq "1">
	<tr bgcolor="DFEFFF">
		<td width="20" align="center">-</td><td colspan="1" class="labelit">
			<cf_tl id="For this purchase order type you may enter receipt details" class="message"> (<cf_tl id="incl. warehouse receipts" class="message">) <cf_tl id="that are not defined in detail in the purchase order itself" class="message">
		</td>
	</tr>
</cfif>

<cfif get.ReceiptEntry eq "9">
	<tr bgcolor="DFEFFF">
		<td width="20" align="center">-</td><td colspan="1" class="labelit">
			<cf_tl id="For this purchase order type there will not be recorded physical receipts" class="message">. <cf_tl id="A workflow is always required here" class="message">.
		</td>
	</tr>
</cfif>

</table>