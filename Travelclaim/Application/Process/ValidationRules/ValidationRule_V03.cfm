
<!--- 
Validation Rule :  V03
Name			:  Recovery on an advance
Steps			:  Determine of claim line amount < Advance amount
Issues			:  Comparison based on converted amount = USD
Date			:  05 June 2006
--->

<cfquery name="Check" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT sum(ClaimAmountBase) as Claimed
	FROM   ClaimLine
	WHERE  ClaimId = '#URL.ClaimId#' 
</cfquery>	

<cfquery name="Advance" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT sum(cnvrt_bal) as Advance
	FROM   IMP_ClaimAdvance
	WHERE  Doc_No = '#ClaimRequest.DocumentNo#'
	AND db_mdst_source = '#ClaimRequest.Mission#'
</cfquery>

<cfif Check.Claimed lt Advance.advance>		 

 <cf_ValidationInsert
   	ClaimId        = "#URL.ClaimId#"
	ClaimLineNo    = ""
	CalculationId  = "#rowguid#"
	ValidationCode = "#code#"
	ValidationMemo = "#Description#"
	Mission        = "#ClaimRequest.Mission#">
	
</cfif>	

