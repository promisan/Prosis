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
<!--- section  3 other claims --->

<!--- Insert claims outside portal --->

<cfquery name="Other"
   datasource="appsTravelClaim"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT * FROM Claim
   WHERE ActionStatus = '6'
   AND ReferenceNo NOT IN (SELECT Doc_id FROM IMP_CLAIM)
</cfquery>  

<cfloop query="other">

	<cfquery name="clear"
	   datasource="appsTravelClaim"
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   DELETE Claim
	   WHERE ClaimId = '#claimId#'
	   AND ReferenceNo NOT IN (SELECT Doc_id FROM IMP_CLAIM)
	</cfquery>   

</cfloop> 

<!--- Prepare other claims directly recorded in IMIS --->

<CF_DropTable dbName="AppsQuery"  tblName="ClaimPortal"> 
<CF_DropTable dbName="AppsQuery"  tblName="ClaimOther">

<cfquery name="PortalClaim"
   datasource="appsTravelClaim"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT     ClaimRequest.Mission, 
	           Claim.Reference, 
			   Claim.ReferenceNo, 
	           Claim.ClaimId, 
			   ClaimRequest.ClaimRequestId
	INTO  userQuery.dbo.ClaimPortal
	FROM  ClaimRequest INNER 
	JOIN  Claim ON ClaimRequest.ClaimRequestId = Claim.ClaimRequestId 
</cfquery> 

<cfquery name="OtherClaim"
   datasource="appsTravelClaim"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT DISTINCT Portal.ClaimId, 
                   Req.ClaimRequestId, 
				   '01' AS PaymentMode, 
                   I.*, 
                   P.PersonNo
   INTO            userQuery.dbo.ClaimOther
   FROM            IMP_CLAIM I, 
                   stPerson P, 
				   ClaimRequest Req, 
				   userQuery.dbo.ClaimPortal Portal 
   WHERE I.f_prsn_index_num *= P.IndexNo
   AND I.db_mdst_source = Req.Mission
   AND I.DocIdRequest   = Req.DocumentNo
   AND I.db_mdst_source *= Portal.Mission 
   AND I.f_dorf_id_code *= Portal.Reference 
   AND I.doc_id         *= Portal.ReferenceNo
</cfquery>

<CF_DropTable dbName="AppsQuery"  tblName="ClaimPortal"> 

<cfquery name="Clean"
   datasource="appsTravelClaim"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   DELETE FROM userQuery.dbo.ClaimOther
   WHERE ClaimId is not NULL
</cfquery>

<cfquery name="PrepareOther"
   datasource="appsTravelClaim"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   UPDATE  userQuery.dbo.ClaimOther
   SET     PaymentMode = R.Code
   FROM    userQuery.dbo.ClaimOther T INNER JOIN 
           Ref_PaymentMode R ON T.f_refx_acpd_seq_num = R.ReferenceACPD
   WHERE   R.ReferenceCode = 'acpd'
</cfquery>   

<cfquery name="PrepareOther"
   datasource="appsTravelClaim"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   UPDATE    userQuery.dbo.ClaimOther
   SET       PaymentMode = R.Code
   FROM      userQuery.dbo.ClaimOther T INNER JOIN
             Ref_PaymentMode R ON T .f_refx_pymd_seq_num = R.ReferencePYMD
   WHERE     R.ReferenceCode = 'pymd'
</cfquery>   

<cfquery name="PrepareOther"
   datasource="appsTravelClaim"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   UPDATE    userQuery.dbo.ClaimOther
   SET       PersonNo = R.PersonNo
   FROM      userQuery.dbo.ClaimOther T INNER JOIN
             ClaimRequest R ON T.DocIdRequest = R.DocumentNo AND T.db_mdst_source = R.Mission
   WHERE     T.PersonNo is NULL
</cfquery>   

<cfquery name="InsertOther"
   datasource="appsTravelClaim"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   INSERT 
   INTO Claim  (PointerUpload, ClaimRequestId, 
		Reference, ReferenceNo, DocumentNo, PaymentMode, ClaimDate, 
		PersonNo, PaymentDueDate, ActionStatus, 
        ReferenceStatus, PaymentFund, PaymentCurrency, OfficerUserId, 
		OfficerLastName, OfficerFirstName)
   SELECT     '1', 
			   ClaimRequestId, 
			   f_dorf_id_code, 
			   doc_id, 
			   '0', 
			   PaymentMode, 
			   creat_date, 
			   PersonNo, 
			   pay_due_date, 
			   '6', 
			   doc_stat_code, 
               f_fund_disb_id_code, 
			   f_curr_disp_code, 
			   'Nova batch', 
			   '#SESSION.last#', 
			   '#SESSION.first#'
   FROM   userQuery.dbo.ClaimOther
   WHERE PersonNo is not NULL
</cfquery>   

<cfquery name="UpdateStatus"
   datasource="appsTravelClaim"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">   
   UPDATE Claim
   SET    ReferenceStatus = I.doc_stat_code
   FROM   Claim C INNER JOIN
          IMP_CLAIM I ON C.Reference = I.f_dorf_id_code AND C.ReferenceNo = I.doc_id
   WHERE  C.ActionStatus = '6'
   AND    C.ReferenceStatus <> I.doc_stat_code
  
</cfquery>   

<CF_DropTable dbName="AppsQuery"  tblName="ClaimPortal"> 
<CF_DropTable dbName="AppsQuery"  tblName="ClaimOther">