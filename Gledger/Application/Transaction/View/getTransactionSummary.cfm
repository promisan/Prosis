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
   datasource="AppsLedger" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		SELECT *
		FROM   TransactionHeader
		WHERE  TransactionId   = '#url.TransactionId#'		  
</cfquery>

<!--- contra-account --->

<cfquery name="SelectLines"
   datasource="AppsLedger" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		SELECT GLAccount, sum(AmountDebit-AmountCredit) as Total
		FROM   TransactionLine
		WHERE  Journal = '#get.Journal#'		  
		AND    JournalSerialNo = '#get.JournalSerialNo#'
		AND    TransactionSerialNo = '0' 
		GROUP BY GLAccount
</cfquery>

	
<!--- we obtain the transaction that serve (parent) this parent transaction and that have the same account so it is normally meant as offset --->

<cfquery name="Associated" 
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT    TH.Journal,              
			  (SELECT Description FROM Journal WHERE Journal = TH.Journal) as LineJournalName,
	          TH.JournalSerialNo,   
			  TH.JournalTransactionNo, 
			  TL.TransactionLineId,
			  TL.ParentLineId,
			  TL.TransactionDate,
			  TL.Reference,
			  TL.TransactionType,
			  TL.Currency, 
			  TL.GLaccount,
			  TL.AmountDebit,
			  TL.AmountCredit,
			  TL.TransactionAmount, 
			  TL.ExchangeRate, 
			  TL.ParentJournal,
			  TL.ParentJournalSerialNo,
			  <!--- correct offset again parent transaction as you can pay in different modes --->
              TL.AmountDebit  * TL.ExchangeRate AS Debit, 
			  TL.AmountCredit * TL.ExchangeRate AS Credit
			  
    FROM      TransactionLine AS TL 
		   	  <!--- Parent of this offset --->
	          INNER JOIN TransactionHeader AS TH ON TL.ParentJournal = TH.Journal AND TL.ParentJournalSerialNo = TH.JournalSerialNo 
			  <!--- header of the line ONLY valid transaction --->
			  INNER JOIN TransactionHeader AS LH ON TL.Journal         = LH.Journal 
			                                    AND TL.JournalSerialNo = LH.JournalSerialNo 
												AND LH.RecordStatus <> '9' 
												AND LH.ActionStatus IN ('0', '1')
	WHERE 	  TL.Journal         = '#get.Journal#' 
    AND       TL.JournalSerialNo = '#get.JournalSerialNo#' 
	AND  	  TL.GLAccount       <> '#SelectLines.GLAccount#'
	<!--- this is to find the offset from the parent --->
   	  																					 	
	AND      	TH.RecordStatus <> '9' AND TH.ActionStatus IN ('0', '1')													 
	
	ORDER BY    TL.Journal, TL.JournalSerialNo, TL.TransactionSerialNo, TL.Created
					
</cfquery>

<cfoutput>

<cf_divscroll>

<table width="95%" border="0" align="center" class="navigation_table">

	<tr class="labelmedium line fixrow">
	    <td style="width:80%"><cf_tl id="Transaction"></td>
		   <td style="min-width:80px"><cf_tl id="Date"></td>
		   <td style="min-width:50px"><cf_tl id="Currency"></td>
		   <td style="min-width:80px"></td>
		   <td style="min-width:100px" align="right"><cf_tl id="Exchange rate"></td>
		   <td style="min-width:100px" align="right">
		   <cfif SelectLines.Total lt 0><cf_tl id="Credit"><cfelse><cf_tl id="Debit"></cfif>		   
		   </td>
	</tr>	
	
	<tr class="labelmedium line fixrow2">
	    <td style="width:80%;font-size:18px">#Get.JournalTransactionNo#</td>
		<td style="min-width:90px;font-size:15px">#dateformat(get.TransactionDate,client.dateformatshow)#</td>
		<td style="min-width:80px;font-size:15px">#Get.Currency#</td>
		<td style="min-width:100px"></td>
		<td style="min-width:100px"></td>
		<td style="min-width:100px;font-size:20px" align="right">#numberformat(SelectLines.Total,',.__')#</td>
	</tr>	
	
	<cfloop query="Associated">
			
	<tr class="labelmedium navigation_row line">
	    <td style="width:80%;font-size:15px;padding-left:5px"><a href="javascript:ShowTransaction('#Journal#','#JournalserialNo#')">#JournalTransactionNo#</td>
		<td style="min-width:90px;;font-size:15px">#dateformat(TransactionDate,client.dateformatshow)#</td>
		   <td style="min-width:80px;;font-size:13px">#currency#</td>
		   <td style="min-width:80px;;font-size:13px"><cfif currency neq get.currency>#numberformat(TransactionAmount,',.__')#</cfif></td>
		   <td align="right" style="min-width:80px;;font-size:13px">#numberformat(ExchangeRate,',.____')#</td>
		   <td style="min-width:120px;font-size:15px" align="right"><cfif credit gt 0>#numberformat(Credit,',.__')#<cfelse>#numberformat(Debit,',.__')#</cfif></td>
	</tr>	
			
	</cfloop>		
	

</table>

</cf_divscroll>

</cfoutput>

<cfset ajaxonload("doHighlight")>