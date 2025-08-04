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

<!--- show the source of this transaction relevant in case of advances and offset but 
can be used for anything which has 1 or more based transactions and multiple subsequence transactions. It adds another layer
--->

<cfquery name="Transaction" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     H.*
	FROM       TransactionHeader H
	WHERE      H.Journal         = '#URL.Journal#' 
	AND        H.JournalSerialNo = '#URL.JournalSerialNo#' 		
</cfquery>

<!--- obtain relevant financials details --->

<cfquery name="Base" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     L.*
	FROM       TransactionLine L
	WHERE      L.Journal         = '#URL.Journal#' 
	AND        L.JournalSerialNo = '#URL.JournalSerialNo#' 		
	AND        L.TransactionSerialNo <> '0'
</cfquery>

<cfoutput>

<cfquery name="Detail" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT      TH.Journal, 
	            TH.JournalSerialNo, 
				TH.TransactionDate, 
				TL.GLAccount,
				TL.TransactionType, 
				TL.Currency, 
				TL.AmountDebit, 
				TL.AmountCredit, 
				TH.Description, 
				TH.OfficerLastName, 
				TH.Created
	FROM        TransactionHeader AS TH INNER JOIN
	                  TransactionLine AS TL ON TH.Journal = TL.Journal AND TH.JournalSerialNo = TL.JournalSerialNo
	WHERE       TH.Journal             = '#Transaction.Journal#'
	 AND        TH.TransactionSourceNo = '#Transaction.TransactionSourceNo#' 
	 AND        TH.AccountPeriod       = '#Transaction.AccountPeriod#'
	 AND        TL.GLAccount           = '#Base.GLAccount#' 
	
	
	UNION ALL
	
	<!--- associated transactions to the source with the same glaccount --->
	
	SELECT      TH.Journal, 
	            TH.JournalSerialNo, 
				TH.TransactionDate, 
				TL.GLAccount, 
				TL.TransactionType,
				TL.Currency, 
				TL.AmountDebit, 
				TL.AmountCredit, 
				TH.Description, 
				TH.OfficerLastName, 
				TH.Created
	FROM        TransactionHeader AS TH INNER JOIN
	                  TransactionLine AS TL ON TH.Journal = TL.Journal AND TH.JournalSerialNo = TL.JournalSerialNo
					  
	WHERE       TL.GLAccount           = '#Base.GLAccount#' 
	<!--- source adjustment --->
	AND         TL.ReferenceNo         = '#Transaction.TransactionSourceNo#' 
	AND         TH.AccountPeriod       = '#Transaction.AccountPeriod#'
	AND         TH.Mission             = '#Transaction.Mission#'	
	<!--- other journal --->
	AND         TH.Journal            != '#Transaction.Journal#'         
</cfquery>							   
							   
<table style="width:96%" align="center" class="navigation_table">
	<tr class="labelmedium2 line">
	   <td colspan="9" style="font-size:18px">#Transaction.Mission# #Transaction.AccountPeriod# <b>#Transaction.TransactionSourceNo#</b></td>
	</tr>	
	
	<tr class="line labelmedium2">
	   	<td style="padding-left:4px"><cf_tl id="Journal"></td>
		<td><cf_tl id="Serial"></td>
		<td><cf_tl id="Date"></td>
		<td><cf_tl id="Type"></td>
		<td><cf_tl id="Officer"></td>
		<td><cf_tl id="Created"></td>	
		<td><cf_tl id="Currency"></td>
		<td align="right"><cf_tl id="Debit"></td>
		<td align="right" style="padding-right:4px"><cf_tl id="Credit"></td>
		
	</tr>
	
	<cfloop query="Detail">
		<tr class="line labelmedium2 navigation_row">
			<td style="padding-left:4px">#Journal#</td>
			<td>#JournalSerialNo#</td>
			<td>#dateformat(TransactionDate,client.dateformatshow)#</td>
			<td>#TransactionType#</td>
			<td >#OfficerLastName#</td>
			<td >#dateformat(Created,client.dateformatshow)#</td>
			<td>#Currency#</td>			
			<td align="right">#numberFormat(AmountDebit,",.__")#</td>
			<td align="right" style="padding-right:4px">#numberFormat(AmountCredit,",.__")#</td>			
		</tr>
	</cfloop>
	
	<tr><td colspan="9" align="center" style="padding-top:4px">
	<input type="button" value="Close" class="button10g" onclick="ProsisUI.closeWindow('source')">
	</td></tr>
</table>

</cfoutput>

<cfset ajaxOnLoad("doHighlight")>