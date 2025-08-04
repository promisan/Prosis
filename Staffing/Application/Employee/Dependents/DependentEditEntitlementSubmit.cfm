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

    <!--- this is not needed as we take the dependent as a package based on recordstatus --->
			
	<cfif change eq "2">
	 							
		 <cfquery name="ArchiveOld" 
	          datasource="AppsEmployee" 
	          username="#SESSION.login#" 
	          password="#SESSION.dbpw#">
	     	  UPDATE Payroll.dbo.PersonDependentEntitlement 
			  SET    Status = '9'
			  WHERE  PersonNo      = '#FORM.PersonNo#' 
	            AND  DependentId   = '#FORM.DependentId#' 			   
		 </cfquery>				
					
	</cfif>	
	
	<!--- carry forward parententitlementid --->
		
	<cfquery name="CarryOn" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	   	   SELECT *
		   FROM   Payroll.dbo.PersonDependentEntitlement 
		   WHERE  PersonNo      = '#FORM.PersonNo#'
		   AND    DependentId   = '#FORM.DependentId#'
		   AND    ParentEntitlementId is not NULL			
	</cfquery>		
	
	<cfloop query="CarryOn">
	
		<cfquery name="Insert" 
	      datasource="AppsEmployee" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	             INSERT INTO Payroll.dbo.PersonDependentEntitlement 
			             (PersonNo,
			    	 	 DependentId,										 
			     		 SalaryTrigger,
						 EntitlementGroup,
						 EntitlementSubsidy,
			    		 DateEffective,
			    		 DateExpiration,
			    		 Remarks,
						 ParentEntitlementId,
			    		 OfficerUserId,
			    		 OfficerLastName,
			    		 OfficerFirstName)
	             VALUES ('#PersonNo#',
			         	  '#rowguid#',		<!--- new id --->								  
				    	  '#SalaryTrigger#',
						  '#EntitlementGroup#', 
						  '#EntitlementSubsidy#', 
			    		  '#DateEffective#',
						  <cfif dateExpiration neq "">
						  '#DateExpiration#',
						  <cfelse>
						  NULL,
						  </cfif> 
			    		  '#Remarks#',
						  '#ParentEntitlementId#',						    		  
			    		  '#SESSION.acc#',
			        	  '#SESSION.last#',		  
			    	  	  '#SESSION.first#') 
			</cfquery>							
	
	
	</cfloop>
	
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
			
				<cfparam name="FORM.#item#" default="0">	
										
				<!--- pointer to define if entry/edit is needed --->
				<cfset entry       = Evaluate("FORM.#Item#")>
				
				<cfloop index="line" list="0,1,2,3,4">
																		
					<cfparam name="FORM.SalaryTrigger#item#_#line#"      default="">					
					<cfparam name="FORM.DateEffective#item#_#line#"      default="">					
					<cfparam name="FORM.DateExpiration#item#_#line#"     default="">
					<cfparam name="FORM.Remarks#item#_#line#"            default="">
					<cfparam name="FORM.EntitlementGroup#item#_#line#"   default="">
					<cfparam name="Form.EntitlementSubsidy#item#_#line#" default="0">
																					
					<cfset triggerN    = Evaluate("FORM.SalaryTrigger#Item#_#line#")>
					<cfset effectiveN  = Evaluate("FORM.DateEffective#Item#_#line#")>
					<cfset expirationN = Evaluate("FORM.DateExpiration#Item#_#line#")>
					<cfset remarksN    = Evaluate("FORM.Remarks#Item#_#line#")>
					<cfset groupN      = Evaluate("FORM.EntitlementGroup#Item#_#line#")>
					<cfset subN        = evaluate("FORM.EntitlementSubsidy#Item#_#line#")>
										
					<cfif entry eq "1" and triggerN neq "" and effectiveN neq "">		
					
						<cfquery name="CheckRelationship" 
						    datasource="AppsEmployee" 
						    username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT * 
							FROM   Payroll.dbo.Ref_PayrollTriggerRelationship
							WHERE  SalaryTrigger = '#triggerN#'
						</cfquery>
						
						<!--- this entitlement is contained by the relationship --->
						 
						<cfif CheckRelationship.recordcount gte "1">
						 
							 <cfquery name="CheckValid" 
							    datasource="AppsEmployee" 
							    username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT * 
								FROM   Payroll.dbo.Ref_PayrollTriggerRelationship
								WHERE  SalaryTrigger = '#triggerN#'
								AND    Relationship  =  '#Form.Relationship#'
								AND    Operational   = 1
							</cfquery>
							
							<cfif CheckValid.recordcount eq "0">
							
								<cfquery name="getTrigger" 
								    datasource="AppsEmployee" 
								    username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT * 
									FROM   Payroll.dbo.Ref_PayrollTrigger
									WHERE  SalaryTrigger = '#triggerN#'
								</cfquery>
								
								<cfquery name="getRelationship" 
								    datasource="AppsEmployee" 
								    username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT * 
									FROM   Ref_Relationship
									WHERE  Relationship = '#Form.Relationship#'
								</cfquery>
								
								<cf_alert message="Entitlement (#getTrigger.description#) is not allowed for a dependent under relationship: #getRelationship.Description#.">	
								
								<cfabort>
													
							</cfif>						 
						 
						</cfif>					
																											
						<cfset dateValue = "">
						<CF_DateConvert Value="#effectiveN#">
						<cfset STR = dateValue>
						
						<cfset dateValue = "">
						<!--- Change from Form.DateExpirationM to expirationN---->
						
						<cfif expirationN neq ''>
						    <CF_DateConvert Value="#expirationN#">
						    <cfset END = dateValue>
						<cfelse>
						    <cfset END = 'NULL'>
						</cfif>		
						
						<cfif GroupN eq "">
							<cfset GroupN = "Standard">
						</cfif>
																								
				        <cfquery name="Insert" 
				           datasource="AppsEmployee" 
				           username="#SESSION.login#" 
				           password="#SESSION.dbpw#">
				             INSERT INTO Payroll.dbo.PersonDependentEntitlement 
						             (PersonNo,
						    	 	 DependentId,										 
						     		 SalaryTrigger,
									 EntitlementGroup,
									 EntitlementSubsidy,
						    		 DateEffective,
						    		 DateExpiration,
						    		 Remarks,
						    		 OfficerUserId,
						    		 OfficerLastName,
						    		 OfficerFirstName)
				             VALUES ('#Form.PersonNo#',
						         	  '#rowguid#',										  
							    	  '#TriggerN#',
									  '#GroupN#', 
									  '#subN#', 
						    		  #STR#,
						    		  #END#,
						    		  '#RemarksN#',
						    		  '#SESSION.acc#',
						        	  '#SESSION.last#',		  
						    	  	  '#SESSION.first#') 
						</cfquery>											
												
					</cfif>
										
				</cfloop>	
												
			</cfif>	
				
	</cfloop>
			
</cfif>