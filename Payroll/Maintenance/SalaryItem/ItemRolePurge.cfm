
<cfquery name="Delete" 
	     datasource="AppsPayroll" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_PayrollItemRole 
		 WHERE PayrollItem = '#URL.ID#' and Role = '#URL.ID1#'
</cfquery>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>

<script>
	 <cfoutput>
	 try { opener.functionrefresh('#URL.ID#') } catch(e) {}
	 #ajaxLink('#SESSION.root#/Payroll/Maintenance/SalaryItem/ItemRole.cfm?ID=#URL.ID#&mid=#mid#')#
	 </cfoutput> 
</script>	