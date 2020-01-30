
<!--- 
Validation Rule :  I04
Name			:  Verify if Home leave travel component
Steps			:  Verify for code '9'
Date			:  05 July 2006
Last date		:  05 July 2006 (review)
--->

<!--- header home leave with different line --->

<cfquery name="Header" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM     ClaimRequest
 WHERE    ClaimRequestId = '#URL.RequestId#'
 AND      ActionPurpose = '9'
</cfquery>

<cfif Header.recordcount eq "1">

		<cfquery name="Insert" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ClaimValidation
		       (ClaimId,
			    CalculationId,
				ValidationCode, 
				ValidationMemo) 
		VALUES ('#Claim.ClaimId#',
		        '#rowguid#',
		        '#Code#',
				'#Description#')
		</cfquery>

</cfif>
