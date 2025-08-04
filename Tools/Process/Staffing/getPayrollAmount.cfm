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


<cfparam name="attributes.PersonNo"      default="">
<cfparam name="attributes.SelectionDate" default="#dateformat(Now(),client.dateformatshow)#">
<cfparam name="attributes.ComponentName" default="">
<cfparam name="attributes.Mission"       default="">

 <CF_DateConvert Value="#attributes.SelectionDate#">
 <cfset dte = dateValue>

<!--- get active contract --->

<cfquery name="contract" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   TOP (1) ContractId, Mission, DateEffective, DateExpiration, 
	                 ContractType, ContractTime, ContractFunctionNo, 
	                 ContractFunctionDescription, 
				     SalarySchedule, SalaryBasePeriod, ContractLevel, ContractStep, ServiceLocation 
	FROM     PersonContract
	WHERE    PersonNo = '#attributes.PersonNo#' 
	AND      Mission  = '#attributes.Mission#' 
	AND      (ISNULL(DateExpiration, '9999-12-31')) >= #dte# 
	AND      ActionStatus IN ('0','1')
	ORDER BY DateEffective
</cfquery>

<cfquery name="payrollscale" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT        S.ScaleNo, 
	              S.SalarySchedule, 
				  S.Mission, 
				  S.ServiceLocation, 
				  S.SalaryEffective, 
				  S.SalaryFirstApplied, 
				  SL.ServiceLevel, 
				  SL.ServiceStep, 
				  SL.ComponentName, 
	              SL.Currency, 
				  SL.Amount
	FROM          SalaryScale AS S INNER JOIN
	              SalaryScaleLine AS SL ON S.ScaleNo = SL.ScaleNo
	WHERE         S.Operational         = '1' 
	AND           S.SalarySchedule      = '#Contract.SalarySchedule#' 
	AND           S.Mission             = '#Contract.Mission#' 
	AND           S.ServiceLocation     = '#Contract.ServiceLocation#' 
	AND           SL.ServiceLevel       = '#contract.ContractLevel#' 
	AND           SL.ServiceStep        = '#contract.ContractStep#' 	
	AND           SL.Operational        = 1 
	<cfif attributes.componentName neq "">
	AND           SL.ComponentName      = '#attributes.ComponentName#' 
	</cfif>
	AND           S.SalaryEffective    <= #dte#
	AND           S.SalaryFirstApplied <= #dte# 
	ORDER BY      S.SalaryFirstApplied DESC	
	
</cfquery>

<cfset caller.payroll = payrollscale>

