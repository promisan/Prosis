
<!--- 
Validation Rule :  R02
Name			:  Travel under a DSA code different from the default DSA requires review
Steps			:  Determine if DSA code for a travel city is different from its default
Date			:  05 April 2006
Last date		:  15 June 2006
--->

<!--- query trip info for status 1 --->


<cfquery name="Default" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   DSA.LocationCode 
    FROM     ClaimLineDSA DSA INNER JOIN
             Ref_CountryCityLocation Def 
			  ON DSA.CountryCityId = Def.CountryCityId 
			 AND DSA.LocationCode = Def.LocationCode
    WHERE    ClaimId = '#URL.ClaimId#'
    AND      Def.LocationDefault = 1								
</cfquery> 

<cfquery name="Check" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT DISTINCT LocationCode 
    FROM   ClaimLineDSA 
    WHERE  ClaimId = '#URL.ClaimId#' 
	AND    LocationCode is not NULL
</cfquery>	


<cfif Check.recordcount gt Default.recordcount and Check.recordcount gte "1">

	 <cf_ValidationInsert
    	ClaimId        = "#URL.ClaimId#"
		ClaimLineNo    = ""
		CalculationId  = "#rowguid#"
		ValidationCode = "#code#"
		ValidationMemo = "#Description#"
		Mission        = "#ClaimRequest.Mission#">
		
</cfif>	 		
		


