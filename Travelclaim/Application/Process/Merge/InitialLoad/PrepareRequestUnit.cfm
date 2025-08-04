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