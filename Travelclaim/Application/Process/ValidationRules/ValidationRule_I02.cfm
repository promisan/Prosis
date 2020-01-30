
<!--- 
Validation Rule :  I02
Name			:  Verify overlapping DSA period
Steps			:  Global search (all portal travel requests) for overlapping periods for the traveller
Date			:  05 April 2006
Last date		:  05 June 2006 (correction global)
--->

<!---
MKM: 28-Oct-2008: 
Added: "AND ActionStatus <> 'cl')" to remove Closed requests from the Validation
--->

<cfquery name="Person" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT DISTINCT PersonNo, COUNT(*)
	 FROM     ClaimRequestLine
	 WHERE    PersonNo IN (SELECT PersonNo FROM ClaimRequest WHERE ClaimRequestId = '#URL.RequestId#' AND ActionStatus <> 'cl')
	 AND      ClaimCategory = 'DSA'
	 GROUP BY PersonNo 
	 HAVING   COUNT(*) > 1 
</cfquery>

<cfset st = "0">

<!---
MKM: 29-Oct-2008: Added: 
"	 AND 	  L.ClaimRequestId NOT IN (SELECT ClaimRequestId FROM ClaimRequest 
										WHERE PersonNo = '#PersonNo#' AND ActionStatus = 'cl')
	 AND      L.ClaimRequestId NOT IN (SELECT ClaimRequestId FROM Claim 
										WHERE PersonNo = '#PersonNo#' AND Reference = 'TVCV' AND ReferenceNo IS NOT NULL)
"
																
	to remove Closed and fulfilled Claims and Requests from the Validation
--->

<cfloop query="Person">

	<cfquery name="Line" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   D.*
	 FROM     ClaimRequestLine L,
	          ClaimRequestDSA D
	 WHERE    PersonNo             = '#PersonNo#'
	 AND      ClaimCategory        = 'DSA'
	 AND      L.ClaimRequestId     = D.ClaimRequestId
	 AND      L.ClaimRequestLineNo = D.ClaimRequestLineNo 
	 <!---
	 AND      L.ClaimRequestId = '#URL.RequestId#'   MKM 28-Oct-2008: WHY is this commented out? It seems neccessary. 
	 												 It checks against other claim requests without it. Should it care 
													 about the other requests? Or just the one that is being started?	
													 
													 MKM 29-Oct-2008: I think I figured it out. You want to check against 
													 all requests for this person to check for overlapping dates.
													 Not just the request in question.												
	 --->
	 AND 	  L.ClaimRequestId NOT IN (SELECT ClaimRequestId FROM ClaimRequest 
										WHERE PersonNo = '#PersonNo#' AND ActionStatus = 'cl')
	 AND      L.ClaimRequestId NOT IN (SELECT ClaimRequestId FROM Claim 
										WHERE PersonNo = '#PersonNo#' AND Reference = 'TVCV' AND ReferenceNo IS NOT NULL)
	  
	 AND      D.DateEffective IS NOT NULL
	 ORDER BY D.DateEffective, D.DateExpiration 
	</cfquery>
	
	<CF_DateConvert 
	   Value="#DateFormat(Line.DateExpiration, CLIENT.DateFormatShow)#">
	   
	<cfset DTE = #dateValue#>
	<cfset prior = "">
		
	<cfloop query="Line" startrow="2">
	
		<CF_DateConvert 
		   Value="#DateFormat(DateEffective, CLIENT.DateFormatShow)#">
		<cfset STR = #dateValue#>
				
		<cfif STR gt DTE>
		
		     <!--- good --->
			 
		<cfelse>
		
			<cfif claimrequestId eq URL.Requestid or prior eq URL.RequestId>
			     <cfset st = "1">
			</cfif>
				 
		</cfif>
		
		<CF_DateConvert Value="#DateFormat(DateExpiration, CLIENT.DateFormatShow)#">
		<cfset DTE   = dateValue>
		<cfset prior = ClaimRequestId>
			
	</cfloop>

</cfloop>

<cfif st eq "1">

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