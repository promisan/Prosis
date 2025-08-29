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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.Operational"             default="1">
<cfparam name="Form.SalaryDays"              default="0">

<cfparam name="Form.EntitlementGradePointer" default="0">

<cfquery name="Trigger"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PayrollTrigger
	WHERE SalaryTrigger = '#Form.SalaryTrigger#'	
</cfquery>

<!---
<cfif trigger.EntitlementClass eq "Percentage" and form.period neq "Percent">

	<cfset form.period = "PERCENT">

</cfif>
--->

<!---

<cfif trigger.EntitlementClass neq "Percentage" and form.period eq "Percent">

	<cf_message message="Trigger has been defined as a percentage. Operational not allowed" return="back">
	<cfabort>

</cfif>

--->


<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT *
   FROM   Ref_PayrollComponent
   WHERE  Code  = '#Form.Code#' 
</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
   	<cfquery name="check" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM Ref_PayrollTriggerGroup
		WHERE SalaryTrigger     = '#Form.SalaryTrigger#'
		AND   EntitlementGroup  = '#Form.EntitlementGroup#'
	</cfquery>
	
	<cfif check.recordcount eq "0">
	
		<cfquery name="insert" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_PayrollTriggerGroup
			(SalaryTrigger,EntitlementGroup,OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES
			('#Form.SalaryTrigger#','#Form.EntitlementGroup#','#session.acc#','#session.last#','#Session.first#')
		</cfquery>
	
	</cfif>
	      	
		<cfquery name="Insert" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_PayrollComponent
		         (Code,
				  Description,
				  SalaryTrigger, 
				  PayrollItem,
				  EntitlementClass,
				  ParentComponent,
				  SalaryMultiplier, 
				  EntitlementGrade,
				  EntitlementGradePointer,
				  EntitlementPointer,
				  EntitlementGroup,
				  Period,
				  SalaryDays, 				 
				  RateStep,
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)
		  VALUES ('#Form.Code#',
        		  '#Form.Description#', 
				  '#Form.SalaryTrigger#',
				  '#Form.PayrollItem#',
				  '#Form.EntitlementClass#',
				  <cfif form.parentComponent neq "">
				  '#Form.ParentComponent#',
				  <cfelse>
				   NULL,
				  </cfif>
				  '#Form.SalaryMultiplier#',
				  '#Form.EntitlementGrade#',
				  '#Form.EntitlementGradePointer#',
				  '#Form.EntitlementPointer#',
				  '#Form.EntitlementGroup#',
				  <cfif form.entitlementClass eq "percentage">
				  'PERCENT',
				  <cfelse>
				  '#Form.Period#',
				  </cfif>				 				  
				  '#Form.SalaryDays#',				  
				  '#Form.RateStep#',
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#')
		  </cfquery>
		     		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="check" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_PayrollTriggerGroup
		WHERE  SalaryTrigger     = '#Form.SalaryTrigger#'
		AND    EntitlementGroup  = '#Form.EntitlementGroup#'
	</cfquery>
	
	<cfif check.recordcount eq "0">
	
		<cfquery name="insert" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_PayrollTriggerGroup
			(SalaryTrigger,EntitlementGroup,OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES
			('#Form.SalaryTrigger#','#Form.EntitlementGroup#','#session.acc#','#session.last#','#Session.first#')
		</cfquery>
	
	</cfif>
	
	<cfquery name="Update" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_PayrollComponent
		SET   Description             = '#Form.Description#', 
			  SalaryTrigger           = '#Form.SalaryTrigger#', 
			  PayrollItem             = '#Form.PayrollItem#', 			  
			  EntitlementClass        = '#form.EntitlementClass#',
			  <cfif ParentComponent eq "">
			  ParentComponent         = NULL,
			  <cfelse>
			  ParentComponent         = '#Form.ParentComponent#',
			  </cfif>
			  SalaryMultiplier        = '#Form.SalaryMultiplier#',
			  EntitlementGrade        = '#Form.EntitlementGrade#',
			  EntitlementGradePointer = '#Form.EntitlementGradePointer#',
			  EntitlementPointer      = '#Form.EntitlementPointer#',
			  EntitlementGroup        = '#Form.EntitlementGroup#', 
			  <cfif form.entitlementClass eq "percentage">
			  Period                  = 'PERCENT',
			  <cfelse>
			  Period                  = '#Form.Period#', 
			  </cfif>
			  SalaryDays              = '#Form.SalaryDays#',			 
			  RateStep                = '#Form.RateStep#' 
		WHERE Code                    = '#Form.CodeOld#'
	</cfquery>
	
	<!--- added to sync the settings as already defined on the schedule level --->
	
	<cfquery name="Update" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  SalaryScheduleComponent
		SET     PayrollItem      = '#Form.PayrollItem#', 				
			    SalaryMultiplier = '#Form.SalaryMultiplier#', 
			    Period           = '#Form.Period#', 
			    SalaryDays       = '#Form.SalaryDays#',						
				EntitlementGroup = '#Form.EntitlementGroup#', 
			    RateStep         = '#Form.RateStep#' 
		WHERE   ComponentName    = '#Form.CodeOld#'
	</cfquery>
		
</cfif>	

<cfif ParameterExists(Form.Delete)> 
	
	<cfquery name="CountRec"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   SalaryScheduleComponent
		WHERE  ComponentName = '#Form.CodeOld#'
	</cfquery>
    
    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">    
	   alert("Code is in use. Operation aborted.")	        
     </script>  
	 
    <cfelse>
			
	<cfquery name="Delete" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_PayrollComponent
		WHERE Code = '#Form.CodeOld#'
    </cfquery>
			
	</cfif>
		
</cfif>	

<script language="JavaScript">   
     window.close()
	 opener.location.reload() 
	 
	
</script>  
