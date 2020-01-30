
<!--- 
Validation Rule :  R07
Name			:  Verify different DSA code
Steps			:  Claimant has indicated one or more personal days
Date			:  15 November 2007
--->

<cfquery name="Check" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#"> 
   SELECT   *
   FROM     ClaimLineDateIndicator
   WHERE    IndicatorCode = 'P01'
   AND      ClaimId = '#URL.ClaimId#'
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
		


