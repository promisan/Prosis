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
<!--- variable to define if the transaction is removed or just archived --->
<!--- default value : Deny which is called from the workfow also exisiting : Purge or Revert = reset to precleared values --->

<cfparam name="Object.ObjectKeyValue4"        default="">
<cfparam name="ScriptFile.DocumentStringList" default="Deny">

<cfparam name="attributes.contractid" default="#Object.ObjectKeyValue4#">
<cfparam name="attributes.qAction"    default="#ScriptFile.DocumentStringList#">

<cfset qAction = attributes.qAction>

<cftransaction>

<!--- --------------------------------------- --->
<!--- check if this is a PA controlled record --->
<!--- --------------------------------------- --->

<cfquery name="ActionSource" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">   
      SELECT * 		  
	  FROM   Employee.dbo.EmployeeActionSource
	  WHERE  ActionDocumentNo IN (SELECT ActionDocumentNo 
		                          FROM   Employee.dbo.EmployeeAction 
								  WHERE  ActionSourceId = '#attributes.contractid#'	
								  )		
							  
</cfquery>	

<cfif ActionSource.recordcount eq "0">

	<!--- added based on STL observation run removing the created portion --->	
	
	<cfquery name="ActionSource" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">   
	      SELECT * 		  
		  FROM   Employee.dbo.EmployeeActionSource
		  WHERE  ActionDocumentNo IN (SELECT ActionDocumentNo 
			                          FROM   Employee.dbo.EmployeeActionSource 
									  WHERE  ActionSourceId = '#attributes.contractid#'  )		
								  
	</cfquery>	

</cfif>

<!--- keep this on top --->
		
<cfquery name="CheckAssignment" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Employee.dbo.PersonAssignment 	      
	  WHERE  ContractId  = '#attributes.ContractId#'  
</cfquery>

<cfset PANo = ActionSource.ActionDocumentNo>
	

<cfif ActionSource.recordcount gt "0">
	
		<cfquery name="getAction" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			      SELECT * 
				  FROM   Employee.dbo.EmployeeAction     
			      WHERE  ActionDocumentNo  = '#actionsource.ActionDocumentNo#'  
		</cfquery>
				
		<cftransaction>
	
		<cfloop query="ActionSource">
							
			<cfquery name="Contract" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			      SELECT * 		  
				  FROM   Employee.dbo.PersonContract
				  WHERE  ContractId = '#ActionSourceId#'					  
			</cfquery>	
					
			<!--- ------------------------------------- --->			
			<!--- loop through the contract/dependents- --->
			<!--- ------------------------------------- --->			
			
			<cfif qAction eq "Deny" or qAction eq "Purge">
			
			    <!--- PA transaction status --->
				<cfif ActionStatus eq "9">
				    <!--- we are going to reinstate this one as it was cancelled --->
				    <cfset contractstatus = "1">
				<cfelse>
				    <!--- contract is going to be removed --->
				    <cfset contractstatus = "9">
				</cfif>
				
			<cfelseif qAction eq "Revert">
			
				<!--- PA transaction line status --->
				<cfif ActionStatus eq "9">
				    <cfset contractstatus = "9">
				<cfelse>
				    <cfset contractstatus = "0">
				</cfif>
			
			</cfif>	
			
			<cfquery name="RevokeContract" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
		    	  UPDATE Employee.dbo.PersonContract 
			      SET    ActionStatus = '#contractstatus#'
			      WHERE  ContractId   = '#ActionSourceId#'  
				  <!--- if we revert we only revert the record of action, this is the case
				   if a contract is amended so a new contract has 2 instances
				    - remainder of the old portion which was cleared before (1)
					- new portion : wf (0)
					- prior record : (9)
			      --->
				  <cfif contractstatus eq "0"> 
				  AND    ContractId = '#getAction.ActionSourceId#'				  
				  </cfif>  
				 				  
			</cfquery>
			
			
									
			<!--- -------------------------------------------------- --->			
			<!--- then rewind dependents entered as part of the PA - --->
			<!--- -------------------------------------------------- --->
			
			<cfif qAction eq "Deny" or qAction eq "Purge">
												   						
				<cfif contractstatus eq "1">
					<cfset status = "2">
				<cfelse>
				    <cfif actionstatus eq "5"> <!--- added for dependents --->
					    <cfset status = "2"> <!--- we set back the status of the record --->
					<cfelse>
						<cfset status = "9">				
					</cfif>	
				</cfif>	
				
			<cfelseif qAction eq "Revert">
			
				<cfif contractstatus eq "1">
				    <cfset status = "9">	
				<cfelse>	
				    <cfif actionstatus lte "5"> 
					    <cfset status = "0">
					<cfelse>
						<cfset status = "9">
					</cfif>	
				</cfif>	
			
			</cfif>				
			
			<!--- ------------------------------------------------------------- --->			
			<!--- sync the entitlement payroll for each reverted action as well --->
			<!--- ------------------------------------------------------------- --->
			
			<cf_verifyOperational 
		         datasource= "appsOrganization"
		         module    = "Payroll" 
				 Warning   = "No">
			 
				<cfif operational eq "1">
						
				<cfquery name="RevertPayroll" 
				     datasource="AppsOrganization" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				      UPDATE Payroll.dbo.PersonEntitlement 
					  SET    DateEffective  = '#Contract.DateEffective#',
					         <cfif contract.dateExpiration neq "">
						     DateExpiration = '#Contract.DateExpiration#',
							 </cfif>						 
							 <cfif Contract.SalarySchedule neq "">
						     SalarySchedule = '#Contract.SalarySchedule#',
							 </cfif>
							 Status         = '#status#'
					  WHERE  ContractId     = '#ActionSourceId#'	
					   <!--- if we revert we only revert the record of action --->
					  <cfif contractstatus eq "0"> 
					  AND    ContractId     = '#getAction.ActionSourceId#'				  
					  </cfif>				    
				</cfquery>	
				
			</cfif>	
			
			<!--- ----------------------------------------------------- --->			
			<!--- sync the dep payroll for each reverted action as well --->
			<!--- ----------------------------------------------------- --->		
				
			<cfquery name="RevokeDep" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   	  UPDATE Employee.dbo.PersonDependent 
				  <cfif status eq "0">
			      SET    ActionStatus = '1'  <!--- this will allow payroll to run against the old data --->
				  <cfelse>
				  SET    ActionStatus = '#status#'				  
				  </cfif>
			      WHERE  PersonNo     = '#PersonNo#'
				  AND    DependentId  = '#ActionSourceId#'  
			</cfquery>
			
			<cfif status neq "0">
			
				<cf_verifyOperational 
		         datasource= "appsOrganization"
		         module    = "Payroll" 
				 Warning   = "No">
			 
				<cfif operational eq "1">
																
				<cfquery name="RevertPayroll" 
				     datasource="AppsOrganization" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				      UPDATE Payroll.dbo.PersonDependentEntitlement 
					  SET  	 Status      = '#status#'						   
					  WHERE  PersonNo    = '#PersonNo#'
					  AND    DependentId = '#ActionSourceId#'					    
				</cfquery>		
				
				</cfif>
			
			</cfif>
						
			<!--- --------------------------------------------------- --->
			<!--- -----finish the PA action processing--------------- --->
			<!--- --------------------------------------------------- --->
			
			<!--- all records reverted so now the PA can be taken out --->
			
			<cfif qAction eq "Deny">
			
				<cfquery name="RevertPA" 
			    datasource="AppsOrganization" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    	 UPDATE Employee.dbo.EmployeeAction 
					 SET    ActionStatus      = '9', 					      
							ActionDescription = 'Denied'
					 WHERE  ActionDocumentNo = '#PANo#'		
				</cfquery>		
				
			<cfelseif qAction eq "Revert">
			
				<cfquery name="RevertPA" 
			    datasource="AppsOrganization" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    	 UPDATE Employee.dbo.EmployeeAction 
					 SET    ActionStatus      = '1', 			<!--- adjusted 20/4/2018 --->		        
							ActionDescription = 'Reverted [ctr]'
					 WHERE  ActionDocumentNo = '#PANo#'		
				</cfquery>		
			
			<cfelseif qAction eq "Purge">
	
				<cfquery name="Delete" 
			    datasource="AppsOrganization" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    	 DELETE Employee.dbo.EmployeeAction 				
					 WHERE  ActionDocumentNo = '#PANo#'			
				</cfquery>	
				
				<!--- contract --->
				
				<cfif contractstatus eq "9">
				
					<cf_verifyOperational 
			         datasource= "appsOrganization"
			         module    = "Payroll" 
					 Warning   = "No">
					 
					<cfif operational eq "1">
					
						<cfquery name="RevertContractPayroll" 
						 datasource="AppsOrganization" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						      DELETE FROM Payroll.dbo.PersonEntitlement 
							  WHERE  ContractId  = '#ActionSourceId#'	
						</cfquery>		
					
					</cfif>
					
					<cfquery name="DeleteRecord" 
					   datasource="AppsOrganization" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
					      DELETE FROM Employee.dbo.PersonAssignment 		    
						  WHERE  PersonNo    = '#Contract.PersonNo#'
					      AND    ContractId  = '#ActionSourceId#'  
					</cfquery>
					
					<cfquery name="getSPA" 
					   datasource="AppsOrganization" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
					      SELECT * FROM Employee.dbo.PersonContractAdjustment 		    
						  WHERE  ContractId  = '#ActionSourceId#'  
					</cfquery>
					
					<cfloop query="getSPA">
					
						<cfquery name="prior" dbtype="query">
						  	SELECT * 
							FROM   ActionSource WHERE ActionStatus = '9'
						</cfquery>  
						
						<cfif prior.recordcount gte "1">					
											
							<cfquery name="relnkRecord" 
							   datasource="AppsOrganization" 
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
							      UPDATE Employee.dbo.PersonContractAdjustment 		    
								  SET    ContractId       = '#prior.ActionSourceId#'  
								  WHERE  PostAdjustmentId = '#PostAdjustmentId#'
							</cfquery>
						
						</cfif>
					
					</cfloop>
					
					<cfquery name="RevertContact" 
				    datasource="AppsOrganization" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    	 DELETE FROM Employee.dbo.PersonContract 				
						 WHERE  ContractId   = '#ActionSourceId#'						
					</cfquery>	
					
					<cfif status eq "9">
					
						<!--- dependent --->	
						
						<cf_verifyOperational 
				         datasource= "appsOrganization"
				         module    = "Payroll" 
						 Warning   = "No">
						 
						<cfif operational eq "1">
						
							<cfquery name="RevertDependentPayroll" 
							     datasource="AppsOrganization" 
							     username="#SESSION.login#" 
							     password="#SESSION.dbpw#">
							      DELETE FROM Payroll.dbo.PersonDependentEntitlement 
								  WHERE  PersonNo    = '#PersonNo#'
								  AND    DependentId = '#ActionSourceId#'					    
							</cfquery>	
						
						</cfif>	
									
						<cfquery name="RevokeDependent" 
						   datasource="AppsOrganization" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						   	  DELETE FROM Employee.dbo.PersonDependent 
						      WHERE  PersonNo     = '#PersonNo#'
							  AND    DependentId  = '#ActionSourceId#'  
						</cfquery>		
					
					</cfif>
					
				</cfif>					
					
			</cfif>	
														
		</cfloop>	
				
		
		</cftransaction>
				
<cfelse>
	
		<!--- NO PA mode so just revert the entry --->
		
		<cfif qAction eq "Deny">
	
			<cfquery name="DeleteContract" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
		    	  UPDATE Employee.dbo.PersonContract 
			      SET    ActionStatus = '9'
			      WHERE  ContractId  = '#Attributes.ContractId#'  
			</cfquery>		
			
			<cf_verifyOperational 
	         datasource= "appsOrganization"
	         module    = "Payroll" 
			 Warning   = "No">
			 
			<cfif operational eq "1">
			
			<cfquery name="RevertPayroll" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			      UPDATE Payroll.dbo.PersonEntitlement 
				  SET  	 Status      = '9'						   
				  WHERE  ContractId  = '#Attributes.ContractId#'  			    
			</cfquery>		
			
			</cfif>
			
		<cfelseif qAction eq "Revert">
		
			<cfquery name="DeleteContract" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
		    	  UPDATE Employee.dbo.PersonContract 
			      SET    ActionStatus = '0'
			      WHERE  ContractId  = '#Attributes.ContractId#'  
			</cfquery>	
			
			<cf_verifyOperational 
	         datasource= "appsOrganization"
	         module    = "Payroll" 
			 Warning   = "No">
			 
			<cfif operational eq "1">	
			
			<cfquery name="RevertPayroll" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			      UPDATE Payroll.dbo.PersonEntitlement 
				  SET  	 Status      = '0'						   
				  WHERE  ContractId  = '#Attributes.ContractId#'  			   
			</cfquery>		
			
			</cfif>		
		
		<cfelse>
						
			<cfquery name="DeleteRecord" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			      DELETE Employee.dbo.PersonAssignment 		    
				  WHERE  ContractId  = '#Attributes.ContractId#'  
			</cfquery>
			
			<cf_verifyOperational 
	         datasource= "appsOrganization"
	         module    = "Payroll" 
			 Warning   = "No">
			 
			<cfif operational eq "1">
			
				<cfquery name="RevertPayroll" 
				     datasource="AppsOrganization" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				      DELETE Payroll.dbo.PersonEntitlement 							   
					  WHERE  ContractId  = '#Attributes.ContractId#'  			    
				</cfquery>		
			
			</cfif>
		
			<cfquery name="DeleteContract" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
		    	  DELETE Employee.dbo.PersonContract 			     
			      WHERE  ContractId  = '#Attributes.ContractId#'  
			</cfquery>		
		
		</cfif>	
	
</cfif>

<!--- --------------------------------------------------------------------------------------- --->
<!--- --------------------------------------------------------------------------------------- --->
<!--- --------------------------------------------------------------------------------------- --->

<!--- --revert assignment records that are related to the contract entry which is reverted -- --->
<!--- -- but only if no later assignment record is found                                   -- --->
<!--- -- otherwise personassignment might already been processed to a valid 9 status 
      which we don't want to revert here to 1                                                 --->
	  
<cfif checkassignment.recordcount gte "1">

	<cfquery name="Contract" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   	  SELECT * 
		  FROM   Employee.dbo.PersonContract 			    
	      WHERE  ContractId  = '#attributes.ContractId#'  
		</cfquery>
	   
	<cfquery name="CheckLater" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   
	   	  SELECT * 
		  FROM   Employee.dbo.PersonAssignment 			    
	      WHERE  PersonNo      = '#Contract.PersonNo#'  
		  AND    PositionNo   IN (SELECT PositionNo 
		                          FROM   Employee.dbo.Position 
								  WHERE  Mission = '#Contract.Mission#')
		  AND    AssignmentClass = 'Regular'						  
		  AND    ContractId    != '#attributes.ContractId#'	  
		  <!--- we have a later recorded assignment which is a reason not to revert --->
		  AND    Created > '#checkAssignment.Created#' 
		      
	</cfquery>

	<!--- no later records observed --->
	<cfif checkLater.recordcount eq "0">
	
		<cfquery name="Contract" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   	  SELECT * 
		  FROM   Employee.dbo.PersonContract 			    
	      WHERE  ContractId  = '#attributes.ContractId#'  
		</cfquery>
		
		<cfif qAction eq "Deny">
				
			<cfif checkAssignment.recordcount eq "1">
				
				<cfquery name="RevertPriorAssignment" 
				   datasource="AppsOrganization" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				      UPDATE Employee.dbo.PersonAssignment 
				      SET    AssignmentStatus = '1'
				      WHERE  PersonNo     = '#Contract.PersonNo#'
					  AND    AssignmentNo = '#checkAssignment.Sourceid#' <!--- parent transaction --->	                          
				</cfquery>
				
				<cfquery name="DeleteRecord" 
				   datasource="AppsOrganization" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				      UPDATE Employee.dbo.PersonAssignment 		    
					  SET    AssignmentStatus = '9'
					  WHERE  PersonNo    = '#Contract.PersonNo#'
				      AND    ContractId  = '#Contract.ContractId#'  
				</cfquery>
				
				<cfquery name="RevertSPA" 
				   datasource="AppsOrganization" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				      UPDATE Employee.dbo.PersonContractAdjustment 
				      SET    ActionStatus = '9'
				      WHERE  PersonNo     = '#Contract.PersonNo#'
					  AND    ContractId   = '#Contract.ContractId#'	                          
				</cfquery>
			
			</cfif>		
			
		<cfelseif qAction eq "Revert">
		
		    <cfif checkAssignment.recordcount eq "1">
		
			    <cfquery name="RevertPriorAssignment" 
				   datasource="AppsOrganization" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">		   
				      UPDATE Employee.dbo.PersonAssignment 
				      SET    AssignmentStatus = '9'
				      WHERE  PersonNo     = '#Contract.PersonNo#'
					  AND    AssignmentNo = '#checkAssignment.Sourceid#'				                         
				</cfquery>
			
				<cfquery name="RevertRecord" 
				   datasource="AppsOrganization" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				      UPDATE Employee.dbo.PersonAssignment 		    
					  SET    AssignmentStatus = '1'
					  WHERE  PersonNo    = '#Contract.PersonNo#'
				      AND    ContractId  = '#attributes.ContractId#'  
				</cfquery>	
				
			</cfif>	
		
			<!--- do nothing for now as this would not be that crucial --->
		
		<cfelseif qAction eq "Purge">
		
			<cfif checkAssignment.recordcount eq "1">
				
				<cfquery name="RevertPriorAssignment" 
				   datasource="AppsOrganization" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">		  
				      UPDATE Employee.dbo.PersonAssignment 
				      SET    AssignmentStatus = '1'
				      WHERE  PersonNo     = '#checkAssignment.PersonNo#'  <!--- the parent of the assignment --->
					  AND    AssignmentNo = '#checkAssignment.Sourceid#'			                            
				</cfquery>
			
				<cfquery name="DeleteRecord" 
				   datasource="AppsOrganization" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				      DELETE FROM Employee.dbo.PersonAssignment 		    
					  WHERE  PersonNo    = '#checkAssignment.PersonNo#'
				      AND    ContractId  = '#attributes.ContractId#'  
				</cfquery>
			
			</cfif>		
		
		</cfif>	
	
	</cfif>
	
</cfif>	

</cftransaction>
