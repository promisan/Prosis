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

<cfquery name="ClaimDetail"
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">


SELECT     C.DocumentNo,convert(varchar,C.DocumentDate,103) as ClaimDate,OO.OrgUnitName as Assured,ISNULL(sum(OAC.InvoiceAmount),0) as Amount
				
FROM         Organization.dbo.OrganizationObject R 
			 INNER JOIN Claim C 
			 ON R.ObjectKeyValue4 = C.ClaimId 
			 INNER JOIN Ref_Status S 
			 ON C.ActionStatus = S.Status 
			 INNER JOIN Ref_ClaimTypeClass D 
			 ON C.ClaimTypeClass = D.Code 
			 INNER JOIN Organization.dbo.Organization OO   
			 ON C.OrgUnitClaimant = OO.OrgUnit and OO.Mission = 'Assured'
		     LEFT OUTER JOIN Organization.dbo.OrganizationObjectActionCost OAC 
			 ON R.ObjectId = OAC.ObjectId  
			 INNER JOIN ClaimOrganization CO 
			 ON CO.ClaimId = C.ClaimId and CO.ClaimRole='LUnderwriter'
<!---
			 INNER JOIN Organization.dbo.Organization OO2 
			 ON CO.OrgUnit = OO2.orgUnit and OO2.Mission='Insight'
--->			 
			 LEFT JOIN Accounting.dbo.TransactionHeader H ON OAC.ActionID = H.ActionID
			        
WHERE   S.StatusClass = 'clm'
AND S.Description = '#URL.Status#'
group by C.DocumentNo,convert(varchar,C.DocumentDate,103),OO.OrgUnitName
order by convert(varchar,C.DocumentDate,103),C.DocumentNo

</cfquery>	

<table width="680" align="center" cellspacing="0" cellpadding="0" border="1" bordercolor="d3d3d3" class="formpadding"> 

<tr><td colspan="4"><cfoutput><b>#URL.Status# Cases </cfoutput></td></tr> 

<tr>
	<td width="70"><strong>Document No.</strong></td>
    <td width="80"><strong>Date of Loss</strong></td>
    <td width="200"><strong>Assured</strong></td>
	<td width="70" align="right"><strong>Costs</strong></td>
</tr>	
<cfoutput query="ClaimDetail">
	<tr>
	<td width="70">#DocumentNo#</td>
    <td width="80">#ClaimDate#</td>
	<td width="200">#Assured#</td>
	<td width="70" align="right">#LSNumberFormat(Amount, "_,________.__")#</td>
	</tr>	
</cfoutput>

</table>