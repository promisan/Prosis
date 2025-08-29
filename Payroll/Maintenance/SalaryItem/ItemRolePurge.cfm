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