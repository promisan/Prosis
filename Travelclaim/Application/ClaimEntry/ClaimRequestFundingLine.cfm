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
<cfoutput>
		
	<cfquery name="Funding" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   stClaimFunding
		WHERE  ClaimRequestId     = '#URL.ClaimRequestId#'
		AND    ClaimRequestLineNo = '#URL.ClaimRequestLineNo#'					
	</cfquery>	
		
	<cfif funding.recordcount gte "1">
	
		<table cellspacing="0" cellpadding="1">
		<cfloop query="Funding">
			
			<tr bgcolor="ECF5FF">
			    <td width="37"><b>BAC:</b></td>
				<td width="40">#f_fnlp_fscl_yr#</td>
				<td width="40">#f_fund_id_code#</td>
				<td width="40">#f_orgu_id_code#</td>
				<td width="40"><cfif f_proj_id_code eq "">----<cfelse>#f_proj_id_code#</cfif></td>
				<td width="40"><cfif f_pgmm_id_code eq "">----<cfelse>#f_pgmm_id_code#</cfif></td>
				<td width="40">#f_objc_id_code#</td>
				<td width="40">#f_objt_id_code#</td>
				<td width="40"><cfif iov_ind eq "1">IOV</cfif></td>
				<td align="right" width="100">#numberformat(amount,"__,__.__")#</td>
			</tr>	
					
		</cfloop>
				
		</table>
			
	</cfif>
		
</cfoutput>