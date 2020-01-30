<cfsilent>
	 <proOwn>MKM</proOwn>
	 <proDes>Extract data from IMIS tables (to IMP tables) </proDes>
	 <proCom>21/11/2008: added person, Staffmember, SM's org unit, e-mail address </proCom>
</cfsilent>

<!--- scope is available in IMP_CLAIMREQ --->
<cfquery name="Advances" 
	datasource="#DSNDW#">	
	SELECT     Rec.f_dorf_ref_id_code AS Document, Rec.f_ref_doc_id AS doc_no, Rec.descr AS Description, RecLine.*, Rec.f_prsn_index_num AS IndexNo, 
	           Rec.est_receipt_date AS est_receipt_date, Rec.apprv_date AS apprv_date, Rec.due_date AS Due_date, Adv.f_refx_apmd_seq_num AS AdvanceMode, 
	           Adv.doc_stat_code AS AdvanceStatus, #DBDW#.#SCHdw#.DW_fin_inter_off_agency_auth.f_mdst_id_code_rqst AS Requester
	INTO       IMP_CLAIMADVANCE
	FROM       #DBDW#.#SCHdw#.DW_fin_receivable_header Rec INNER JOIN
	           IMP_CLAIMREQ ON Rec.db_mdst_source = IMP_CLAIMREQ.db_mdst_source AND Rec.f_ref_doc_id = IMP_CLAIMREQ.doc_id INNER JOIN
	           #DBDW#.#SCHdw#.DW_fin_receivable_line_actg RecLine ON Rec.db_mdst_source = RecLine.db_mdst_source AND 
	           Rec.f_dorf_id_code = RecLine.f_dorf_rcvh_id_code AND Rec.doc_id = RecLine.f_rcvh_doc_id INNER JOIN
	           #DBDW#.#SCHdw#.DW_fin_advance Adv ON RecLine.db_mdst_source = Adv.db_mdst_source AND IMP_CLAIMREQ.doc_id = Adv.f_ref_doc_id AND 
	           RecLine.f_rcvh_doc_id = Adv.doc_id LEFT OUTER JOIN
	           #DBDW#.#SCHdw#.DW_fin_inter_off_agency_auth ON Adv.f_dorf_ioau_id_code = #DBDW#.#SCHdw#.DW_fin_inter_off_agency_auth.f_dorf_id_code AND 
	           Adv.f_ioau_doc_id = #DBDW#.#SCHdw#.DW_fin_inter_off_agency_auth.doc_id
	WHERE     (Rec.f_dorf_ref_id_code = 'TVRQ')
	 AND      (Rec.doc_stat_code = 'ap') 
	 AND      (Adv.doc_stat_code <> 'ca')
</cfquery>		
	
  
<cfquery name="EO" 
	datasource="#DSNDW#">  		
SELECT    	TRXA1.db_mdst_source, TRXA1.part1_doc_id, IUSER.f_ugrp_id_code, UGRP.f_orgu_id_code,
			TRXA1.f_user_id_code as f_user_id_code_certifier,
			PRSN.f_prsn_index_num as f_prsn_index_num_certifier,
			PRSN.calc_fullname_FL CertifierFullName,
			TRXA1.f_user_id_code as f_user_id_code_admin_asst,
			PRSN.f_prsn_index_num as f_prsn_index_num_admin_asst,
			PRSN.calc_fullname_FL AS AdminAsstFullName
INTO       	dbo.IMP_CLAIMREQEO
FROM       	#DBDW#.#SCHdw#.DW_Ref_user_grp UGRP INNER JOIN
           	WarehouseOPPBA.dbo.DW_Ref_user_h IUSER ON UGRP.db_mdst_source = IUSER.db_mdst_source AND UGRP.id_code = IUSER.f_ugrp_id_code INNER JOIN
           	#DBDW#.#SCHdw#.DW_Ref_trans_approval TRXA1 ON IUSER.db_mdst_source = TRXA1.db_mdst_source AND IUSER.id_code = TRXA1.f_user_id_code INNER JOIN
			WarehouseOPPBA.dbo.DW_sum_person_name_curr PRSN ON PRSN.db_mdst_source = IUSER.db_mdst_source AND PRSN.f_prsn_index_num = IUSER.f_prsn_index_num 
WHERE     	(TRXA1.part1_doc_id IN
                          (SELECT     doc_id
                            FROM          IMP_ClaimReq)) 
AND (TRXA1.f_adlh_tran_ser_num IN
                          (SELECT     MAX(f_adlh_tran_ser_num)
                            FROM          #DBDW#.#SCHdw#.DW_Ref_trans_approval
                            WHERE      part1_doc_id IN
                                          (SELECT     doc_id
                                           FROM       IMP_ClaimReq) 
							AND f_adme_id_code = 'TVQY' AND f_dorf_id_code = 'TVRQ'
                            GROUP BY part1_doc_id)) 
AND (IUSER.f_adlh_tran_ser_num  = (SELECT MAX(f_adlh_tran_ser_num)
				  FROM WarehouseOPPBA.dbo.DW_Ref_user_h IUSER1
				  WHERE TRXA1.proc_date BETWEEN IUSER1.eff_beg_date AND IUSER1.eff_end_date
				  AND IUSER1.db_mdst_source = IUSER.db_mdst_source
				  AND IUSER1.id_code = IUSER.id_code
				  AND IUSER1.f_ugrp_id_code <> 'ESDNYDEL')) 							
AND (TRXA1.f_adme_id_code = 'TVQY') 
AND (TRXA1.f_dorf_id_code = 'TVRQ')
ORDER BY    TRXA1.db_mdst_source, TRXA1.part1_doc_id
</cfquery>

<cfquery name="UpdateEO" 
	datasource="#DSNDW#">  		
UPDATE dbo.IMP_CLAIMREQEO
SET f_user_id_code_admin_asst = TRXA1.f_user_id_code,
f_prsn_index_num_admin_asst = PRSN.f_prsn_index_num,
AdminAsstFullName = PRSN.calc_fullname_FL
FROM      
#DBDW#.#SCHdw#.DW_Ref_imis_user IUSER INNER JOIN
#DBDW#.#SCHdw#.DW_Ref_trans_approval TRXA1 ON IUSER.db_mdst_source = TRXA1.db_mdst_source AND IUSER.id_code = TRXA1.f_user_id_code INNER JOIN
WarehouseOPPBA.dbo.DW_sum_person_name_curr PRSN ON PRSN.db_mdst_source = IUSER.db_mdst_source AND PRSN.f_prsn_index_num = IUSER.f_prsn_index_num 
WHERE
IMP_CLAIMREQEO.part1_doc_id = TRXA1.part1_doc_id
AND (TRXA1.part1_doc_id IN (SELECT doc_id
                       FROM   IMP_ClaimReq)) 
AND (TRXA1.f_adlh_tran_ser_num IN  (SELECT MAX(f_adlh_tran_ser_num)
                            	    FROM #DBDW#.#SCHdw#.DW_Ref_trans_approval
                                    WHERE part1_doc_id IN (SELECT doc_id
                                                           FROM   IMP_ClaimReq) 
									AND f_adme_id_code IN ('TVQC', 'TVQF', 'TVQM', 'TVQX')
									AND f_dorf_id_code = 'TVRQ'
                                    GROUP BY part1_doc_id)) 
AND (TRXA1.f_adme_id_code IN ('TVQC', 'TVQF', 'TVQM', 'TVQX')) 
AND (TRXA1.f_dorf_id_code = 'TVRQ')	
</cfquery>	

<cfquery name="TravellerOrg" 
	datasource="#DSNDW#">  
SELECT DISTINCT
	TVRQ.db_mdst_source,
	TVRQ.doc_id,
	TVRQ.f_prsn_index_num,
	POST.post_f_orgu_id_code,
	ORGU.abbrev_name
INTO
	IMP_CLAIMREQ_TRAVELLER_ORG
FROM
	WarehouseOPPBA.dbo.DW_sum_post_asof POST,
	dbo.IMP_CLAIMREQ TVRQ,
	WarehouseOPPBA.dbo.DW_Rfg_org_unit ORGU
WHERE 
	ORGU.id_code = POST.post_f_orgu_id_code
	AND POST.db_mdst_source = TVRQ.db_mdst_source 
	AND POST.calc_asof_date <= TVRQ.creat_date
	AND POST.pasn_f_prsn_index_num = TVRQ.f_prsn_index_num
	AND POST.calc_asof_date = (SELECT MAX(POST1.calc_asof_date)
				   FROM WarehouseOPPBA.dbo.DW_sum_post_asof POST1
				   WHERE POST.db_mdst_source = POST1.db_mdst_source
				   AND POST.pasn_f_prsn_index_num = POST1.pasn_f_prsn_index_num
				   AND POST1.calc_asof_date <= TVRQ.creat_date)
	AND POST.pasn_incmb_pct = (SELECT MAX(POST2.pasn_incmb_pct)
				FROM WarehouseOPPBA.dbo.DW_sum_post_asof POST2
				WHERE POST.db_mdst_source = POST2.db_mdst_source
				AND POST.pasn_f_prsn_index_num = POST2.pasn_f_prsn_index_num
				AND POST.calc_asof_date = POST2.calc_asof_date
				)
	AND POST.post_chg_eff_date = (SELECT MAX(POST3.post_chg_eff_date)
				FROM WarehouseOPPBA.dbo.DW_sum_post_asof POST3
				WHERE POST.db_mdst_source = POST3.db_mdst_source
				AND POST.pasn_f_prsn_index_num = POST3.pasn_f_prsn_index_num
				AND POST.calc_asof_date = POST3.calc_asof_date
				AND POST.pasn_incmb_pct = POST3.pasn_incmb_pct)
	ORDER BY 
	2
</cfquery>	
<!--- Added Line.oblg_curr_amt and tvrl to make sure that
zero amounts do not come into the portal , this was done to ensure that
we always have a bac , the draw backs are even if a line has MSC zero amount in the portal
we will not show such zero amount lines and only create it as a non -obligated line against the same BAC
but we will bring the NOC line ,SFT lines etc with zero amount f_refx_tvrl_seq_num 
JG --->
	
<cfquery name="TravelRequestLine" 
	datasource="#DSNDW#">
	SELECT   Line.*
	INTO     dbo.IMP_CLAIMREQLINE
	FROM     #DBDW#.#SCHdw#.DW_fin_travel_request_line Line INNER JOIN  
				IMP_CLAIMREQ I ON Line.db_mdst_source = I.db_mdst_source 
							  AND Line.f_tvrq_doc_id  = I.doc_id
							   WHERE     (Line.oblg_curr_amt > 0 or Line.f_refx_tvrl_seq_num = 1)
</cfquery>							  

<cfquery name="TravelRequestLineDetail" 
	datasource="#DSNDW#">
	SELECT    M.*
	INTO      IMP_CLAIMREQLINEDETAIL
	FROM      #DBDW#.#SCHdw#.DW_fin_travel_request_misc_line M INNER JOIN
               IMP_CLAIMREQ I ON M.db_mdst_source = I.db_mdst_source 
				   AND M.f_tvrq_doc_id = I.doc_id
</cfquery>		

<cfquery name="TravelRequestLineFunding" 
	datasource="#DSNDW#">
	SELECT     M.*
	INTO       IMP_CLAIMREQLINEFUND
	FROM  	   IMP_CLAIMREQ I INNER JOIN 
	           #DBDW#.#SCHdw#.DW_fin_travel_request_line_actg M 
			       ON I.db_mdst_source = M.db_mdst_source 
		   		   AND I.doc_id = M.f_tvrq_doc_id
</cfquery>													

<cfquery name="TravelRequestLineTicket" 
	datasource="#DSNDW#">
	SELECT     T.*, TCity.seq_num AS CityLineNo, TCity.f_city_ser_num AS CityId
	INTO       IMP_CLAIMREQTICKET
	FROM       #DBDW#.#SCHdw#.DW_fin_itinerary T INNER JOIN
               IMP_CLAIMREQ I 
			   		ON T.db_mdst_source  = I.db_mdst_source 
				    AND T.f_tvrq_doc_id  = I.doc_id 
			   INNER JOIN #DBDW#.#SCHdw#.DW_fin_authorized_itinerary TCity 
					ON  T.db_mdst_source = TCity.db_mdst_source 
					AND T.f_tvrq_doc_id  = TCity.f_tvrq_doc_id 
					AND T.f_tvrl_seq_num = TCity.f_tvrl_seq_num
</cfquery>	

<cfquery name="TravelRequestLineDSA" 
	datasource="#DSNDW#">
	SELECT     T.*
	INTO       IMP_CLAIMREQDSA
	FROM       #DBDW#.#SCHdw#.DW_fin_travel_request_dsa_location T INNER JOIN
               IMP_CLAIMREQ I 
			   ON  T.db_mdst_source = I.db_mdst_source 
			   AND T.f_tvrq_doc_id  = I.doc_id
</cfquery>		

<cfquery name="DSALocation" 
	datasource="#DSNDW#">
	SELECT     id_code, 
	           f_cnty_id_code, 
			   f_city_id_code, 
			   name
	INTO       IMP_DSALocation
	FROM       #DBDW#.#SCHdw#.DW_Rfg_subsistence_location
</cfquery>


<cfquery name="DSARates" 
	datasource="#DSNDW#">
	SELECT   f_dsal_id_code, f_cnty_id_code, MAX(eff_date) AS LastDate
	INTO     tmp_DSA
	FROM     #DBDW#.#SCHdw#.DW_Rfg_subsistence_rate
	WHERE     (eff_date < '06/06/2007')
	GROUP BY f_dsal_id_code, f_cnty_id_code
</cfquery>	

<cfquery name="DSARates" 
	datasource="#DSNDW#">
	  SELECT DISTINCT
               D.*, R.usd_rate_amt AS usd_rate_amt,
               R.f_curr_code AS f_curr_code,
               R.local_curr_rate_amt AS local_curr_rate_amt,
               R.room_rate_pct AS room_rate_pct,
               R.f_refx_prdc_seq_num AS Pointer
	  INTO IMP_DSARATE
	  FROM   #DBDW#.#SCHdw#.DW_Rfg_subsistence_rate D INNER JOIN
	                      #DBDW#.#SCHdw#.DW_Rfg_subsistence_rate_range R
	            ON  D.f_dsal_id_code = R.f_dsal_id_code
	            AND D.f_cnty_id_code = R.f_cnty_id_code
	            AND D.f_refx_dsal_seq_num = R.f_refx_dsal_seq_num
	            AND D.eff_date = R.f_dsar_eff_date
	  WHERE     (D.eff_date >= '6/6/2007')

	  UNION
	  SELECT DISTINCT
	               D.*, R.usd_rate_amt AS usd_rate_amt,
	               R.f_curr_code AS f_curr_code,
	               R.local_curr_rate_amt AS local_curr_rate_amt,
	               R.room_rate_pct AS room_rate_pct,
	               R.f_refx_prdc_seq_num AS Pointer
	  FROM         #DBDW#.#SCHdw#.DW_Rfg_subsistence_rate D INNER JOIN
                   #DBDW#.#SCHdw#.DW_Rfg_subsistence_rate_range R ON D.f_dsal_id_code = R.f_dsal_id_code AND D.f_cnty_id_code = R.f_cnty_id_code AND 
                   D.f_refx_dsal_seq_num = R.f_refx_dsal_seq_num AND D.eff_date = R.f_dsar_eff_date INNER JOIN
                   tmp_DSA T ON D.f_dsal_id_code = T.f_dsal_id_code AND D.f_cnty_id_code = T.f_cnty_id_code AND D.eff_date = T.LastDate				   
</cfquery>

<cfquery name="BankInsitutions" 
	datasource="#DSNDW#">
	SELECT DISTINCT D.f_prsn_index_num, 
					D.eff_date, 
					D.f_curr_code,
					D.expir_date,
					D.f_fnli_un_id_code, 
					D.acct_num, 
					D.f_refx_acty_seq_num, 
					D.f_refx_csty_seq_num, 
                    D.f_refx_efty_seq_num, 
					D.db_mdst_source, 
					Type.refx_name AS AccountType, 
					Inst.name, 
					Inst.strt_addr, 
					Inst.city, 
					Inst.f_cnty_id_code, 
                    Inst.routing_num_int, 
					D.seq_num
	INTO  IMP_PERSONBANK	
	FROM         #DBDW#.#SCHdw#.DW_Ref_person_bank D INNER JOIN
                 #DBDW#.#SCHdw#.DW_Ref_financial_institution Inst ON D.f_fnli_un_id_code = Inst.un_id_code
				 AND D.db_mdst_source = Inst.db_mdst_source
				  INNER JOIN
                 #DBDW#.#SCHdw#.DW_Rfg_ReferenceCodes Type ON D.f_refx_csty_seq_num = Type.refx_seq_num
	WHERE     (D.eff_date <= ISNULL(GETDATE(), D.eff_date)) AND (D.proc_comp =
                          (SELECT     MIN(proc_comp)
                            FROM          #DBDW#.#SCHdw#.DW_Ref_person_bank PNBK2
                            WHERE      D.f_prsn_index_num = PNBK2.f_prsn_index_num 
							AND PNBK2.db_mdst_source = D.db_mdst_source
							AND D.seq_num = PNBK2.seq_num)) AND (ISNULL(D.expir_date, '12/31/2012') 
                      >= ISNULL(GETDATE(), ISNULL(D.expir_date, '12/31/2012'))) AND (Type.refx_code = 'csty')
					  AND D.db_mdst_source='#mission#'
	ORDER BY D.f_prsn_index_num	
</cfquery>
<!---
OLD query Commented JG3 1-May-2008
<cfquery name="ValidTVCUClaims" 
 datasource="#DSNDW#">
 SELECT  DISTINCT LN.db_mdst_source, LN.f_dorf_tvch_id_code, LN.f_tvch_doc_id, LN.f_tvrq_doc_id
 INTO    tmp_claim2 
 FROM    #DBDW#.#SCHdw#.DW_fin_travel_claim_line LN INNER JOIN
         #DBDW#.#SCHdw#.DW_fin_itinerary TVRQ ON LN.db_mdst_source = TVRQ.db_mdst_source AND LN.f_tvrq_doc_id = TVRQ.f_tvrq_doc_id AND 
         LN.f_tvrl_seq_num = TVRQ.f_tvrl_seq_num
 WHERE   LN.f_dorf_tvch_id_code IN ('TVCU', 'TVCC') 
  AND     TVRQ.f_refx_tvli_seq_num <> '1'
</cfquery> 
--->
<!---
Latest Query below done based on what Karl had told me
1-May-2008 JG3
---->

<cfquery name="ValidTVCUClaims" 
 datasource="#DSNDW#">
SELECT  DISTINCT TVCL.db_mdst_source, TVCL.f_dorf_tvch_id_code, TVCL.f_tvch_doc_id, 
TVCL.f_tvrq_doc_id
into tmp_claim2
 FROM    #DBDW#.#SCHdw#.DW_fin_travel_claim_line TVCL INNER JOIN
         #DBDW#.#SCHdw#.DW_fin_travel_request_line  TVRL ON TVCL.db_mdst_source = TVRL.db_mdst_source 
      AND TVCL.f_tvrq_doc_id = TVRL.f_tvrq_doc_id AND 
         TVCL.f_tvrl_seq_num = TVRL.seq_num
 WHERE   TVCL.f_dorf_tvch_id_code IN ('TVCU', 'TVCC') 
 AND     TVRL.f_refx_tvrl_seq_num <> '1'

union


SELECT  DISTINCT TVCL.db_mdst_source, TVCL.f_dorf_tvch_id_code, TVCL.f_tvch_doc_id, 
TVCL.f_tvrq_doc_id
 
 FROM   #DBDW#.#SCHdw#.DW_fin_travel_claim_line TVCL INNER JOIN
         #DBDW#.#SCHdw#.DW_fin_itinerary ITNH ON TVCL.db_mdst_source = ITNH.db_mdst_source 
AND TVCL.f_tvrq_doc_id = ITNH.f_tvrq_doc_id AND 
         TVCL.f_tvrl_seq_num = ITNH.f_tvrl_seq_num
 WHERE   TVCL.f_dorf_tvch_id_code IN ('TVCU', 'TVCC') 
  AND     ITNH.f_refx_tvli_seq_num <> '1'

</cfquery> 



<!---
Removed by JG on MAY-01-2008
AND     LN.f_tvrl_seq_num = '1' 
--->
<!--- old 

<cfquery name="ValidTVCUClaims" 
	datasource="#DSNDW#">
	SELECT  DISTINCT db_mdst_source, f_dorf_tvch_id_code, f_tvch_doc_id, f_tvrq_doc_id
	INTO    tmp_claim2 
	FROM    #DBDW#.#SCHdw#.DW_fin_travel_claim_line
	WHERE   (f_dorf_tvch_id_code IN ('TVCU', 'TVCC')) 
	AND     (f_tvrl_seq_num != '1')
	UNION
	SELECT  DISTINCT LN.db_mdst_source, LN.f_dorf_tvch_id_code, LN.f_tvch_doc_id, LN.f_tvrq_doc_id
	FROM    #DBDW#.#SCHdw#.DW_fin_travel_claim_line LN INNER JOIN
	        #DBDW#.#SCHdw#.DW_fin_itinerary TVRQ ON LN.db_mdst_source = TVRQ.db_mdst_source AND LN.f_tvrq_doc_id = TVRQ.f_tvrq_doc_id AND 
	        LN.f_tvrl_seq_num = TVRQ.f_tvrl_seq_num
	WHERE   LN.f_dorf_tvch_id_code IN ('TVCU', 'TVCC') 
	AND     LN.f_tvrl_seq_num = '1' 
	AND     TVRQ.f_refx_tvli_seq_num <> '1'
</cfquery>	

--->

<cfquery name="ClaimsSubmittedHeader" 
	datasource="#DSNDW#">
	SELECT DISTINCT C.*, CL.f_tvrq_doc_id AS DocIdRequest
	INTO  IMP_CLAIM
	FROM  IMP_CLAIMREQ R INNER JOIN
	        #DBDW#.#SCHdw#.DW_fin_travel_claim_line CL 
			ON   R.db_mdst_source = CL.db_mdst_source 
			AND  R.doc_id         = CL.f_tvrq_doc_id 
			INNER JOIN
	        #DBDW#.#SCHdw#.DW_fin_travel_claim C 
			ON   CL.f_tvch_doc_id       = C.doc_id 
			AND  CL.db_mdst_source      = C.db_mdst_source 
			AND  CL.f_dorf_tvch_id_code = C.f_dorf_id_code
		WHERE     (C.f_dorf_id_code     = 'TVCV')
	UNION
	SELECT DISTINCT C.*, CL.f_tvrq_doc_id AS DocIdRequest	
	FROM    IMP_CLAIMREQ R INNER JOIN
            #DBDW#.#SCHdw#.DW_fin_travel_claim_line CL ON R.db_mdst_source = CL.db_mdst_source 
			AND R.doc_id = CL.f_tvrq_doc_id INNER JOIN
            #DBDW#.#SCHdw#.DW_fin_travel_claim C ON CL.f_tvch_doc_id = C.doc_id 
			AND CL.db_mdst_source = C.db_mdst_source 
			AND CL.f_dorf_tvch_id_code = C.f_dorf_id_code INNER JOIN
            tmp_claim2 TVCU ON CL.db_mdst_source = TVCU.db_mdst_source 
			AND CL.f_dorf_tvch_id_code           = TVCU.f_dorf_tvch_id_code 
			AND CL.f_tvch_doc_id                 = TVCU.f_tvch_doc_id	
			AND CL.f_tvrq_doc_id                 = TVCU.f_tvrq_doc_id	
</cfquery>	

<cfquery name="ClaimsSubmittedLine" 
	datasource="#DSNDW#">
	SELECT      CL.*, f_curr_code as PaymentCurrency, claim_amt as PaymentAmount
	INTO        IMP_CLAIMLINE
	FROM        #DBDW#.#SCHdw#.DW_fin_travel_claim_line CL INNER JOIN IMP_CLAIM 
			ON  CL.db_mdst_source      = IMP_CLAIM.db_mdst_source 
			AND CL.f_dorf_tvch_id_code = IMP_CLAIM.f_dorf_id_code 
			AND CL.f_tvch_doc_id       = IMP_CLAIM.doc_id
	WHERE     (CL.f_dorf_tvch_id_code  = 'TVCV')
	UNION
	SELECT     CL.*, f_curr_code as PaymentCurrency, claim_amt as PaymentAmount
	FROM       #DBDW#.#SCHdw#.DW_fin_travel_claim_line CL 
	           INNER JOIN IMP_CLAIM ON CL.db_mdst_source = IMP_CLAIM.db_mdst_source 
			   AND CL.f_dorf_tvch_id_code = IMP_CLAIM.f_dorf_id_code 
			   AND CL.f_tvch_doc_id = IMP_CLAIM.doc_id INNER JOIN 
			   tmp_claim2 TVCU ON CL.db_mdst_source = TVCU.db_mdst_source 
			   AND CL.f_dorf_tvch_id_code           = TVCU.f_dorf_tvch_id_code 
			   AND CL.f_tvch_doc_id                 = TVCU.f_tvch_doc_id	     
			   AND CL.f_tvrq_doc_id                 = TVCU.f_tvrq_doc_id	
</cfquery>	


<!--- update Payment currency --->

<cfquery name="ClaimsPaid" 
	datasource="#DSNDW#">
SELECT  CLA.db_mdst_source,
        CLA.f_dorf_tvch_id_code, 
        CLA.f_tvch_doc_id, 
		CLA.f_tvcl_seq_num, 
		CLA.f_curr_code AS PaymentCurrency, 
		SUM(curr_amt) AS PaymentAmount
INTO   tmp_claim
FROM    #DBDW#.#SCHdw#.DW_fin_travel_claim_line_actg CLA INNER JOIN IMP_CLAIM 
			ON  CLA.db_mdst_source      = IMP_CLAIM.db_mdst_source 
			AND CLA.f_dorf_tvch_id_code = IMP_CLAIM.f_dorf_id_code 
			AND CLA.f_tvch_doc_id       = IMP_CLAIM.doc_id
WHERE     (CLA.f_dorf_tvch_id_code IN ('TVCV', 'TVCU', 'TVCC'))
GROUP BY CLA.db_mdst_source, CLA.f_dorf_tvch_id_code, CLA.f_tvch_doc_id, CLA.f_tvcl_seq_num, CLA.f_curr_code
</cfquery>

<cfquery name="ClaimsPaid" 
	datasource="#DSNDW#">
UPDATE    IMP_ClaimLine
SET       PaymentCurrency = T.PaymentCurrency, PaymentAmount = T.PaymentAmount
FROM      tmp_claim T INNER JOIN
          IMP_CLAIMLINE I ON T.db_mdst_source = I.db_mdst_source 
		  AND T.f_dorf_tvch_id_code = I.f_dorf_tvch_id_code 
		  AND T.f_tvch_doc_id = I.f_tvch_doc_id 
		  AND T.f_tvcl_seq_num = I.seq_num
</cfquery>					  

<cfquery name="ClaimsOffSet" 
	datasource="#DSNDW#">
SELECT DISTINCT  f_dorf_id_code_pybh, 
                 f_pybh_doc_id, 
				 seq_num, 
				 f_dorf_id_code_rcvh, 
				 f_rcvh_doc_id, 
				 f_curr_code, 
				 offset_amt, 
				 f_rcvl_seq_num, 
				 f_rcva_seq_num, 
				 exch_rate, 
				 offset_cnvrt_amt
INTO    IMP_CLAIMOFFSET 
FROM    #DBDW#.#SCHdw#.DW_fin_receivable_offset 
WHERE   f_dorf_id_code_pybh = 'TVCV'
 AND    (f_pybh_doc_id IN (SELECT doc_id FROM IMP_Claim))
 AND    db_mdst_source = '#mission#' 
 AND    (f_rcvl_seq_num IS NULL)
</cfquery> 

<cfquery name="FundType" 
	datasource="#DSNDW#">
	SELECT    id_code as Fund, 
	          f_refx_fatr_seq_num as Fund_type,
			  f_refx_cycl_seq_num as Fund_cycl_num
	INTO      IMP_stFund
	FROM      #DBDW#.#SCHdw#.DW_Ref_fund
</cfquery>

<cfquery name="ExchangeRates" 
	datasource="#DSNDW#">
	SELECT    *
	INTO      IMP_EXCHANGE
	FROM      #DBDW#.#SCHdw#.DW_Rfg_exchange_rate
	WHERE     eff_date > '01/01/2006'
	OR f_curr_code IN (SELECT DISTINCT f_curr_code
					   FROM #DBDW#.#SCHdw#.DW_Rfg_exchange_rate
					   WHERE     (f_curr_code NOT IN (SELECT  f_curr_code
							                          FROM    #DBDW#.#SCHdw#.DW_Rfg_exchange_rate
			            			                  WHERE   eff_date > '1/1/2006'
													  )
  								  )
					  )			  
</cfquery>	   

<cfquery name="City" 
	datasource="#DSNDW#">
	
	SELECT	C.*, ST.name AS State
	INTO    IMP_City
    FROM    #DBDW#.#SCHdw#.DW_Rfg_city C LEFT OUTER JOIN
            #DBDW#.#SCHdw#.DW_Ref_admin_territory ST ON C.f_admt_id_code = ST.id_code AND C.f_cnty_id_code = ST.f_cnty_id_code	
			   
</cfquery>	

<cfquery name="Paygroup" 
	datasource="#DSNDW#">
	
	SELECT   *
	INTO     IMP_PayGroup
	FROM     #DBDW#.#SCHdw#.DW_Ref_staff_member_pay_group
	
</cfquery>	

<cfquery name="Paygroup" 
	datasource="#DSNDW#">
CREATE TABLE [IMP_Person] (
	[PersonNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[IndexNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[MiddleName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MaidenName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FullName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Category] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Rank] [int] NULL ,
	[Gender] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Nationality] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL ,
	[BirthDate] [datetime] NULL ,
	[BirthCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BirthNationality] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Bloodtype] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MaritalStatus] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrganizationCategory] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrganizationStart] [datetime] NULL ,
	[OrganizationEnd] [datetime] NULL ,
	[PersonStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL ,
	[ParentOffice] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ParentOfficeLocation] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Source] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Remarks] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EmailAddress] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ServiceJoinDate] [datetime] NULL ,
	[OfficerUserId] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OfficerLastName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OfficerFirstName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Created] [datetime] NOT NULL ,
	[rowguid] [uniqueidentifier] NULL ,
	[Grade] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OnPayroll] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[prsn_index_num] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StaffMemberOrg] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
</cfquery>	

<cfquery name="Person" 
	datasource="#DSNDW#">
	INSERT INTO
		IMP_Person	
	SELECT 
		'IND' + REPLICATE ('0', 6-LEN(prsn_index_num)) + prsn_index_num AS PersonNo,
		REPLICATE ('0', 6-LEN(prsn_index_num)) + prsn_index_num AS IndexNo,
		RTRIM(pnme_last_name) AS LastName,
		RTRIM(pnme_first_name) AS FirstName,
		RTRIM(pnme_mid_name) AS MiddleName,
		RTRIM(pnme_maidn_name) AS MaidenName,
		RTRIM(RTRIM(pnme_first_name)  + ' ' +  RTRIM(ISNULL(pnme_mid_name,''))) + ' ' +  RTRIM(pnme_last_name) as FullName,
		NULL AS Category,
		NULL AS Rank,
		SUBSTRING(refx_sexc_name,1 ,1) AS Gender, 
		ISNULL(pnat_f_cnty_id_code, prsn_f_cnty_birth_id_code) AS Nationality,
		prsn_birth_date AS BirthDate,
		RTRIM(prsn_birth_place_city) AS BirthCity,
		prsn_f_cnty_birth_id_code AS BirthNationality,
		NULL AS Bloodtype,
		RTRIM(SUBSTRING(refx_marg_name,1,10)) AS MaritalStatus,
		NULL AS OrganizationCategory,
		NULL AS OrganizationStart,
		NULL AS OrganizationEnd,
		NULL AS PersonStatus,
		NULL AS ParentOffice,
		NULL AS ParentOfficeLocation,
		'IMIS' AS Source,
		NULL AS Remarks,
		NULL AS EmailAddress,
		NULL AS ServiceJoinDate,
		'nova' AS OfficerUserId,
		'Data' AS OfficerLastName,
		'IMIS' AS OfficerFirstName,
		getDate() AS Created,
		NULL AS rowguid,
		'undefined' AS Grade,
		'0' AS OnPayroll,
		prsn_index_num,
		NULL
	FROM 
		#DBDW#.#SCHdw#.DW_sum_person_curr
	WHERE
		db_mdst_source = '#mission#'
		AND prsn_index_num IS NOT NULL
	ORDER BY 1
</cfquery>	

<cfquery name="StaffMember" 
	datasource="#DSNDW#">
	
	SELECT DISTINCT
		stfm_f_prsn_index_num,
		'IND' + REPLICATE ('0', 6-LEN(stfm_f_prsn_index_num)) + stfm_f_prsn_index_num as PersonNo,
		REPLICATE ('0', 6-LEN(stfm_f_prsn_index_num)) + stfm_f_prsn_index_num as IndexNo,
		smgr_catg_grde_id_code,
		stfm_un_eod_date,
		stfm_offce_code,
		CONVERT(VARCHAR(4), NULL) AS post_f_orgu_id_code
	INTO     
		IMP_StaffMember
	FROM     
		#DBDW#.#SCHdw#.DW_sum_stfm_curr	
	WHERE 
		db_mdst_source = '#mission#' 
	ORDER BY 1	
	
</cfquery>	

<cfquery name="stPersonGenerate" 
datasource="#DSNDW#">
	UPDATE IMP_StaffMember
	SET    post_f_orgu_id_code = POST.post_f_orgu_id_code
	FROM   IMP_StaffMember STFM,	#DBDW#.#SCHdw#.DW_sum_post_curr POST
	WHERE  STFM.stfm_f_prsn_index_num = POST.PASN_f_prsn_index_num
		AND POST.db_mdst_source = '#mission#' 
</cfquery>


<cfquery name="EmailAddress" 
	datasource="#DSNDW#">

	SELECT DISTINCT
		f_prsn_index_num,
		'IND' + REPLICATE ('0', 6-LEN(f_prsn_index_num)) + f_prsn_index_num as PersonNo,
		REPLICATE ('0', 6-LEN(f_prsn_index_num)) + f_prsn_index_num as IndexNo,
		email_addr
	INTO     
		IMP_email_address
	FROM     
		#DBDW#.#SCHdw#.DW_sum_address_curr	
	WHERE 
		db_mdst_source = '#mission#' 
		AND email_addr IS NOT NULL
	ORDER BY 1
	
</cfquery>	

<cfquery name="ClaimApprovalDate" 
	datasource="#DSNDW#">
	
	SELECT 
		TRXA.f_adlh_tran_ser_num,
		TRXA.proc_date AS IMIS_AP_Date,
		TRXA.f_dorf_id_code,
		TRXA.part1_doc_id,
		TRXA.f_user_id_code		
	INTO
		dbo.IMP_CLAIMAPPROVAL
	FROM
		#DBDW#.#SCHdw#.DW_Ref_trans_approval TRXA,
		IMP_CLAIM CLAM
	WHERE
		TRXA.f_dorf_id_code = 'TVCV'
		AND TRXA.f_adme_id_code = 'TVCA'
		AND TRXA.doc_stat_code IN ('ap','db')
		AND TRXA.db_mdst_source = CLAM.db_mdst_source 
		AND TRXA.f_dorf_id_code = CLAM.f_dorf_id_code
		AND TRXA.part1_doc_id = CLAM.doc_id

</cfquery>							  

<cfquery name="ClaimCreationDate" 
	datasource="#DSNDW#">

SELECT 
	TRXA.f_adlh_tran_ser_num,
	TRXA.proc_date AS IMIS_AP_Date,
	TRXA.f_dorf_id_code,
	TRXA.part1_doc_id,
	TRXA.f_user_id_code,
	TRXA.f_adme_id_code	
INTO
	dbo.IMP_CLAIMCREATION
FROM
	#DBDW#.#SCHdw#.DW_Ref_trans_approval TRXA,
	IMP_CLAIM CLAM
WHERE
	TRXA.f_adme_id_code IN ('TVCC', 'MCPI')
	AND TRXA.db_mdst_source = CLAM.db_mdst_source 
	AND TRXA.f_dorf_id_code = CLAM.f_dorf_id_code	
	AND TRXA.part1_doc_id = CLAM.doc_id
	
</cfquery>							  


<cfquery name="ClaimRecoverySchedule" 
	datasource="#DSNDW#">

SELECT 
	RCSH.*,
	RCSL.seq_num,
	RCSL.f_payp_yr,
	RCSL.f_payp_num,
	RCSL.f_refx_pyfr_seq_num,
	RCSL.pay_prd_recvy_amt,
	RCSL.pay_prd_recvy_pct,
	RCSL.actual_recvy_amt,
	PAYP.beg_date,
	PAYP.end_date
INTO
	dbo.IMP_CLAIMRECOVERYSCHED	
FROM
	dbo.DW_fin_recovery_sched RCSH,
	dbo.DW_fin_recovery_sched_line RCSL,
	dbo.DW_Ref_pay_period PAYP
WHERE
	RCSH.db_mdst_source = RCSL.db_mdst_source
	AND RCSH.f_dorf_adre_id_code = RCSL.f_dorf_id_code_adre
	AND RCSH.f_adre_doc_id = RCSL.doc_id_adre
	AND RCSH.db_mdst_source = 'UNHQ'
	AND RCSH.f_dorf_adre_id_code = 'RCTA'
	AND RCSL.db_mdst_source = PAYP.db_mdst_source
	AND RCSL.f_payp_yr = PAYP.yr 
	AND RCSL.f_payp_num = PAYP.num 
	AND RCSL.f_refx_pyfr_seq_num = PAYP.f_refx_pyfr_seq_num 

</cfquery>
<!---- HS 08 Dec 2009: Added three tables i.e. IMP_DSARate_h,IMP_DSARateUpload and IMP_IOAU required for reporting purpose ---->
<cfquery name="IMPDSARate" 
	datasource="#DSNDW#">

SELECT 
	DSAR.*	
INTO
	IMP_DSARate_h 
FROM
	dbo.DW_Rfg_subsistence_rate_h DSAR
</cfquery>				

<cfquery name="IMPDSARateUpload" 
	datasource="#DSNDW#">

SELECT 
	DSAU.*	
INTO
	IMP_DSARateUpload 
FROM
	dbo.DW_Rfg_audit_log_header_DSAL DSAU
</cfquery>							  
<cfquery name="IMPIOAU" 
	datasource="#DSNDW#">

SELECT 
	IOAU.*	
INTO
	IMP_InterOfficeAgencyAuth 
FROM
	dbo.DW_fin_inter_off_agency_auth_payee IOAU
	
</cfquery>	