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
<!--- Script to generate contract extensions --->
<!--- -------------------------------------- --->

<!--- Looking for the last contract for participating missions only --->

<cfsavecontent variable="LastValidContract">
	
	<cfoutput>
	
		SELECT PC.PersonNo, PC.Mission,
			   MAX(pc.DateEffective) as DateEffective		
		FROM   PersonContract PC 
		WHERE  PC.ContractStep >= '01'
		AND    PC.Mission in	(
				  SELECT Mission
				  FROM   Ref_ParameterMission
				  WHERE  BatchStepIncrement = '1'		
			    )	
		AND    PC.ActionStatus = '1'		
		AND    PC.HistoricContract = '0'
		GROUP BY PC.PersonNo, PC.Mission 
		
	</cfoutput>	

</cfsavecontent>

<cfquery name="getDueIncrements"
		 datasource="AppsEmployee"  
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 
		SELECT   *, ISNULL(DateExpiration,'2050-12-31') as DateExpirationEnd
		FROM     PersonContract PC INNER JOIN (#preserveSingleQuotes(LastValidContract)#) A1
				   ON  PC.PersonNo        = A1.PersonNo 
				   AND PC.Mission         = A1.Mission
			       AND PC.DateEffective   = A1.DateEffective 
		WHERE    PC.StepIncreaseDate >= getDate()-10
		AND      PC.StepIncreaseDate <= getDate()+10 
		
		<!--- process only if the last record is cleared --->
		
		AND      PC.ActionStatus  = '1'	
		
		<!--- added by hanno to prevent we extend beyond the contract --->
		
		AND      (PC.StepIncreaseDate < PC.DateExpiration OR PC.DateExpiration is NULL) 
		
		AND      PC.HistoricContract = '0'
		
		<!--- added provision to disable step increase if the month of the expiration is the same as the month of the step increase --->
		
		AND      MONTH(PC.StepIncreaseDate) != MONTH(PC.DateExpiration)										
	<!---  disabled for now AND PC.StepIncrease = 1 --->
	
	
		
</cfquery>

<cfloop query="getDueIncrements">

	<cfset ripple1 = "">

	<cfset dateValue = "">
	
	 <cfquery name="getGrade" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_PostGrade
			WHERE  PostGrade   = '#ContractLevel#' 			
	</cfquery>
		
	<cfset vContractStep       = ContractStep>	
	<cfset vDateExpiration     = DateAdd("d",-1,StepIncreaseDate)>
	<cfset DateNextEffective   = DateAdd("d",0,StepIncreaseDate)>		
	<cfset DateNextExpiration =  DateAdd("d",0,DateExpirationEnd)>	
	
	<!--- <cfset DateNextExpiration = DateAdd("d",-1,vDateNextIncrease)>--->
	<!--- remains unchanged --->
	
	<!--- obtain the valid steps --->
	
	<cfquery name="StepList" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT *
		  FROM   Ref_PostGradeStep
		  WHERE  PostGrade = '#ContractLevel#'
		  AND    DateEffective IN (
					SELECT   MAX(DateEffective) 
					FROM     Ref_PostGradeStep
					WHERE    PostGrade      = '#ContractLevel#'
					AND      DateEffective <= #DateNextEffective#
					 )		
		  ORDER BY Step						
	</cfquery>
	
	<cfif steplist.recordcount eq "0">
	
			<!--- default increment period set on the grade level --->	
						
			<cfset LongevityVerify = vContractStep+1>
			<cfif LongevityVerify lt getGrade.PostGradeSteps and getGrade.PostGradeSteps gte "1">
			
				<cfset vContractStep = vContractStep+1>
				<cfif len(vContractStep) eq "1">
					<cfset vContractStep = "0#vContractStep#">
				</cfif>
				
			<cfelse>
			
				<!--- no change --->
				<cfset vContractStep = vContractStep>	
				
			</cfif>	
			
			<cfset DateNextIncrease    = DateAdd("yyyy","#getGrade.PostGradeStepInterval#",StepIncreaseDate)>
			
	<cfelse>	
	
		<cfquery name="getNextStep" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT TOP 1 *
		  FROM   Ref_PostGradeStep
		  WHERE  PostGrade = '#ContractLevel#'
		  AND    Step      > '#vContractStep#'
		  AND    DateEffective IN (
					SELECT   MAX(DateEffective) 
					FROM     Ref_PostGradeStep
					WHERE    PostGrade      = '#ContractLevel#'
					AND      DateEffective <= #vDateExpiration#
					 )		
		  ORDER BY Step						
		</cfquery>
	
		<cfif getNextStep.recordcount gte "1">
		
			<cfset vContractStep = getNextStep.Step>	
		
		<cfelse>
		
			<!--- no change --->
			<cfset vContractStep = vContractStep>		
			
		</cfif>	
	
		<cfquery name="getStepInterval" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT *
		  FROM   Ref_PostGradeStep
		  WHERE  PostGrade = '#ContractLevel#'
		  AND    Step      = '#vContractStep#'
		  AND    DateEffective IN (
					SELECT   MAX(DateEffective) 
					FROM     Ref_PostGradeStep
					WHERE    PostGrade      = '#ContractLevel#'
					AND      DateEffective <= #vDateExpiration#
					 )		
		  ORDER BY Step						
		</cfquery>
	
		<!--- default increment period set on the grade level --->			
		
		<cfif getStepInterval.StepInterval eq "0">
		    <cfset DateNextIncrease    = "">
		<cfelse>
			<cfset DateNextIncrease    = DateAdd("yyyy","#getStepInterval.StepInterval#",StepIncreaseDate)>
		</cfif>	
	
	</cfif>
	
	<!--- we only create a record if the step is different AND if effective date of the step increase is different from the 
	effective date of the line that triggers it as this is certainly not correctly recorded for the step increase --->
			
	<cfif vContractStep neq contractStep and DateNextEffective neq DateEffective>	
		
		 <cf_verifyOperational 
    					module    = "Payroll" 
						Warning   = "No">
		
				
		<cftransaction>
		
		<cf_assignid>
		
		<cfset newcontractid = rowguid>
		
		<cfset form.PersonNo   = PersonNo>
		<cfset form.Mission    = Mission>
		<cfset form.ContractId = newcontractid>
		<cfset STR             = dateNextEffective>
		<cfset END             = "NULL">
					
		<cfinclude template="../../Contract/ContractEditSubmitPrior.cfm">
			
		<!------- 3004 : Increment within GRADE ----->			
		
		<cfquery name="second" 
		    datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		
			INSERT INTO PersonContract (
					PersonNo,
					ContractId,
					Mission,
					DateEffective,
					DateExpiration,
					ContractType,
					ContractTime,
					ContractStatus,
					AppointmentStatus,
					AppointmentStatusMemo,
					ContractSalaryAmount,					
					SalarySchedule,
					SalaryBasePeriod,
					ContractFunctionNo,
					ContractFunctionDescription,
					ContractLevel,
					ContractStep,
					ServiceLocation,	
					StepIncrease,
					StepIncreaseDate,
					ActionStatus,
					ActionCode,
					PersonnelActionNo,
					EnforceFinalPay,
					ReviewPanel,
					HistoricContract,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName )
					
			SELECT  PersonNo,
					'#newcontractid#',
					Mission,
					#dateNextEffective#,
					<cfif dateNextExpiration neq "2050/12/31">
						#dateNextExpiration#, 
					<cfelse>
						NULL,
					</cfif>
					ContractType,
					ContractTime,
					ContractStatus,
					AppointmentStatus,
					AppointmentStatusMemo,
					ContractSalaryAmount,					
					SalarySchedule,
					SalaryBasePeriod,
					ContractFunctionNo,
					ContractFunctionDescription,		
					ContractLevel,
					'#vContractStep#',
					ServiceLocation,					
					'1',
					<cfif DateNextIncrease eq "">
					NULL,
					<cfelse>
					#dateNextIncrease#,
					</cfif>					
					'0',
					'3004',
					PersonnelActionNo,
					EnforceFinalPay,
					ReviewPanel,
					'0',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#'
					
			FROM    PersonContract
			WHERE   ContractId = '#ContractId#'
			
		</cfquery>
		
		 <!--- create a new record for the old contract for the still valid period --->
				
		<cfquery name="BackupRecord" 
		   datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
				 INSERT INTO Payroll.dbo.PersonEntitlement	(
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
								 Created )
						 		 
				  SELECT PersonNo, 							 
						 #dateNextEffective#, 
						 #dateNextExpiration#,
						 SalarySchedule, 
						 EntitlementClass, 
						 SalaryTrigger, 
						 PayrollItem, 
						 Period, 
						 Currency, 
						 Amount, 
                         DocumentReference, 
						 Remarks, 
						 '1', 
						 '#newcontractid#', <!--- newly added contract --->
						 ActionReference, 
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName, 
						 Created	
								 							 
				 FROM    Payroll.dbo.PersonEntitlement		
						 			 
				 WHERE   ContractId = '#ContractId#'	
						 							
		</cfquery>		
					
		<!--- create a PA Action Log --->
		
		<cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
				method             = "ActionDocument" 
				PersonNo           = "#PersonNo#"
				Mission            = "#Mission#"
				ActionCode         = "3004"
				ActionLink         = "Staffing/Application/Employee/Contract/ContractEdit.cfm?ID=#personNo#&ID1="
				ActionDate         = "#dateformat(dateNextEffective,client.dateformatshow)#"
				ActionSourceId     = "#newcontractid#"	
				Ripple1            = "#ripple1#"					  
				Ripple9            = "#ContractId#"					 		 
				ActionStatus       = "1">	
				
		</cftransaction>		
		
		<cf_ScheduleLogInsert
		    Datasource     = "AppsEmployee"
		   	ScheduleRunId  = "#schedulelogid#"
			Description    = "WIGI : #PersonNo# #dateformat(dateNextEffective,client.dateformatshow)# step : #vContractStep#"
			StepStatus     = "1">		
				   
		<!--- create a workflow object --->  
	
		<cfset link = "Staffing/Application/Employee/Contract/ContractEdit.cfm?id=#PersonNo#&id1=#newcontractid#">
		 
		<!--- workflow enabled --->
		 
		<cfquery name="CheckMission" 
			 datasource="AppsEmployee"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
					 SELECT   *
					 FROM     Organization.dbo.Ref_EntityMission 
					 WHERE    EntityCode     = 'PersonContract'  
					 AND      Mission        = '#Mission#' 
		</cfquery>
			
		<cfquery name="EntityClass" 
			   datasource="AppsEmployee" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			      SELECT * 
				  FROM   Ref_ContractType
				  WHERE  ContractType =  '#ContractType#'	
				   <!--- published workflow --->	    			
				  AND    EntityClass IN (SELECT EntityClass
										 FROM   Organization.dbo.Ref_EntityClassPublish
									 	 WHERE  EntityCode = 'PersonContract') 
				  						 
		 </cfquery>
				
		   <cfif CheckMission.WorkflowEnabled eq "0" 
			      or CheckMission.recordcount eq "0" 
				  or EntityClass.Recordcount eq "0">
				 		 
		 	<cfquery name="Update" 
			   datasource="AppsEmployee" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   	  UPDATE PersonContract
				  SET    ActionStatus = '1'
				  WHERE  PersonNo     = '#PersonNo#'
			        AND  ContractId   = '#newcontractid#'	 
			</cfquery>	
		 
		 <cfelse>		
				 
	 		  <cfquery name="Person" 
			 	datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM Person
					WHERE PersonNo = '#PersonNo#' 
		 	  </cfquery>
		   
			 <cf_ActionListing 
				    EntityCode       = "PersonContract"
					EntityClass      = "#EntityClass.EntityClass#"
					EntityGroup      = ""
					EntityStatus     = ""
					Mission          = "#Mission#"
					PersonNo         = "#PersonNo#"
					ObjectReference  = "Step Increment #ContractLevel#/#vContractStep#"
					ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
				    ObjectKey1       = "#PersonNo#"
					ObjectKey4       = "#newcontractid#"
					ObjectURL        = "#link#"
					Show             = "No"
					CompleteFirst    = "No">
				
		  </cfif>		
		  
	<cfelse>
	
		  <cf_ScheduleLogInsert
		   	ScheduleRunId  = "#schedulelogid#"
			Datasource     = "AppsEmployee"
			Description    = "Skipped : #PersonNo# #dateformat(dateNextEffective,client.dateformatshow)# step : #vContractStep#"
			StepStatus     = "1">	
				
	</cfif>		
	
</cfloop>

