
<!--- 
Validation Rule :  R10
Name			:  Claimant entered remarks
Steps			:  Check claim remarks indicator
Date			:  15 November 2007
--->

<cfquery name="Check" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#"> 
	SELECT   Remarks
	FROM     Claim
	WHERE    ClaimId = '#URL.ClaimId#'	
</cfquery>		

<cfif len(check.remarks) gte "10">

	 <cf_ValidationInsert
    	ClaimId        = "#URL.ClaimId#"
		ClaimLineNo    = ""
		CalculationId  = "#rowguid#"
		ValidationCode = "#code#"
		ValidationMemo = "#Description#"
		Mission        = "#ClaimRequest.Mission#">
		
</cfif>	 		
		


