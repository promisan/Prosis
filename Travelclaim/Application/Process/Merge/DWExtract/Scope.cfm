<!--
    Copyright Â© 2025 Promisan

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
 <proDes>Template for The Scope of TCP   </proDes>
 <proCom>Added the scope SG Party since if it an Sg party we exclude them from the portal. This was done since 
          EO complained that SG Party people are totally entitled to different DSA 
 </proCom>
</cfsilent>


<cfquery name="step1" 
	datasource="#DSNDW#">

	SELECT DISTINCT *
	INTO            tmp_scope1
	FROM         	#DBDW#.#SCHdw#.DW_fin_travel_request
			
	WHERE   db_mdst_source = '#mission#' 
	
	<!--- have creation date >= Implementation Date of the Portal a site specific parameter --->
	AND     creat_date > '#dateformat(get.SourceDateCutOff,client.dateSQL)#'
	
	<!--- official business only '1' / Home = '9' --->
	AND     f_refx_tvrq_seq_num IN ('1') 
	
	<!--- Ø	have been approved The condition “travel request has been approved” implies that 
	i) the travel request current status is Approved, or 
	ii) the travel request current status is unapproved (not in Approved status, could be Unapproved, Certified, Certified Insufficient Funds, etc)
	but the travel request was approved earlier and subsequently amended (tvrq.apprv_trav_ind = 1 indicates that the travel portion of the travel request was approved at one point), or 
	iii) the travel requests current status is Closed and there is in IMIS a travel claim 
	associated to the travel request with the status Approved, Pending Disbursement or Disbursed., 
	--->
	
	AND (doc_stat_code_trav IN ('ap','vr') OR (apprv_trav_ind = 1))
	<!---Added on 04-12-2007 Based on Hanno Email after discussing with Flor 
	     To exclude everyone other than Staff Members
	--->
	AND (f_refx_trpn_seq_num IN ('1'))
	<!--- Added on 11-Jul-2008 by JG to avoid SG party TVRQ to get picked up since 
	this SG party are entitled to different DSA rates 
	--->
	
	AND (isnull(upper(sg_auth_code),'') not like('%SG PARTY%'))
		 
	UNION
	
	SELECT DISTINCT R.*
	FROM   #DBDW#.#SCHdw#.DW_fin_travel_request R INNER 
	JOIN   #DBDW#.#SCHdw#.DW_fin_travel_claim_line C 
	        ON R.db_mdst_source = C.db_mdst_source AND R.doc_id = C.f_tvrq_doc_id
	WHERE  R.db_mdst_source = '#mission#' 
	AND    R.creat_date > '#dateformat(get.SourceDateCutOff,client.dateSQL)#' 
	AND    R.f_refx_tvrq_seq_num IN ('1') 
	AND    (R.doc_stat_code_trav IN ('cl') OR R.apprv_trav_ind = 1)
	<!---Added on 04-12-2007 Based on Hanno Email after discussing with Flor 
	     To exclude everyone other than Staff Members
	--->
	
	AND    (R.f_refx_trpn_seq_num IN ('1'))
	<!--- Added on 11-Jul-2008 by JG to avoid SG party TVRQ to get picked up since 
	this SG party are entitled to different DSA rates 
	AND (isnull(R.sg_auth_code,'') not in ('SG Party')) old code
	--->
	
	AND (isnull(upper(sg_auth_code),'') not like('%SG PARTY%'))
	
					  
</cfquery>		


<cfquery name="step2" 
	datasource="#DSNDW#">
	SELECT     *
	INTO dbo.IMP_CLAIMREQ
	FROM         tmp_scope1
	
	<!--- have at least one line of type Itinerary under NEW structure with cities  ---> 
	WHERE  doc_id IN
	            (SELECT  f_tvrq_doc_id
	             FROM    #DBDW#.#SCHdw#.DW_fin_authorized_itinerary
				 WHERE    db_mdst_source = '#mission#'
				) 			 
				
				
	AND	   doc_id NOT IN
	              (SELECT DISTINCT f_tvrq_doc_id                            
					FROM   #DBDW#.#SCHdw#.DW_fin_travel_request_misc_line                            
					WHERE  f_refx_tvlm_seq_num = '7' 
					AND    db_mdst_source = '#mission#'
				  ) 
					  
	AND    doc_id NOT IN (SELECT   DISTINCT f_tvrq_doc_id                            
	          			  FROM     #DBDW#.#SCHdw#.DW_fin_itinerary      
						  WHERE    db_mdst_source = '#mission#' 
	   					  AND      f_refx_tvli_seq_num = '3'  <!--- lumpsum exclusion --->
						 )	
							 
	AND   (	
				 doc_id IN (
				 		  SELECT   DISTINCT f_tvrq_doc_id                            
	          			  FROM     #DBDW#.#SCHdw#.DW_fin_itinerary      
						  WHERE    db_mdst_source = '#mission#' 
	   					  AND      f_refx_tvli_seq_num = '2'  <!--- SFT --->
						   )						 
				
				OR (
				
					doc_id IN (SELECT   DISTINCT f_tvrq_doc_id                            
	          			  FROM     #DBDW#.#SCHdw#.DW_fin_itinerary      
						  WHERE    db_mdst_source = '#mission#' 
	   					  AND      f_refx_tvli_seq_num IN ('1','4')  <!--- NOC/ITN --->						 						 
						       )						 	 
						 
					 AND 
					 
					 <!--- DSA/MSC lines --->
					 
					 doc_id IN
			              (SELECT DISTINCT f_tvrq_doc_id                            
							FROM   #DBDW#.#SCHdw#.DW_fin_travel_request_misc_line                            
							WHERE  f_refx_tvlm_seq_num != '7' 
							AND    db_mdst_source = '#mission#'
						  ) 
										  
					)	  
				 
		)		 		 
									 
						 
	<!--- have no lines of Shipping or Insurance type (f_refx_tvrl_seq_num = 3 or 4 in travel_request_line). --->					 	
	
	AND    doc_id NOT IN (SELECT   DISTINCT f_tvrq_doc_id                            
	          			  FROM     #DBDW#.#SCHdw#.DW_fin_travel_request_line      
						  WHERE    db_mdst_source = '#mission#' 
	   					  AND      f_refx_tvrl_seq_num IN ('3','4')
						 )		
	
	<!--- 1/11/07 remove if detailed line has home leave in it --->
						 
	AND    doc_id NOT IN (SELECT   DISTINCT f_tvrq_doc_id                            
	          			  FROM     #DBDW#.#SCHdw#.DW_fin_travel_request_line      
						  WHERE    db_mdst_source = '#mission#' 
	   					  AND      f_refx_tvrq_seq_num IN ('9')
						 )		
	
	<!--- 1/11/07 exclude travel request with > 1 multiple travellers --->
						 
	AND    doc_id NOT IN (SELECT     f_tvrq_doc_id 
						  FROM       #DBDW#.#SCHdw#.DW_fin_travel_request_line
						  WHERE    db_mdst_source = '#mission#'
						  GROUP BY   f_tvrq_doc_id
						  HAVING     COUNT(DISTINCT f_prsn_index_num) > 1
						 ) 	 							 					 
</cfquery>					 	  