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
<!--- default value : Deny which is called from the workfow also exisiting : Purge or Revert = reset to precleared values --->

<cfparam name="Object.ObjectKeyValue4"        default="">
<cfparam name="ScriptFile.DocumentStringList" default="Deny">

<cfparam name="attributes.PostAdjustmentId"   default="#Object.ObjectKeyValue4#">
<cfparam name="attributes.qAction"            default="#ScriptFile.DocumentStringList#">

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
								  WHERE  ActionSourceId = '#attributes.PostAdjustmentId#')		
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
				  FROM   Employee.dbo.PersonContractAdjustment
				  WHERE  PostAdjustmentId = '#ActionSourceId#'		
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
		    	  UPDATE Employee.dbo.PersonContractAdjustment 
			      SET    ActionStatus      = '#contractstatus#'
			      WHERE  PostAdjustmentId  = '#ActionSourceId#'  
				  <!--- if we revert we only revert the record of action, this is the case
				   if a contract is amended so a new contract has 2 instances
				    - remainder of the old portion which was cleared before (1)
					- new portion : wf (0)
					- prior record : (9)
			      --->
				  <cfif contractstatus eq "0"> 
				  AND    PostAdjustmentId = '#getAction.ActionSourceId#'				  
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
					 SET    ActionStatus      = '1', 					        
							ActionDescription = 'Reverted [spa]'
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
								  					
					<cfquery name="RevertContact" 
				    datasource="AppsOrganization" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    	 DELETE FROM Employee.dbo.PersonContractAdjustment 				
						 WHERE  PostAdjustmentId  = '#ActionSourceId#'						
					</cfquery>	
					
					<cfif status eq "9">
					
						<!--- dependent --->	
						
						<cfquery name="RevertDependentPayroll" 
						     datasource="AppsOrganization" 
						     username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
						      DELETE FROM Payroll.dbo.PersonDependentEntitlement 
							  WHERE  PersonNo    = '#PersonNo#'
							  AND    DependentId = '#ActionSourceId#'					    
						</cfquery>		
									
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
	
		<!--- NO PA mode so just revert the entry 
		
		<cfif qAction eq "Deny">
	
			<cfquery name="DeleteContract" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
		    	  UPDATE Employee.dbo.PersonContract 
			      SET    ActionStatus = '9'
			      WHERE  ContractId  = '#Attributes.ContractId#'  
			</cfquery>		
			
			<cfquery name="RevertPayroll" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			      UPDATE Payroll.dbo.PersonEntitlement 
				  SET  	 Status      = '9'						   
				  WHERE  ContractId  = '#Attributes.ContractId#'  			    
			</cfquery>		
			
		<cfelseif qAction eq "Revert">
		
			<cfquery name="DeleteContract" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
		    	  UPDATE Employee.dbo.PersonContract 
			      SET    ActionStatus = '0'
			      WHERE  ContractId  = '#Attributes.ContractId#'  
			</cfquery>		
			
			<cfquery name="RevertPayroll" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			      UPDATE Payroll.dbo.PersonEntitlement 
				  SET  	 Status      = '0'						   
				  WHERE  ContractId  = '#Attributes.ContractId#'  			   
			</cfquery>				
		
		<cfelse>
		
			<cfquery name="DeleteRecord" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			      DELETE Employee.dbo.PersonAssignment 		    
				  WHERE  ContractId  = '#Attributes.ContractId#'  
			</cfquery>
			
			<cfquery name="RevertPayroll" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			      DELETE Payroll.dbo.PersonEntitlement 							   
				  WHERE  ContractId  = '#Attributes.ContractId#'  			    
			</cfquery>		
		
			<cfquery name="DeleteContract" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
		    	  DELETE Employee.dbo.PersonContract 			     
			      WHERE  ContractId  = '#Attributes.ContractId#'  
			</cfquery>		
		
		</cfif>	
		
		--->
	
</cfif>

<!--- revert assignment records that are related to the contract entry --->

<!--- check if an assignment record was created for this contract and revert this --->

<cfquery name="SPA" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   	  SELECT * 
	  FROM   Employee.dbo.PersonContractAdjustment 			    
      WHERE  PostAdjustmentId  = '#attributes.PostAdjustmentId#'  
</cfquery>
	
<cfif qAction eq "Deny">
				
		<!---
		
		<cfquery name="RevertPriorAssignment" 
		   datasource="AppsOrganization" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		      UPDATE Employee.dbo.PersonAssignment 
		      SET    AssignmentStatus = '1'
		      WHERE  PersonNo     = '#Contract.PersonNo#'
			  AND    AssignmentNo = '#checkAssignment.Sourceid#'	                          
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
		
		--->
		
		<cfquery name="RevertSPA" 
		   datasource="AppsOrganization" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		      UPDATE Employee.dbo.PersonContractAdjustment 
		      SET    ActionStatus = '9'
		      WHERE  PersonNo         = '#SPA.PersonNo#'
			  AND    PostAdjustmentId = '#SPA.PostAdjustmentId#'	                          
		</cfquery>
		
<cfelseif qAction eq "Revert">

	<!---

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
		
		--->

	<!--- do nothing for now as this would not be that crucial --->

<cfelseif qAction eq "Purge">

	<!---

	<cfif checkAssignment.recordcount eq "1">
		
		<cfquery name="RevertPriorAssignment" 
		   datasource="AppsOrganization" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		      UPDATE Employee.dbo.PersonAssignment 
		      SET    AssignmentStatus = '1'
		      WHERE  PersonNo     = '#checkAssignment.PersonNo#'
			  AND    AssignmentNo = '#checkAssignment.Sourceid#'			                            
		</cfquery>
	
		<cfquery name="DeleteRecord" 
		   datasource="AppsOrganization" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		      DELETE FROM Employee.dbo.PersonAssignment 		    
			  WHERE  PersonNo    = '#Contract.PersonNo#'
		      AND    ContractId  = '#attributes.ContractId#'  
		</cfquery>
	
	</cfif>		
	
	--->

</cfif>	

</cftransaction>
