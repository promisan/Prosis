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

<cfparam name="attributes.EntitlementId"      default="#Object.ObjectKeyValue4#">
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
								  WHERE  ActionSourceId = '#attributes.EntitlementId#')		
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
			
		<cfloop query="ActionSource">
					
			<cfquery name="Contract" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			      SELECT * 		  
				  FROM   Payroll.dbo.PersonEntitlement
				  WHERE  EntitlementId = '#ActionSourceId#'		
			</cfquery>	
								
			<!--- ------------------------------------- --->			
			<!--- loop through the contract/dependents- --->
			<!--- ------------------------------------- --->			
			
			<cfif qAction eq "Deny">
			
			    <!--- PA transaction status --->
				<cfif ActionStatus eq "9">
				    <!--- we are going to reinstate this one as it was cancelled --->
				    <cfset contractstatus = "2">
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
		    	  UPDATE Payroll.dbo.PersonEntitlement
			      SET    Status    = '#contractstatus#'
			      WHERE  EntitlementId   = '#ActionSourceId#'  
				  <!--- if we revert we only revert the record of action, this is the case
				   if a contract is amended so a new contract has 2 instances
				    - remainder of the old portion which was cleared before (1)
					- new portion : wf (0)
					- prior record : (9)
			      --->
				  				  
			</cfquery>
												
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
							ActionDescription = 'Reverted [entitlement]'
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
				    	 DELETE FROM Payroll.dbo.PersonEntitlement 				
						 WHERE  EntitlementId  = '#ActionSourceId#'						
					</cfquery>	
									
				</cfif>					
					
			</cfif>			
								
		</cfloop>				
			
</cfif>

</cftransaction>
