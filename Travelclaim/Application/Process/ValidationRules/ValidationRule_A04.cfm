<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfsilent>
  <proUsr>Joseph George</proUsr>
  <proOwn>Joseph George</proOwn>
 <proDes>Template for validation Rule A04  </proDes>
 <proCom>New File For Validation A04 </proCom>
</cfsilent>
 
<!--- 
	Validation Rule :  A04
	Name			:  To Check whether Tolerance Exceeded Current Period Funding
	Steps			:  To initially find whther it has current period funding A03 should be 
	                   implemented first . To find the Sum of positive claims -obligated amounts only
					   exceeds the tolerance. Do not check funds sufficiency for fundtype 4
					    fundtype => 2 summ up the objc amount from fundsufficiency done in the global
						sp itself. 
					   
	Date			:  17 July 2007
	Last date		:  17 July 2007
--->

<cfif month(now()) lte "9">
	  <cfset m = "0#month(now())#">
<cfelse>
	  <cfset m = "#month(now())#">  
</cfif>
<cfset default = "#year(now())##m#.0">
<!--- 
	SELECT    C.ClaimRequestId, 
	          C.ClaimRequestLineNo, 
			  R.ClaimCategory, 
			  C.ClaimObligated,
			  SUM(C.AmountBase) AS AmountBase
	FROM      ClaimEventIndicatorCost C INNER JOIN
	          Ref_Indicator R ON C.IndicatorCode = R.Code
	WHERE     C.ClaimEventId IN
                         (SELECT     ClaimEventId
                          FROM          ClaimEvent
	   					  WHERE ClaimId = '#URL.ClaimId#')
	AND       C.AmountBase is not  NULL					  
	GROUP BY  C.ClaimRequestId, 
	          C.ClaimRequestLineNo, 
			  R.ClaimCategory,
			  C.ClaimObligated
			  --->


<cfquery name="ClaimLines" 
datasource="appsTravelClaim">
	SELECT D.ClaimRequestId, 
	       D.ClaimRequestLine as ClaimRequestLineNo, 
		   R.ClaimCategory,
	 	   D.ClaimObligated, 
		   C.exchangeratePayment,
		   Sum(D.MatchingInvoiceAmount/c.exchangeratePayment)as AmountBase,
		   Sum(D.MatchingInvoiceAmount/c.exchangeratepayment)/c.exchangerate as USD_AMT
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
		 	 GROUP BY D.ClaimRequestId, D.ClaimRequestLine, R.ClaimCategory, D.ClaimObligated,c.exchangeratepayment,c.exchangerate

	UNION
	SELECT    ClaimRequestId, 
	          ClaimRequestLineNo, 
			  'DSA' AS ClaimCategory, 
			  1 as ClaimObligated,  <!--- DSA are by nature always obligated --->
			  1 as ExchangeRate, <!--- Since DSA by nature will have the same currency to be claimed --->
			  SUM(AmountBase) AS AmountBase,
			  Sum(AmountBase)  As USD_AMT
	FROM      ClaimLineDSA
	WHERE     ClaimId = '#URL.ClaimId#' 
	
	GROUP BY  ClaimRequestId, ClaimRequestLineNo  
	having Sum(AmountBase) > 0 
</cfquery>	

<!-- AND      ClaimRequestId is NOT NULL  Added it because for some reasons sometimes it might be null Bad data /Bad insertions -->
 <!-- Summing BoTH OBLIGATED and NON-OBLIGATED lines
     from the earlier Query 
--->
	 
<cfquery name="SumAllLines"
   dbtype="query">
	SELECT SUM(USD_AMT) AS SumClaimAmountBase
	FROM ClaimLines		 	          
</cfquery>	

<!-- Summing Just based on  CAtegory alone example MSC,DSA,TRM etc -->
<cfquery name="ClaimNONOBLGLines"
   dbtype="query">
	SELECT    ClaimRequestId, 
		      ClaimObligated,
			  ClaimCategory,
			  SUM(USD_AMT) AS AmountBase
	FROM ClaimLines		  
	where claimobligated =0
	GROUP BY  ClaimRequestId, 
	          ClaimObligated,
			  ClaimCategory
			  
</cfquery>	
<cfquery name ="Sum_Nonoblg_amt" dbtype="query">
select Sum(USD_AMT) as summ_nonoblg_amt 
from ClaimLines 
where ClaimObligated =0
</cfquery>
<!----
<cfoutput> tttt #Sum_Nonoblg_amt.summ_nonoblg_amt#</cfoutput>
<cfabort>
---->
<cfquery name="ClaimLines"
   dbtype="query">
	SELECT    ClaimRequestId, 
		      ClaimRequestLineNo,
			  ClaimCategory,
			  SUM(USD_AMT) AS AmountBase
	FROM ClaimLines		  
	GROUP BY  ClaimRequestId, 
	          ClaimRequestLineNo,
			  ClaimCategory
</cfquery>	
<cfquery name="TVRQSUMM" 
		datasource="appsTravelClaim">
			SELECT    sum(Amount) as SUMM_TVRQ_Amount 
			FROM      stClaimFunding
			WHERE     ClaimRequestId     = '#Claim.ClaimRequestId#' and claimcategory not in ('ITIN')
			<!--- Added ITIN because we are not showing them exclusively in portal to claim 
			      so the amounts should not be taken into consideration.  --->
</cfquery>
			
<cfquery name="Tolerance" 
	datasource="appsTravelClaim">
		SELECT    TOP 1 *
		FROM      stClaimFunding
		WHERE     ClaimRequestId = '#Claim.ClaimRequestId#' 
</cfquery>

<cfset tol = Tolerance.Tolerance>

<!--- do we take tolerance from here ?? --->
 
<cfif tol eq "">
  <cfset tol = 0>
</cfif>

<cfset tclaimAmountBase = #SumallLines.SumClaimAmountBase# >

<cfif tclaimAmountBase eq "">
<cfset tclaimAmountBase =0>
</cfif>

<cfset tTVRQAmount = #TVRQSUMM.SUMM_TVRQ_Amount#>
<cfif tTVRQAmount eq "">
	<cfset tTVRQAmount =0>
</cfif>

<cfset excess_amount = #tclaimAmountBase# - #tTvrqAmount# + #tol#>
<!----
<cfoutput> JG testing something #Valfundstatus# 1 amount #SumallLines.SumClaimAmountBase# 2 #TVRQSUMM.SUMM_TVRQ_Amount# 3 tol #tol# 
 Claimrequestid #Claim.ClaimRequestId# excess_amount = #excess_amount#
 </cfoutput>
---->
 <!---
 <cfabort>
 --->
 
<cfif Valfundstatus neq "closed">

    <cfset excess_amount = (#tclaimAmountBase# - #tTvrqAmount# )+ #tol#>
 
	<cfif excess_amount gt VariableTolerance>
 
	<cf_ValidationInsert
		    ClaimId        = "#URL.ClaimId#"
			ClaimCategory  = "#cat#"
			CalculationId  = "#rowguid#"
			ValidationCode = "A04"
			ValidationMemo = "Tolerance Exceeded by #excess_amount# greater than #VariableTolerance#">					
						 							
	</cfif>
	
</cfif>	

<!--- ------------------------------------------ --->
<!--- 5. loop through claim data set ---- ------ --->
<!--- ------------------------------------------ --->

<!---  Cut from A1 all lines have been associated to a travel request line
		likely  we need to record that a non-obligated line was created 
			
		<cfif ClaimObligated eq "0">
		
		     non obligated line : PENDING (monday) 
		
		     <cf_ValidationInsert
				ClaimId        = "#URL.ClaimId#"
				ClaimCategory  = ""
				ValidationCode = "014"
				ValidationMemo = "Non-obligated line">
								  
		</cfif>	  
		

---->				

<cfif Valfundstatus neq "closed">
	
	<cfoutput query="ClaimLines">
	
	    <cfset cat = "#ClaimCategory#">
	     <!-- A1 -->
	       		
		<cfquery name="Obligated" 
		datasource="appsTravelClaim">
			SELECT    *, 
			          Percentage*#AmountBase# as AmountClaim
			FROM      stClaimFunding
			WHERE     ClaimRequestId     = '#ClaimRequestId#'
			AND       ClaimRequestLineNo = '#ClaimRequestLineNo#'  
			AND       Amount >0
		</cfquery>
			
		<cfif Obligated.recordcount eq 0>
		
			   <!--- NOTE : this can only happen in case 
			   data is wrong --->
		   
			   <cfquery name="Category" 
			    datasource="appsTravelClaim">
				SELECT    *
				FROM      Ref_ClaimCategory
				WHERE     Code = '#ClaimCategory#'
			   </cfquery>
			 			   
			   <cfif Category.RequireRequestLine eq "1">
			   
			       <cf_ValidationInsert
					    ClaimId        = "#URL.ClaimId#"
						ClaimCategory  = "#cat#"
						CalculationId  = "#rowguid#"
						ValidationCode = "A08"
						ValidationMemo = "Invalid Category for Non-Obligated Line">
						
			   </cfif>	
			  		   	   
	    <cfelse>	
						
		    <cfloop query="Obligated">
					<cfset ValFundRemamt = Amount>		
  				<!---
				<cfoutput>   AmountClaim #AmountClaim#  greater than > ValfundRemant is #ValFundRemamt#</cfoutput>	
				 --->
				 
				<cfif AmountClaim gt Amount>
										
				    <!--- This was where 010 was there removed it have a back up A04.200711 --->
						
					<cfset tol = tol-AmountClaim+Amount>
				<!---
				<cfoutput> tol is #tol# amountclaim is #AmountClaim# amount is #amount# </cfoutput>
				---->

					<cfif tol lt "0">				 
					
						<cfif Tolerance.Tolerance eq "">
						  <cfset t = 0.00>
						<cfelse>
						  <cfset t = #numberFormat(Tolerance.Tolerance,"__,__.__")#>
						</cfif>
												
						<!--- This was where 011 was there removed it have a back up A04.200711 --->			
					</cfif>	
						
					
						 <cfif f_accn_ser_num neq "" and fundtype neq 4 and fundtype neq 7>		
						  
						   
							<cfif Parameter.AliasSourceData neq "" AND Valpap neq "">
															
								<!--- enable above change once in production Hanno --->
								<cfset sp = "Warehousedev">
								<!--- <cfset sp = "#Parameter.AliasSourceData#"> --->
															 																														
								<cfstoredproc procedure="up_fn_val_ldgb_suf" 
								    datasource  = "#sp#" 
								    username    = "#SESSION.login#" 
								    password   = "#SESSION.dbpw#"
									returncode ="YES">
								
									<cfprocparam 
								    type="In" 
								    cfsqltype="CF_SQL_FLOAT" 
								    dbvarname="@ldgb_postd_acct_prd" 
								    value="#Valpap#" 
								    null="No">
								
								<cfprocparam 
								    type="In" 
								    cfsqltype="CF_SQL_INTEGER" 
									dbvarname="@ldgb_f_fnlp_fscl_yr"  
									value="#f_fnlp_fscl_yr#" 
									null="No">
								
								<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_f_fund_id_code"  
									value="#f_fund_id_code#" 
									null="No">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_f_orgu_id_code"  
									value="#f_orgu_id_code#" 
									null="No">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_f_proj_id_code"  
									value="#f_proj_id_code#" 
									null="YES">
								<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_f_pgmm_id_code"  
									value="#f_pgmm_id_code#" 
									null="YES">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_f_objt_id_code"  
									value="#f_objt_id_code#" 
									null="YES">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_f_objc_id_code"  
									value="#f_objc_id_code#" 
									null="YES">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_f_budx_id_code"  
									value="NULL" 
									null="YES">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_float" 
									dbvarname="@doc_amt"  
									value="NULL" 
									null="YES">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_f_sldg_id_code"  
									value="NULL" 
									null="YES">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_integer" 
									dbvarname="@ldgb_f_refx_agsr_seq_num"  
									value="NULL" 
									null="YES">
									
								    <cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_integer"
									dbvarname="@distr_ind"  
									value="1" 
									null="NO">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_integer" 
									dbvarname="@accn_ser_num"  
									value="#f_accn_ser_num#" 
									null="NO">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_integer" 
									dbvarname="@rs_flag"  
									value="1" 
									null="YES">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_f_dorf_id_code"  
									value="NULL" 
									null="YES">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_db_mdst_source"  
									value="#claimRequest.mission#" 
									null="NO">
						 	  
								<cfprocparam type="Out" 
									cfsqltype="CF_SQL_FLOAT"
									dbvarname="@avail_funds"  
									variable="funds" >
					       
								</cfstoredproc>
								
								  
								<cfset bal = funds-amountClaim>
								
								<cfset ValFundRemamt = #bal#>
		 
								<cfif bal lt 0>
					
								 <cf_ValidationInsert
								    ClaimId        = "#URL.ClaimId#"
									ClaimCategory  = "#cat#"
									CalculationId  = "#rowguid#"
									ValidationCode = "A05"
									ValidationMemo = "Insufficient Funds to cover Claimed amt (PAP:#Valpap# SERNO:#f_accn_ser_num#-#f_fnlp_fscl_yr#-#f_fund_id_code#-#f_orgu_id_code#-#f_proj_id_code#-#f_pgmm_id_code#-#f_objt_id_code#-AMT:#funds#)">
																
								</cfif>
							
							</cfif>
							
						</cfif>	
						
												
				</cfif>
			
			</cfloop>
						
		</cfif>	
			
	</cfoutput>
	
<cfelse>

    <!--- closed accounts, make exceptiotion : IMIS --->
	<cfset Valincomplete = "1">
	
</cfif>	


<cfquery name ="CV1" datasource="appsTravelClaim" username="#SESSION.login#" password="#SESSION.dbpw#">
						SELECT 
	                      *
							FROM 
								ClaimValidation
							WHERE  
									ClaimId = '#URL.ClaimId#'
									AND ValidationCode in ('A05') 
									   AND CalculationID = '#rowguid#'   
										 
										
</cfquery>
<!---  
<cfoutput> The count of CVI is #CV1.recordcount#  URL #URL.ClaimId# Calculation #rowguid# </cfoutput> 
<cfabort>
--->
<cfif CV1.recordcount eq "0" and ClaimNONOBLGLines.recordcount gt "0" > 

	<cfquery name="BAC" 
		datasource="appsTravelClaim">
			SELECT    distinct f_accn_ser_num ,db_mdst_source,
			f_fnlp_fscl_yr,
			f_fund_id_code,
			f_orgu_id_code,
			f_proj_id_code,
			proj_external_symbol,
			f_pgmm_id_code,
			f_objc_id_code,
			f_objt_id_code,
			f_actv_id_code
			FROM      stClaimFunding
			WHERE     ClaimRequestId     = '#Claim.ClaimRequestId#'
			AND       f_accn_ser_num is not null 
			AND       FundType not in (4,7) 
			AND       Amount >0
			<!--- Do not check for Fundtype 4 as told by Terry JG 01-02-2008 ---->
	</cfquery>
	<cfoutput query="BAC">
	<cfset funds = 1 >
		<cfif Parameter.AliasSourceData neq "" AND Valpap neq "">
					<!--- Commented on 02-11-2008 JG3 old way of calling 										
	                      This was the place the old code was there 
						  The old code validationRule_a04.02122008 has this part .
						  Just called a wrapped SP , here below I am calling the 
						  same SP IMIS is calling 
									---->
							
							<!--- JG3  Added the following stuff below directly calling 
							the original SP as in IMIS on 11-Feb-2008  --->
						
						<!--- enable above change once in production Hanno --->
							
						<cfset sp = "Warehousedev">
								<!--- <cfset sp = "#Parameter.AliasSourceData#"> --->
															 																														
								<cfstoredproc procedure="up_fn_val_ldgb_suf" 
								    datasource  = "#sp#" 
								    username    = "#SESSION.login#" 
								    password   = "#SESSION.dbpw#"
									returncode ="YES">
								
									<cfprocparam 
								    type="In" 
								    cfsqltype="CF_SQL_FLOAT" 
								    dbvarname="@ldgb_postd_acct_prd" 
								    value="#Valpap#" 
								    null="No">
								
								<cfprocparam 
								    type="In" 
								    cfsqltype="CF_SQL_INTEGER" 
									dbvarname="@ldgb_f_fnlp_fscl_yr"  
									value="#f_fnlp_fscl_yr#" 
									null="No">
								
								<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_f_fund_id_code"  
									value="#f_fund_id_code#" 
									null="No">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_f_orgu_id_code"  
									value="#f_orgu_id_code#" 
									null="No">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_f_proj_id_code"  
									value="#f_proj_id_code#" 
									null="YES">
								<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_f_pgmm_id_code"  
									value="#f_pgmm_id_code#" 
									null="YES">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_f_objt_id_code"  
									value="#f_objt_id_code#" 
									null="YES">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_f_objc_id_code"  
									value="#f_objc_id_code#" 
									null="YES">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_f_budx_id_code"  
									value="NULL" 
									null="YES">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_float" 
									dbvarname="@doc_amt"  
									value="NULL" 
									null="YES">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_f_sldg_id_code"  
									value="NULL" 
									null="YES">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_integer" 
									dbvarname="@ldgb_f_refx_agsr_seq_num"  
									value="NULL" 
									null="YES">
									
								    <cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_integer"
									dbvarname="@distr_ind"  
									value="1" 
									null="NO">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_integer" 
									dbvarname="@accn_ser_num"  
									value="#f_accn_ser_num#" 
									null="NO">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_integer" 
									dbvarname="@rs_flag"  
									value="1" 
									null="YES">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_f_dorf_id_code"  
									value="NULL" 
									null="YES">
									
									<cfprocparam 
								    type="In" 
								    cfsqltype="cf_sql_char" 
									dbvarname="@ldgb_db_mdst_source"  
									value="#claimRequest.mission#" 
									null="NO">
						 	  
								<cfprocparam type="Out" 
									cfsqltype="CF_SQL_FLOAT"
									dbvarname="@avail_funds"  
									variable="funds" >
					       
								</cfstoredproc>
							<cfset bal =funds>
							<cfset SP_RET_CODE = cfstoredproc.statusCode >
							<!---
							<cfoutput> funds are #funds# and ldbg #valpap# SP_RET_CODE #SP_RET_CODE#</cfoutput>
							---->
							<!--- JG3 End of stuff I added on 11-Feb-2008 --->
							
							<cfset SP_RET_CODE = cfstoredproc.statusCode >
							
							<cfset ValFundRemamt = #Sum_Nonoblg_amt.summ_nonoblg_amt# >
							<cfif bal eq "" > <cfset bal =0> </cfif>
							<!----
							<cfset ValFundRemamt = #Sum_Nonoblg_amt.summ_nonoblg_amt# >
		                     <cfoutput> SP_RET_CODE #SP_RET_CODE# Bal is #bal# </cfoutput>
							 ---->
							  
							<cfif bal lt 0 OR SP_RET_CODE lt 0  OR bal lt ValFundRemamt OR SP_RET_CODE lt 0>
					
								 <cf_ValidationInsert
								    ClaimId        = "#URL.ClaimId#"
									ClaimCategory  = "#cat#"
									CalculationId  = "#rowguid#"
									ValidationCode = "A05"
									ValidationMemo = "Non-Oblg-Insufficient Funds to cover Claimed amt (PAP:#Valpap# SERNO:#f_accn_ser_num#-#f_fnlp_fscl_yr#-#f_fund_id_code#-#f_orgu_id_code#-#f_proj_id_code#-#f_pgmm_id_code#-#f_objt_id_code#-AMT:#funds#)">
									<!---							
									ValidationMemo = "Non-oblg-Insufficient Funds  to cover Claimed amt (PAP:#Valpap# SERNO:#f_accn_ser_num# AMT:#funds#)">
									--->
																
							</cfif>
							
		</cfif>
							
	</cfoutput>
</cfif>
		
<cfif Valincomplete eq "0">

	<cfquery name="UpdateClaim" 
		datasource="appsTravelClaim">
		UPDATE Claim
		SET AccountPeriod = '#Valpap#' 
		WHERE  ClaimId = '#URL.ClaimId#'
	</cfquery>

<cfelse>

	<cfquery name="UpdateClaim" 
		datasource="appsTravelClaim">
		UPDATE Claim
		SET AccountPeriod = '#default#',
		    ClaimException = 1 
		WHERE  ClaimId = '#URL.ClaimId#' 
	</cfquery>

</cfif>

<!---  
<cfset Valexecutiontime = #Valexecutiontime# +#cfquery.executiontime# >
 
--->
