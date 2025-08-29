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

<cfset mode = "rate">

<cfif Len(Form.Remarks) gt 200>
  <cfset remarks = left(Form.Remarks,200)>
<cfelse>
  <cfset remarks = Form.Remarks>
</cfif>  

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<cfset dateValue = "">
<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = dateValue>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<cfparam name="Form.EntitlementDate" default="">

<cfset dateValue = "">
<cfif Form.EntitlementDate neq ''>
    <CF_DateConvert Value="#Form.EntitlementDate#">
    <cfset ENT = dateValue>
<cfelse>
    <cfset ENT = STR>
</cfif>	

<cfquery name="Trigger" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_PayrollTrigger
	WHERE  SalaryTrigger = '#Form.SalaryTrigger#'
</cfquery>

<!--- verify if record exist --->

<cfquery name="Entitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  *
FROM    PersonEntitlement
WHERE   PersonNo = '#Form.PersonNo#' 
AND     EntitlementId = '#Form.EntitlementId#'
</cfquery>

<cfquery name="Children" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  *
FROM    PersonDependentEntitlement
WHERE   PersonNo = '#Form.PersonNo#' 
AND     ParentEntitlementId = '#Form.EntitlementId#'
</cfquery>

<!--- check for overlap --->

<cfquery name="Check" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   PersonEntitlement
	WHERE  PersonNo       = '#Form.PersonNo#' 
	AND    SalaryTrigger  = '#Form.SalaryTrigger#' 
	AND    DateEffective >= #END# 
	AND    Status        != '9'
	AND    EntitlementId != '#Form.EntitlementId#' 
</cfquery>

<!----- the following lines were added by dev dev dev on may 29th 2008 ----->
<cfset overlaps=0>
<cfloop query="Check">

	<cfif END lt check.DateEffective>
		<cfset overlaps=overlaps+1>
	</cfif>

</cfloop>

<!----- end.----->

<cfset overlaps=check.recordcount-overlaps>

<cfif overlaps gte "1">
	<cf_tl id="Problem, dates may not overlap with other entitlements" class="message" var="1">
	<cf_message message="#lt_text# #Check.RecordCount#" return="back">
	<cfabort>
</cfif>

<cfset entid = Form.EntitlementId>

<cfparam name="Entitlement.RecordCount" default="0">

<cfif Entitlement.recordCount eq 1> 
	
	<cfif Entitlement.status lte "1">
		
		<cfquery name="EditEntitlement" 
		   datasource="AppsPayroll" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   UPDATE PersonEntitlement 
			   SET   DateEffective      = #STR#,
					 DateExpiration     = #END#,
					 SalaryTrigger      = '#Form.SalaryTrigger#',
					 SalarySchedule     = '#Form.SalarySchedule#',
					 DocumentReference  = '#Form.DocumentReference#',
					 <cfif trigger.enableAmount eq "1">
					 Currency           = '#Form.Currency#',
					 Amount             = '#Form.Amount#', 
					 </cfif>
					 Remarks            = '#Remarks#'
			   WHERE PersonNo = '#Form.PersonNo#' AND EntitlementId  = '#Form.EntitlementId#' 
		   </cfquery>
		   		   
		   <cfparam name="form.dependents" default="">
						
		   <cfif trigger.salarytrigger eq trigger.triggerdependent 
		      and Trigger.TriggerCondition eq "Dependent">
		   
			 <cfquery name="resetlinkeddependents" 
			     datasource="AppsPayroll" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 DELETE FROM PersonDependentEntitlement 
				 WHERE   PersonNo            = '#Form.PersonNo#'
				 AND     ParentEntitlementId = '#Form.EntitlementId#' 					
			</cfquery>
		
			<cfloop index="itm" list="#form.dependents#">			
			
				  <cfquery name="Group" 
				     datasource="AppsPayroll" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     SELECT   *
						 FROM     Ref_PayrollTriggerGroup 
						 WHERE    SalaryTrigger = '#Form.SalaryTrigger#'
						 ORDER BY ListingOrder					
				  </cfquery>		
				 												
				  <cfquery name="InsertEntitlement" 
				     datasource="AppsPayroll" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     INSERT INTO PersonDependentEntitlement 
					         (PersonNo,
							 DependentId, 		
							 ParentEntitlementId,				
							 DateEffective,
							 DateExpiration,
							 SalaryTrigger,
							 EntitlementGroup,
							 Status,						 
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
					      VALUES ('#Form.PersonNo#',
							      '#itm#',		
								  '#Form.EntitlementId#',			     
							      #STR#,
								  #END#,						 
								  '#Form.SalaryTrigger#',
								  '#Group.EntitlementGroup#',
								  '2',
								  '#SESSION.acc#',
						    	  '#SESSION.last#',		  
							  	  '#SESSION.first#')
					</cfquery>		
							
			</cfloop>
						
		</cfif>		   		   
	
	<cfelse>
	
		<cfparam name="form.dependents" default="">
	
		<cfset cnt = 0>
	
		<cfloop index="itm" list="#Form.Dependents#" delimiters=",">
		   <cfset cnt = cnt+1>		   
		</cfloop>
		
		<!--- we detect if there are changes --->			
				
		<cfif Form.DateExpiration neq DateFormat(Entitlement.DateExpiration,CLIENT.DateFormatShow)
		 or Form.DateEffective neq DateFormat(Entitlement.DateEffective,CLIENT.DateFormatShow)
		 or cnt neq children.recordcount>
		 
		 <!--- additional check if the period overlaps the old period --->
						
			<cfset dateValue = "">
			<CF_DateConvert Value="#DateFormat(Entitlement.DateEffective,CLIENT.DateFormatShow)#">
			<cfset EFF = dateValue>
						
			<cfset dateValue = "">			
			<cfif Entitlement.DateExpiration neq "">			
				<CF_DateConvert Value="#DateFormat(Entitlement.DateExpiration,CLIENT.DateFormatShow)#">
			<cfelse>		
				<CF_DateConvert Value="31/12/9999">					
			</cfif>
			<cfset EXP = dateValue>
			
			<cfif STR gt EXP or (END neq 'NULL' and END lt EFF)>
													
				<cf_message message="Problem, it does not appear you are recording an amendment for this record but a new record. Please contact your administrator" return="back">
				<cfabort>			
								
			</cfif>
		
			     <cftransaction>
				 
				 <cfquery name="EditEntitlement" 
			      datasource="AppsPayroll" 
			      username="#SESSION.login#" 
			      password="#SESSION.dbpw#">
				      UPDATE PersonEntitlement 
				      SET    Status        = '9' 
				      WHERE  PersonNo      = '#Form.PersonNo#' 
					  AND    EntitlementId = '#Form.EntitlementId#' 
			     </cfquery>
				 
				 <cfquery name="EditDependentEntitlement" 
			      datasource="AppsPayroll" 
			      username="#SESSION.login#" 
			      password="#SESSION.dbpw#">
				      UPDATE PersonDependentEntitlement 
				      SET    Status              = '9' 
				      WHERE  PersonNo            = '#Form.PersonNo#' 
					  AND    ParentEntitlementId = '#Form.EntitlementId#' 
			     </cfquery>
				 
				 <cf_assignId>			
				 <cfset entid = rowguid>
				 
				 <cfparam name="form.EntitlementGroup" default="Standard">
				
								 			 		
			     <cfquery name="InsertEntitlement" 
			     datasource= "AppsPayroll" 
			     username  = "#SESSION.login#" 
			     password  = "#SESSION.dbpw#">
			     INSERT INTO PersonEntitlement 
				            (PersonNo,
							 EntitlementId,
							 EntitlementDate,
							 DateEffective,
							 DateExpiration,
							 SalarySchedule,
							 EntitlementClass,
							 EntitlementGroup,
							 SalaryTrigger,
							 <cfif trigger.enableAmount eq "1">
							 Currency,          
							 Amount,            
							 </cfif>
							 Remarks,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
			      VALUES ('#Form.PersonNo#',
					      '#entid#',
						  #ENT#,
					      #STR#,
						  #END#,
						  '#Form.SalarySchedule#',
						  '#Trigger.EntitlementClass#',
						  '#Form.EntitlementGroup#',
						  '#Form.SalaryTrigger#',
						  <cfif trigger.enableAmount eq "1">
							'#Form.Currency#',          
							'#Form.Amount#',            
							 </cfif>
						  '#Remarks#',
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#')
						  
				 </cfquery>
				 
				 <cfset action = "3062">			
				 <cfinclude template="EntitlementActionSubmit.cfm">
				 
			     <!--- check if there is a need to record dependents --->
									
				<cfif trigger.salarytrigger eq trigger.triggerdependent and Trigger.TriggerCondition eq "Dependent">
					
						<cfloop index="itm" list="#form.dependents#">	
						
							<cfquery name="Group" 
							     datasource="AppsPayroll" 
							     username="#SESSION.login#" 
							     password="#SESSION.dbpw#">
								     SELECT   *
									 FROM     Ref_PayrollTriggerGroup 
									 WHERE    SalaryTrigger = '#Form.SalaryTrigger#'
									 ORDER BY ListingOrder					
							</cfquery>	
							
							<cfquery name="check" 
							  datasource="AppsPayroll" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">		
								SELECT      *
								FROM        PersonDependentEntitlement
								WHERE       PersonNo = '#Form.PersonNo#' 
								AND         DependentId = '#itm#'
								AND         SalaryTrigger = '#Form.SalaryTrigger#' 
								AND         DateEffective = #STR#
							</cfquery>
							
							<cfif check.recordcount eq "1">
							
								<cfquery name="update" 
								  datasource="AppsPayroll" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">		
									UPDATE      PersonDependentEntitlement
									SET         ParentEntitlementId = '#entid#', 
									            Status              = '2', 
												EntitlementGroup    = '#Group.EntitlementGroup#' 
									WHERE       PersonNo            = '#Form.PersonNo#' 
									AND         DependentId         = '#itm#'
									AND         SalaryTrigger       = '#Form.SalaryTrigger#' 
									AND         DateEffective       = #STR#
								</cfquery>					
							
							<cfelse>
											 				
								<cfquery name="insert" 
								     datasource="AppsPayroll" 
								     username="#SESSION.login#" 
								     password="#SESSION.dbpw#">					  
									     INSERT INTO PersonDependentEntitlement 
										         (PersonNo,
												 DependentId, 		
												 ParentEntitlementId,	<!--- associated --->									 
												 DateEffective,
												 DateExpiration,
												 SalaryTrigger,
												 EntitlementGroup,
												 Status,						 
												 OfficerUserId,
												 OfficerLastName,
												 OfficerFirstName)
									      VALUES ('#Form.PersonNo#',
										      '#itm#',		
											  '#entid#',							     
										      #STR#,
											  #END#,						 
											  '#Form.SalaryTrigger#',
											  '#Group.EntitlementGroup#',
											  '2',
											  '#SESSION.acc#',
									    	  '#SESSION.last#',		  
										  	  '#SESSION.first#')
											  
											  
								</cfquery>	
								
							</cfif>		
												
						</cfloop>
									
				</cfif>	 
				  
			</cftransaction>  
					 		  
			<cfquery name="Person" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Person
				WHERE  PersonNo = '#Form.PersonNo#' 
		    </cfquery>
			  
		    <cfquery name="OnBoard" 
			  datasource="AppsEmployee" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT TOP 1 *
				FROM      PersonAssignment
				WHERE     PersonNo = '#Form.PersonNo#' 
				AND       DateEffective < #STR#
				AND       DateExpiration >= #STR#
				AND       AssignmentStatus IN ('0','1') 
				ORDER BY  DateExpiration DESC
		    </cfquery>		
				  
		    <cfset link = "Staffing/Application/Employee/Entitlement/EntitlementEditTrigger.cfm?ID=#Form.PersonNo#&ID1=#rowguid#">
	
		     <cf_ActionListing 
			    EntityCode       = "EntEntitlement"
				EntityClass      = "Standard"
				EntityGroup      = "Rate"
				EntityStatus     = ""
				OrgUnit          = "#OnBoard.OrgUnit#"
				PersonNo         = "#Person.PersonNo#"
				ObjectReference  = "#Entitlement.SalaryTrigger#"
				ObjectReference2 = "#Person.FirstName# #Person.LastName#"
			    ObjectKey1       = "#Form.PersonNo#"
				ObjectKey4       = "#rowguid#"
				ObjectURL        = "#link#"
				Show             = "No"
				CompleteFirst    = "Yes">    
				  
		<cfelse>
		
			  <cfquery name="EditEntitlement" 
			   datasource="AppsPayroll" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   UPDATE PersonEntitlement 
			   SET    SalarySchedule     = '#Form.SalarySchedule#',
					  DocumentReference  = '#Form.DocumentReference#',
					  EntitlementDate    = #ENT#,
					  <cfif trigger.enableAmount eq "1">
					  Currency           = '#Form.Currency#',
					  Amount             = '#Form.Amount#', 
					  </cfif>
					  Remarks            = '#Remarks#'
			   WHERE  PersonNo           = '#Form.PersonNo#' 
			   AND    EntitlementId      = '#Form.EntitlementId#' 
			  </cfquery>		  
			
		</cfif>
	
	</cfif>

</cfif>

<cf_SystemScript>
	    
<cfoutput>
		
	<script>	 
		 ptoken.location("EntitlementEditTrigger.cfm?ID=#Form.PersonNo#&ID1=#entid#&mode=");    
	</script>	

</cfoutput>	   
