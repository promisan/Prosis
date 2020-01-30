
<!--- 
Validation Rule :  R11
Name			:  Verify subsistence indicators
Steps			:  Determine if any subsistence exception was selected
Date			:  20 Feb 2007
--->

<cfquery name="Check" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT * FROM ClaimEventTripIndicator
    WHERE     ClaimTripId IN
                  (SELECT  Tr.ClaimTripId
                   FROM    ClaimEvent Ev INNER JOIN
                           ClaimEventTrip Tr ON Ev.ClaimEventId = Tr.ClaimEventId
                   WHERE   Ev.ClaimId = '#URL.ClaimId#')
	AND       IndicatorCode IN (SELECT Code 
	          	    	        FROM Ref_Indicator 
								WHERE Category IN (SELECT Code 
					                               FROM Ref_IndicatorCategory 
												   WHERE ClaimSection = 'Subsistence'))  
</cfquery>

<cfset cde = code>
<cfset des = description>

<cfloop query="Check">

	<cfquery name="Indicator" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM Ref_Indicator 
	 WHERE Code = '#IndicatorCode#'
	</cfquery>

	 <cf_ValidationInsert
    	ClaimId        = "#URL.ClaimId#"
		ClaimLineNo    = ""
		CalculationId  = "#rowguid#"
		ValidationCode = "#cde#"
		ValidationMemo = "#des#"
		Mission        = "#ClaimRequest.Mission#">
		
</cfloop>