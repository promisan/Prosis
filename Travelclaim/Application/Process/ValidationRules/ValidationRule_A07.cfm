<cfsilent>
 <proUsr>Joseph George</proUsr>
  <proOwn>Joseph George</proOwn>
 <proDes>Template for validation Rule A07  </proDes>
 <proCom>New File For Validation A07 </proCom>
</cfsilent>

<!--- 
						Validation Rule :  A07
						Name			:  To Check The sum of  Non-obligated Line  that 
						                    has been created against the Portal , and check whether
											it is within the Threshold amount , In all practicality 
											this Threshold Amount should be there in the parameter table.
											
											
						Steps			:  To get the Sum of NonObligatedAmounts and compare it with the 
						                   Threshold saved in the Portal .
						Date			:  18 Sep 2007
						Last date		:  18 Sep 2007
--->

<cfquery name="NonObligatedLines" 
datasource="appsTravelClaim"
username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT    
	          SUM(C.AmountBase) AS AmountBase
	FROM      ClaimEventIndicatorCost C INNER JOIN
	          Ref_Indicator R ON C.IndicatorCode = R.Code
			  INNER JOIN ClaimEventIndicatorCostLINE D
			  ON D.ClaimEventID = C.ClaimEventID 
			  AND D.IndicatorCode = C.IndicatorCode 
			  AND D.CostlineNO = C.CostLineNO
			  WHERE     C.ClaimEventId IN
                         (SELECT     ClaimEventId
                          FROM          ClaimEvent
	   					  WHERE ClaimId = '#URL.ClaimId#') 
	AND       C.AmountBase is not  NULL					  
	AND       D.ClaimObligated =0 
	having Sum(C.AmountBase) is not NULL
	<!--- ClaimObligated=0 means it is a NON-Obligated Line otherwise  --->

	          
</cfquery>

 

<cfif #NonObligatedLines.AmountBase#  gt #VariableNON_OBLIGATED_THRESHOLD# >
<cf_ValidationInsert
								ClaimId        = "#URL.ClaimId#"
								ClaimLineNo    = ""
								CalculationId  = "#rowguid#"
								ValidationCode = "#code#"
								ValidationMemo = "#Description#"
								Mission        = "#ClaimRequest.Mission#">

</cfif>
 
