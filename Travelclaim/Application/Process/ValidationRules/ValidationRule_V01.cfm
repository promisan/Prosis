
<!--- 
Validation Rule :  V01
Name			:  Verify if user selected that other advanced was received
Steps			:  Query the indicator table
Date			:  05 June 2006
--->
<!---
<cfquery name="Check2" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT     *
	FROM    ClaimEventIndicator
	WHERE   IndicatorCode = 'ADV' 
	AND (ClaimEventId IN
            (SELECT    ClaimEventid
             FROM      ClaimEvent
             WHERE     ClaimId = '#URL.ClaimId#')) 
			 
</cfquery>	--->
<cfquery name="Check2" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT     *
	FROM    ClaimEventIndicatorCost
	WHERE   IndicatorCode = 'ADV' 
	AND (ClaimEventId IN
            (SELECT    ClaimEventid
             FROM      ClaimEvent
             WHERE     ClaimId = '#URL.ClaimId#')) 
</cfquery>	

<cfif Check2.recordcount gte 1>		 

 <cf_ValidationInsert
   	ClaimId        = "#URL.ClaimId#"
	ClaimLineNo    = ""
	CalculationId  = "#rowguid#"
	ValidationCode = "#code#"
	ValidationMemo = "#Description#"
	Mission        = "#ClaimRequest.Mission#">
	
</cfif>	


