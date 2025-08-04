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

<!--- from workflow --->

<!--- variable to define if the transaction is removed or just archived --->
<!--- default value : Deny which is called from the workfow also exisiting : Purge or Revert = reset to precleared values --->

<cfparam name="Object.ObjectKeyValue4"        default="">
<cfparam name="ScriptFile.DocumentStringList" default="Deny">

<cfparam name="attributes.dependentid" default = "#Object.ObjectKeyValue4#">
<cfparam name="attributes.qAction"     default = "#ScriptFile.DocumentStringList#">

<cfset qAction = attributes.qAction>

<cftransaction>

<cfquery name="Check" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
    	  SELECT * 
		  FROM   Employee.dbo.PersonDependent 		    
	      WHERE  DependentId  = '#attributes.DependentId#'  
</cfquery>		
		
<!--- check if this transaction was part of a prior workflow which was cleared and has to be reverted --->		
	
<cfquery name="ActionSource" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	      SELECT * 
		  FROM   Employee.dbo.EmployeeActionSource
		  WHERE  ActionDocumentNo IN 
					  (SELECT ActionDocumentNo 
					   FROM   Employee.dbo.EmployeeAction 
					   WHERE  ActionSourceId = '#attributes.DependentId#')		
</cfquery>	

<cfset PANo = ActionSource.ActionDocumentNo>
		
<!--- PA exists --->	
		
<cfif ActionSource.recordcount gte "1">
		
		<!--- revert the transaction to the prior state --->
	
		<cfloop query="ActionSource">			
								
			<!--- ---------------------- --->			
			<!--- rewind the dependents- --->
			<!--- ---------------------- --->
			
			<!--- ------------------------------------- --->			
			<!--- loop through the contract/dependents- --->
			<!--- ------------------------------------- --->			
			
			<cfif qAction eq "Deny" or qAction eq "Purge">
			
			    <!--- PA transaction status --->
				<cfif ActionStatus eq "9">
				    <!--- revert value --->
				    <cfset st = "2">
				<cfelse>
				    <cfset st = "9">
				</cfif>
				
			<cfelseif qAction eq "Revert">
			
				<!--- PA transaction line status --->
				<cfif ActionStatus eq "9">
				    <cfset st = "9">
				<cfelse>
				    <cfset st = "0">
				</cfif>
			
			</cfif>	
					
			<cfquery name="RevokeDep" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
		    	  UPDATE Employee.dbo.PersonDependent 
			      SET    ActionStatus = '#st#'
			      WHERE  PersonNo     = '#PersonNo#'
				  AND    DependentId  = '#ActionSourceId#'  
			</cfquery>
						
			<!--- ------------------------------------------------- --->			
			<!--- sync the payroll for each reverted action as well --->
			<!--- ------------------------------------------------- --->
											
			 <cfquery name="RevertPayroll" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			      UPDATE Payroll.dbo.PersonDependentEntitlement 
				  SET  	 Status      = '#st#'						   
				  WHERE  PersonNo    = '#PersonNo#'
				  AND    DependentId = '#ActionSourceId#'					    
			</cfquery>		
			
			<!--- finishing --->
			
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
							ActionDescription = 'Reinitialised [dep]'
					 WHERE  ActionDocumentNo  = '#PANo#'		
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
				
				<cfif st eq "9">
															
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
									
		</cfloop>
		
<cfelse>

		<cfif qAction eq "Deny">
							
			 <cfquery name="Remove" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   	  UPDATE Employee.dbo.PersonDependent
				  SET    ActionStatus = '9'
				  WHERE  PersonNo    = '#check.PersonNo#' 
			        AND  DependentId = '#attributes.DependentId#' 	 
			 </cfquery>
				 
			 <cfquery name="Remove" 
				   datasource="AppsOrganization" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   	  UPDATE Payroll.dbo.PersonDependentEntitlement 
					   SET   Status      = '9'
					  WHERE  PersonNo    = '#check.PersonNo#' 
				        AND  DependentId = '#attributes.DependentId#' 	 
			 </cfquery>
		 
		 <cfelseif qAction eq "Revert">
		 
		 	 <cfquery name="Remove" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   	  UPDATE Employee.dbo.PersonDependent
				  SET    ActionStatus = '0'
				  WHERE  PersonNo    = '#check.PersonNo#' 
			        AND  DependentId = '#attributes.DependentId#' 	 
			 </cfquery>
				 
			 <cfquery name="Remove" 
				   datasource="AppsOrganization" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   	  UPDATE Payroll.dbo.PersonDependentEntitlement 
					   SET   Status      = '0'
					  WHERE  PersonNo    = '#check.PersonNo#' 
				        AND  DependentId = '#attributes.DependentId#' 	 
			 </cfquery>
		 
		 <cfelseif qAction eq "Purge">
		 
	 	       <!--- dependent --->	
				
				<cfquery name="RevertDependentPayroll" 
				     datasource="AppsOrganization" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				      DELETE FROM Payroll.dbo.PersonDependentEntitlement 
					  WHERE  PersonNo    = '#check.PersonNo#' 
		        	  AND    DependentId = '#attributes.DependentId#' 	 				    
				</cfquery>		
							
				<cfquery name="RevokeDependent" 
				   datasource="AppsOrganization" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   	  DELETE FROM Employee.dbo.PersonDependent 
				      WHERE  PersonNo    = '#check.PersonNo#' 
				      AND    DependentId = '#attributes.DependentId#' 	 
				</cfquery>		
		 
		 </cfif>
						 
</cfif>	 
		  		   	
</cftransaction>					
		