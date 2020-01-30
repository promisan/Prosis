<cfset Period = #Replace(Form.Period,"'","","ALL")#>
<cfset Month = #Replace(Form.Month,"'","","ALL")#>
<cfset Type = #Replace(Form.Type,"'","","ALL")#>


<cfquery name="Result1" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

select   esp.OrgUnit,o.hierarchycode,o.OrgUnitName,pitem.PrintDescription,sum(esp.PaymentAmount) cantidad
into userquery.dbo.#Answer1#
from EmployeeSettlementLine esp,organization.dbo.Organization o,
     Payroll.dbo.ref_PayrollItem pitem
where esp.OrgUnit = o.OrgUnit
  and o.Mission = 'SAT'
  and esp.PayrollItem = pitem.PayrollItem
  and esp.PaymentMonth = '#Month#'
  and esp.PaymentYear = '#Period#'
  and esp.SalarySchedule = '#Type#'
  and pitem.PrintGroup<>'Contributions'
group by esp.OrgUnit,o.hierarchycode,o.OrgUnitName,pitem.PrintDescription

</cfquery>

 
<cfquery name="Result2" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
select   *
into userquery.dbo.#table1# 
from userquery.dbo.#Answer1# A1
order by hierarchyCode,orgunitname,printDescription
</cfquery>



