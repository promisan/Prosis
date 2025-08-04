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

<cfparam name="url.scope" 			default="Backoffice">
<cfparam name="url.viewMode" 		default="view">
<cfparam name="url.DateEffective" 	default="">

<cfif url.scope neq "Backoffice">
	 <cfset url.id = CLIENT.personno>
</cfif>

<cfset vViewMode = url.viewMode>

<cf_screentop height="100%" scroll="Yes" html="No" jQuery="Yes" menuaccess="context" actionobject="Person"
		actionobjectkeyvalue1="#url.id#">

<cf_calendarScript>
<cfajaximport tags="cfdiv,cfform">
<cf_dialogPosition>

<cfquery name="ValidAccounts" 
     datasource="AppsPayroll" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT   PA.*
		FROM     PersonAccount PA INNER JOIN Ref_Bank B ON PA.BankCode = B.Code
		WHERE    PersonNo = '#url.id#'
		AND 	 PA.DateEffective <= GETDATE() + 30
		AND 	 (PA.DateExpiration > GETDATE() - 30 OR PA.DateExpiration IS NULL)
</cfquery>

<cfquery name="ValidContracts" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT   PC.*
		FROM     PersonContract PC
		WHERE    PersonNo = '#url.id#'
		AND 	 PC.DateEffective   <= (GETDATE() + 960)
		AND 	 (PC.DateExpiration >= (GETDATE() - 960) OR PC.DateExpiration IS NULL)
		AND 	 PC.ActionStatus IN ('0','1')		
</cfquery>

<cfquery name="validCurrencies" 
     datasource="AppsPayroll" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT 	   S.*
		FROM 	   SalaryScheduleMission SM INNER JOIN SalarySchedule S ON SM.SalarySchedule = S.SalarySchedule
		WHERE 	   SM.Mission = '#ValidContracts.Mission#'
		AND 	   S.Operational = '1'
		ORDER BY   S.PaymentCurrency ASC
</cfquery>

<cfset vBigAmount = 999999999999>
<cfset vLines = 3>
<cfif validAccounts.recordCount lt 3>
	<cfset vLines = validAccounts.recordCount>
</cfif>

<cf_tl id="Remove all distributions for this effective date ?" var="lblRemoveDist">

<cfoutput>
	<script>
		
		function _doFilter(reset, date) {
			    var vMethod = $('##distributionMethod').val();
			    var vMode = $('##paymentmode').val();
				_cf_loadingtexthtml='';	
			    ptoken.navigate('#session.root#/payroll/application/paymentDistribution/EmployeeDistributionDetail.cfm?id=#url.id#&lines=#vLines#&bigAmount=#vBigAmount#&method='+vMethod+'&mode='+vMode+'&reset='+reset+'&DateEffective='+date, 'divDetail');
		}

		function reloadDist(mode, date) {
			if (mode.toLowerCase() == 'view') {
			    _cf_loadingtexthtml='';	
				ptoken.navigate('#SESSION.root#/Payroll/Application/PaymentDistribution/EmployeeDistributionListing.cfm?ID=#URL.ID#&lines=#vLines#&bigAmount=#vBigAmount#&scope=#url.scope#&viewMode='+mode+'&DateEffective='+date, 'distributionDetail');
			}
			if (mode.toLowerCase() == 'edit') {
			    _cf_loadingtexthtml='';	
				ptoken.navigate('#SESSION.root#/Payroll/Application/PaymentDistribution/EmployeeDistributionEdit.cfm?ID=#URL.ID#&lines=#vLines#&bigAmount=#vBigAmount#&scope=#url.scope#&viewMode='+mode+'&DateEffective='+date, 'distributionDetail');
			}
		}

		function removeDist(date) {
			if (confirm('#lblRemoveDist#')) {
				_cf_loadingtexthtml='';	
				ptoken.navigate('#SESSION.root#/Payroll/Application/PaymentDistribution/EmployeeDistributionPurge.cfm?ID=#URL.ID#&DateEffective='+date, 'distprocess');
			}
		}

		function formatDistDate(dte) {
			var vReturn = '';
			if (dte) {
				if ('#client.dateFormatShow#' == 'dd/mm/yyyy') {
					vReturn = (dte.dd.toString().length == 2) ? dte.dd.toString() : '0' + dte.dd.toString();
					vReturn = vReturn + '/' + ((dte.mm.toString().length == 2) ? dte.mm.toString() : '0' + dte.mm.toString());
					vReturn = vReturn + '/' + dte.yyyy.toString();
				}
				if ('#client.dateFormatShow#' == 'mm/dd/yyyy') {
					vReturn = (dte.mm.toString().length == 2) ? dte.mm.toString() : '0' + dte.mm.toString();
					vReturn = vReturn + '/' + ((dte.dd.toString().length == 2) ? dte.dd.toString() : '0' + dte.dd.toString());
					vReturn = vReturn + '/' + dte.yyyy.toString();
				}
			}
			return vReturn;
		}

		function changeDistDate(dteObj) {
			var vDate = formatDistDate(dteObj);
			if (vDate != '') {
				reloadDist('edit', vDate);
			}
		}

	</script>
</cfoutput>

<table cellpadding="0" cellspacing="0" width="95%" align="center">
	<tr>
		<td height="10" style="padding-top:3px;">	
			<cfset ctr = "0">		
	    	<cfset openmode = "open"> 
			<cfinclude template="../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">		  
		</td>
	</tr>	
	<tr>
		<td id="distributionDetail">
			<cfif ValidAccounts.recordcount gt 0 AND ValidContracts.recordCount gt 0 AND validCurrencies.recordCount gt 0>
				<cf_securediv bind="url:#SESSION.root#/Payroll/Application/PaymentDistribution/EmployeeDistributionListing.cfm?ID=#URL.ID#&lines=#vLines#&bigAmount=#vBigAmount#&scope=#url.scope#&viewMode=view&DateEffective=">
			<cfelse>
				<table width="100%">
					<tr>
						<td class="labellarge" style="color:red; padding-top:25px; font-size:22px;" align="center">[ <cf_tl id="No valid contract, salary schedule or bank accounts recorded"> ]</td>
					</tr>
				</table>
			</cfif>
		</td>
	</tr>
	<tr><td id="distprocess"></td></tr>
</table>

