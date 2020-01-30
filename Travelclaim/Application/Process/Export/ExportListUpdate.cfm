
<cfquery name="Update" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	UPDATE  Claim
	SET     AccountPeriod = '#URL.AccountPeriod#'    
	WHERE   ClaimId = '#URL.ClaimId#'
</cfquery>