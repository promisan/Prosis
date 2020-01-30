
<CF_DropTable dbName="AppsQuery"  tblName="tmpUploadLines"> 

<!--- 4. register IMIS claim lines in ClaimLineExternal --->

<cfquery name="InsertLines"
   datasource="appsTravelClaim">
	TRUNCATE Table ClaimLineExternal
</cfquery>	

<!--- 
select line information based on the linkage of the IMIS document No
      claims already in portal --->

<cfquery name="InsertLines"
   datasource="appsTravelClaim"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
    SELECT DISTINCT 
    	      Req.ClaimRequestId AS ClaimRequestId, 
			  C.ClaimId AS ClaimId, 
			  '01' AS PaymentMode, 
			  P.PersonNo AS PersonNo, 
			  I_ln.*, 
			  Cat.Code AS ClaimCategory, 
	          Loc.LocationCode AS LocationCode, 
			  ReqL.ClaimCategory AS ClaimCategoryRequest, 
			  I_cl.f_dorf_id_code AS Reference, 
			  I_cl.doc_id AS ReferenceNo, 
    	      I_cl.doc_stat_code AS ReferenceStatus, 
			  C.DocumentNo AS DocumentNo
	INTO      userQuery.dbo.tmpUploadLines
	FROM      ClaimRequest Req INNER JOIN
    	      IMP_CLAIMLINE I_ln ON Req.Mission = I_ln.db_mdst_source AND Req.DocumentNo = I_ln.f_tvrq_doc_id INNER JOIN
        	  stPerson P ON I_ln.f_prsn_index_num = P.IndexNo INNER JOIN
	          IMP_CLAIM I_cl ON I_ln.db_mdst_source = I_cl.db_mdst_source AND I_ln.f_tvch_doc_id = I_cl.doc_id AND 
    	      I_ln.f_dorf_tvch_id_code = I_cl.f_dorf_id_code INNER JOIN
        	  Claim C ON I_cl.f_dorf_id_code = C.Reference AND I_cl.doc_id = C.ReferenceNo AND Req.ClaimRequestId = C.ClaimRequestId LEFT OUTER JOIN
	          ClaimRequestLine ReqL ON I_ln.f_tvrl_seq_num = ReqL.ClaimRequestLineNo AND Req.ClaimRequestId = ReqL.ClaimRequestId LEFT OUTER JOIN
    	      Ref_ClaimCategory Cat ON I_ln.f_refx_tvlt_seq_num = Cat.ReferenceTVLT LEFT OUTER JOIN
	          Ref_PayrollLocation Loc ON I_ln.f_cnty_id_code = Loc.LocationCountry AND I_ln.f_dsal_id_code = Loc.LocationCity			 
</cfquery>

<cfquery name="InsertLines"
   datasource="appsTravelClaim"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	INSERT 
	INTO ClaimLineExternal
	          (ClaimId, 
			   Reference, 
			   ReferenceNo, 
			   ReferenceStatus, 
			   ClaimLineNo, 
			   ClaimRequestId, 
			   ExpenditureDate, 
			   ClaimCategory, 
			   Currency, 
			   AmountClaim,                     
	           PointerClaimFinal, 
			   PersonNo, 
			   ServiceLocation, 
			   OfficerUserId, 
	           OfficerLastName, 
			   OfficerFirstName)
	SELECT     ClaimId, 
	           Reference, 
	           ReferenceNo, 
			   ReferenceStatus, 
			   seq_num, 
			   ClaimRequestId, 
			   expend_date, 
	CASE WHEN ClaimCategory IS NOT NULL 
	THEN ClaimCategory ELSE ClaimCategoryRequest END AS Category, 
	           PaymentCurrency, 
			   PaymentAmount, 
			   final_liq_ind, 
			   PersonNo, 
			   LocationCode, 
	           'Nucleus' AS Expr1, 
			   'Van Pelt' AS Expr2, 
	           'Hanno' AS Expr3
	FROM       userquery.dbo.tmpUploadLines
	WHERE     PersonNo IS NOT NULL
	AND  (ClaimCategory is not NULL or claimCategoryRequest is not NULL)
</cfquery>	

<CF_DropTable dbName="AppsQuery"  tblName="tmpUploadLines"> 