<!--- JG Added this since we are creating a One to Many relationship between Auditing and Claims adding some more comments--->

<!--- Will be  interested in inserting the latest records only upon once the claim is settled  --->
<!--- JG3 Query that will be used intially and made changes further

--->
<CF_DropTable dbName="AppsQuery"  tblName="temp_claimAudit"> 
<cfquery name="InsertAudit"
   datasource="appsTravelClaim"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
  select distinct 
  Claim.Claimid,Claim.ClaimRequestid,Claim.documentNo as Tcp_documentno ,
  CR.documentno as f_tvrq_doc_id ,CR.Personno as PersonNo,
  stPerson.Grade as Grade_IMIS,     
     G.PostOrder, 
		  Claim.ClaimAsis,
		  Ref_Status.Status as  Status_dim, 
          Ref_Status.Description AS Status_IMIS,
		  CR.OrgUnit AS EO_Orgunit, 
           O.OrgUnitName AS EO_name

	into userQuery.dbo.temp_ClaimAudit   

 FROM        Claim INNER JOIN
             stPerson ON Claim.PersonNo = stPerson.PersonNo INNER JOIN
            Ref_Status ON Claim.ActionStatus = Ref_Status.Status INNER JOIN
             ClaimRequest CR ON Claim.ClaimRequestId = CR.ClaimRequestId INNER JOIN
            Organization.dbo.Organization O ON CR.OrgUnit = O.OrgUnit INNER JOIN
                                Employee.dbo.Ref_PostGrade G ON stPerson.Grade = G.PostGrade 
 WHERE     (Ref_Status.StatusClass = 'TravelClaim') 
 AND        (Ref_Status.Status > '3') AND (Ref_Status.Status < '6')    
 AND CLAIM.Reference is NOT NULL 
 AND CLAIM.ReferenceNO is NOT NULL 
 AND CLAIM.ReferenceStatus is NOT NULL 
 --AND CR.Operational =0
 

  
</cfquery>  
<cfquery name="InsClaimAudit"
   datasource="appsTravelClaim"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   insert into ClaimAudit (claimid, ClaimRequestId, TCP_DocumentNo, f_tvrq_doc_id, 
			PersonNO, Operational,Descr, 
			Audit_status, Userid, Created, updated, ClaimidAuditid,
			Grade_IMIS,ClaimAsis,Status_IMIS,EO_OrgUnit,EO_Name)
Select 			Claimid,ClaimRequestid,Tcp_documentno ,f_tvrq_doc_id ,
                        PersonNo, 1,NULL,
                         0,'IMIS_batch',getdate(),NULL,newid(),
  			Grade_IMIS,ClaimASis,Status_IMIS, EO_Orgunit, EO_name 
from 
			userQuery.dbo.temp_ClaimAudit   where 
claimid not in (select claimid from claimaudit)



   </cfquery>
 <CF_DropTable dbName="AppsQuery"  tblName="temp_claimAudit"> 
