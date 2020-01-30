
<!--- 
Validation Rule 	:  R04
Name				:  Validate different DSA location code
Desc				:  Verify to check the DSA location code and flag for EO review if the location code is not in the travel request
Date				:  15 August2006

---------------------Modification-----------------------------

Last Modified 	:  24/08/2008
Last Modfied By :  Huda Seid
Change Made 	: Made changes below to exclude the DSA days when annual leave is taken --->



<cfquery name="Check" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">

	SELECT  *
    FROM    ClaimLineDSA
    WHERE   ClaimId = '#URL.ClaimId#'
    AND calendardate NOT IN (select calendardate 
			 				from dbo.ClaimLineDateIndicator 
			 				where indicatorcode='P01' and claimid='#URL.ClaimId#')
    AND LocationCode NOT IN (SELECT ServiceLocation 
	                         FROM ClaimRequestDSA
							 WHERE ClaimRequestId = '#ClaimRequest.ClaimRequestId#') 
	 <!---- Previous code was as below not taking into account annual leave days
	 
	SELECT  *
    FROM    ClaimLineDSA
    WHERE   ClaimId = '#URL.ClaimId#'
    AND LocationCode NOT IN (SELECT ServiceLocation 
	                         FROM ClaimRequestDSA
							 WHERE ClaimRequestId = '#ClaimRequest.ClaimRequestId#') 
							 
	---->
	
</cfquery>		

<cfif Check.recordcount gte "1">

	 <cf_ValidationInsert
    	ClaimId        = "#URL.ClaimId#"
		ClaimLineNo    = ""
		CalculationId  = "#rowguid#"
		ValidationCode = "#code#"
		ValidationMemo = "#Description#"
		Mission        = "#ClaimRequest.Mission#">
		
</cfif>	 		
		


