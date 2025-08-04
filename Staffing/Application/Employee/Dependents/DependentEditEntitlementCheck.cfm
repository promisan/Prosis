<!--
    Copyright © 2025 Promisan

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
	
<cfif operational eq "1" or Parameter.DependentEntitlement eq "1">
	
	<!---								
	<cfloop index="itm" list="Insurance,RateInsurance,Entitlement,Dependent,Housing">
	--->
	<cfloop index="itm" list="Insurance,RateInsurance,Entitlement,Dependent">
		
	        <cfset item = left(itm,1)>
	
			<cfquery name="Enabled" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		        SELECT * 
		        FROM   Payroll.dbo.Ref_PayrollTrigger				
				WHERE  TriggerGroup = '#itm#'				
		    </cfquery>		
										
			<cfif enabled.recordcount gte "1">			
												
				<!--- pointer to define if entry/edit is needed --->
				
				 <cfquery name="Prior" 
		          datasource="AppsEmployee" 
		          username="#SESSION.login#" 
		          password="#SESSION.dbpw#">
		     	  SELECT * 
				  FROM   Payroll.dbo.PersonDependentEntitlement 
				  WHERE  PersonNo      = '#FORM.PersonNo#' 
		            AND  DependentId   = '#FORM.DependentId#' 			   
					AND  SalaryTrigger IN (SELECT SalaryTrigger 
					                       FROM   Payroll.dbo.Ref_PayrollTrigger 
										   WHERE  TriggerGroup = '#itm#')
					AND  Status != '9'					   
			    </cfquery>
								
				<cfparam name="FORM.#Item#"            default="0">				
				<cfparam name="FORM.lines#Item#"       default="0">	
								
				<cfset entry       = Evaluate("FORM.#Item#")>		
				<cfset lines       = Evaluate("FORM.lines#Item#")>					
									
				<cfif prior.recordcount eq "0">	  <!--- there was a NO previous entry --->
													  
					 <cfif entry eq "1">   <!--- but an entitlement was checked for recording --->	
													  		
							<cfset change = "2">
						        		  
					 </cfif>
							
				<cfelse> <!--- there was a previous entry --->
								
				    <cfif entry eq "0"> <!--- and now it was removed --->
					
						   <cfset change = "2">
														
					<cfelse>  
				
				    <!--- check if any of the lines were changed --->
					
					<cfset row = 0>					
				
				    <cfloop index="line" list="0,1,2,3,4">			
				
						<cfparam name="FORM.SalaryTrigger#item#_#line#"       default="">					
						<cfparam name="FORM.DateEffective#item#_#line#"       default="">					
						<cfparam name="FORM.DateExpiration#item#_#line#"      default="">
						<cfparam name="FORM.EntitlementGroup#item#_#line#"    default="">
						<cfparam name="FORM.EntitlementSubsidy#item#_#line#"  default="">
						<cfparam name="FORM.Remarks#item#_#line#"             default="">
																						
						<cfset triggerN    = Evaluate("FORM.SalaryTrigger#Item#_#line#")>
						<cfset expirationN = Evaluate("FORM.DateExpiration#Item#_#line#")>
						<cfset effectiveN  = Evaluate("FORM.DateEffective#Item#_#line#")>
						<cfset groupN      = Evaluate("FORM.EntitlementGroup#Item#_#line#")>
						<cfset subN        = Evaluate("FORM.EntitlementSubsidy#Item#_#line#")>
						<cfset remarksN    = Evaluate("FORM.Remarks#Item#_#line#")>
																				
						<cfset dateValue = "">
						<CF_DateConvert Value="#effectiveN#">
						<cfset STR = dateValue>
						
						<cfset dateValue = "">
						<cfif expirationN neq ''>
						    <CF_DateConvert Value="#expirationN#">
						    <cfset END = dateValue>
						<cfelse>
						    <cfset END = 'NULL'>
						</cfif>		
												
						<cfif effectiveN neq "">
						
							<cfset row = row+1>
						
							<cfquery name="Entitlement" 
						         datasource="AppsEmployee" 
						         username="#SESSION.login#" 
						         password="#SESSION.dbpw#">
								     SELECT *
									 FROM   Payroll.dbo.PersonDependentEntitlement 
									 WHERE  PersonNo           = '#FORM.PersonNo#'
							          AND   DependentId        = '#FORM.DependentId#' 	  
									  AND   SalaryTrigger      = '#triggerN#' 
									  AND   EntitlementGroup   = '#groupN#'  
									  AND   EntitlementSubsidy = '#subN#'
									  AND   DateEffective      = #str#									  
									  <cfif ExpirationN eq "">
									  AND   DateExpiration is NULL
									  <cfelse>
									  AND   DateExpiration     = #end#
									  </cfif>
							 </cfquery>
														 
							 <!--- something must have changed --->
							 <cfif entitlement.recordcount eq "0">
							 
							 	<cfset change = "2">
								
							 <cfelse>
							 
							 <cfquery name="description" 
						          datasource="AppsEmployee" 
						          username="#SESSION.login#" 
						          password="#SESSION.dbpw#">
								 
							     	  UPDATE Payroll.dbo.PersonDependentEntitlement 
									  SET    Remarks = '#remarksN#'
									  WHERE  PersonNo      = '#FORM.PersonNo#' 
							            AND  DependentId   = '#FORM.DependentId#' 			   
										AND  SalaryTrigger = '#triggerN#'
										AND  DateEffective      = #str#	 
							</cfquery>			
							 								
							 </cfif>
						 
						</cfif>		
						
										 
						 
					</cfloop>		
					
					<!--- number of lines with data changed --->
					
					<cfif row neq lines>
					
						<cfset change = "2">
					
					</cfif> 
																		 
				</cfif>			
				
			</cfif>		
			
		</cfif>		
				
	</cfloop>
			
</cfif>
