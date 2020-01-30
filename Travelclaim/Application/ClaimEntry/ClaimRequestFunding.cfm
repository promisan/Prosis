<cfoutput>
		
	<cfquery name="Funding" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   stClaimFunding
		WHERE  ClaimRequestId     = '#URL.ClaimRequestId#'
		AND    PersonNo = '#PersonNo#'
		AND    ClaimCategory = '#Code#'				
	</cfquery>
	
	<cfquery name="Sum" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT sum(Amount) as Amount
		FROM   stClaimFunding
		WHERE  ClaimRequestId     = '#URL.ClaimRequestId#'
		AND    PersonNo = '#PersonNo#'
		AND    ClaimCategory = '#Code#'					
	</cfquery>		
	
	<cfif funding.recordcount gte "1">
	
		<table cellspacing="0" cellpadding="1">
		<tr><td colspan="10" bgcolor="silver"></td></tr>
			
		<cfloop query="Funding">
			<tr bgcolor="f4f4f4">
			    <td height="17" width="37"><b>#ClaimRequestLineNo#:</td>
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
		<tr><td colspan="10" bgcolor="silver"></td></tr>
				
		</table>
			
	</cfif>
		
</cfoutput>