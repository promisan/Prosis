
<!--- 
Validation Rule :  R05
Name			:  Verify different DSA code
Steps			:  Determine if DSA code in travel request is not used in claim at all
Date			:  15 November 2007
--->


<cfquery name="Check" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT ServiceLocation 
	FROM   ClaimRequestDSA
	WHERE  ClaimRequestId = '#ClaimRequest.ClaimRequestId#'
	AND    ServiceLocation NOT IN (SELECT  LocationCode
							       FROM    ClaimLineDSA
								   WHERE   ClaimId = '#URL.ClaimId#'
								   )   
</cfquery>		

<cfif Check.recordcount gte "1">

	 <cf_ValidationInsert
    	ClaimId        = "#URL.ClaimId#"
		ClaimLineNo    = ""
		CalculationId  = "#rowguid#"
		ValidationCode = "#code#"
		ValidationMemo = "#Description#"
		Mission        = "#ClaimRequest.Mission#">
		
</cfif>	 		
		


