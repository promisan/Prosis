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
<cfinvoke component = "Service.Access"  
	method           = "RoleAccess" 
	role          	 = "'ContractManager'"
	returnvariable   = "ContractManagerAccess">

<cfquery name="getContract" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT TOP 1 PC.*
		FROM      PersonContract PC
		WHERE     PersonNo = '#url.id#'
		AND 	  PC.DateEffective <= (GETDATE() + 460)
		AND 	  (PC.DateExpiration >= (GETDATE() - 460) OR PC.DateExpiration IS NULL)
		AND 	  PC.ActionStatus != '9'
		ORDER BY PC.Created DESC
</cfquery>

<cfset vAllowEdit = "No">
<cfif (ContractManagerAccess eq "GRANTED" OR getAdministrator('*') eq "1")>
	<cfset vAllowEdit = "Yes">
</cfif>

<cfquery name="get" 
     datasource="AppsPayroll" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT 	PD.*,
				PA.BankCode,
				PA.AccountName,
				PA.AccountNo,
				PA.IBAN,
				PA.AccountType,
				PD.DistributionCurrency,
				PA.DateEffective,
				PA.DateExpiration,
				B.Description as BankDescription
		FROM 	PersonDistribution PD 
				LEFT OUTER JOIN PersonAccount PA
					ON PD.AccountId = PA.AccountId
				LEFT OUTER JOIN Ref_Bank B 
				 	ON PA.BankCode = B.Code
		WHERE 	PD.PersonNo = '#url.id#'	
		AND 	PD.Operational = 1     
		ORDER BY PD.DateEffective DESC, PD.DistributionOrder ASC
</cfquery>

<cfquery name="getGroups" dbtype="query">
	SELECT DISTINCT DateEffective
	FROM 	[get]
</cfquery>

<table width="98%" align="center" class="formpadding navigation_table">
   
		<cfoutput> 
		<img src="#SESSION.root#/Images/BankAccounts.png" height="64" alt=""  border="0" align="absmiddle" style="float: left; padding-right: 10px;">
            <h1 style="float:left;color:##333333;font-size:28px;font-weight:200;padding:0;position: relative;top: 18px;"><cf_tl id="Distribution of Payroll"></h1>
		</cfoutput>		
    
	
	<cfoutput>
		<cfif getContract.recordcount eq 0>
			<cf_tl id="No active contract" var="1">
			<tr>
				<td colspan="6" class="labellarge" style="color:red;">** #lt_text#</td>
			</tr>
		</cfif>
		<tr class="line" style="height:35px;">
			<td class="labellarge" style="padding-left:8px;">
				<cfif vAllowEdit eq "Yes">
					<cf_tl id="Add new" var="1">
					<img src="#session.root#/images/add_blueSquare.png" height="20px" onclick="reloadDist('edit', '');" style="cursor:pointer;" title="#lt_text#">
				</cfif>
			</td>			
			<td class="labellarge" colspan="2"><cf_tl id="Distribution"></td>
			<td class="labellarge" stylle="padding-left:4px"><cf_tl id="To Bank"></td>
			<td class="labellarge"><cf_tl id="Account No"></td>
			<td class="labellarge"><cf_tl id="Account Type"></td>
			<td class="labellarge"><cf_tl id="IBAN"></td>
		</tr>
		
	</cfoutput>
	<cfif get.recordCount eq 0>
		<tr>
			<td colspan="7" class="labellarge" style="padding:20px; color:#ED8282;" align="center">[<cf_tl id="No distribution defined.  Please contact your staff administrator.">]</td>
		</tr>
	</cfif>
	<cfoutput query="get" group="DateEffective">
		
		<tr class="line">
			<td colspan="7">
				<cfset vThisDate = dateFormat(DateEffective, client.dateFormatShow)>
				<table>
					<tr>
						<td class="labellarge">
							<cfif vAllowEdit eq "Yes" AND currentrow eq 1 AND getGroups.recordCount gt 1>
								<cf_tl id="Remove" var="1">
								<img src="#session.root#/images/delete_blueSquare.png" height="20px" onclick="removeDist('#vThisDate#');" style="cursor:pointer;" title="#lt_text#">
							</cfif>
						</td>
						<td class="labellarge" style="padding-left:6px;">
							<cfif vAllowEdit eq "Yes" AND currentrow eq 1>
								<cf_tl id="Edit" var="1">
								<img src="#session.root#/images/edit_blueSquare.png" height="20px" onclick="reloadDist('edit', '#vThisDate#');" style="cursor:pointer;" title="#lt_text#">
							</cfif>
						</td>
						<td class="labellarge" style="padding-left:10px;"><cf_tl id="Effective">:</td>
						<td style="padding-left:10px; font-weight:bold;" class="labellarge">#dateFormat(get.DateEffective, client.dateFormatShow)#</td>
						<!---
						<td class="labellarge" style="padding-left:10px;"><cf_tl id="Mode">:</td>
						<td style="padding-left:10px; font-weight:bold;" class="labellarge">#get.PaymentMode#</td>
						--->
						<td class="labellarge" style="padding-left:25px;"><cf_tl id="Method">:</td>
						<td style="padding-left:10px; font-weight:bold;" class="labellarge">#get.DistributionMethod#</td>
					</tr>
				</table>
			</td>
			
		</tr>
		
		<cfset cntGroup = 0>
		<cfoutput>
			<cfif PaymentMode neq "Cash">
			<cfset cntGroup = cntGroup + 1>
				<tr class="navigation_row line labelmedium">
					<td style="padding-left:30px;padding-right:4px">#cntGroup#.</td>
					<td style="padding-left:4px;background-color:f1f1f1;border-left:1px solid silver">#DistributionCurrency#</td>
					<td style="background-color:f1f1f1;font-weight:bold;border-right:1px solid silver;padding-left:3px">
						<cfif DistributionNumber eq url.BigAmount>
							<cf_tl id="The rest">
						<cfelse>
							#numberFormat(DistributionNumber, ",.__")#
							<cfif DistributionMethod eq "Percentage">%</cfif>
						</cfif>
					</td>
					<td style="padding-left:4px">
					<cfif AccountId eq "">
					   #get.PaymentMode#
					<cfelse>
					   #BankDescription#
					</cfif>
					</td>
					<td>#AccountNo# <cfif trim(AccountName) neq "">(#trim(AccountName)#)</cfif></td>
					<td>#AccountType#</td>
					<td>#IBAN#</td>
				</tr>
			</cfif>
		</cfoutput>
		<tr><td height="10"></td></tr>

	</cfoutput>
</table>

<cfset ajaxOnLoad("doHighlight")>