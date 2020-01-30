
<cfsilent>
 	<proOwn>Huda Seid</proOwn>
	<proDes>Claim Validation Memo </proDes>
	<proCom>Changed Line 43 -  Changed text in the sql from 'exceed amount of:' to ': Claimed amount in excess of Obligation is above the USD threshhold amount '
			Changed Line 111 - Changed text in the sql from 'exceed authorised amount with more than USD:' to ': claimed amount is in excess of USD threshold amount of'
	</proCom>
	<!--- reverse text to rely more on the default text --->
</cfsilent>
<!--- 
Validation Rule :  Threshold
Name			:  Verify if claimed amounts lie within the threshold for the various indicator
Steps			:  Step 1 : Threshold for the amoount
				   Step 2 : Threshold for the balance	
Date			:  05 April 2006
Last date		:  15 June 2006
--->

<!--- 1 : obligation, 2 amount --->

<!--- Obligation/ClaimCategory balance threshold : threshold1--->

<!--- define totals by category (FdT issue will be the "assumed" claim lines for implicit funding) --->

<cfquery name="Claimed" 
    datasource="appsTravelClaim">
	SELECT     ClaimId,
			   ClaimLineNo,
	           ClaimCategory,
	           PersonNo,
			   AmountClaimBase as Total
	FROM       ClaimLine
	WHERE      ClaimId IN (SELECT ClaimId 
	                       FROM Claim 
						   WHERE ClaimRequestId = '#ClaimRequest.ClaimRequestId#') 
</cfquery>

<cfloop query = "Claimed">

	<!--- verify requested amount --->
	
	<cfquery name="Requested" 
	    datasource="appsTravelClaim">
		SELECT     ClaimCategory,
		           PersonNo,
				   SUM(RequestAmount) AS Total
		FROM       ClaimRequestLine
		WHERE      ClaimRequestId = '#ClaimRequest.ClaimRequestId#'
		AND        ClaimCategory  = '#ClaimCategory#'
		AND        PersonNo       = '#PersonNo#'
		GROUP BY   ClaimCategory, PersonNo
	</cfquery>
	
	<cfif Requested.total eq "">
	  <cfset req = 0>
	<cfelse>
	  <cfset req = #Requested.Total#>  
	</cfif>
	
	<cfif Claimed.Total gt Requested.Total>
	     
	    <cfset diff = Claimed.Total-Req>
	
		<cfquery name="Insert" 
	    datasource="appsTravelClaim">
		INSERT INTO ClaimValidation
		       (ClaimId, CalculationId, ClaimCategory, IndicatorCode,ClearanceActor, ValidationCode, ValidationMemo) 
		SELECT '#ClaimId#',
		       '#rowguid#',
		       '#ClaimCategory#',
			   '#ClaimCategory#',
		       ClearanceActor,
			   ValidationCode, 
			   R.Description+': claimed amount is in excess of Obligation and above the threshold amount of USD '+Ltrim(str(ThresholdAmount))
		FROM   Ref_DutyStationValidation V, 
		       Ref_ClaimCategory R
		WHERE  V.Mission         = '#ClaimRequest.Mission#' 
		 AND   V.ClaimCategory   = '#ClaimCategory#' 
		 AND   V.Operational     = 1
		 AND   V.ClaimCategory   = R.Code
		 AND   V.ThresholdAmount < '#diff#'
		 AND   V.ValidationCode IN
	                 (SELECT    Code
	                  FROM      Ref_Validation
	                  WHERE     ValidationClass = 'Threshold1') 
		</cfquery>		
	
	<!--- register verify threshold --->
	
	</cfif>

</cfloop>


<!--- amount/indicators checking only --->

<!--- define totals by category (FdT issue will be the "assumed" claim lines for implicit funding) --->

<cfquery name="Total" 
    datasource="appsTravelClaim">
	SELECT   '#ClaimRequest.Mission#' as Mission, 
	         Cost.IndicatorCode, 
			 SUM(Cost.AmountBase) AS TotalAmount
	FROM     ClaimEventIndicatorCost Cost INNER JOIN
    	     ClaimEvent Event ON Cost.ClaimEventId = Event.ClaimEventId
	WHERE    ClaimId = '#URL.ClaimId#'		 
	GROUP BY Cost.IndicatorCode 
</cfquery>

<!--- loop through totals and verify if threshold is exceeded.--->


<cfloop query = "Total">

	<cfquery name="Insert" 
    datasource="appsTravelClaim">
	INSERT INTO ClaimValidation
	       (ClaimId, CalculationId, ClearanceActor, IndicatorCode, ValidationCode, ValidationMemo) 
	SELECT '#ClaimId#',
	       '#rowguid#',
	       ClearanceActor,
		   IndicatorCode,
		   ValidationCode, 
		   R.Description+': Claimed amount in excess of the threshhold amount of USD '+Ltrim(str(ThresholdAmount))
	FROM   Ref_DutyStationValidation V, Ref_Indicator R
	WHERE  V.Mission         = '#Mission#' 
	 AND   V.IndicatorCode   = '#IndicatorCode#' 
	 AND   V.Operational     = 1
	 AND   V.IndicatorCode   = R.Code
	 AND   V.ThresholdAmount < '#TotalAmount#' 
	 AND   V.ValidationCode IN
                 (SELECT    Code
                  FROM      Ref_Validation
                  WHERE     ValidationClass = 'Threshold2') 
	</cfquery>			  

</cfloop>



<!--- loop through totals and verify if threshold is exceeded.--->



