
<!--- 
Validation Rule :  I06
Name			:  Verify If the TVRQ has only a NOC line or only an ITN line, and no other line types, then the TVRQ should|
                   not be available for claiming in the portal,  neither as an Express Claim, nor as a Detailed   
                   Claim.
Steps			:  Claim Request Itin should have three or more records
Date			:  17 September 2007
--->

<!--- header home leave with different line --->

<cfquery name="CheckITN" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM     ClaimRequestLine
 WHERE    ClaimRequestId = '#Claim.ClaimRequestId#'
 AND ClaimCategory IN ('NOC','ITIN')
</cfquery>

<cfquery name="CheckAll" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM     ClaimRequestLine
 WHERE    ClaimRequestId = '#Claim.ClaimRequestId#'
</cfquery>

<cfif CheckITN.recordcount eq "1" and CheckAll.recordcount eq "1">

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
