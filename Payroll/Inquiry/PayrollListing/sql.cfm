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
<cfset Period = #Replace(Form.Period,"'","","ALL")#>
<cfset Month = #Replace(Form.Month,"'","","ALL")#>
<cfset Type = #Replace(Form.Type,"'","","ALL")#>


<cfquery name="Result1" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
select   esp.OrgUnit,o.OrgUnitName,p.IndexNo Nit,p.FullName,esp.PayrollItem,pitem.PrintDescription,esp.PaymentAmount,
				case pitem.Source
                     when 'Earning' then 'Ingresos'
					 when 'Deduction' then 'Descuentos'
					 when 'Miscellaneous' then 'Miscelaneos'
		         end Source
into userquery.dbo.#table1#
from EmployeeSettlementLine esp,employee.dbo.Person p,organization.dbo.Organization o,
     Payroll.dbo.ref_PayrollItem pitem
where esp.PersonNo = p.PersonNo
  and esp.OrgUnit = o.OrgUnit
  and o.Mission = 'S'
  and esp.PayrollItem = pitem.PayrollItem
  and esp.SalarySchedule = '#Type#'
  and esp.PaymentMonth = '#Month#'
  and esp.PaymentYear='#Period#'
  and esp.OrgUnit in (1980,2085,2086)
  and pitem.PrintGroup<>'Contributions'
  
Order by o.HierarchyCode,p.IndexNo,pitem.Source,esp.PayrollItem
</cfquery>

 




