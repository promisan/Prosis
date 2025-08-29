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
<!---
<cftransaction>
--->
	
	<cfquery name="Reviewdata" 
	datasource="appsTravelClaim">
	SELECT  DISTINCT I.*, 
	        P.PersonNo AS PersonNo,
			R.ClaimRequestId AS ClaimRequestId
	INTO    tmp_Claim1
	FROM    IMP_CLAIMREQ I LEFT OUTER JOIN stPerson P ON I.f_prsn_index_num = P.IndexNo LEFT OUTER JOIN
	        ClaimRequest R ON I.db_mdst_source = R.Mission 
			AND I.doc_id = R.DocumentNo
	</cfquery>
	
	<cfquery name="Purpose" 
	datasource="appsTravelClaim">
	INSERT INTO Ref_ClaimPurpose
	(Code,Description,OfficerUserId)
	SELECT  f_refx_tvrq_seq_num, 'undefined', 'Merge'
	FROM    tmp_Claim1
	WHERE   f_refx_tvrq_seq_num NOT IN (SELECT Code FROM Ref_ClaimPurpose)
	</cfquery>
	
	<cfquery name="InsertNEW" 
	datasource="appsTravelClaim">
	INSERT INTO ClaimRequest
	            (Mission, 
				 DocumentNo, 
				 DocumentDate, 
				 DocumentModified, 
				 DocumentModifiedNo, 
				 Description, 
				 EffectivePeriod, 
				 AccountPeriod, 
				 ActionStatus, 
				 PersonNo, 
				 ClaimantType, 
				 ActionPurpose, 
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)
	SELECT       DISTINCT db_mdst_source, 
	             doc_id, 
				 Creat_date, 
				 mod_date, 
				 amend_seq_num, 
				 auth_remarks, 
				 eff_acct_prd, 
				 postd_acct_prd, 
				 doc_stat_code_trav, 
				 PersonNo, 
				 f_refx_trpn_seq_num, 
				 f_refx_tvrq_seq_num,
				 'Nova', 
				 'Van Pelt', 
				 'Hanno'
	FROM         tmp_Claim1
	WHERE        ClaimRequestid is NULL
	AND          PersonNo is not NULL
	AND          f_refx_tvrq_seq_num IN (SELECT Code FROM Ref_ClaimPurpose)
	AND          f_refx_trpn_seq_num IN (SELECT Code FROM Ref_Claimant)
	</cfquery>
	
	<cfquery name="UPDATEExisting" 
	datasource="appsTravelClaim" >
	UPDATE     ClaimRequest
	SET        DocumentDate       = T.creat_date,
	           DocumentModified   = T.mod_date,
	           DocumentModifiedNo = T.amend_seq_num,
	           Description        = T.auth_remarks,
	           PersonNo           = T.PersonNo,
	           EffectivePeriod    = T.eff_acct_prd,
	           AccountPeriod      = T.postd_acct_prd,
	           ActionStatus       = T.doc_stat_code_trav,
	           ActionPurpose      = T.f_refx_tvrq_seq_num,
	           ClaimantType       = T.f_refx_trpn_seq_num,
	           Updated            = getDate()
	FROM       ClaimRequest S, tmp_Claim1 T
	WHERE      S.ClaimRequestId = T.ClaimRequestId
	AND        T.PersonNo is not NULL
	</cfquery>
	
	<!--- reload lines --->
	
	<cfquery name="Clear" 
	datasource="appsTravelClaim" >
	      DELETE FROM  ClaimRequestLine
	</cfquery>
	
	<cfquery name="PrepareLines" 
	datasource="appsTravelClaim" >
	SELECT     P.PersonNo AS PersonNo, I.ClaimRequestId 
	           AS ClaimRequestId, R.*
	INTO       tmp_Claim2
	FROM       ClaimRequest I INNER JOIN IMP_CLAIMREQLINE R ON I.Mission 
	           = R.db_mdst_source AND I.DocumentNo = R.f_tvrq_doc_id INNER JOIN
	           stPerson P ON R.f_prsn_index_num = P.IndexNo
	</cfquery>
	
	<cfquery name="PrepareLines" 
	datasource="appsTravelClaim" >
	SELECT     T2.*, 
	           R.Code AS ClaimCategory, 
			   D.f_refx_tvlm_seq_num AS f_refx_tvlm_seq_num, 
			   D.offcl_vhcl_arriv_ind AS offcl_vhcl_arriv_ind, 
	           D.offcl_vhcl_deprt_ind AS offcl_vhcl_deprt_ind
	INTO       tmp_tvlm
	FROM       tmp_Claim2 T2 INNER JOIN
	                      IMP_CLAIMREQLINEDETAIL D ON T2.db_mdst_source = D.db_mdst_source AND T2.f_tvrq_doc_id = D.f_tvrq_doc_id AND 
	                      T2.seq_num = D.f_tvrl_seq_num INNER JOIN
	                      Ref_ClaimCategory R ON D.f_refx_tvlm_seq_num = R.ReferenceNo
	WHERE      R.ReferenceCode = 'tvlm'
	</cfquery>
	
	<cfquery name="Purpose" 
	datasource="appsTravelClaim">
	INSERT INTO Ref_ClaimPurpose
	(Code,Description,OfficerUserId)
	SELECT  f_refx_tvrq_seq_num, 'undefined', 'Merge'
	FROM    tmp_tvlm
	WHERE   f_refx_tvrq_seq_num NOT IN (SELECT Code FROM Ref_ClaimPurpose)
	</cfquery>
	
	<cfquery name="PrepareLines" 
	datasource="appsTravelClaim" >
	SELECT     DISTINCT T2.*, 
	           R.Code AS ClaimCategory, 
			   D.retrn_date AS retrn_date, 
			   D.itny_descr AS itny_descr, 
			   D.itny_remarks AS itny_remarks,
			   D.spec_instr AS spec_instr, 
			   D.deprt_date AS deprt_date, 
	           D.CityLineNo AS CityLineNo, 
			   D.CityId AS CityId
	INTO       tmp_tvli
	FROM       tmp_Claim2 T2 INNER JOIN IMP_CLAIMREQTICKET D 
	            ON T2.db_mdst_source = D.db_mdst_source 
			   AND T2.f_tvrq_doc_id = D.f_tvrq_doc_id 
			   AND T2.seq_num = D.f_tvrl_seq_num INNER JOIN
	                      Ref_ClaimCategory R ON D.f_refx_tvli_seq_num = R.ReferenceNo
	WHERE     (R.ReferenceCode = 'tvli')
	</cfquery>
	
	<cfquery name="InsertLines" 
		datasource="appsTravelClaim" >
		INSERT INTO ClaimRequestLine
		             (ClaimRequestId, 
		              ClaimRequestLineNo,
		              ClaimCategory,            
		              PersonNo, 
		              ClaimantType,
		              ActionPurpose,
		              Currency,
		              RequestAmount,
		              Remarks,
		              OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName)
		SELECT     DISTINCT ClaimRequestId, 
		             seq_num,
		             ClaimCategory,
		             PersonNo, 
		             f_refx_trpn_seq_num, 
		             f_refx_tvrq_seq_num,
		             f_curr_code,
		             oblg_curr_amt,
		             remrk,
		             'Nova', 'Van Pelt', 'Hanno'
		FROM         tmp_tvli
		WHERE   f_refx_tvrq_seq_num IN (SELECT Code FROM Ref_ClaimPurpose)
		AND     f_refx_trpn_seq_num IN (SELECT Code FROM Ref_Claimant)
	</cfquery>
	
	<cfquery name="InsertLinesItin" 
	datasource="appsTravelClaim" >
	INSERT INTO ClaimRequestItinerary
	           (ClaimRequestId, 
				ClaimRequestLineNo, 
				ItineraryLineNo, 
				DateDeparture, 
				DateReturn, 
				Itinerary, 
				Memo,
				CountryCityId, 
				OfficerUserId)
	SELECT     ClaimRequestId, 
	           seq_num, 
			   CityLineNo, 
			   deprt_date, 
			   retrn_date, 
			   itny_descr, 
			   itny_remarks,
			   CityId, 
			   'nova'
	FROM       tmp_tvli
	</cfquery>
	
	<!--- DSA lines --->
	
	<cfquery name="step" 
	datasource="appsTravelClaim" >
	INSERT INTO ClaimRequestLine
	             (ClaimRequestId, 
	              ClaimRequestLineNo,
	              ClaimCategory,            
	              PersonNo, 
	              ClaimantType,
	              ActionPurpose,
	              Currency,
	              RequestAmount,
	              Remarks,
	              OfficerUserId, OfficerLastName, OfficerFirstName)
	SELECT     ClaimRequestId, 
	              seq_num,
	              ClaimCategory,
	              PersonNo, 
	              f_refx_trpn_seq_num, 
	              f_refx_tvrq_seq_num,
	              f_curr_code,
	              oblg_curr_amt,
	              remrk,
	              'Nova', 'Van Pelt', 'Hanno'
	FROM         tmp_tvlm
	</cfquery>
	
	
	<cfquery name="ArrivalIndicator" 
	datasource="appsTravelClaim" >
		INSERT ClaimRequestLineIndicator
				(ClaimRequestId, ClaimRequestLineNo, IndicatorCode, IndicatorValue,OfficerUserId)
		SELECT  ClaimRequestId, seq_num, 'T01', offcl_vhcl_arriv_ind, 'nucleus'
		FROM    tmp_tvlm
		WHERE   offcl_vhcl_arriv_ind = 1
	</cfquery>
	
	<cfquery name="DepartIndicator" 
	datasource="appsTravelClaim" >
	 INSERT   ClaimRequestLineIndicator
				(ClaimRequestId, ClaimRequestLineNo, IndicatorCode, IndicatorValue,OfficerUserId)
	 SELECT   ClaimRequestId, seq_num, 'T02', offcl_vhcl_deprt_ind, 'nucleus'
	 FROM     tmp_tvlm
	 WHERE    offcl_vhcl_deprt_ind = 1
	</cfquery>
	
	<cfquery name="DSA" 
	datasource="appsTravelClaim">
	INSERT INTO  ClaimRequestDSA
	       (ClaimRequestId, 
			  ClaimRequestLineNo, 
			  DSALineNo, 
			  DateEffective, 
			  DateExpiration, 
			  RequestDays, 
			  RequestAmount,
			  ServiceLocation)
	SELECT  Line.ClaimRequestId, 
	        Line.seq_num, 
			LineDSA.seq_num AS Expr1, 
			LineDSA.subs_strt_date, 
			LineDSA.subs_end_date, 
			LineDSA.num_subsis_days, 
	        LineDSA.cnvrt_amt, 
			Ref_PayrollLocation.LocationCode
	FROM    tmp_tvlm Line INNER JOIN
	        IMP_CLAIMREQDSA LineDSA ON Line.db_mdst_source = LineDSA.db_mdst_source AND Line.f_tvrq_doc_id = LineDSA.f_tvrq_doc_id AND 
	        Line.seq_num = LineDSA.f_tvrl_seq_num INNER JOIN
	        Ref_PayrollLocation ON LineDSA.f_dsal_id_code = Ref_PayrollLocation.LocationCity AND 
	        LineDSA.f_cnty_id_code = Ref_PayrollLocation.LocationCountry
	</cfquery>
	
	<cfloop index="itm" list="food,accomm" delimiters=",">
		
		<cfif itm is "food">
			<cfset p = "T04">
		<cfelse>
		  	<cfset p = "T03">
		</cfif>
		
		<cfquery name="Pointer" 
		datasource="appsTravelClaim" >
		INSERT INTO ClaimRequestLineIndicator
		              (ClaimRequestId, 
						ClaimRequestLineNo, 
						DetailLineNo, 
						IndicatorCode, 
						IndicatorValue,
						DateEffective,
						DateExpiration,
						OfficerUserId)
		SELECT     DISTINCT T.ClaimRequestId, T.seq_num, 
					I.seq_num, 
					'#p#', 
					I.#itm#_provd_ind, 
					subs_strt_date, subs_end_date, 
					'nucleus' 
		FROM       tmp_tvlm T INNER JOIN
		           IMP_CLAIMREQDSA I ON T.db_mdst_source = I.db_mdst_source 
					AND T.f_tvrq_doc_id = I.f_tvrq_doc_id 
					AND T.seq_num = I.f_tvrl_seq_num
		WHERE      I.#itm#_provd_ind = 1
		</cfquery>
	
	</cfloop>

	<!---
</cftransaction>
--->

