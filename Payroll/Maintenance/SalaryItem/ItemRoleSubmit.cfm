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
<cfsilent>
 <proUsr>administrator</proUsr>
 <proOwn>Dev van Pelt</proOwn>
 <proDes>Function Menu Role Access</proDes>
 <!--- specific comments for the current change, may be overwritten --->
  <proCom>Added provision for role level verification</proCom>
</cfsilent>
<!--- End Prosis template framework --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="Form.Operational"     default="0">
<cfparam name="Form.AccessLevelList" default="">

<cftransaction action="BEGIN">

	<cfif Form.Role neq "">
	
		<cfif URL.ID1 eq "">
		
			<cfquery name="Insert" 
			     datasource="AppsPayroll" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_PayrollItemRole 
			         (PayrollItem,
					 Role,
					 Operational,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			      VALUES ('#URL.ID#',
			      	  '#Form.Role#',
					  '#Form.Operational#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
			</cfquery>
			
			<cfloop index="lvl" list="#form.accessLevelList#" delimiters=",">
			
				<cfquery name="Insert" 
			     datasource="AppsPayroll" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			   	 INSERT INTO Ref_PayrollItemRoleLevel
		               (PayrollItem, Role, AccessLevel)  
				 VALUES ('#URL.ID#',
			      	  '#Form.Role#','#lvl#') 				
		       </cfquery> 
			
			</cfloop>
			
		<cfelse>
			
			   <cfquery name="Update" 
			     datasource="AppsPayroll" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     UPDATE Ref_PayrollItemRole
				  SET Operational = '#Form.Operational#' 
				 WHERE SystemFunctionId = '#URL.ID#'
				 AND Role = '#URL.ID1#'
		    	</cfquery>
				
				<!--- level access --->
				
				<cfquery name="Clean" 
			     datasource="AppsPayroll" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			   	 DELETE FROM Ref_PayrollItemRoleLevel 
		         WHERE PayrollItem = '#URL.ID#'
				 AND Role = '#URL.ID1#'
		       </cfquery> 
					
				<cfloop index="lvl" list="#form.accessLevelList#" delimiters=",">
			
					<cfquery name="Insert" 
				     datasource="AppsPayroll" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				   	 INSERT INTO Ref_PayrollItemRole
			               (PayrollItem, Role, AccessLevel)
				     VALUES ('#URL.ID#','#URL.ID1#','#lvl#')
			       </cfquery> 
			
			    </cfloop>
			
		</cfif>
		
	</cfif>

</cftransaction>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/> 
  	
<script>
	 <cfoutput>
	 #ajaxLink('#SESSION.root#/Payroll/Maintenance/SalaryItem/ItemRole.cfm?ID=#URL.ID#&mid=#mid#')#
	 try { opener.functionrefresh('#URL.ID#') } catch(e) {}
	 </cfoutput> 
</script>	
   
