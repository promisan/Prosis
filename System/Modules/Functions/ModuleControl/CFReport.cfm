
<!--- payroll claim --->

<cfset list = "Attendance,Accounting,Payroll,Procurement,Program,Roster,Staffing,TravelClaim,Vacancy,Warehouse,WorkOrder">

<cfloop index="itm" list="#list#" delimiters=",">

<cf_ModuleInsertSubmit
   SystemModule="Portal" 
   FunctionClass = "#itm#"
   FunctionName = "Reports" 
   MenuClass    = "Main"
   MenuOrder    = "3"
   MainMenuItem = "1"   
   FunctionDirectory = "CFReports"
   FunctionPath = "Menu.cfm"
   FunctionCondition = "id=#itm#"> 
   
</cfloop>    
