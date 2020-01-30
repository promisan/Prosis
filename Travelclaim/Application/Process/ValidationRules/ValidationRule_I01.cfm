
<!--- 
Validation Rule :  I01
Name			:  Verify consistant traveller type
Steps			:  Determine if traveller in the header <> Household memmber
Date			:  05 April 2006
Last date		:  05 June 2006
--->

<cfif ClaimTitle.ClaimantType eq "3">

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
	


