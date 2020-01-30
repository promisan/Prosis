<cfquery name="stepUnit" 
datasource="appsTravelClaim" >
UPDATE    ClaimRequest
SET       OrgUnit = Parent.OrgUnit
FROM      Organization.dbo.Organization Parent INNER JOIN
          Organization.dbo.Organization Mapping ON Parent.OrgUnitCode = Mapping.ParentOrgUnit AND Parent.Mission = Mapping.Mission INNER JOIN
          IMP_CLAIMREQEO EO ON Mapping.SourceCode = EO.f_orgu_id_code AND Mapping.SourceGroup = EO.f_ugrp_id_code INNER JOIN
          ClaimRequest REQ ON EO.db_mdst_source = REQ.Mission AND EO.part1_doc_id = REQ.DocumentNo
WHERE     (Mapping.Mission = '#Get.TreeUnit#')
AND       REQ.OrgUnit is NULL
</cfquery>

<cfquery name="stepGroup" 
datasource="appsTravelClaim">
UPDATE    ClaimRequest
SET       OrgUnit = Parent.OrgUnit
FROM      Organization.dbo.Organization Parent INNER JOIN
          Organization.dbo.Organization Mapping ON Parent.OrgUnitCode = Mapping.ParentOrgUnit AND Parent.Mission = Mapping.Mission INNER JOIN
          IMP_CLAIMREQEO EO ON Mapping.SourceGroup = EO.f_ugrp_id_code INNER JOIN
          ClaimRequest REQ ON EO.db_mdst_source = REQ.Mission AND EO.part1_doc_id = REQ.DocumentNo
WHERE     (Mapping.Mission = '#Get.TreeUnit#')
AND       (Mapping.SourceCode = '' or Mapping.SourceCode is NULL)
AND       REQ.OrgUnit is NULL
</cfquery>