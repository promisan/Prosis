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
<cfquery name="getCredit" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	Ref_LeaveTypeCredit
		WHERE  	1=1
		<cfif url.leaveType neq "">
		AND 	LeaveType = '#url.LeaveType#'    
		AND 	ContractType = '#url.ContractType#'
		AND 	DateEffective = '#url.DateEffective#'
		<cfelse>
		AND 	1=0
		</cfif>
</cfquery>

<cfquery name="getEntitlement" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	Ref_LeaveTypeCreditEntitlement
		WHERE  	1=1
		<cfif url.leaveType neq "">
		AND 	LeaveType = '#url.LeaveType#'    
		AND 	ContractType = '#url.ContractType#'
		AND 	DateEffective = '#url.DateEffective#'
		<cfelse>
		AND 	1=0
		</cfif>
		ORDER BY ContractDuration ASC
</cfquery>

<table width="240" class="navigation_table">
	<tr class="labelit">
		<td align="center" width="10%">
			<cf_img icon="add" onclick="addCreditLine();">
			<cfoutput>
				<input type="Hidden" name="CountCreditRows" id="CountCreditRows" value="#getEntitlement.recordCount#">
			</cfoutput>
		</td>
		<td width="45%"><cf_tl id="Contract"> (<cf_tl id="Month">)</td>
		<td width="45%"><cf_tl id="Entitlement"> <cfif getCredit.recordCount gt 0>(<cf_tl id="#getCredit.CreditUoM#">)</cfif></td>
	</tr>
	<tr>
		<td style="border-bottom:1px solid silver" colspan="3" class="clsCreditListing">
			<cfoutput query="getEntitlement">
				<cfset url.currentrow = currentrow>
				<cfset url.ContractDuration = ContractDuration>
				<cfset url.Credit = Credit>
				<cfinclude template="CreditLine.cfm">
			</cfoutput>
		</td>
	</tr>
</table>

<cfset AjaxOnLoad("doHighlight")>