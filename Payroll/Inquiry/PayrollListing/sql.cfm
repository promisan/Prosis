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
  and o.Mission = 'SAT'
  and esp.PayrollItem = pitem.PayrollItem
  and esp.SalarySchedule = '#Type#'
  and esp.PaymentMonth = '#Month#'
  and esp.PaymentYear='#Period#'
  and esp.OrgUnit in (1980,2085,2086)
  and pitem.PrintGroup<>'Contributions'
  
Order by o.HierarchyCode,p.IndexNo,pitem.Source,esp.PayrollItem
</cfquery>

 




