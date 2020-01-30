
<!--- 
Validation Rule :  I03
Name			:  Verify if Home leave travel request has Official Business component
Steps			:  Search for overlapping periods for the traveller
Date			:  05 April 2006
Last date		:  05 June 2006 (review)
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

<cfquery name="Line" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM     ClaimRequestLine
 WHERE    ClaimRequestId = '#URL.RequestId#'
 AND      ActionPurpose != '9'
</cfquery>

<cfif Header.recordcount eq "1" and Line.Recordcount gt "0">

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

<!--- line home leave with different header --->

<cfquery name="Header" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM     ClaimRequest
 WHERE    ClaimRequestId = '#URL.RequestId#'
 AND      ActionPurpose != '9'
</cfquery>

<cfquery name="Line" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM     ClaimRequestLine
 WHERE    ClaimRequestId = '#URL.RequestId#'
 AND      ActionPurpose = '9'
</cfquery>

<cfif Header.recordcount eq "1" and Line.Recordcount gt "0">

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

