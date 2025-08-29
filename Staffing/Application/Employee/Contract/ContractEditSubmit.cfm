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

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfparam name="Form.ActionCode"       default="">
<cfparam name="Form.GroupCode"        default="">
<cfparam name="Form.GroupListCode"    default="">
<cfparam name="Form.Scoped"           default="edit">
<cfparam name="Form.Remarks"          default="0">
<cfparam name="Form.CandidateId"      default="">
<cfparam name="Form.ContractSalaryAmount"  default="0">

<cfparam name="url.action"            default="0">
<cfparam name="url.wf"                default="0">
<cfset client.contractreason = Form.GroupListCode>
<cfparam name="form.recordeffective"  default="#dateformat(now(),client.dateformatshow)#">

<cfif ParameterExists(Form.Delete)> 

   <cf_verifyOperational 
    module    = "Payroll" 
	Warning   = "No">
	
	<cfif Operational eq "1">
	
		<cfquery name="Contract" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   SELECT * 
			   FROM   PersonContract 
			   WHERE  ContractId  = '#Form.ContractCurrent#' 
		</cfquery>
	
 		<cfinvoke component="Service.Access"  
		   method="payrollofficer" 
		   mission="#Contract.Mission#"
		   returnvariable="accessPayroll">	
			 
		<cfif getAdministrator("#Contract.Mission#") eq "0" and accessPayroll neq "ALL"> 	  
			
			<!--- check if contract conflicts with a period that has been settled as part of the payroll already --->
			
			<cfquery name="Contract" 
			   datasource="AppsEmployee" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				   SELECT * 
				   FROM   PersonContract 
				   WHERE  ContractId  = '#Form.ContractCurrent#' 
			</cfquery>
				
			<cfquery name="Check" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				SELECT    ES.SalarySchedule, ES.PayrollStart, ES.PersonNo, ES.PayrollCalcNo, SSP.CalculationStatus, SSP.PayrollEnd
				FROM      EmployeeSalary AS ES INNER JOIN
		                  SalarySchedulePeriod AS SSP ON ES.Mission = SSP.Mission AND ES.SalarySchedule = SSP.SalarySchedule AND ES.PayrollStart = SSP.PayrollStart
				WHERE     ES.PersonNo           = '#Contract.PersonNo#'
				AND       ES.PayrollEnd        >= '#Contract.DateEffective#' 
				AND       SSP.CalculationStatus = '3'
				ORDER BY  ES.PayrollEnd DESC		
					
			</cfquery>
			
			<cfif Check.recordcount gte "1">
	
				<cf_tl id="Problem" var="1">
				<cfset msg1="#lt_text#">
	
				<cf_tl id="employee has been on payroll until the period ending" class="Message" var="1">
				<cfset msg2="#lt_text#">
				
				<cf_tl id="Contract removal can not be applied." class="Message" var="1">
				<cfset msg3="#lt_text#">
				
				<cf_message message="#msg1#, #msg2# #dateformat(check.PayrollEnd)#. #msg2#">
				<cfabort>
			
			</cfif>
								
		</cfif>
		
	</cfif>		

    <!--- ----------------------------- --->	
	<!--- REVERT SCRIPT---------------- --->
	<!--- ----------------------------- --->
	<cf_ContractEditSubmitRevert contractid="#Form.ContractCurrent#" qAction="Purge">
	<!--- ----------------------------- --->	
				
	<cfif url.action eq "1">
	
		<script>
			 window.close()
		</script>
		
	<cfelse>
	
		<cfoutput>
			<script LANGUAGE = "JavaScript">
				 window.location = "#SESSION.root#/staffing/application/employee/contract/EmployeeContract.cfm?ID=#Form.PersonNo#&mid=#mid#";
			</script>	
		</cfoutput>	
		
	</cfif>	
	
	<cfabort> 
	
<cfelseif form.actionCode eq "3002">	

    <!--- rescind, I think it is better to retire this action  --->

	<cfquery name="get" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
	    	  SELECT * 
			  FROM   PersonContract 		    
		      WHERE  ContractId  = '#Form.ContractCurrent#'  
	</cfquery>	

	<cfquery name="RevokeContract" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
	    	  UPDATE PersonContract 
		      SET    ActionStatus = '9'
		      WHERE  ContractId  = '#Form.ContractCurrent#'  
	</cfquery>	
	
	<cfquery name="RevokeEntitlement" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
	    	  UPDATE Payroll.dbo.PersonEntitlement
		      SET    Status = '9'
		      WHERE  ContractId  = '#Form.ContractCurrent#'  
	</cfquery>			
	
	<!--- rescind contract --->
						
    <cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
		   method         = "ActionDocument" 
		   PersonNo       = "#Form.PersonNo#"
		   Mission        = "#Form.Mission#"
		   ActionDate     = "#dateformat(get.DateEffective,CLIENT.DateFormatShow)#"
		   ActionCode     = "#form.actionCode#"
		   ActionSourceId = "#Form.ContractCurrent#"	
		   ActionLink     = "Staffing/Application/Employee/Contract/ContractEdit.cfm?ID=#form.personNo#&ID1="					  		
		   ActionStatus   = "1">		
		   
	<cfoutput>
		<script LANGUAGE = "JavaScript">
			 window.location = "#SESSION.root#/staffing/application/employee/contract/EmployeeContract.cfm?ID=#Form.PersonNo#&mid=#mid#";
		</script>	
	</cfoutput>		   
		
	<cfabort>   

<cfelse>

	<cf_tl id="Position not available for the requested period" class="Message" var="available">
	
	<cfif Len(Form.Remarks) gt 800>
	  <cfset remarks = left(Form.Remarks,800)>
	<cfelse>
	  <cfset remarks = Form.Remarks>
	</cfif>  
	
	<cfparam name="Fprm.CandidateId"             default="">
	<cfparam name="Form.SalaryBasePeriod"        default="0">
	<cfparam name="Form.EnforceFinalPay"         default="0">
	<cfparam name="Form.StepIncreaseDate"        default="">
	<cfparam name="Form.ContractType"            default="">
	<cfparam name="Form.ContractLevel"           default="">
	<cfparam name="Form.ContractStep"            default="1">
	<cfparam name="Form.GroupCode"               default="">
	<cfparam name="Form.GroupListCode"           default="">
	<cfparam name="Form.AppointmentStatusMemo"   default="">
	
	<cfif Form.ContractLevel eq "">
	
	    <cfoutput>
	    <script>
		   alert("No contract level selected..")
		   history.back()		  
	    </script>	
		</cfoutput>
		
		<cfabort>
	
	</cfif>
	
	<cfif Form.ContractType eq "">
	
	    <cfoutput>
	    <script>
		   alert("No contract type selected. Please check with your administrator.")
		   history.back()		  
	    </script>	
		</cfoutput>
		
		<cfabort>
	
	</cfif>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.DateEffective#">
	<cfset STR = dateValue>
	
	<!--- action effective date --->
	<cfset dateValue = "">
	<cfif form.recordeffective neq "">
		<CF_DateConvert Value="#Form.RecordEffective#">
		<cfset AEF = dateValue>
	<cfelse>
	    <!--- default is the start date of the period --->
	    <cfset AEF = STR>
	</cfif>	
	
	<cfset dateValue = "">
	<cfif Form.DateExpiration neq ''>
	    <CF_DateConvert Value="#Form.DateExpiration#">
	    <cfset END = dateValue>
	<cfelse>
	    <cfset END = 'NULL'>
	</cfif>	
	
	<cfset dateValue = "">
	
	<cfif Form.StepIncreaseDate eq "Auto">	
			
	  <cfquery name="getGrade" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_PostGrade
			WHERE  PostGrade   = '#Form.ContractLevel#' 			
		</cfquery>	
	
		<cfset STEP = dateadd("YYYY","#getGrade.PostGradeStepInterval#",STR)>		
	
	<cfelseif Form.StepIncreaseDate neq "">
	
	    <CF_DateConvert Value= "#Form.StepIncreaseDate#">
	    <cfset STEP = dateValue>
			
	<cfelse>
		
		<cfset STEP = "">	    
		
	</cfif>	
	
	<cfquery name="Contract" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   PersonContract
			WHERE  PersonNo    = '#Form.PersonNo#' 
			AND    ContractId  = '#Form.ContractId#' 
		</cfquery>
	
	<cfif form.ActionCode eq "" and Contract.recordcount eq "0">
	
		<cfoutput>
	    <script>
		   alert("You must select an action. Operation aborted.")
		   history.back()
	    </script>	
		
		</cfoutput>
		
		<cfabort>	
	
	</cfif>
	
	<cfparam name="Form.ServiceLocation" default="">
	
	<cfif STR gt END and END neq "NULL">
	
	    <cfoutput>
	    <script>
		   alert("Expiration date lies before effective date. Operation aborted.")
		   history.back()		  
	    </script>	
		</cfoutput>
		
		<cfabort>
	
	</cfif>
			
	<cf_verifyOperational 
		    datasource= "appsSystem"
		    module    = "Payroll" 
		    Warning   = "No">
					 
		<cfif operational eq "1">
			
			<cfquery name="Check" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			  	 SELECT    P.PostType, SM.PostType AS Required
				 FROM      PersonAssignment PA INNER JOIN
		                   [Position] P ON PA.PositionNo = P.PositionNo INNER JOIN
		                   Payroll.dbo.SalaryScheduleMission SM ON P.Mission = SM.Mission
				 WHERE     (PA.DateExpiration >= #STR#) 
				 AND       (PA.DateEffective <= #STR#) 
				 AND       (PA.PersonNo = '#FORM.PersonNo#') 
				 AND       (PA.AssignmentStatus IN ('0', '1')) 
				 AND       (SM.SalarySchedule = '#Form.SalarySchedule#') 
			</cfquery>	
				
			<cfif Check.required neq Check.Posttype and Check.required neq "">
			
					<cfoutput>
					<cf_tl id="Problem" var="1"> 
					<cfset msg1="#lt_text#">
		
					<cf_tl id="employee is assigned to a Position which may not used for a contract under schedule" class="Message" var="1">
					<cfset msg2="#lt_text#">
				
					<cf_message message="#msg1#, #msg2# #Form.SalarySchedule#.">
					</cfoutput>
					<cfabort>
				
			</cfif> 	
				
		</cfif>		
		
		<cfquery name="Check" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#"> 
			 SELECT * 
			 FROM   Ref_Action
			 WHERE  ActionCode = '#Form.ActionCode#'
		</cfquery>
		
		<cfif check.ModeEffective neq "1"> 
	
			<!--- verify if prior overlap record exist, which is not allowed --->
				
			<cfquery name="Verify" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     PersonContract
				WHERE    PersonNo = '#Form.PersonNo#' 
				<cfif end neq "NULL">
				AND      (DateEffective <= #END# AND DateExpiration >= #STR#) 
				<cfelse>
				AND      DateExpiration >= #STR# 
				</cfif>
				AND      Mission = '#Form.Mission#'
				AND      ContractId  != '#Form.ContractId#'   
				<cfif Form.ContractCurrent neq "">
				AND     Contractid != '#Form.ContractCurrent#'
				</cfif>
				AND 	 ActionStatus != '9' 
				
			</cfquery>
			
			<cfif Verify.recordcount gte "1">
			
				 <cf_tl id="ContractOverlaps" var="1" class="message">
				 <cfset tContractOverlaps = "#Lt_text#">
			
				 <cf_tl id="OperationNotAllowed" var="1" >
				 <cfset tOperationNotAllowed = "#Lt_text#">
				 
				<cf_message message="#tContractOverlaps# #dateFormat(verify.DateEffective, CLIENT.DateFormatShow)# - #dateFormat(verify.DateExpiration, CLIENT.DateFormatShow)#. <br>#tOperationNotAllowed#" return="back">
				<cfabort>
			
			</cfif>		
			
		<cfelse>
		
			<!--- Promotion mode allowing to go back further in time --->
				
			<cfquery name="Verify" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   MIN(DateEffective) as FirstEffective
				FROM     PersonContract
				WHERE    PersonNo      = '#Form.PersonNo#' 
				AND 	 ActionStatus != '9'				
				AND      Mission       = '#Form.Mission#'
				AND      ContractId   != '#Form.ContractId#'	
				<cfif Form.ContractCurrent neq "">
				AND     Contractid != '#Form.ContractCurrent#'
				</cfif>							
			</cfquery>
			
			<cfif Verify.FirstEffective gt str>
				 <cf_tl id="ContractOverlaps" var="1" class="message">
				 <cfset tContractOverlaps = "#Lt_text#">
			
				 <cf_tl id="OperationNotAllowed" var="1" >
				 <cfset tOperationNotAllowed = "#Lt_text#">
				 
				<cf_message message="#tContractOverlaps#. <br>#tOperationNotAllowed#" return="back">
				<cfabort>
			
			</cfif>			
		
		</cfif>	
			
		<cf_verifyOperational 
		    module    = "Payroll" 
			Warning   = "No">
			 
		<cfif Operational eq "1"> 	  
		
			<!--- check if contract conflicts with a period that has been part of the payroll already --->
			
			<cfquery name="Check" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					SELECT    TOP 1 ES.SalarySchedule, ES.PayrollStart, ES.PayrollEnd, ES.PersonNo, ES.PayrollCalcNo, SSP.CalculationStatus
					FROM      EmployeeSalary AS ES INNER JOIN
			                  SalarySchedulePeriod AS SSP ON ES.Mission = SSP.Mission AND ES.SalarySchedule = SSP.SalarySchedule AND ES.PayrollStart = SSP.PayrollStart
					WHERE     ES.PersonNo           = '#Form.PersonNo#'
					AND       ES.PayrollEnd        >= #STR# 
					AND       SSP.CalculationStatus = '3'
					ORDER BY  ES.PayrollEnd DESC		
					
			</cfquery>
			
			<cfinvoke component="Service.Access"  
			   method="payrollofficer" 
			   mission="#form.Mission#"
			   returnvariable="accessPayroll">	
			 
			<cfif getAdministrator("#form.Mission#") eq "1" or accessPayroll eq "ALL"> 	  
										
				<cfif Check.recordcount gte "1" and Check.salarySchedule neq Form.SalarySchedule>
				
					<cf_tl id="Problem" var="1"> 
					<cfset msg1="#lt_text#">
			
					<cf_tl id="employee has been on payroll for the period ending" class="Message" var="1">
					<cfset msg2="#lt_text#">	
					
					<cf_tl id="Contract should be recalculated." class="Message" var="1">
					<cfset msg3="#lt_text#">	
					
					<cfset message = "#msg1#, #msg2# #dateformat(check.PayrollEnd)#. <br>#msg3#">
													
				</cfif>
			
			<cfelse>
				
				<cfif Check.recordcount gte "1" and Check.salarySchedule neq Form.SalarySchedule>
					
					<cf_tl id="Problem" var="1"> 
					<cfset msg1="#lt_text#">
			
					<cf_tl id="employee has been on payroll for the period ending" class="Message" var="1">
					<cfset msg2="#lt_text#">	
					
					<cf_tl id="Contract should be recalculated." class="Message" var="1">
					<cfset msg3="#lt_text#">	
					
					<cfset message = "#msg1#, #msg2# #dateformat(check.PayrollEnd)#. <br>#msg3#">				
										
				</cfif>		
			
			</cfif>
									
		</cfif>		
		
		<cfparam name="url.wf" default="0">
		
		<cfquery name="Contract" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   PersonContract
			WHERE  PersonNo    = '#Form.PersonNo#' 
			AND    ContractId  = '#Form.ContractId#' 
		</cfquery>
		
										
		<cfif Contract.recordCount eq 1 and (ParameterExists(Form.Update) or url.wf eq "1")> 
															   			
			<cf_verifyOperational 
		         datasource= "appsSystem"
		         module    = "Payroll" 
				 Warning   = "No">
				 
			<cfif operational eq "1">
				<cfset Amount = Form.ContractSalaryAmount>
			</cfif>		
			
			<!--- ------------------------------------------------------------------------------------------------------------------ --->		
			<!--- updating is only allowed if a workflow is enabled, without workflow the edit is disabled as status = 1 upon saving --->
			<!--- ------------------------------------------------------------------------------------------------------------------ --->
								
			<cf_wfActive entitycode="PersonContract" 
				objectkeyvalue4="#contractid#" 
				datasource="AppsEmployee">	
			
			<cftransaction>
		
				<cfquery name="UpdateContract" 
				   datasource="AppsEmployee" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">	
				   		   
				   UPDATE PersonContract 
				   SET    RecordEffective        = #AEF#,
				          DateEffective          = #STR#,
						  DateExpiration         = #END#,			
						  ActionCode             = '#Form.ActionCode#',
						  
						  <cfif Form.groupCode neq "" and Form.grouplistcode neq "">
							GroupCode      =  '#Form.GroupCode#',
							GroupListCode  = '#Form.GroupListCode#',
						  <cfelse>
							GroupCode      =  NULL,
							GroupListCode  =  NULL,							 
						  </cfif>
						  	
						  ContractType           = '#Form.ContractType#',
						  AppointmentStatus      = '#Form.AppointmentStatus#',
						  AppointmentStatusMemo  = '#Form.AppointmentStatusMemo#',
						  ContractTime           = '#Form.ContractTime#', 
						  ReviewPanel            = '#Form.ReviewPanel#',
						  ContractLevel          = '#Form.ContractLevel#',
						  ContractStep           = '#Form.ContractStep#',						  
						  <cfif form.ContractFunctionNo neq "">
						  ContractFunctionNo          =  '#Form.ContractFunctionNo#',
						  </cfif>
						  <cfif form.ContractFunctionDescription neq "">
						  ContractFunctionDescription =  '#Form.ContractFunctionDescription#',
						  </cfif> 		
						  ContractStatus         = '#Form.ContractStatus#',
						  EnforceFinalPay        = '#Form.EnforceFinalPay#',
						  <cfif form.servicelocation neq "">
						  ServiceLocation        = '#Form.ServiceLocation#',
						  </cfif>
						  HistoricContract       = 0,						 
						  <cfif operational eq "1">							 
							 SalarySchedule         = '#Form.SalarySchedule#',						  	 
							 ContractSalaryAmount   = '#Amount#',
						  </cfif>
						  SalaryBasePeriod      = '#Form.SalaryBasePeriod#',
						  PersonnelActionNo     = '#Form.PersonnelActionNo#',
						  <cfif step eq "">
						  StepIncreaseDate      = NULL,
						  <cfelse>
						  StepIncreaseDate      = #STEP#,
						  </cfif>						  
						  Remarks               = '#Remarks#'
				   WHERE  PersonNo    = '#Form.PersonNo#' 
				   AND    ContractId  = '#Form.ContractId#' 
				</cfquery>
				
				<cfparam name="Form.WeekSelect" default="0">
			  
			    <cfif Form.weekselect eq "1">							  
				  <cfinclude template="ContractSchedule.cfm">						  
			    </cfif>
								
				<cfif form.scoped eq "edit">
				
					<!--- tag the prior contracts to be adjusted --->

					<cfinclude template="ContractEditSubmitPrior.cfm">
				
					<cfquery name="Check" 
					   datasource="AppsEmployee" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
				    	  SELECT * 
						  FROM   PersonAssignment 		    
						  WHERE  PersonNo    = '#Form.PersonNo#'
					      AND    ContractId  = '#Form.ContractId#'  
					</cfquery>
								
					<cfparam name="Form.ExtendAssignment" default="">
					
					<!--- refers to a checkbox in the contract edit screen : ContractAssignmentExtend.cfm --->
						
					<cfif Form.ExtendAssignment eq "">
					
					   <!--- we found an assignment linked to the contract, 
					   the user to not select an option to extend the contract, in that case 
					   we check if we should remove the assignment extension
					   once we know there is a prior record which could be restored  --->
					   					
					   <cfquery name="RevertPrior" 
						   datasource="AppsEmployee" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						      UPDATE PersonAssignment 
						      SET    AssignmentStatus = '1'
						      WHERE  PersonNo     = '#Check.PersonNo#'
							  AND    AssignmentNo = '#Check.SourceId#'  
					   </cfquery>				   		
					
						<cfquery name="DeleteRecord" 
						   datasource="AppsEmployee" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						      DELETE FROM PersonAssignment 		    
							  WHERE  PersonNo    = '#Check.PersonNo#'
						      AND    ContractId  = '#Form.ContractId#'  
						</cfquery>
														
					<cfelse>
					  				  		
						<cfinclude template="ContractAssignmentExtend.cfm">		
					  
					</cfif>
					
				</cfif>	
				
				<cfset ctid = Form.ContractId>
			 
			   <!--- make the leave  entries --->
			   <cfinclude template="ContractLeave.cfm">								   
				
			   <cfinclude template="ContractPayroll.cfm">   
			
			</cftransaction>
			   
		<cfelse>					
					
			<cf_verifyOperational 
		         datasource= "appsSystem"
		         module    = "Payroll" 
				 Warning   = "No">
				 
			 <cfif operational eq "1">
				<cfset Amount = Form.ContractSalaryAmount>
			</cfif>							
					
		    <!--- ---------------------------------------------------------------------- --->
			<!--- Recruitment track workflow embedded contracts, acts like like a create --->
			<!--- ---------------------------------------------------------------------- --->
								
			<cftransaction>				
						
			<!--- --------------- --->	
			<!--- insert contract --->	
			<!--- --------------- --->
			
			<cfquery name="Parameter" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      Ref_ParameterMission
				WHERE     Mission = '#Form.Mission#'		
			</cfquery>	
			
			<!--- assign the applied Contract number not the same as PA --->
			
			<cfif Contract.PersonnelActionNo neq "">
			
				<cfset pano = Contract.PersonnelActionNo>
			
			<cfelse>
			
				<cfparam name="Form.PersonnelActionNo" default="">
		
				<cfif Parameter.PersonActionEnable eq "0" or 
			      	  Parameter.PersonActionNo eq "" or 
					  Parameter.PersonActionPrefix eq "">
				
					<cfset pano = Form.PersonnelActionNo>
				
				<cfelse>
						
					<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
					
						<cfquery name="Parameter" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM Ref_ParameterMission
							WHERE Mission = '#Form.Mission#' 
						</cfquery>		
							
						<cfset No = Parameter.PersonActionNo+1>
						<cfif No lt 10000>
						     <cfset No = 10000+No>
						</cfif>
							
						<cfquery name="Update" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    UPDATE Ref_ParameterMission
							SET    PersonActionNo = '#No#'
							WHERE  Mission = '#Form.Mission#' 
						</cfquery>
					
					</cflock>
					
					<cfset left = ltrim(Parameter.PersonActionPrefix)>
					
					<cfif left neq "">
						<cfset pano = "#Parameter.PersonActionPrefix#-#No#">
					<cfelse>
					    <cfset pano = "#No#">
					</cfif>	
					
					<cfset pano = ltrim(pano)>
					
				</cfif>	
				
			</cfif>	
			
			<!--- initaliase variables to store --->
			
			<cfparam name="Form.AppointmentStatus" default="">
			<cfparam name="Form.ContractStep"      default="">
			<cfparam name="Form.ServiceLocation"   default="">
			
			<cfif Form.AppointmentStatus eq "" or Form.ContractStep eq "">										
				
				<cf_message message="A data collection error has occurred. Please close your application and try submitting your action again.">						
				<cfabort>
				
			</cfif>					
			
			<cfset ripple9 = "">
			<cfset ripple1 = "">
						
			<cfif form.scoped eq "edit">
			
				<!--- process existing records --->	
				<cfinclude template="ContractEditSubmitPrior.cfm">
			
			<cfelse>
			
				<cfset ripple9 = form.ContractCurrent>
				
				<cfquery name="UpdateContract" 
				   datasource="AppsEmployee" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					 UPDATE PersonContract
					 SET    ActionStatus = '9'
					 WHERE  ContractId = '#ripple9#'									
				</cfquery>	 
				
				<cfset ripple1 = "">
			
			</cfif>		
			
									
			<!--- check if exist --->
			
			<cfquery name="check_exist" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   PersonContract
				WHERE  PersonNo    = '#Form.PersonNo#' 
				AND    ContractId  = '#Form.ContractId#' 
			</cfquery>
									
			<cfif check_exist.recordcount gte "1">										
				
					<cf_message message="System detected a problem as a record has been created for the assigned contract id. Please inform your administrator if this problem persist after you close and reopen the contract tab." return="back">						
					<cfabort>
				
			</cfif>		
			
			<!--- record the new transaction contract entry --->			
												 
			<cfquery name="InsertContract" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     INSERT INTO PersonContract 
					         (ContractId,
							 ActionCode,
							 RecordEffective,
							 EnforceFinalPay,
							 GroupCode,
							 GroupListCode,
							 Mission,
							 PersonNo,
							 HistoricContract,
							 DateEffective,
							 DateExpiration,
							 ContractType,
							 AppointmentStatus,
							 AppointmentStatusMemo,
						     ContractFunctionNo,       
						     ContractFunctionDescription,
							 ReviewPanel,
							 ContractTime,
							 ContractLevel,
							 ContractStep,
							 ServiceLocation,
							 <cfif Operational eq "1"> 							 
							 SalarySchedule,
							 ContractSalaryAmount,
							 </cfif> 
							 SalaryBasePeriod,
							 PersonnelActionNo,		
							 StepIncreaseDate,
							 Remarks,
							 CandidateId,
							 ActionStatus,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
				  VALUES    ('#Form.ContractId#',
						     '#Form.ActionCode#', 
							 #AEF#,
							 '#Form.EnforceFinalPay#',
							 <cfif Form.groupCode neq "" and Form.grouplistcode neq "">
								 '#Form.GroupCode#',
								 '#Form.GroupListCode#',
							 <cfelse>
								 NULL,
								 NULL,							 
							 </cfif>
						     '#Form.Mission#',
						     '#Form.PersonNo#',
							 0,
					         #STR#,
							 #END#,
							 '#Form.ContractType#',
							 '#Form.AppointmentStatus#',
							 '#Form.AppointmentStatusMemo#',
							 <cfif form.ContractFunctionNo neq "">
						      '#Form.ContractFunctionNo#',
							 <cfelse>
							  NULL,
						     </cfif>  
							 <cfif form.ContractFunctionDescription neq ""> 
						      '#Form.ContractFunctionDescription#',
							 <cfelse>
							  NULL,
						     </cfif> 		
							 '#Form.ReviewPanel#',
							 '#Form.ContractTime#',
							 '#Form.ContractLevel#',
							 '#Form.ContractStep#',
							 <cfif form.servicelocation neq "">
							 '#Form.ServiceLocation#',
							 <cfelse>
							 NULL,
							 </cfif>
							 <cfif Operational eq "1"> 						  
							 '#Form.SalarySchedule#',
							 '#amount#',
							 </cfif> 
							 '#FORM.SalaryBasePeriod#',
							 '#pano#',	
							  <cfif step eq "">
							  NULL,
							  <cfelse>
							  #STEP#,
							  </cfif>		 
							 '#Remarks#',
							 <cfif Form.CandidateId neq "">
							 '#Form.CandidateId#',
							 <cfelse>
							 NULL,
							 </cfif>
							 '0',
							 '#SESSION.acc#',
					    	 '#SESSION.last#',		  
						  	 '#SESSION.first#')							 
			  </cfquery>
			  
			  <cfparam name="Form.PositionNo" default="">
			  
			  <cfif form.scoped eq "edit">
			  
				  <cfif Form.PositionNo neq "">
				  
				  <!--- check if position is valid and is free for the requested dates --->
				  
				  <!--- add new assignment --->
				  
					  <cfquery name="checkPosition" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT *
						FROM   Position P
						WHERE  PositionNo = '#Form.PositionNo#' <!--- drives the period and the entity --->
						AND    DateEffective  <= #STR#
						AND    DateExpiration >= #END#
						AND    PositionNo NOT IN (SELECT PositionNo 
						                          FROM   PersonAssignment
												  WHERE  PositionNo = P.PositionNo
												  AND    AssignmentStatus IN ('0','1')
												  AND    AssignmentClass = 'Regular'
												  AND    Incumbency > 0
												  <!--- prevent overlap --->
												  AND    (
												         (DateEffective <= #STR# and DateExpiration >= #STR#)
												         OR
														 (DateEffective <= #END# and DateExpiration >= #END#)
														 )		
												)		 		
					</cfquery>
					
					<cfif CheckPosition.recordcount eq "0">
										
						<cf_message message="#available#" return="back">
						<cfabort>
					
					<cfelse>
					
						<cfquery name="InsertAssignment" 
					     datasource="AppsEmployee" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     INSERT INTO PersonAssignment
						         (PersonNo,
								 PositionNo,
								 DateEffective,
								 DateExpiration,
								 OrgUnit,
								 LocationCode,
								 FunctionNo,
								 FunctionDescription,
								 AssignmentStatus,
								 AssignmentClass,
								 AssignmentType,
								 Incumbency,
								 ContractId,
								 Source,													 							
								 Remarks,
								 DateArrival,
								 DateDeparture,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
						  VALUES ( '#Form.PersonNo#',
						           '#Form.PositionNo#',
								    #STR#,
								    #END#,
									'#checkPosition.OrgUnitOperational#',
									'#checkPosition.LocationCode#',
									'#checkPosition.FunctionNo#',
									'#checkPosition.FunctionDescription#',
									'0',
									'Regular',
									'Actual',
									'100',
									'#Form.ContractId#',
									'Contract Entry',								
									'New contract',
									#STR#,
								    #END#,
									'#SESSION.acc#',
						    	    '#SESSION.last#',		  
							  	    '#SESSION.first#'
								 )	
						 </cfquery>		
					
					</cfif>
							  
				  </cfif>
			  
				  <cfparam name="Form.ExtendAssignment" default="">
				  
				  <cfif ExtendAssignment neq "">
				  
				  		<cfinclude template="ContractAssignmentExtend.cfm">					  
				  
				  </cfif>
				  
			  </cfif>	  
			  
			  <cfparam name="Form.WeekSelect" default="0">
			  
			  <cfif Form.weekselect eq "1">							  
				  <cfinclude template="ContractSchedule.cfm">						  
			  </cfif>
			 			  					
			  <cfset ctid = Form.ContractId>
			  
			  <!--- make the payroll entries --->
			  <cfinclude template="ContractPayroll.cfm">
			   <!--- make the leave  entries --->
			  <cfinclude template="ContractLeave.cfm">
			  	
			  <!--- ------------------------ --->				  
			  <!--- determine type of action --->
			  <!--- ------------------------ --->
			  				  
			  <cfquery name="Current" 
				   datasource="AppsEmployee" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   SELECT * 
				   FROM   PersonContract 
				   WHERE  ContractId  = '#Form.ContractCurrent#' 
			  </cfquery>									 
			  
			  <!--- check which effective date to be issued to the action --->
			  
			   <cfquery name="Action" 
				 datasource="AppsEmployee" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					SELECT * 
					FROM   Ref_Action 
					WHERE  ActionCode = '#form.actionCode#' 
			  </cfquery>
			  						  
			  <cfif Action.ModeEffective eq "2">
				   <cfset date = "#Form.DateExpiration#">			  
			  <cfelse>
				   <cfset date = "#Form.DateEffective#">			  
			  </cfif>	
			  
			  <!--- ---------------------------------------------- --->
			  <!--- action for amended contract------------------- --->
			  <!--- ---------------------------------------------- --->
			 	 

			  <cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
					   method             = "ActionDocument" 
					   PersonNo           = "#Form.PersonNo#"
					   Mission            = "#Form.Mission#"
					   ActionCode         = "#form.actionCode#"
					   ActionDate         = "#date#"
					   ActionLink         = "Staffing/Application/Employee/Contract/ContractEdit.cfm?ID=#form.personNo#&ID1="
					   ActionSourceId     = "#ctid#"	
					   Ripple1            = "#ripple1#"
					   Ripple9            = "#ripple9#"					 		 
					   ActionStatus       = "1">						   
											   
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
					 WHERE    EntityCode     = 'PersonContract'  
					 AND      Mission        = '#Form.Mission#' 
			</cfquery>
			
			<!---
			<cfquery name="EntityClass" 
			   datasource="AppsEmployee" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			      SELECT * 
				  FROM   Ref_ContractType
				  WHERE  ContractType =  '#Form.ContractType#'	
				  <!--- published workflow --->	    			
				  AND    EntityClass IN (SELECT EntityClass
										 FROM   Organization.dbo.Ref_EntityClassPublish
									 	 WHERE  EntityCode = 'PersonContract') 
				  						 
			</cfquery>
			--->
							  
			<cfif CheckMission.WorkflowEnabled eq "0" 
			      or CheckMission.recordcount eq "0">
	        
					<!--- no workflow or no workflowendable,
					    clear the transaction immediately to status = 1 --->
					
					<cfif url.wf eq "0">
										
						<cfquery name="Update" 
						   datasource="AppsEmployee" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						   	  UPDATE PersonContract
							  SET    ActionStatus = '1'
							  WHERE  PersonNo    = '#FORM.PersonNo#' 
						      AND    ContractId  = '#Form.ContractId#' 	 
						</cfquery>
						
						<!--- ---------------------------------------- --->
						<!--- update also the extend assignment record --->
						<!--- ---------------------------------------- --->
						
						<cfquery name="Update" 
						   datasource="AppsEmployee" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						   	  UPDATE PersonAssignment
							  SET    AssignmentStatus = '1'
							  WHERE  PersonNo         = '#FORM.PersonNo#' 
						        AND  (ContractId      = '#Form.ContractId#' and ContractId is not NULL)	 
						</cfquery>
					
					</cfif>
			
		  	  <cfelse>
			  			  
				  <cfquery name="Person" 
				 	datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Person
						WHERE  PersonNo = '#Form.PersonNo#' 
			 	  </cfquery>
				  				 				  				  					
				  <cfset link = "Staffing/Application/Employee/Contract/ContractEdit.cfm?id=#form.personNo#&id1=#Form.Contractid#">
				
				  <cf_ActionListing 
					    EntityCode       = "PersonContract"
						EntityClass      = "#Action.EntityClass#"
						EntityGroup      = ""
						EntityStatus     = ""
						Mission          = "#Form.mission#"
						PersonNo         = "#Form.PersonNo#"						
						ObjectReference  = "#Form.ContractLevel#/#Form.ContractStep#"
						ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
						ObjectFilter     = "#Form.ActionCode#"
					    ObjectKey1       = "#Form.PersonNo#"
						ObjectKey4       = "#Form.ContractId#"
						ObjectURL        = "#link#"
						Show             = "No">
						
			  </cfif>		   
				  
		</cfif>

</cfif>	   

<cfif url.wf neq "1">

	

	<cfparam name="message" default="">
	
	<cfif message neq "">
	
		<cf_message message="#message#" return="click" 
		script="window.location = '#SESSION.root#/staffing/application/employee/contract/EmployeeContract.cfm?ID=#Form.PersonNo#&mid=#mid#'">
	
	<cfelse>
			  
		<cfoutput>
			
			<script>
				 window.location = "#SESSION.root#/staffing/application/employee/contract/EmployeeContract.cfm?ID=#Form.PersonNo#&mid=#mid#";
			</script>	
			
		</cfoutput>	   
		
	</cfif>
	
</cfif>  	

