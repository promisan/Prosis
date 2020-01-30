

<!--- 
Validation Rule :  R01
Name			:  Travel with overnight stop requires review
Steps			:  Determine if an overnight stop was checked/reported
Date			:  05 April 2006
Last date		:  15 June 2006
--->

<!--- query trip info for status 1 --->

<cfquery name="Check" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT     *
	FROM    ClaimEventTrip
	WHERE   OverNightStay = '1' 
	AND (ClaimEventId IN
            (SELECT    ClaimEventid
             FROM      ClaimEvent
             WHERE     ClaimId = '#URL.ClaimId#')) 
</cfquery>	

<cfif Check.recordcount neq "0">		 

 <cf_ValidationInsert
   	ClaimId        = "#URL.ClaimId#"
	ClaimLineNo    = ""
	CalculationId  = "#rowguid#"
	ValidationCode = "#code#"
	ValidationMemo = "#Description#"
	Mission        = "#ClaimRequest.Mission#">
	
</cfif>	


