
<cfquery name="step" 
datasource="appsTravelClaim" >
SELECT     RA.db_mdst_source, RA.f_tvrq_doc_id, RA.f_tvrl_seq_num, 
           ClaimRequestLine.PersonNo, ClaimRequestLine.ClaimCategory, SUM(RA.oblg_cnvrt_amt) 
           AS AmountTotal, COUNT(*) AS Lines, ClaimRequest.ClaimRequestId, ClaimRequestLine.ClaimRequestLineNo,                      
           IMP_CLAIMREQ.tolerance_amt AS Tolerance, ClaimRequestLine.ClaimantType
INTO       tmp_claim2p
FROM       IMP_CLAIMREQLINEFUND RA INNER JOIN
           ClaimRequestLine ON RA.f_tvrl_seq_num = ClaimRequestLine.ClaimRequestLineNo INNER JOIN
		   ClaimRequest ON ClaimRequestLine.ClaimRequestId 
           = ClaimRequest.ClaimRequestId AND RA.db_mdst_source = ClaimRequest.Mission 
AND         RA.f_tvrq_doc_id = ClaimRequest.DocumentNo 
           INNER JOIN  IMP_CLAIMREQ ON RA.db_mdst_source = IMP_CLAIMREQ.db_mdst_source 
AND        RA.f_tvrq_doc_id = IMP_CLAIMREQ.doc_id
GROUP BY   RA.db_mdst_source, RA.f_tvrq_doc_id, ClaimRequestLine.PersonNo, 
           ClaimRequestLine.ClaimCategory, ClaimRequest.ClaimRequestId, 
           IMP_CLAIMREQ.tolerance_amt, ClaimRequestLine.ClaimRequestLineNo, 
           RA.f_tvrl_seq_num, ClaimRequestLine.ClaimantType
</cfquery>

<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="stClaimFunding">

<cfquery name="step" 
datasource="appsTravelClaim" >
SELECT     RL.ClaimRequestId, RL.ClaimRequestLineNo, T.Tolerance, IMP.db_mdst_source, IMP.f_tvrq_doc_id, IMP.f_tvrl_seq_num, RL.ClaimCategory, 
           RL.PersonNo, T.ClaimantType, IMP.f_accn_ser_num, IMP.f_fnlp_fscl_yr, IMP.f_fund_id_code, IMP.f_orgu_id_code, IMP.f_proj_id_code, IMP.proj_external_symbol, 
           IMP.f_pgmm_id_code, IMP.f_objt_id_code, IMP.f_refx_agsr_seq_num, IMP.f_objc_id_code, IMP.f_actv_id_code, IMP.oblg_cnvrt_amt AS Amount, 
           IMP.oblg_cnvrt_amt / T.AmountTotal AS Percentage, T.AmountTotal, IMP.seq_num, stFund.Fund_Type as FundType, IMP.iov_ind,
	       stFund.Fund_cycl_num	   
INTO       stClaimFunding
FROM       tmp_claim2p T INNER JOIN  
           IMP_CLAIMREQLINEFUND IMP ON T.db_mdst_source = IMP.db_mdst_source AND T.f_tvrq_doc_id = IMP.f_tvrq_doc_id 
AND        T.f_tvrl_seq_num = IMP.f_tvrl_seq_num 
INNER JOIN
          ClaimRequestLine RL ON T.ClaimRequestId = RL.ClaimRequestId 
AND       T.ClaimCategory = RL.ClaimCategory 
AND       T.PersonNo = RL.PersonNo 
AND       IMP.f_tvrl_seq_num = RL.ClaimRequestLineNo LEFT OUTER 
JOIN
                      IMP_stFund stFund ON IMP.f_fund_id_code = stFund.Fund
WHERE     (T.AmountTotal <> 0)
</cfquery>


