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
<cfoutput>

<cfquery name="ItemTotal" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT SUM(ReceiptAmountBaseCost) as Total
	 FROM   PurchaseLineReceipt 
	 WHERE  ReceiptNo    = '#url.ReceiptNo#'
	 AND    ActionStatus <> '9'
</cfquery>

<cfif ItemTotal.total eq "">
	<cfset itm = 0>
<cfelse>
	<cfset itm = ItemTotal.total>
</cfif>

<cfquery name="CostTotal" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT SUM(AmountCost) as Total
	 FROM   PurchaseLineReceiptCost 
	 WHERE  ReceiptId IN (SELECT ReceiptId
	                      FROM PurchaseLineReceipt 
						  WHERE ReceiptNo = '#url.ReceiptNo#' 
						  AND ActionStatus <> '9')	
</cfquery>

<cfif CostTotal.total eq "">
	<cfset cst = 0>
<cfelse>
	<cfset cst = CostTotal.total>
</cfif>

<cfquery name="TransactionTotal" 
	 datasource="AppsLedger" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	 
	    SELECT    SUM(L.AmountBaseDebit) as AmountBaseDebit, 
                  SUM(L.AmountBaseCredit) as AmountBaseCredit
	    FROM      TransactionHeader H INNER JOIN
                  TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
                  Ref_Account R ON L.GLAccount = R.GLAccount
				   
		WHERE     H.Mission              = '#url.mission#'	
	    AND       H.TransactionSource    = 'ReceiptSeries'
	    AND       H.TransactionSourceNo  = '#url.receiptno#'	
		AND       H.TransactionSourceId IS NULL <!--- cost reflected on the lines --->										
	    AND       H.ActionStatus         <> '9' 	
		AND       L.TransactionSerialNo != '0'  
		AND       R.TaxAccount           = '0'				
</cfquery>	

<cfquery name="Activated" 
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	 	 
		SELECT     SUM(TransactionValue) AS Total
		FROM       ItemTransaction
		WHERE      TransactionType = '1'
		AND        ReceiptId IN
                             (SELECT    ReceiptId
                               FROM     Purchase.dbo.PurchaseLineReceipt
                               WHERE    ReceiptNo = '#url.receiptno#')							   
	   
</cfquery>

<cfif TransactionTotal.AmountBaseDebit eq "">
	<cfset amt = 0>
	<cfset prc = "">
<cfelse>
    <cfset amt = TransactionTotal.AmountBaseDebit - TransactionTotal.AmountBaseCredit>
	<cfif itm gte "1">
		<cfset prc = "(#numberformat(((amt/itm)*100),"__._")#%)&nbsp;">
	</cfif>
</cfif>   
      
<script> 
    
    try { document.getElementById('totaldirect').innerHTML    = '#numberformat(itm,',.__')#' }     catch(e) {}
	try { document.getElementById('totalother').innerHTML     = '#prc# #numberformat(amt,',.__')#' }     catch(e) {}
	try { document.getElementById('totalsum').innerHTML       = '#numberformat(itm+cst+amt,',.__')#' } catch(e) {}	
	try { document.getElementById('activatedsum').innerHTML   = '#numberformat(Activated.Total,',.__')#' } catch(e) {}
</script>
   
</cfoutput>   