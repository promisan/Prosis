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
<cfif mode eq "personal">
  <cfset lk = "Staffing/Application/Employee/Entitlement/EntitlementEdit.cfm?id=#form.personno#&id1=">
<cfelse>
  <cfset lk = "Staffing/Application/Employee/Entitlement/EntitlementEditTrigger.cfm?id=#form.personno#&id1="> 
</cfif>

<cfparam name="ripple1" default="">
<cfparam name="ripple9" default="">

<cfif action eq "3062">	
				  
	 <!--- amendment --->
				   												
	 <cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
	   Datasource         = "AppsPayroll" 
	   method             = "ActionDocument" 
	   PersonNo           = "#Form.PersonNo#"	   
	   ActionCode         = "#action#"
	   ActionDate         = "#Form.DateEffective#"
	   ActionSourceId     = "#entid#"	
	   ActionLink   	  = "#lk#"
	   ripple9            = "#Form.EntitlementId#"						 			 
	   ActionStatus       = "1">	
				 
<cfelseif action eq "3061">
				   				   													
  <cfinvoke component   = "Service.Process.Employee.PersonnelAction" 
       Datasource         = "AppsPayroll" 
	   method             = "ActionDocument" 
	   PersonNo           = "#Form.PersonNo#"	   
	   ActionDate         = "#Form.DateEffective#"
	   ActionCode         = "#action#"
	   ActionSourceId     = "#entid#"	
	   ActionLink   	  = "#lk#"
	   ripple9            = "#ripple9#"	
	   ripple1            = "#ripple1#"	
	   ActionStatus       = "1">						 
				 
</cfif>  

