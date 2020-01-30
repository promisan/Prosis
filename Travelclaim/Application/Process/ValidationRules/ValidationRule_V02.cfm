
<!--- 
Validation Rule :  V02
Name			:  DSA obligated but no advance
Steps			:  Query Request Line for DSA and determine if an advance was issued
Date			:  05 June 2006
--->

<!--- parameter value, to be move to Parameter table --->

<cfset amt = 100>

<cfquery name="CheckDSA" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT  sum(RequestAmount) as Total
	FROM    ClaimRequestLine
	WHERE   ClaimRequestId = '#ClaimRequest.ClaimRequestId#'
	AND     ClaimCategory IN ('DSA','TRM')
</cfquery>	

<cfquery name="CheckAdvance" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT *
	FROM   IMP_ClaimAdvance
	WHERE  Doc_No         = '#ClaimRequest.DocumentNo#'
	AND    db_mdst_source = '#ClaimRequest.Mission#'
</cfquery>

<cfif checkDSA.recordcount eq "1">
	
	<cfif CheckDSA.total gt amt and CheckAdvance.recordcount eq "0">		 
	
	 <cf_ValidationInsert
	   	ClaimId        = "#URL.ClaimId#"
		ClaimLineNo    = ""
		CalculationId  = "#rowguid#"
		ValidationCode = "#code#"
		ValidationMemo = "#Description#"
		Mission        = "#ClaimRequest.Mission#">
	
	</cfif>	

</cfif>


