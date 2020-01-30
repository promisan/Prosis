

<!--- employee action population --->

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

