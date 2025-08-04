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
<cf_screenTop height="100%" html="No" jQuery="Yes">

<script>

	function saveStatement(mission,glaccount,orgunit,statemetcode) {
		ptoken.navigate('PresentationSave.cfm?mission='+mission+'&GlAccount='+glaccount+'&orgunit='+orgunit+'&statementcode='+statemetcode,'Process__'+mission+'_'+glaccount+'_'+orgunit);
	}

</script>

<cfquery name="cleanPresentation" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE  S
		FROM 	Ref_StatementAccountUnit S
		WHERE   S.Mission = '#URL.Mission#'
		AND 	NOT EXISTS
			   (
				  SELECT	'X'
				  FROM	TransactionLine
				  WHERE	Mission = S.Mission
				  AND	GLAccount = S.GlAccount
				  AND	OrgUnit = S.OrgUnit
			   )		
</cfquery>

<cfquery name="getAccounts" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT
		       H.Mission,
		       P.AccountParent,
		       P.Description as AccountParentDescription,
		       G.AccountGroup,
		       G.Description as AccountGroupDescription,
		       L.GLAccount,
		       A.Description as GLAccountDescription,
		       L.OrgUnit,
		       (SELECT OrgUnitName FROM Organization.dbo.Organization WHERE OrgUnit = L.OrgUnit) as OrgUnitName,
		       (SELECT HierarchyCode FROM Organization.dbo.Organization WHERE OrgUnit = L.OrgUnit) as OrgUnitHierarchyCode,
		       (SELECT StatementCode FROM Ref_StatementAccountUnit WHERE Mission = H.Mission AND GLAccount = L.GLAccount AND OrgUnit = L.OrgUnit) StatementCode
		FROM TransactionLine L
		     INNER JOIN TransactionHeader H
		          ON L.Journal = H.Journal
		             AND L.JournalSerialNo = H.JournalSerialNo
		     INNER JOIN Ref_Account A
		     	ON L.GLAccount = A.GLAccount
		     INNER JOIN Ref_AccountGroup G
		     	ON A.AccountGroup = G.AccountGroup
		     INNER JOIN Ref_AccountParent P
		     	ON G.AccountParent = P.AccountParent
		WHERE 	Mission = '#URL.MISSION#'
		ORDER BY P.AccountParent, G.AccountGroup, L.GLAccount, 11
</cfquery>

<cfquery name="getStatements" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_StatementPresentation
		WHERE	Mission = '#url.mission#'
		ORDER BY StatementOrder
</cfquery>

<cf_divScroll>

	<table width="98%" align="center" class="formpadding navigation_table">
		<tr><td colspan="5" height="30px"></td></tr>
		<cfoutput query="getAccounts" group="AccountParent">
			<tr>
				<td colspan="5" class="labellarge" style="font-weight:bold;">#ucase("#AccountParent# #AccountParentDescription#")#</td>
			</tr>
			<cfoutput group="AccountGroup">
				<tr>
					<td width="30px"></td>
					<td colspan="4" class="labelmedium">#ucase("#AccountGroup# #AccountGroupDescription#")#</td>
				</tr>
				<cfoutput group="GLAccount">
					<tr>
						<td width="30px"></td>
						<td width="30px"></td>
						<td colspan="3" class="labelit"><u>#GLAccount# #GLAccountDescription#</u></td>
					</tr>
					<cfoutput>
						<tr class="navigation_row">
							<td width="30px"></td>
							<td width="30px"></td>
							<td width="30px"></td>
							<td class="labelit" width="25%">#OrgUnitHierarchyCode# <cfif OrgUnitName eq "">[<cf_tl id="No Cost Center">]<cfelse>#OrgUnitName# [#OrgUnit#]</cfif></td>
							<td class="labelit">
								<cfset thisStatementCode = StatementCode>
								<select name="StatementCode_#Url.Mission#_#GLAccount#_#OrgUnit#" class="regularxl" style="width:250px;" onchange="saveStatement('#url.mission#','#glaccount#','#orgunit#',this.value);">
									<option value="" <cfif StatementCode eq "">selected</cfif>></option>
									<cfloop query="getStatements">
										<option value="#StatementCode#" <cfif StatementCode eq thisStatementCode>selected</cfif>>#StatementName#</option>
									</cfloop>
								</select>
							</td>
							<td width="50%" id="Process__#Url.Mission#_#GLAccount#_#OrgUnit#" class="labelit" style="padding-left:10px; color:4F92FF;"></td>
						</tr>
					</cfoutput>
				</cfoutput>
			</cfoutput>
		</cfoutput>
	</table>

</cf_divScroll>