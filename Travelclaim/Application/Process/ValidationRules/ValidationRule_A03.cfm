<cfsilent>
		 <proUsr>Joseph George</proUsr>
		  <proOwn>Joseph George</proOwn>
		 <proDes>Template for validation Rule A03  </proDes>
		 <proCom>New File For Validation A03 </proCom>
</cfsilent>
		
			<!--- 
			Validation Rule :  A03
			Name			:  Excess claim for a Prior Period Funding 
			Steps			:  Prior Period Line amount exceeds Obligated Amount - So EO should provide BAC to cover excess
			Date			:  15 July 2007
			Last date		:  16 July 2007
			--->
			<!----
			Logic is simple the first query checks prior period funding and amounts are greater than zero
			all the rest are not important.
			2 Query checks obligated lines alone matching againgst tvrq amount
			3. Subquery checks for amounts greater alone.
			4. Checks for non obligated lines alone , if it is existenent.
			Queries 2,3,4 will get executed only if the first condition is true.
			---->			 
<cfset t_a03 = 'TCP_a03_'&RandRange(1,500)&RandRange(1,500)&RandRange(1,500)>
<cfset t1_a03 = 'TCP_a031_'&RandRange(1,500)&RandRange(1,500)&RandRange(1,500)>
			<cfquery name="Check1" 
			datasource="appsTravelClaim"
			username="#SESSION.login#" 
				password="#SESSION.dbpw#">
	SELECT DISTINCT 
				 st.f_fnlp_fscl_yr AS Fscl, 
				 st.f_fund_id_code AS Fund, 
				 Fs.Fundtype as FundType,
				 St.f_tvrq_doc_id ,
				 St.f_tvrl_seq_num,
				 (St.AmountTotal - TVRL.amountclaimbase) as difference,
				St.AmountTotal,TVRL.AmountClaimBase,
	
				  St.ClaimCategory,
				  Fs.BACPrior,
				 Fs.DateEffective
					 
			FROM     stFundStatus Fs,
				 stClaimFunding st ,
				 ClaimLine TVRL
			WHERE    st.ClaimRequestId = '#Claim.ClaimRequestId#'
					AND St.ClaimRequestId= TVRL.ClaimRequestId 
					AND St.ClaimCategory = TVRL.ClaimCategory
					AND     Fs.Period   =st.f_fnlp_fscl_yr
					AND     Fs.FundType =st.FundType
					AND st.amount >0 <!--- Introduced issue 590 JG new condition   --->
					AND     Fs.DateEffective = (SELECT max(TT.dateeffective) 
												FROM  stfundstatus TT
												WHERE 
												TT.Period = st.f_fnlp_fscl_yr
												and TT.Fundtype = st.fundtype
												and TT.dateeffective <= getdate()) 
					AND      getdate()  <= (SELECT max(TT.dateeffective) 
													FROM  stfundstatus TT
											WHERE 
											TT.Period = st.f_fnlp_fscl_yr
											AND TT.Fundtype = st.fundtype)
				AND FS.BACPrior =1
				AND st.iov_ind =0 
				<!--- AND 			 (TVRL.AmountClaimBase - St.amountTotal) >0 
				     This was commented because if it Prior Year BAC alone 
					 Do the next step otherwise do not worry about it .--->
	
																
			</cfquery>		
		 
<cfset msg =''>
<cfoutput>#Check1.recordcount#</cfoutput>			
 
<cfif Check1.recordcount neq 0>
	<cfquery name="ObligatedlineCheck" 
	datasource="appsTravelClaim"
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
			
	
	SELECT D.ClaimRequestId, 
	       D.ClaimRequestLine as ClaimRequestLineNo, 
		   R.ClaimCategory,
	 	   D.ClaimObligated, 
		   C.exchangeratePayment,
		   Sum(D.MatchingInvoiceAmount/c.exchangeratePayment)as AmountBase,
		   Sum(D.MatchingInvoiceAmount/c.exchangeratepayment)/c.exchangerate as USD_AMT
 into userquery.dbo.#t_a03#
   	FROM   ClaimEventIndicatorCost C INNER JOIN Ref_Indicator R ON 
			C.IndicatorCode = R.Code 
			INNER JOIN ClaimEventIndicatorCostLine D ON C.ClaimEventID = D.ClaimEventID
			AND D.IndicatorCode = R.Code
			AND D.IndicatorCode = C.IndicatorCode
	        AND D.CostLineNo = C.CostLineNo
    WHERE C.ClaimEventId IN 
			(SELECT ClaimEventId 
			 FROM   ClaimEvent 
			 WHERE  ClaimId = '#URL.ClaimId#')
			 AND    C.AmountBase is not NULL 
                         AND    D.ClaimObligated =1
		 	 GROUP BY D.ClaimRequestId, D.ClaimRequestLine, R.ClaimCategory, D.ClaimObligated,c.exchangeratepayment,c.exchangerate

	UNION
	SELECT    ClaimRequestId, 
	          ClaimRequestLineNo, 
			  'DSA' AS ClaimCategory, 
			  1 as ClaimObligated,  
			  1 as ExchangeRate, 
			  SUM(AmountBase) AS AmountBase,
			  Sum(AmountBase)  As USD_AMT
	FROM      ClaimLineDSA
	WHERE     ClaimId = '#URL.ClaimId#' 
	
	GROUP BY  ClaimRequestId, ClaimRequestLineNo  
	having Sum(AmountBase) > 0 

</cfquery>			
<cfquery name="TVRQ_AMOUNT" 
    datasource="appsTravelClaim"
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	
select ClaimRequestid ,ClaimRequestlineno ,claimcategory ,sum(amount) tvrq_amount 
into userquery.dbo.#t1_a03#
from stclaimfunding 
where claimrequestid =(select distinct claimrequestid from userquery.dbo.#t_a03#)
and claimcategory !='ITIN'
group by claimrequestid,claimrequestlineno,claimcategory
</cfquery>				
<cfquery name="AmountGreater" 
datasource="appsTravelClaim"
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	
select *, USD_AMT-tvrq_amount as difference from userquery.dbo.#t_a03# A, userquery.dbo.#t1_a03# B
where a.Claimrequestid =b.Claimrequestid
and a.claimRequestlineno =b.claimrequestlineno
and  a.claimcategory =b.claimcategory
and A.USD_AMT > B.tvrq_amount

</cfquery>	
<cfquery name="NonobligatedlineCheck" 
	datasource="appsTravelClaim"
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
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
	 AND ST.iov_ind =0 
	 AND D.ClaimObligated =0
	 GROUP BY D.ClaimRequestId, D.ClaimRequestLine, R.ClaimCategory, 
	D.ClaimObligated
	having sum(AmountBase) > 0
</cfquery>

<cfif AmountGreater.recordcount gt 0 or NonobligatedlineCheck.recordcount gt 0  > 			
				<cfif AmountGreater.recordcount gt 0>
				<cfloop query="AmountGreater">
					<cfif msg eq "">
						<cfset msg = "#currentRow#. #difference#-#claimcategory#">
					<cfelse>
						<cfset msg = "#msg#. #difference#-#claimcategory#">
					</cfif>	
					<!---
					<cfoutput> Greater amount #AmountGreater.recordcount# #amountGreater.Difference# </cfoutput>
                     ---->
				</cfloop>
				</cfif>
				<cfif NonobligatedLineCheck.recordcount gt 0>
				
				<cfloop query="NonobligatedlineCheck">
				    
					<cfif msg eq "">
						<cfset msg = "#currentRow#. NonObligatedLine-#claimcategory#">
					<cfelse>
						<cfset msg = "#msg#. -#claimcategory#">
					</cfif>	
					
				</cfloop>
				</cfif>
				 
				
				
				 <cf_ValidationInsert
					ClaimId        = "#URL.ClaimId#"
					ClaimLineNo    = ""
					CalculationId  = "#rowguid#"
					ValidationCode = "#code#"
					ValidationMemo = "#Description# #msg#"
					Mission        = "#ClaimRequest.Mission#">
					<!---
					<cfoutput> code #code# desc #Description# msg  #msg# url  #URL.ClaimId# reques #ClaimRequest.Mission#</cfoutput> 
					--->
					
</cfif>						
						
</cfif>
			
