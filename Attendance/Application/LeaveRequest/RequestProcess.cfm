
<cfquery name="check" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM PersonLeave
  WHERE LeaveId = '#URL.ID#'
</cfquery>

<cfquery name="delete" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  DELETE FROM PersonLeave
  WHERE LeaveId = '#URL.ID#'
</cfquery>

<cfquery name="leavetype" 
  datasource="AppsEmployee" 
  maxrows=1 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM Ref_LeaveType
  WHERE LeaveType = '#Check.leaveType#'
</cfquery>

<cfif LeaveType.LeaveAccrual neq "0">

	<cfinvoke component  = "Service.Process.Employee.Attendance"  
		   method        = "LeaveBalance" 
		   PersonNo      = "#check.PersonNo#" 			   
		   LeaveType     = "#check.LeaveType#"
		   BalanceStatus = "0"
		   StartDate     = "#Check.DateEffective#"
		   EndDate       = "#Check.DateExpiration#">		
      			 
</cfif>

<cfoutput>

<cfif URL.Source eq "Manual">

   <script language="JavaScript">
    window.location = "#SESSION.root#/Staffing/Application/Employee/Leave/EmployeeLeave.cfm?ID=#check.PersonNo#"	
   </script>

<cfelse>

   <script language="JavaScript">
      window.location = "Request1.cfm?ID=#check.PersonNo#"	
   </script> 
   
</cfif>   

</cfoutput>
