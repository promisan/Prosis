<!--
    Copyright © 2025 Promisan

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
		 <proDes>Template for validation Rule A13</proDes>
		 <proCom>New File For Validation A13 Validates whether an existing TVCV was already created manually or TVCV exists </proCom>
</cfsilent>
<!--- 
This is also another query which will work , but the other one is better query 
since it will display the docid and TVCV created too with the status ,even if there
are more than one.

SELECT     CL.ClaimId, CL.ClaimRequestId
		FROM         Claim AS CL INNER JOIN
              stPerson AS PRSN ON CL.PersonNo = PRSN.PersonNo INNER JOIN
              ClaimRequest AS TVRQ ON CL.ClaimRequestId = TVRQ.ClaimRequestId
		WHERE     (TVRQ.DocumentNo IN
                 	(SELECT     DocIdRequest
                       FROM          IMP_CLAIM AS IMP
                       WHERE      (db_mdst_source = 'UNHQ') AND (f_dorf_id_code = 'TVCV') AND (DocIdRequest = TVRQ.DocumentNo) AND 
                       (f_prsn_index_num = PRSN.IndexNo)
				 	)
				 ) AND (CL.ClaimId = '#URL.ClaimId#')
		
 --->
<!---
JG Joining against Claim , Claimrequest, TVCV documents and the person table to find out
whether there is TVCV that was created either earlier or outside of the portal
if so prevent it to go through the portal
--->

<cfquery name ="CheckA13" 
      datasource="appsTravelClaim" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		
		SELECT     CL.ClaimId, CL.ClaimRequestId, IMP_CLAIM.DocIdRequest, IMP_CLAIM.f_prsn_index_num, IMP_CLAIM.f_dorf_id_code, IMP_CLAIM.db_mdst_source, 
                      IMP_CLAIM.doc_id, IMP_CLAIM.doc_stat_code
		FROM         Claim AS CL INNER JOIN
                      stPerson AS PRSN ON CL.PersonNo = PRSN.PersonNo INNER JOIN
                      ClaimRequest AS TVRQ ON CL.ClaimRequestId = TVRQ.ClaimRequestId INNER JOIN
                      IMP_CLAIM ON TVRQ.DocumentNo = IMP_CLAIM.DocIdRequest AND PRSN.IndexNo = IMP_CLAIM.f_prsn_index_num AND 
                      CL.ClaimId = '#URL.ClaimId#'
		WHERE     (IMP_CLAIM.f_dorf_id_code = 'TVCV') AND (IMP_CLAIM.db_mdst_source = 'UNHQ')

		
		
</cfquery>
<!--- 
JG Just looping through the existing query earlier to build a dynamic Error message.
if the query has produced any results .
--->
<cfset spaces =" ">
<cfset msg="">
<cfloop query="CheckA13">
				<cfif msg eq "">
					<cfset msg = "#f_dorf_id_code#.#doc_id# with #spaces# #doc_stat_code# #spaces# status  ">
				<cfelse>
					<cfset msg = "#msg#, #f_dorf_id_code#.#doc_id# with #spaces# #doc_stat_code# #spaces#status ">
				</cfif>	
</cfloop>

<cfif CheckA13.recordcount gt 0> 

			
			
				<cf_ValidationInsert
					ClaimId        = "#URL.ClaimId#"
					ClaimLineNo    = ""
					CalculationId  = "#rowguid#"
					ValidationCode = "#code#"
					ValidationMemo = "#Description# #msg#"
					Mission        = "#ClaimRequest.Mission#">
			
			
</cfif>
			
		 