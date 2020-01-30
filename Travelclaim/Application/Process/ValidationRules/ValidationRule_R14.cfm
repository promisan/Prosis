<!--- 
Validation Rule :  R14
Name			:  Flag for accounts review if Days DSA claimed > Days DSA Obligated excluding annual leave days
Creation Date	:  29 October 2008
Created         : Huda Seid
---->

<cfquery name="DSARequest" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
     SELECT    SUM(RequestDays) AS Requested
     FROM      ClaimRequestDSA
     WHERE     ClaimRequestId = '#Claim.ClaimRequestId#' 
</cfquery>	

<cfquery name="DSAClaim" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 	SELECT count(*) as Claimed
		FROM    ClaimLineDSA
		WHERE    ClaimId = '#URL.claimid#'
		AND calendardate not in (select calendardate 
								 from dbo.ClaimLineDateIndicator 
								 where indicatorcode='P01'
								 And ClaimId = '#URL.claimid#') 
	 
	 
</cfquery> 

<cfif DSARequest.Requested gte "1">

	<cfif DSAClaim.Claimed gt DSARequest.Requested >

		 <cf_ValidationInsert
	    	ClaimId        = "#URL.ClaimId#"
			ClaimLineNo    = ""
			CalculationId  = "#rowguid#"
			ValidationCode = "#code#"
			ValidationMemo = "#Description#"
			Mission        = "#ClaimRequest.Mission#">
		
	</cfif>	 	

</cfif>	
		

		