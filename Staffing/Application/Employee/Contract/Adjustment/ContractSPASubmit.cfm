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
<!--- workflow will be accessed in the existing screen (expand) --->

<!--- verify if spa record possibly conflicts --->
		
<cfquery name="Contract" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     PersonContract
	WHERE    ContractId = '#url.ContractId#'
</cfquery>

<cfif url.action eq "delete"> 

	<!--- ----------------------------- --->	
	<!--- Check if there is a PA log -- --->
	<!--- ----------------------------- --->
		
	<cfquery name="ActionSource" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	      SELECT * 
		  FROM   EmployeeActionSource
		  WHERE  ActionDocumentNo IN (SELECT ActionDocumentNo 
		                              FROM   EmployeeAction 
									  WHERE  ActionSourceId = '#Form.PostAdjustmentId#')		
	</cfquery>	
		
	<cfquery name="Check" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
	    	  SELECT * FROM PersonContractAdjustment 	    
		      WHERE  PersonNo = '#PersonNo#'
			  AND    PostAdjustmentId = '#Form.PostAdjustmentId#'  
	</cfquery>	
		
	<cfif ActionSource.recordcount gte "1">
	
			<cfloop query="ActionSource">
						
				<!--- ---------------------- --->			
				<!--- rewind the dependents- --->
				<!--- ---------------------- --->
			
				<cfif ActionStatus eq "9">
				    <cfset st = "1">
					<cfset ctid = "#ActionSourceId#">
				<cfelse>
				    <cfset st = "9">					
				</cfif>
				
				<cfquery name="RevokeDep" 
				   datasource="AppsEmployee" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
			    	  UPDATE PersonContractAdjustment 
				      SET    ActionStatus      = '#st#'
				      WHERE  PersonNo          = '#PersonNo#'
					  AND    PostAdjustmentId  = '#ActionSourceId#'  
				</cfquery>
				
				<!--- closing the workflow steps --->
				
				<!--- before I was set the operational to 0 but that is tricky upon opening
				<cfquery name="DisableWkf" 
				   datasource="AppsOrganization" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
						UPDATE OrganizationObject
						SET    Operational       = '0'
						WHERE  ObjectKeyValue4 = '#Form.PostAdjustmentId#'			   	   
				</cfquery>   
				
				--->		
				
							
						 
				<cfquery name="RevertPA" 
				    datasource="AppsEmployee" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    	 UPDATE EmployeeAction 
						 SET    ActionStatus = '9', 						       
								ActionDescription = 'Reverted [spa]'
						 WHERE  ActionSourceId = '#Form.PostAdjustmentId#'	
				</cfquery>	
										
			</cfloop>
		
	 <cfelse>
			
			<cfquery name="DeleteSPA" 
			   datasource="AppsEmployee" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			      UPDATE PersonContractAdjustment 
			      SET    ActionStatus = '9'
			      WHERE  PostAdjustmentId  = '#Form.PostAdjustmentId#'  
			</cfquery>
			
			<!--- Setting operational 0 associated workflows which means
			the moment it will be opened it will reset its status
			based on the workfolow to kick in again and that I don't think is
			a good idea anymore !!!
			
			<cfquery name="DisableWkf" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
					UPDATE OrganizationObject
					SET    Operational       = '0'
					WHERE  ObjectKeyValue4 = '#Form.PostAdjustmentId#'			   	   
			</cfquery>   	
			
			--->   			 
	 </cfif>	
	 
	 <!--- only if there is a workflow we disable the steps because of the revoke --->
			
	<cfquery name="Object" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT * FROM OrganizationObject
			WHERE ObjectKeyValue4 =  '#Form.PostAdjustmentId#'	
			AND   Operational = 1			 
	</cfquery>	
			
	<cfif Object.recordcount gte "1">
		 
	    <cfset show = "No">   		    
	    <cfset enf  = "Yes">
		<cfset link = "#Object.ObjectURL#">
	 
		<cf_ActionListing 
		    EntityCode       = "PersonSPA"				
			EntityGroup      = ""
			EntityStatus     = ""	
			Personno         = "#PersonNo#"					
		    ObjectKey1       = "#PersonNo#"
			ObjectKey4       = "#Form.PostAdjustmentId#"
			AjaxId           = "#Form.PostAdjustmentId#"	
			Show             = "#show#"				
			CompleteCurrent  = "#enf#"
			ObjectURL        = "#link#">	
				
	</cfif>		  	
	
<cfelse>
	
	<cfif Len(Form.Remarks) gt 800>
	  <cfset remarks = left(Form.Remarks,800)>
	<cfelse>
	  <cfset remarks = Form.Remarks>
	</cfif>  
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.DateEffective#">
	<cfset STR = dateValue>
	
	<cfset dateValue = "">
	<cfif Form.DateExpiration neq "">
		<CF_DateConvert Value="#Form.DateExpiration#">
		<cfset END = dateValue>
	<cfelse>	 		 
		<cfset END = 'NULL'>
	</cfif>	
		
	<cfset dateValue = "">
	<cfif Form.StepIncreaseDate neq ''>
	    <CF_DateConvert Value="#Form.StepIncreaseDate#">
	    <cfset STEP = dateValue>
	<cfelse>
	    <cfset STEP = 'NULL'>
	</cfif>	
				
	<cfif STR gt END and END neq "NULL">
	
	    <cfoutput>
	    <script>
		   alert("Expiration date lies before effective date.\n\n Operation aborted.")		    
	    </script>	
		</cfoutput>
		
		<cfabort>
	
	</cfif>		
	
	<!--- check if contract is found --->
	
	<cfquery name="getContract" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     PersonContract
		WHERE    PersonNo = '#contract.PersonNo#'
		AND      Mission  = '#contract.Mission#'
		AND      ActionStatus = '1'
		AND      DateEffective >= '#contract.DateEffective#'
		ORDER BY DateEffective DESC	
	</cfquery>
	
	<cfif END gt getContract.DateExpiration 
	      and getContract.dateExpiration neq "" 
		  and Form.DateExpiration neq "">
	
	 	<cfoutput>
		    <script>
			   alert("Expiration date exceeds the contract expiration date.\n\nOperation not allowed.")		    
		    </script>	
		</cfoutput>
		
		<cfabort>
	
	</cfif>
		
	<!--- ---- business rule on overlapping SPA ----- --->
	<!--- verify if a contract SPA record which expiration
	   lies after the effective date of the new entry --->
		
		<cfquery name="VerifyConflict" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     PersonContractAdjustment
			WHERE    PersonNo = '#Contract.PersonNo#' 		
			AND      DateExpiration >= #STR# 				
			AND      PostAdjustmentId  != '#Form.PostAdjustmentId#'
			AND 	 ActionStatus != '9' 
		</cfquery>
		
		<cfif VerifyConflict.recordcount gte "1">
		
			 <cf_tl id="SPAOverlaps" var="1" class="message">
			 <cfset tContractOverlaps = "#Lt_text#">
		
			 <cf_tl id="OperationNotAllowed" var="1" >
			 <cfset tOperationNotAllowed = "#Lt_text#">
			 
			<cf_alert message="#tContractOverlaps# #dateFormat(VerifyConflict.DateEffective, CLIENT.DateFormatShow)# - #dateFormat(verifyConflict.DateExpiration, CLIENT.DateFormatShow)#. #tOperationNotAllowed#" 
			return="no">
			
			<cfabort>
		
		</cfif>
						
		<cfquery name="SPA" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   PersonContractAdjustment
			WHERE  PersonNo         = '#Contract.PersonNo#' 
			AND    PostAdjustmentId = '#Form.PostAdjustmentId#' 
		</cfquery>
											
		<cfif SPA.recordCount eq 1 and SPA.ActionStatus is "0"> 
				
				<!--- the record has status 0 as
				 otherwise update need to result in a cancel and insert --->
				
				<cfquery name="UpdateContract" 
				   datasource="AppsEmployee" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">				   
				   UPDATE PersonContractAdjustment 
				   SET    DateEffective        = #STR#,
						  DateExpiration       = #END#,
						  PostSalarySchedule   = '#Form.PostSalarySchedule#',
						  PostServiceLocation  = '#Form.PostServiceLocation#',
						  PostAdjustmentLevel  = '#Form.ContractLevel#',
						  PostAdjustmentStep   = '#Form.ContractStep#',						
						  StepIncreaseDate     = #STEP#,
						  Remarks              = '#Remarks#'
				   WHERE  PersonNo             = '#Contract.PersonNo#' 
			       AND    PostAdjustmentId     = '#Form.PostAdjustmentId#' 
			   </cfquery>
						  
			   <cfif "#dateformat(STR,client.dateSQL)#" eq "#dateformat(SPA.DateEffective,client.dateSQL)#" AND			         
					 Form.ContractLevel eq SPA.PostAdjustmentLevel AND
					 Form.ContractStep eq SPA.PostAdjustmentStep>		
					 
					 <!--- no changes --->								  	  
				  
				<cfelse>
				
				   <!--- if workflow has started we recreate --->				  
				   <cf_wfReset objectkeyvalue4="#Form.PostAdjustmentId#" mode="recreate">
				   
				</cfif> 
							  					  
			  <cfset ctid = "#Form.PostAdjustmentId#">
							   
		<cfelse>
			
			<!--- --------------- --->	
			<!--- insert SPA----- --->	
			<!--- --------------- --->
			
			<cfquery name="Parameter" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      Ref_ParameterMission
				WHERE     Mission = '#Contract.Mission#'		
			</cfquery>
			
			<cfquery name="SPA" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   PersonContractAdjustment
				WHERE  PersonNo         = '#Contract.PersonNo#' 
				AND    PostAdjustmentId = '#Form.PostAdjustmentId#' 
			</cfquery>
						
			<cftransaction>
			
				<!--- retire prior entry --->
				
				<cfquery name="UpdateContract" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">				   
					UPDATE   PersonContractAdjustment 
					   SET   ActionStatus = '9'
					  WHERE  PersonNo         = '#Contract.PersonNo#' 
				      AND    PostAdjustmentId = '#Form.PostAdjustmentId#' 
				</cfquery>
				
				<cfset adid = "">
				
				<cfif SPA.DateEffective lt STR and SPA.recordcount eq "1">
				
				    <!--- we create an entry for the missing portion --->
				
					<cfset prior = dateAdd("d",-1,STR)>
					
					<cf_assignId>					
					<cfset adid  = rowguid>
					
					<cfquery name="InsertSPA" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     INSERT INTO PersonContractAdjustment 
						        (PostAdjustmentId,
								 PersonNo,
								 Contractid,
								 DateEffective,
								 DateExpiration,
								 PostSalarySchedule,
								 PostServiceLocation,
								 PostAdjustmentLevel,
								 PostAdjustmentStep,
								 StepIncreaseDate,
								 Remarks,
								 ActionStatus,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
					      VALUES ('#adid#',
							      '#Contract.PersonNo#',
								  '#Contract.ContractId#',
								  '#SPA.DateEffective#',
								  #PRIOR#,
								  '#SPA.PostSalarySchedule#',
								  '#SPA.PostServiceLocation#',
								  '#SPA.PostAdjustmentLevel#',
								  '#SPA.PostAdjustmentStep#',					
								  '#SPA.StepIncreaseDate#',
								  '#SPA.Remarks#',
								  '1',
								  '#SESSION.acc#',
						    	  '#SESSION.last#',		  
							  	  '#SESSION.first#')
					  </cfquery>				
				
				</cfif>				
				
				<!--- add new --->
				
				<cfif SPA.recordCount eq 1> 
					 <!--- amend --->
					 <cf_assignId>
					 <cfset ctid = rowguid>					
				<cfelse>
				    <!--- grant --->					
					<cfset ctid = Form.PostAdjustmentId>
				</cfif>
																 
				<cfquery name="InsertSPA" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				     INSERT INTO PersonContractAdjustment 
					        (PostAdjustmentId,
							 PersonNo,
							 Contractid,
							 DateEffective,
							 DateExpiration,
							 PostSalarySchedule,
							 PostServiceLocation,
							 PostAdjustmentLevel,
							 PostAdjustmentStep,
							 StepIncreaseDate,
							 Remarks,
							 ActionStatus,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
				      VALUES ('#ctid#',
						      '#Contract.PersonNo#',
							  '#Contract.ContractId#',
							  #STR#,
							  #END#,
							  '#Form.PostSalarySchedule#',
							  '#Form.PostServiceLocation#',
							  '#Form.ContractLevel#',
							  '#Form.ContractStep#',					
							  #STEP#,
							  '#Remarks#',
							  '0',
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#')
				  </cfquery>
				 
				  <cfif SPA.recordCount eq 1> 		
				  
				      <cfset action = "3052">
				  
					  <!--- amendment --->
				  			   												
					  <cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
						   method             = "ActionDocument" 
						   PersonNo           = "#Contract.PersonNo#"
						   Mission            = "#Contract.Mission#"
						   ActionCode         = "#action#"
						   ActionDate         = "#Form.DateEffective#"
						   ActionSourceId     = "#ctid#"	
						   ActionLink   	  = "Staffing/Application/Employee/Contract/Adjustment/ContractSPAForm.cfm?contractid=#contract.contractid#&postadjustmentid="
						   ripple1            = "#adid#"
						   ripple9            = "#Form.PostAdjustmentId#"						 			 
						   ActionStatus       = "1">	
				 
			       <cfelse>
				   
				      <cfset action = "3051">
													
					  <cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
						   method             = "ActionDocument" 
						   PersonNo           = "#Contract.PersonNo#"
						   Mission            = "#Contract.Mission#"
						   ActionDate         = "#Form.DateEffective#"
						   ActionCode         = "#action#"
						   ActionSourceId     = "#ctid#"	
						   ripple1            = "#adid#"
						   ActionLink   	  = "Staffing/Application/Employee/Contract/Adjustment/ContractSPAForm.cfm?contractid=#contract.contractid#&postadjustmentid="
						   ActionStatus       = "1">						 
				 
			      </cfif>  
				   
			</cftransaction>	
			
			<!--- --------------- --->
			<!--- create workflow --->
			<!--- --------------- --->
								  
			  <cfquery name="CheckMission" 
				 datasource="AppsEmployee"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
						 SELECT   *
						 FROM     Organization.dbo.Ref_EntityMission 
						 WHERE    EntityCode     = 'PersonSPA'  
						 AND      Mission        = '#Contract.Mission#'  
			  </cfquery>
			  
			  <cfif CheckMission.WorkflowEnabled eq "0" or CheckMission.recordcount eq "0">
	        
					<!--- no workflow, clear the transaction immediately to status = 1 
					this will allow to amend it, otherwise you need to clear
					--->
															
					<cfquery name="Update" 
					   datasource="AppsEmployee" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
					   	  UPDATE PersonContractAdjustment
						  SET    ActionStatus = '1'
						  WHERE  PersonNo    = '#Contract.PersonNo#' 
					        AND  PostAdjustmentId = '#ctid#' 	 
					</cfquery>
								
		  	  <cfelse>
			  				  
				  <cfquery name="Person" 
				 	datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
							SELECT *
							FROM Person
							WHERE PersonNo = '#Contract.PersonNo#' 
			 	  </cfquery>
				  
				    <cfquery name="wfclass" 
				 	datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">				
						SELECT  *
						FROM    Ref_Action
						WHERE   ActionCode = '#action#' 
			 	  </cfquery>
				
				  <cfset link = "Staffing/Application/Employee/Contract/Adjustment/ContractSPAForm.cfm?contractid=#contract.contractid#&postadjustmentid=#ctid#">
								
				  <cf_ActionListing 
					    EntityCode       = "PersonSPA"
						EntityClass      = "#wfclass.EntityClass#"
						EntityGroup      = ""
						EntityStatus     = ""
						Mission          = "#Contract.mission#"
						PersonNo         = "#Contract.PersonNo#"
						ObjectReference  = "#Form.ContractLevel#/#Form.ContractStep#"
						ObjectReference2 = "#Person.FirstName# #Person.LastName#" 						
					    ObjectKey1       = "#Contract.PersonNo#"
						ObjectKey4       = "#ctid#"
						ObjectURL        = "#link#"
						Show             = "No">
											
			  </cfif>		   
				  
		</cfif>

</cfif>	     
	  
<cfoutput>

<cfif url.spabox eq "">

	<script>
	 window.close()
	</script>

<cfelse>
	
	<script>	     
		 // parent.ColdFusion.Window.hide('spa')
		 parent.history.go()
		 // parent.ColdFusion.navigate('Adjustment/EmployeeContractSPA.cfm?id=#Contract.PersonNo#&postadjustmentid=#Form.PostAdjustmentId#&spabox=#url.spabox#','#url.spabox#')
	</script>	
	
</cfif>	
	
</cfoutput>	   
	

