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
			 
<!--- amounts in the payment currency --->

<cfset Cat = "DSA">

<cfquery name="BaseSet" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO stExportFileLine
(   ExportNo,
	#Header0#,
	ReferenceTVLT,
	ClaimObligated,
	PortalLineNo,
	LineIndexNo,
	LineDate,
	LineDateEnd,
	LocationCountry,
	LocationCode,
	LinePercentage,
	IndicatorFood,
	IndicatorAccom,
	#fund1#,
	LineCurrency,
	LineAmount,
	LineAccountAmount)
	
	SELECT   #No#,
	         #PreserveSingleQuotes(Header1)#,
			 '5',
			 '1',
			 DSA.Grouping+100, 
		     LinePerson.IndexNo, 
			 MIN(DSA.CalendarDate) AS DateStart, 
			 MAX(DSA.CalendarDate) AS DateEND, 
	         L.LocationCountry, 
			 L.LocationCity, 
			 DSA.Percentage,
			 '0',
			 '0',
			 #fund1#, 			  
			 C.PaymentCurrency,
			 SUM(DSA.AmountPayment) AS TotalAmount, 
			 SUM(DSA.AmountPayment * Fd.Percentage) AS Amount 
	FROM      ClaimLineDSA DSA INNER JOIN
              stPerson LinePerson ON DSA.PersonNo = LinePerson.PersonNo INNER JOIN
              Ref_PayrollLocation L ON DSA.LocationCode = L.LocationCode AND DSA.LocationCode = L.LocationCode INNER JOIN
              stClaimFunding Fd ON DSA.ClaimRequestId = Fd.ClaimRequestId AND DSA.ClaimRequestLineNo = Fd.ClaimRequestLineNo INNER JOIN
              Claim C ON DSA.ClaimId = C.ClaimId AND DSA.ClaimId = C.ClaimId INNER JOIN
              stPerson Person ON C.PersonNo = Person.PersonNo
	WHERE    C.ExportNo = '#No#'			 
	GROUP BY C.DocumentNo, 
			 C.ClaimDate, 
			 C.ClaimId,
			 C.ClaimException,
			 C.PaymentCurrency,
			 C.PaymentFund,
			 C.PaymentMode,
			 C.AccountPeriod,
			  Fd.seq_num,
			 Fd.ClaimRequestId,
			 Fd.f_tvrq_doc_id, 
			 Fd.f_tvrl_seq_num, 
			 C.PaymentCurrency,
	         DSA.ClaimRequestLineNo, 
	         DSA.Grouping,
			 DSA.Percentage, 
			 DSA.ClaimId, 
			 Person.IndexNo, 
			 L.LocationCountry, 
			 L.LocationCity, 
	         Fd.Percentage, 
			 Fd.seq_num, 
			 LinePerson.IndexNo, 
			 #fund1#
</cfquery>	 

<!--- update the meal indicator --->

<cfquery name="BaseSet" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE    stExportFileLine
SET       IndicatorFood = '1'
WHERE     ExportNo = '#No#' 
AND       LinePercentage < 100 
AND       ClaimId IN
              (SELECT DISTINCT Meal.ClaimId
               FROM   ClaimLineDateIndicator Meal INNER JOIN
                      Ref_Indicator R ON Meal.IndicatorCode = R.Code
               WHERE  R.ParentCode = 'T04')
</cfquery>		

<!--- update the meal indicator --->

<cfquery name="BaseSet" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE    stExportFileLine
SET       IndicatorAccom = '1'
WHERE     ExportNo = '#No#' 
AND       LinePercentage < 100 
AND       ClaimId IN
              (SELECT DISTINCT Meal.ClaimId
               FROM   ClaimLineDateIndicator Meal INNER JOIN
                      Ref_Indicator R ON Meal.IndicatorCode = R.Code
               WHERE  R.ParentCode = 'T03')
</cfquery>											



