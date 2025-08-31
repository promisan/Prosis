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
<cfparam name="Form.EnforceFinalPay" default="0">
<cfparam name="status" default="2">

<cf_verifyOperational 
         datasource= "appsEmployee"
         module    = "Payroll" 
		 Warning   = "No">		
		
<cfquery name="Param" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     Parameter	
</cfquery>		 
				 
<cfif Operational eq "1"  or Param.DependentEntitlement eq "1"> 

		<!--- diusable this field as it works based on separatioj now
	
		<cfif form.EnforceFinalPay eq "0">
		
			<cfquery name="Reset" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Payroll.dbo.EmployeeSalary
				SET    PaymentFinal = 0
				FROM   Payroll.dbo.EmployeeSalary E INNER JOIN
		               Payroll.dbo.SalarySchedulePeriod S ON E.Mission = S.Mission AND E.SalarySchedule = S.SalarySchedule AND E.PayrollStart = S.PayrollStart
				WHERE  E.PersonNo = '#Form.PersonNo#'	   
				AND    S.CalculationStatus != '2'
				AND    E.PayrollEnd <= #END#		
			</cfquery>
				
		</cfif>
		
		--->
	
		<cfquery name="Ent" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      Payroll.dbo.Ref_PayrollTrigger
			WHERE     EnableContract IN ('1','2')
		</cfquery>
	
	    <cfparam name="Form.SalarySchedule" default="">	
	
		<cfloop query="Ent">
		
			<cfparam name="Form.#SalaryTrigger#" default="0">
			<cfset val = evaluate("Form.#SalaryTrigger#")>
			
			<cfparam name="Form.#SalaryTrigger#_amount" default="">
			<cfset amt = evaluate("Form.#SalaryTrigger#_amount")>
			
			<cfparam name="Form.#SalaryTrigger#_payrollitem" default="">
			<cfset itm = evaluate("Form.#SalaryTrigger#_payrollitem")>		
			
			 <cfquery name="ClearPrior" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				     DELETE Payroll.dbo.PersonEntitlement 
					 WHERE  ContractId    = '#ctid#'
					 AND    SalaryTrigger = '#SalaryTrigger#'
			 </cfquery>  
		
			<cfif val eq "1">
	  	   		       										      			  
				 <cfquery name="Insert" 
					 datasource="AppsEmployee" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 INSERT INTO Payroll.dbo.PersonEntitlement 
					 
				             (PersonNo,
							  DateEffective,
							  DateExpiration,
							  <cfif form.salaryschedule neq "">
							  SalarySchedule,
							  </cfif>
							  EntitlementClass,
							  SalaryTrigger,
							  Status,
							  Remarks,
							  ContractId,
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName)
							  
					      VALUES
						  
						  	 ('#Form.PersonNo#',
						      #STR#,
							  #END#,
							 <cfif form.salaryschedule neq "">
							 '#Form.SalarySchedule#',
							 </cfif>
							 '#entitlementclass#',
							 '#SalaryTrigger#',
							 '2', <!--- #status#', cleared by default as it is contract related --->
							 'Generated from contract',
							 '#ctid#',
							 '#SESSION.acc#',
						     '#SESSION.last#',		  
							 '#SESSION.first#'
							 )
							 
				  </cfquery>
				  
			 <cfelseif amt neq "0" and LSIsNumeric(amt) and itm neq "">
			 
			 	<cfparam name="Form.#SalaryTrigger#_period" default="MONTH">
				<cfset per = evaluate("Form.#SalaryTrigger#_period")>
				
				<cfparam name="Form.#SalaryTrigger#_currency" default="#application.basecurrency#">
				<cfset cur = evaluate("Form.#SalaryTrigger#_currency")>		
						 
			 	<cfquery name="Insert" 
					 datasource="AppsEmployee" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 INSERT INTO Payroll.dbo.PersonEntitlement 
					 
				             (PersonNo,
							  DateEffective,
							  DateExpiration,
							  <cfif form.salaryschedule neq "">
							  SalarySchedule,
							  </cfif>
							  EntitlementClass,
							  SalaryTrigger,
							  PayrollItem,
							  Period,
							  Currency,
							  Amount,
							  Status,
							  Remarks,
							  ContractId,
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName)
							  
					      VALUES
						  
						  	 ('#Form.PersonNo#',
						      #STR#,
							  #END#,
							 <cfif form.salaryschedule neq "">
							 '#Form.SalarySchedule#',
							 </cfif>
							 '#entitlementclass#',
							 '#SalaryTrigger#',
							 '#itm#',
							 '#per#',
							 '#cur#',
							 '#amt#',
							 '2', <!--- #status#', cleared by default as it is contract related --->
							 'Generated from contract',
							 '#ctid#',
							 '#SESSION.acc#',
						     '#SESSION.last#',		  
							 '#SESSION.first#'
							 )
							 
				</cfquery> 
					 
			 </cfif>
						
	</cfloop>		  
	  	   
 </cfif>
  