<!--- 
Validation Rule :  R17
Name			:  Verify whether the Hazard Pay  radio /Indicator is switched on  and also
                 : finding out whether there are changes that the TVRQ has a HZP line 
				 : so doing a Union to get all cases.
Steps			:  Determine if any subsistence exception was selected
Date			:  16/09/2009 JG

--->


<cfquery name="Check" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT IndicatorCode as Indcode_ind  FROM ClaimEventTripIndicator
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
	AND IndicatorCode ='R01' 
	
	UNION
	
	SELECT  claimcategory as Indcode_ind from claimrequestline TVRQ, claim MYTVCV
	WHERE 
	MYTVCV.claimid = '#URL.ClaimId#' 
	AND  MYTVCV.claimrequestid = TVRQ.Claimrequestid 
	AND TVRQ.claimcategory ='HZP'
	AND TVRQ.RequestAmount > 0
	
	
	
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
	 WHERE Code = '#Indcode_ind#'
	</cfquery>

	 <cf_ValidationInsert
    	ClaimId        = "#URL.ClaimId#"
		ClaimLineNo    = ""
		CalculationId  = "#rowguid#"
		ValidationCode = "#cde#"
		ValidationMemo = "#des#"
		Mission        = "#ClaimRequest.Mission#">
		
</cfloop>