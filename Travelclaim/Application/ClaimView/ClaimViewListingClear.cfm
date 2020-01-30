
<cfsilent>

<proUsr>administrator</proUsr>
<proOwn>Hanno van Pelt</proOwn>
<proDes></proDes>
<proCom></proCom>
<proCM></proCM>

<proInfo>
<table width="100%" cellspacing="0" cellpadding="0">
<tr><td>
This template can be disabled, as it performs a check on the content of the claim database to prevent double claims for the same TVRQ.
This occurred during testing because if incorrect coding of the create claim button. 

Note : it does not hurt to keep it either.
</td></tr>
</table>
</proInfo>

</cfsilent>

<!--- safe guard --->

<cfquery name="Clear1" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   ClaimRequestId 
		FROM     Claim 
		WHERE    PersonNo = '#URL.PersonNo#'
		GROUP BY ClaimRequestId
		HAVING   count(*) = 2 
	</cfquery>		
	
	<cfif Clear1.recordcount gte "1">
	
		<cfquery name="Clear2" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Claim 
			WHERE ClaimId IN (SELECT TOP 1 ClaimId
								FROM     Claim 
								WHERE    ClaimRequestId = '#Clear1.ClaimRequestId#'
								ORDER BY DocumentNo		
							 )	
		</cfquery>		
		
	</cfif>	
	
	<cfquery name="Clean" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Claim
		WHERE DocumentNo = 0
		AND  PersonNo = '#URL.PersonNo#'
		AND  ClaimRequestId IN (SELECT ClaimRequestId 
		                         FROM  Claim 
								 WHERE PersonNo = '#URL.PersonNo#'
								 AND   DocumentNo = 0
								 GROUP BY ClaimRequestId
								 HAVING count(*) = 2) 
	</cfquery>		
	
	