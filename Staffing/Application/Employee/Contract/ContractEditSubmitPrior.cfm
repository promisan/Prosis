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
<!--- --------------------------------------------------- --->

<cfparam name="ripple1" default="">
<cfparam name="ripple9" default="">

    <!--- adjusted on 19/4 to NOT discontinue if there is no overlap detected 
	for the new entry if there are future contract entries already --->
			
	<cfquery name="Select" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 SELECT   * 
		 FROM     PersonContract
		 WHERE    (DateExpiration is NULL or DateExpiration >= #STR#)
		 <cfif end neq "NULL">
		 AND      DateEffective <= #END#
		 </cfif>
		 AND      PersonNo      = '#Form.PersonNo#'
		 AND      Mission       = '#Form.Mission#' 
		 AND      ContractId   != '#Form.ContractId#'  
		 AND      ActionStatus != '9'
		 ORDER BY DateEffective  	
		
	</cfquery>	 
	
	<cfloop query="Select">
		
	    <cfif currentrow gt "1">
		
			<!--- wildcard protection which should not occur 
			completely cancel additional contract records in case of negative period 
			if this is not the first record --->
	
			<cfquery name="UpdateContract" 
			   datasource="AppsEmployee" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				 UPDATE PersonContract
				 SET    ActionStatus = '9'
				 WHERE  ContractId = '#ContractId#'									
			</cfquery>	 
			
			<cfif ripple9 eq "">
				<cfset ripple9 = "#ContractId#">
			<cfelse>
			    <cfset ripple9 = "#ripple9#,#ContractId#">
			</cfif>	
			
			<cfif operational eq "1">
			
				<cfquery name="UpdateContract" 
					  datasource="AppsEmployee" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  UPDATE Payroll.dbo.PersonEntitlement
					  SET    Status = '9'
					  WHERE  ContractId = '#ContractId#'
				</cfquery>	
		
			</cfif>	 				
		
		<cfelse>
		
			<cf_assignid>
			
			<!--- --------------------------------------------------------------- --->		
			<!--- check if the new entered start date fully supersedes 
			   the existing contract. Hereto we check if the amendmended record
			   starts before the new effective date (the query is in the reverse) --->
			<!--- --------------------------------------------------------------- --->
					
			<cfquery name="CheckOverLap" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT * 
				 FROM   PersonContract
				 WHERE  ContractId = '#ContractId#'		
				 AND    ActionStatus != '9'	
				 AND    DateEffective > DateAdd(day,-1,#STR#)  				
			</cfquery>	 	
			
						<!--- if we have a start date before the query will be having 0 records..
			if NOT fully overlapped there is a need to create a new record for
			the remainder of the prior contract, here to new cancelled record is created
			and the current record is adjusted  --->
			
			<cfif CheckOverlap.recordcount eq "0">	
			
				<cfif ripple1 eq "">
					<cfset ripple1 = rowguid>
				<cfelse>
				    <cfset ripple1 = "#ripple1#,#rowguid#">
				</cfif>	
				
				<!--- create a new record for the old contract for the still valid period --->
															
				<cfquery name="BackupRecord" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 INSERT INTO PersonContract
					 		(PersonNo, 
					        ContractId, 
							Mission, 
							DateEffective, 
							DateExpiration, 
							ContractType, 
							ContractTime, 
							SalarySchedule, 
							SalaryBasePeriod, 
							ContractLevel, 
		                    ContractStep, 
							ServiceLocation, 
							ContractSalaryAmount, 
							Remarks, 
							StepIncrease, 
							StepIncreaseDate, 
							AppointmentStatus, 
							AppointmentStatusMemo,
							ContractStatus, 
							ActionStatus, 
							HistoricContract,
		                    ActionCode, 
							GroupCode,
							GroupListCode,							
							PersonnelActionNo, 
							ContractFunctionNo,
							ContractFunctionDescription,
							
							EnforceFinalPay, 
							ReviewPanel, 
							OfficerUserId, 
							OfficerLastName, 
							OfficerFirstName, 
							Created)						 
					 SELECT PersonNo, 
					        '#rowguid#', 
							Mission, 
							DateEffective, 
							DateExpiration, 
							ContractType, 
							ContractTime, 
							SalarySchedule, 
							SalaryBasePeriod, 
							ContractLevel, 
		                    ContractStep, 
							ServiceLocation, 
							ContractSalaryAmount, 
							'Generated portion of the non-amended period of the contract', 
							StepIncrease, 
							StepIncreaseDate, 
							AppointmentStatus, 
							AppointmentStatusMemo,
							ContractStatus, 
							'1', 
							'0',
		                    ActionCode, 
							GroupCode,
							GroupListCode,		
							PersonnelActionNo, 
							ContractFunctionNo,
							ContractFunctionDescription,
							EnforceFinalPay, 
							ReviewPanel, 
							'#SESSION.acc#', 
							'#SESSION.last#', 
							'#SESSION.first#', 
							getDate()					 
					 FROM   PersonContract						 
					 WHERE  ContractId = '#ContractId#'								
				</cfquery>								
				
				<!--- --------------------------------------- --->
				<!--- create archived payroll entry as well-- --->
				<!--- --------------------------------------- --->
				
				<cfif operational eq "1">
				
				    <!--- create a new record for the old contract for the still valid period --->
				
					<cfquery name="BackupRecord" 
					     datasource="AppsEmployee" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						 INSERT INTO Payroll.dbo.PersonEntitlement
						 
							 	(
								 PersonNo, 						 
								 DateEffective, 
								 DateExpiration, 
								 SalarySchedule, 
								 EntitlementClass, 
								 SalaryTrigger, 
								 PayrollItem, 
								 Period, 
								 Currency, 
								 Amount, 
		                         DocumentReference, 
								 Remarks, 
								 Status, 
								 ContractId, 
								 ActionReference, 
								 OfficerUserId, 
								 OfficerLastName, 
								 OfficerFirstName, 
								 Created
								)
						 		 
						  SELECT PersonNo, 							 
								 DateEffective, 
								 DateExpiration, 
								 SalarySchedule, 
								 EntitlementClass, 
								 SalaryTrigger, 
								 PayrollItem, 
								 Period, 
								 Currency, 
								 Amount, 
		                         DocumentReference, 
								 Remarks, 
								 '2',         <!--- was '1' but corrected by Dev 6/10/2018 --->
								 '#rowguid#', <!--- newly added contract --->
								 ActionReference, 
								 OfficerUserId, 
								 OfficerLastName, 
								 OfficerFirstName, 
								 Created	
								 							 
						 FROM    Payroll.dbo.PersonEntitlement		
						 			 
						 WHERE   ContractId = '#ContractId#'	
						 							
					</cfquery>	
				
				</cfif> 	
				
				<!--- Now adjust the newly created record for the valid portion of the contract 
					 to match new period, this will ensure the wf is still
					 visible, I might reverse this as it might be better
					 to link the wf to the cancelled portion --->
					 
				<!--- check if we have any SPAs to be relinked --->				
								
				<cfquery name="UpdateContract" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 UPDATE  PersonContract
					 SET     DateExpiration = DateAdd(day,-1,#STR#)
					 WHERE   ContractId     = '#rowguid#'							
				</cfquery>	 					
										 
				<cfif operational eq "1">
				
					<cfquery name="UpdateContract" 
					     datasource="AppsEmployee" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						 UPDATE Payroll.dbo.PersonEntitlement
						 SET    DateExpiration = DateAdd(day,-1,#STR#)
						 WHERE  ContractId = '#rowguid#'					 
					</cfquery>	
			
				</cfif>	 	
				
				<!--- archive the old record --->				
				
				<cfquery name="UpdateContract" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 UPDATE PersonContract
					 SET    ActionStatus = '9'
					 WHERE  ContractId = '#contractid#'							
				</cfquery>	 					
										 
				<cfif operational eq "1">
				
					<cfquery name="UpdateContract" 
					     datasource="AppsEmployee" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						 UPDATE Payroll.dbo.PersonEntitlement
						 SET    Status = '9'
						 WHERE  ContractId = '#contractid#'						 
					</cfquery>	
			
				</cfif>	 	
				
				<cfif ripple9 eq "">
					<cfset ripple9 = "#ContractId#">
				<cfelse>
				    <cfset ripple9 = "#ripple9#,#ContractId#">
				</cfif>								
				
			<cfelse>
			
				<!--- just archive the record as it is fully superseded --->
				
				<cfquery name="CheckCancelling" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 SELECT * 
					 FROM   PersonContract					
					 WHERE  ContractId = '#ContractId#'								
					 AND    ActionStatus = '1' 
				</cfquery>	
				
				<cfif CheckCancelling.recordcount eq "1">				
			
					<cfquery name="CancelContract" 
					     datasource="AppsEmployee" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						 UPDATE PersonContract
						 SET    ActionStatus = '9' 						       
						 WHERE  ContractId = '#ContractId#'								
						 AND    ActionStatus = '1' 
					</cfquery>	
					
					<cf_wfActive datasource="AppsEmployee" 
					            entitycode="PersonContract" 
								objectkeyvalue4="#ContractId#">		
									
					<cfif wfstatus eq "open">
					
						<cfquery name="ArchiveFlow" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								UPDATE Organization.dbo.OrganizationObjectAction
								SET    ActionStatus     = '2',
								       ActionMemo       = 'Closed by agent due to prior contract amendment action causing a cancellation',
								       OfficerUserId    = 'administrator',
									   OfficerLastName  = 'Agent',
									   OfficerFirstName = 'System',									   
									   OfficerDate      = getDate()					   		
								WHERE  ObjectId IN (SELECT ObjectId 
								                    FROM   Organization.dbo.OrganizationObject 
													WHERE  ObjectKeyValue4 = '#contractid#')
								AND    ActionStatus = '0'			
						</cfquery>	
					
					</cfif>
					
					<cfquery name="UpdateEA" 
					     datasource="AppsEmployee" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
							UPDATE EmployeeAction
							SET    ActionStatus = '9'
							WHERE  ActionSourceId = '#ContractId#'	
					</cfquery>	
				
				</cfif>
							
				<cfif ripple9 eq "">
					<cfset ripple9 = "#ContractId#">
				<cfelse>
				    <cfset ripple9 = "#ripple9#,#ContractId#">
				</cfif>	
				
				<!--- CORRECTION, it is not correct anymore to then also 
				remove the assignment, as it will be used to serve under the new
				contract 1/12/2010, it might mean that we have cancelled contract with
				valid assignment record --->
				
				<!---
				
				<cfquery name="CancelAssignment" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 UPDATE PersonAssignment
					 SET    AssignmentStatus = '9'
					 WHERE  ContractId = '#ContractId#'										
				</cfquery>	
				
				--->
				
				<cfif operational eq "1">
				
					<cfquery name="CancelPayroll" 
					     datasource="AppsEmployee" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						 UPDATE Payroll.dbo.PersonEntitlement
						 SET    Status = '9'
						 WHERE  ContractId = '#ContractId#'
					</cfquery>	
			
				</cfif>	 
				
			</cfif>	
						   
		</cfif>		   
	
	</cfloop>			