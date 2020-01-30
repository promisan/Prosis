
<!--- 
Validation Rule :  R09
Name			:  TRM calculated by the Portal but not obligated in TVRQ
Steps			:  Check if TRM exist but not in Obligation
Date			:  15 January 2008
--->

<cfquery name="Check1" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#"> 
 	SELECT   *
	FROM     ClaimEventIndicatorCost CI INNER JOIN
             ClaimEvent C ON CI.ClaimEventId = C.ClaimEventId
	WHERE    CI.IndicatorCode = 'TRM'
	AND      C.ClaimId = '#URL.ClaimId#'
</cfquery>	
 
<cfquery name="Check2" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#"> 
 	SELECT   *
    FROM     ClaimRequestLine
    WHERE    ClaimRequestid = '#ClaimRequest.ClaimRequestId#'
	AND      ClaimCategory = 'TRM'	
</cfquery>							

<cfif Check1.recordcount gte "1" and Check2.recordcount eq "0">

	 <cf_ValidationInsert
    	ClaimId        = "#URL.ClaimId#"
		ClaimLineNo    = ""
		CalculationId  = "#rowguid#"
		ValidationCode = "#code#"
		ValidationMemo = "#Description#"
		Mission        = "#ClaimRequest.Mission#">
				
</cfif>	 		
		


