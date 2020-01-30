<cfsilent>
  <proOwn>Joseph George</proOwn>
 <proDes>Template for validation Rule A06  </proDes>
 <proCom>New File For Validation A06 </proCom>
</cfsilent>

<!--- 
						Validation Rule :  A06
						Name			:  To Check whether Non-obligated Line has been 
						                    created against IOV-Billing request , IMIS will
											not permist the creation of the Claim .
											
						Steps			:  To Associate The ClaimRequestID other than DSA which is always obligated
						                    along with stclaimfunding which has the obligated/Non Obligated 
											indicator along with the IOV_ind field which determines whether it is IOV
											document or not.
										   
						Date			:  17 Sep 2007
						Last date		:  17 Sep 2007
						
	SELECT    C.ClaimRequestId, 
	          C.ClaimRequestLineNo, 
			  R.ClaimCategory, 
			  C.ClaimObligated,
			  SUM(C.AmountBase) AS AmountBase
	FROM      ClaimEventIndicatorCost C INNER JOIN
	          Ref_Indicator R ON C.IndicatorCode = R.Code
			  INNER JOIN
			  stClaimFunding ST ON C.ClaimRequestId = ST.ClaimRequestid
	WHERE     C.ClaimEventId IN
                         (SELECT     ClaimEventId
                          FROM          ClaimEvent
	   					  WHERE ClaimId = '#URL.ClaimId#')
	AND       C.AmountBase is not  NULL					  
	AND       ST.iov_ind = 1
	GROUP BY  C.ClaimRequestId, 
	          C.ClaimRequestLineNo, 
			  R.ClaimCategory,
			  C.ClaimObligated
--->

<cfquery name="ClaimLinesIOV" 
datasource="appsTravelClaim"
username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT D.ClaimRequestId, D.ClaimRequestLine as ClaimRequestLineNo, R.ClaimCategory,
	 		D.ClaimObligated, SUM(C.AmountBase) AS AmountBase 
	FROM ClaimEventIndicatorCost C INNER JOIN Ref_Indicator R ON 
	C.IndicatorCode = R.Code 
	INNER JOIN ClaimEventIndicatorCostLine D ON C.ClaimEventID = D.ClaimEventID
	ANd D.IndicatorCode = R.Code
	INNER JOIN
			  stClaimFunding ST ON D.ClaimRequestId = ST.ClaimRequestid
			  AND      D.ClaimRequestLine =ST.claimRequestlineno
	WHERE C.ClaimEventId IN 
	(SELECT ClaimEventId FROM ClaimEvent WHERE ClaimId = '#URL.ClaimId#')
	 AND C.AmountBase is not NULL 
	 AND ST.iov_ind =1 
	 AND D.ClaimObligated =0
	GROUP BY D.ClaimRequestId, D.ClaimRequestLine, R.ClaimCategory, 
	D.ClaimObligated
</cfquery>
<cfif ClaimLinesIOV.recordcount gt 0> 
<cf_ValidationInsert
								ClaimId        = "#URL.ClaimId#"
								ClaimLineNo    = ""
								CalculationId  = "#rowguid#"
								ValidationCode = "A06"
								ValidationMemo = "Non Obligated Claim Line against IOV-Billing Request "
								Mission        = "#ClaimRequest.Mission#">
</cfif>
