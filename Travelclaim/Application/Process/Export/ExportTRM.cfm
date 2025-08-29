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
<cfset Cat = "TRM">

<cfquery name="Category" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_ClaimCategory
	WHERE     Code = '#cat#'
</cfquery>

<cfquery name="BaseSet" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO stExportFileLine
	(ExportNo,
	#PreserveSingleQuotes(Header0)#,
	ClaimObligated,
	PortalLineNo,
	ReferenceTVLT,
	LineIndexNo,
	#fund1#,
	LineDate,
	LineCurrency,
	LineAmount,
	LineAccountAmount)
SELECT  '#No#', 
        #PreserveSingleQuotes(Header1)#,
		LC.ClaimObligated,
		MIN(L.CostLineNo),
		'#Category.ReferenceTVLT#',
		stDetail.IndexNo,
		#fund1#,
		MIN(ClaimEvent.EventDateEffective) as Date,
		L.InvoiceCurrency, 
		SUM(LC.MatchingInvoiceAmount) AS InvoiceAmount, 
		SUM(LC.MatchingInvoiceAmount * Fd.Percentage) AS Amount
FROM    stPerson stDetail INNER JOIN
        ClaimEventIndicatorCost L INNER JOIN
        stPerson Person INNER JOIN
        Claim C ON Person.PersonNo = C.PersonNo INNER JOIN
        ClaimEvent ON C.ClaimId = ClaimEvent.ClaimId ON L.ClaimEventId = ClaimEvent.ClaimEventId ON stDetail.PersonNo = L.PersonNo INNER JOIN
        ClaimEventIndicatorCostLine LC ON L.ClaimEventId = LC.ClaimEventId AND L.IndicatorCode = LC.IndicatorCode AND 
        L.CostLineNo = LC.CostLineNo INNER JOIN
        stClaimFunding Fd ON LC.ClaimRequestId = Fd.ClaimRequestId AND LC.ClaimRequestLine = Fd.ClaimRequestLineNo	
WHERE   L.IndicatorCode = '#cat#' 
AND     C.ExportNo = '#No#'
GROUP BY Fd.ClaimRequestId,
         Fd.f_tvrq_doc_id, 
         Fd.f_tvrl_seq_num, 
		 LC.ClaimObligated,
		 Fd.seq_num,
		 C.ClaimId,
		 C.ClaimException,
		 C.PaymentMode,
		 L.InvoiceCurrency, 
         Person.IndexNo, 
		 stDetail.IndexNo,
		 C.DocumentNo, 
		 C.ClaimDate,
		 C.PaymentCurrency,
	     C.PaymentFund,
		 C.AccountPeriod,
		 #fund1#
ORDER BY C.DocumentNo	
</cfquery>	

<!--- 1. correction for non-obligated lines as fields are not needed ---> 

<!--- old code 
FROM    stPerson Person INNER JOIN
        Claim C ON Person.PersonNo = C.PersonNo INNER JOIN
        ClaimEvent ON C.ClaimId = ClaimEvent.ClaimId INNER JOIN
        ClaimEventIndicatorCost L INNER JOIN
        stClaimFunding Fd ON L.ClaimRequestId = Fd.ClaimRequestId AND L.ClaimRequestLineNo = Fd.ClaimRequestLineNo ON 
        ClaimEvent.ClaimEventId = L.ClaimEventId INNER JOIN
        stPerson stDetail ON L.PersonNo = stDetail.PersonNo		
--->

 