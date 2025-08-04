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
		
<html><head><title>Payroll Calculation</title></head><body>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="url.processno"    default="">
<cfparam name="url.PersonNo"     default="">
<cfparam name="FORM.PersonNo"    default="#url.personNo#">
<cfparam name="url.enforce"      default="0">
<cfparam name="url.dateEff"      default="">
<cfparam name="url.selectedid"   default="">
<cfparam name="wffinal"          default="0">
<cfparam name="url.forcesettle"  default="0"> <!--- maintenance setting --->

<!--- set the modality under which this payroll process is run --->

<cfif form.PersonNo eq "">
	<!--- this is the normal batch processing of one or more months followed by settlement --->
	<cfset processmodality = "InCycleBatch">	
<cfelseif wffinal neq "0">
	<!--- this is the process to be run inside the final payment workflow in the portal that has to generate
	an off cycle after the incycle portion was processed --->
	<cfset processmodality = "WorkflowFinal">	
		
	<cfset dateValue = "">
	<CF_DateConvert Value="#url.dateEff#">
	<cfset DEFF = createDate(year(dateValue),month(dateValue),"1")>
	
<cfelseif url.enforce eq "1"> 		
    <!--- this is a modality to enforce settlement for whatever is to be settled and creates a workflow ---> 
	<cfset processmodality = "PersonalForce">
	
    <cfset dateValue = "">
	<CF_DateConvert Value="#url.dateEff#">
	<cfset DEFF = createDate(year(dateValue),month(dateValue),"1")>
	
<cfelse>
	<!--- this is a normal recalculation, no different than one within the batch but then for one person ---> 
	<cfset processmodality = "PersonalNormal">
</cfif>


<!--- clean prior version of this log file --->

<cfquery name="ClearLog"
 datasource="AppsPayroll" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	DELETE FROM CalculationLogSettlementLine
	WHERE  ProcessNo = '#url.processno#'	
	
	-- DELETE FROM CalculationLogSalaryLine
	-- WHERE  ProcessNo = '#url.processno#'	

	DELETE FROM CalculationLog
	WHERE  ProcessNo = '#url.processno#'	
</cfquery>

<!--- checking processing --->

<cfquery name="Calculation"
 datasource="AppsPayroll" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT    TOP 1 Created
	FROM      CalculationLog
	WHERE     ActionStatus     = 0 
	AND       ProcessNo != '#url.processno#'
	ORDER BY  Created DESC
</cfquery>

<!--- currently all tables are personalised in appstransaction; this condition prevents overlapping calculations
but was disabled for STL on 7/22/2019. It can be re-enabled, but for now we keep it open : Hanno van Pelt

<cfif calculation.recordcount gt "0" and getAdministrator("*") eq "0">
	
	<cfset d = DateDiff("n", Calculation.Created, now())>
	
	<cfif d lte "1">
	
		<!--- create log container --->
	
		<cfquery name="InsertProcessBatch"
		 datasource="AppsPayroll" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			INSERT INTO CalculationLog
					(ProcessNo,
					 ProcessClass,
					 ProcessBatchId,				
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			VALUES
					('#url.ProcessNo#',
					 'calculation',
					 '00000000-0000-0000-0000-000000000000',						
					 '#SESSION.acc#',
					 '#SESSION.last#',
					 '#SESSION.first#')			
		</cfquery>
	
		<cfquery name="Update"
		 datasource="AppsPayroll" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			    UPDATE CalculationLog 
				SET    ActionStatus = '9',
				       ActionMemo = 'Another process is still running, please try again later'				    
				WHERE  ProcessNo  = '#url.processno#'				
		</cfquery>
				
		<cfabort>
		
	</cfif>

</cfif>

--->


<cfif processmodality neq "InCycleBatch">

	<cfinvoke component = "Service.Process.Employee.PersonnelAction"
			    Method          = "getEOD"
			    PersonNo        = "#Form.PersonNo#"
				Mission         = "#url.mission#"
			    ReturnVariable  = "EOD">	
				
	<cfif isDefined ("url.customStart") and url.customStart neq "">
	
			<cfset dateValue = "">
			<CF_DateConvert Value="#url.customStart#">
			<cfset str = dateValue>		
			
	<cfelse>
	
			<cfset str = EOD>			
			
	</cfif>		
	
	<cfif isDefined ("url.customEnd") and url.customEnd neq "">
	
			<cfset dateValue = "">
			<CF_DateConvert Value="#url.customEnd#">
			<cfset end = dateValue>		
			
	<cfelse>
	
			<cfset end = "">			
			
	</cfif>		
	
	<!--- determine the period of calculation of entitlements			

		<cfquery name="selPeriod" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    <cfif isDefined ("url.customStart") and url.customStart neq "">	<!--- defined in the interface to calculate fro a person --->			
				  	  #str# as PeriodStart, 				 
					  <cfelse>	<!--- through the workflow final payment process --->			  
					  #EOD# as PeriodStart, 	
				      </cfif>
					  <!--- Hanno 6/10 : adjust in case of a found period in the payroll action --->
				      isNULL(DateExpiration+3000,'2050/12/31') as PeriodEnd
					  
			 FROM     PersonContract
			 WHERE    Mission        = '#url.mission#'	
			 AND      SalarySchedule = '#Contract.salaryschedule#' 
			 AND      PersonNo       = '#Form.PersonNo#'
			 AND      RecordStatus  = '1'  <!--- was actionstatus and that was incorrect 25/6/2019 --->
			 ORDER BY DateEffective DESC 	 
		</cfquery>		
	
		<cfif selPeriod.recordcount eq 0>
			
			<cfoutput>
			There is no contract record defined for PersonNo : #Form.PersonNo# - #url.mission#
			</cfoutput>
			<cfabort>
			
		</cfif>
	
	--->	
	
</cfif>

<cfif processmodality eq "InCycleBatch" and url.selectedid eq "">

		<!--- create log container --->
	
		<cfquery name="InsertProcessBatch"
		 datasource="AppsPayroll" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			INSERT INTO CalculationLog
				(ProcessNo,
				 ProcessClass,
				 ProcessBatchId,				
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
			VALUES
				('#url.processno#',
				 'calculation',
				 '00000000-0000-0000-0000-000000000000',						
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')			
		</cfquery>
	
		<cfquery name="Update"
		 datasource="AppsPayroll" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			    UPDATE    CalculationLog 
				SET       ActionStatus = '9',
				          ActionMemo = 'Sorry, no payroll period(s) were selected'			    
				WHERE     ProcessNo = '#URL.ProcessNo#'
		</cfquery>
		
		<cfabort>
 				
</cfif>


<!--- determine the calculation --->
 
<cfquery name="Calculation"
 datasource="AppsPayroll" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#"> 
 
    SELECT   *
	
	FROM     SalaryScheduleMission M, 
	         SalarySchedulePeriod P, 
		     SalarySchedule S			
	
	<cfif processmodality eq "InCycleBatch">			
		
	<!--- common in-cycle batch --->
	
	WHERE    P.CalculationId IN (#preserveSingleQuotes(url.selectedid)#) 
	AND      M.SalarySchedule = P.SalarySchedule
	AND      M.Mission        = P.Mission
	AND      M.SalarySchedule = S.SalarySchedule
	ORDER BY P.SalarySchedule, P.PayrollStart
	
	<cfelseif processmodality eq "PersonalForce" or processmodality eq "PersonalNormal">
	
		<!--- manual calculation ---> 
		
		<!--- personal / manual calculation --->
			
		WHERE    P.CalculationId IN (SELECT  CalculationId 
									 FROM    SalarySchedulePeriod SSP
									 WHERE   Mission              = '#url.mission#'
									 
									 <!--- in this mode 
									 we re-evaluate all schedules for this person since his/her first appointment date found 
									 to include recalculation of incorrectly paid stuff under a wrong schedule --->
									 
									 AND     SalarySchedule    IN  ( SELECT SalarySchedule
																	 FROM   Employee.dbo.PersonContract
																     WHERE  PersonNo        = '#Form.Personno#'	
																	 AND    (ActionStatus   = '1' OR RecordStatus = '1')
																	 AND    Mission         = '#url.mission#'
																	 <cfif processmodality eq "PersonalForce">
																	 AND    DateEffective  <= SSP.PayrollEnd		
																	 <cfelseif processmodality eq "PersonalNormal">
																	 <!--- we take only periods to calculate that are relevant for this person --->
																	 AND    DateEffective  <= SSP.PayrollEnd																 
																	 AND    (DateExpiration >= SSP.PayrollStart OR DateExpiration is NULL)
																	 </cfif>														 
																	 ) 
																	 
																	 
									 AND     PayrollStart >= #str#	
									 <cfif end neq "">
									 AND     PayrollStart   <= #end#
									 </cfif>
									 
									 <!--- selected in the form for periods to be calculated --->							 								 
									 <!---  AND     PayrollEnd   <= '#selPeriod.PeriodEnd#'	--->
									 								 						
									 
									) 
		<cfif processmodality eq "PersonalNormal">							
		AND      CalculationStatus != '0'	
		</cfif>
		AND      M.SalarySchedule  = P.SalarySchedule
		AND      M.Mission         = P.Mission
		AND      M.SalarySchedule  = S.SalarySchedule
				
		ORDER BY P.PayrollStart,P.SalarySchedule
		
													
	<cfelseif processmodality eq "WorkflowFinal">	
	
		<!--- final payment workflow to obtain periods to be calculated --->	
		
	    <cfset fst = dateAdd("d",  -31,  wffinal)>
		<cfset fed = dateAdd("d",  +31,  wffinal)>
					
		WHERE    P.CalculationId IN (SELECT   CalculationId 
									 FROM     SalarySchedulePeriod
									 WHERE    Mission              = '#url.mission#'
									 AND      SalarySchedule       = '#url.salaryschedule#'
									 
									 <!--- adjusted to take a safe margin of calculation of the final payroll to be considered --->
									 AND      PayrollEnd   >= #fst# 
									 AND      PayrollStart <= #fed#
									 
									 )										  
											
		AND      M.SalarySchedule = P.SalarySchedule
		AND      M.Mission        = P.Mission
		AND      M.SalarySchedule = S.SalarySchedule
		
		ORDER BY P.PayrollStart,P.SalarySchedule	
												
	</cfif>	
							
</cfquery>	

<cfif Calculation.recordcount eq 0>

		<!--- incycle batch --->

		<cfquery name="InsertProcessBatch"
		 datasource="AppsPayroll" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			INSERT INTO CalculationLog
			
				   (ProcessNo,
					 ProcessClass,
					 ProcessBatchId,				
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
					 
			VALUES ('#url.ProcessNo#',
				    'calculation',
				    '00000000-0000-0000-0000-000000000000',						
				    '#SESSION.acc#',
				    '#SESSION.last#',
				    '#SESSION.first#')			
		</cfquery>
	
		<cfquery name="Update"
		 datasource="AppsPayroll" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			    UPDATE CalculationLog 
				SET    ActionStatus = '9',
				       ActionMemo   = 'Nothing to calculate for person in entity #url.mission#'
				WHERE  ProcessNo    = '#url.processno#'				
		</cfquery>
				
		<cfabort>	
		
</cfif>

<!--- verify consequitive periods --->

<cfset calc = "1">

<cfoutput query="Calculation" group="SalarySchedule">	
	
    <cfset s = "#DateFormat(PayrollStart,CLIENT.DateSQL)#">
	
	<cfoutput>
		<cfif DateFormat(PayrollStart,CLIENT.DateSQL) neq s>
		    <cfset calc = "0">
		</cfif>
		<cfset next = DateAdd("d", "1", "#PayrollEnd#")>
		<cfset s = "#DateFormat(next,CLIENT.DateSQL)#">	
		
	</cfoutput>

</cfoutput>	

<cfif calc eq "0">
	
	<!--- create log container --->
	
		<cfquery name="InsertProcessBatch"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO CalculationLog
				(ProcessNo,
					ProcessClass,
					ProcessBatchId,				
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName)
			VALUES
				('#url.processno#',
					'calculation',
					'00000000-0000-0000-0000-000000000000',						
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#')			
		</cfquery>

		<cfquery name="Update"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE CalculationLog 
				SET    ActionStatus = '9',
						ActionMemo = 'You have selected one or more periods which are not consecutive. Operation not allowed'				    
				WHERE  ProcessNo= '#URL.Processno#' 
		</cfquery>
			
<cfelse>

	<cfset starts = now()>
		
	<!--- there are two modes 
	Individial calculation, driven by final payment
	Collective calculation, excluding employees that have a final payment indicator beyond the payroll period	
	--->	
		
	<cfset logNo = url.processno>
			
	<cfset sch = "">		
									
	<cfloop query="Calculation">	
							
		<cfset roundsettle = paymentRounding>		
	
		<!--- create log container --->
	
		<cfquery name="InsertProcessBatch"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO CalculationLog
				(ProcessNo,
					ProcessClass,
					ProcessBatchId,
					PersonNo,
					Mission,
					SalarySchedule,
					PayrollStart,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName)
			VALUES
				('#url.processno#',
					'calculation',
					'#calculationid#',		
					'#form.PersonNo#',
					'#Mission#',
					'#SalarySchedule#',
					'#PayrollStart#',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#')			
		</cfquery>
				
		<cfset pstarts = now()>
								
		<CF_DateConvert Value="#DateFormat(PayrollStart,CLIENT.DateFormatShow)#">
			<cfset SALSTR = dateValue>
		
		<CF_DateConvert Value="#DateFormat(PayrollEnd,CLIENT.DateFormatShow)#">
			<cfset SALEND = dateValue>
			
		<cfif SettleInitialMode eq "1" and CalculationStatus lt "2">
			<cfset settlement = "Initial">
		<cfelse>
			<cfset settlement = "Final">
		</cfif>	
											
		<cfset Form.Schedule    = SalarySchedule>
		<cfset Form.Currency    = PaymentCurrency>
		<cfset Form.Mission     = Mission>
		<cfset SettleOther      = SettleOtherSchedules>
		
		<cfif SalaryBasePeriodDays eq "30" or SalaryBasePeriodDays eq "28_31">
			<cfset Form.SalaryDays  = daysInMonth(SALSTR)> 		
		<cfelseif SalaryBasePeriodDays eq "30fix">
			<cfset Form.SalaryDays  = "30"> 	
		<cfelse>
			<cfset Form.SalaryDays  = "21.75">
		</cfif>	
								
		<!--- ------------------------------------------------------------------------------------------------------------- --->
		<!--- important query to prevent that final payment entries which are not processed yet for release in the workflow
				are removed by the general batch                                                                              --->
		<!--- ------------------------------------------------------------------------------------------------------------- --->

		<cfoutput>			
			<cfsavecontent variable="selper">				
				SELECT PersonNo
				FROM   Payroll.dbo.EmployeeSettlement
				WHERE  Mission        = '#Form.Mission#'
				AND    SalarySchedule = '#Form.Schedule#' 
				AND    PaymentDate    = #SALEND#
				AND    ActionStatus   = '0'	  <!--- a determined final payment settlement has to be released first --->						
			</cfsavecontent>						
		</cfoutput>
											
		<cfquery name="Payment" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				SELECT   *
				FROM     SalarySchedulePeriod
				WHERE    Mission           = '#Form.Mission#'
				AND      SalarySchedule    = '#Form.Schedule#'
				AND      CalculationStatus IN ('0','1','2') <!--- initially cleared --->
				ORDER BY PayrollEnd
		</cfquery>		
		
		<cfif processmodality neq "WorkflowFinal">							
							
			<cfif Payment.PayrollEnd lt SALEND>		
				<!--- open period less than salary period --->  
				<cfset CALCSTR = SALSTR>  
				<cfset CALCEND = SALEND>				
			<cfelse>	
				<CF_DateConvert Value="#DateFormat(Payment.PayrollStart,CLIENT.DateFormatShow)#">	
				<cfset CALCSTR = dateValue> 
				<CF_DateConvert Value="#DateFormat(Payment.PayrollEnd,CLIENT.DateFormatShow)#">
				<cfset CALCEND = dateValue>				
			</cfif>		
									
		<cfelse>
		
			<!--- Hanno adjustment for off-cycle payment as part of the final workflow
			In case of an off-cycle payment the calcend is driven by the last settlement and if this
			last settlement is off-cycle then we use CALEND to be the last date instead. --->	
		
			<cfquery name="PersonalPayment" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">				
				SELECT      *
				FROM        EmployeeSettlement
				WHERE       PersonNo = '#Form.PersonNo#'
				AND         Mission = '#Form.Mission#'
				ORDER BY    PaymentDate DESC						
			</cfquery>		
			
			<cfif PersonalPayment.PaymentStatus eq "1">				
			
				<CF_DateConvert Value="#DateFormat(Payment.PayrollStart,CLIENT.DateFormatShow)#">	
				<cfset CALCSTR = dateValue> 
				<CF_DateConvert Value="#DateFormat(PersonalPayment.PaymentDate,CLIENT.DateFormatShow)#">
				<cfset CALCEND = dateValue>
							
			<cfelse>
			
				<cfif Payment.PayrollEnd lt SALEND>
					<cfset CALCSTR = SALSTR>  		    
					<cfset CALCEND = SALEND>				
				<cfelse>	
					<CF_DateConvert Value="#DateFormat(Payment.PayrollStart,CLIENT.DateFormatShow)#">	
				<cfset CALCSTR = dateValue> 	
					<CF_DateConvert Value="#DateFormat(Payment.PayrollEnd,CLIENT.DateFormatShow)#">
					<cfset CALCEND = dateValue>				
				</cfif>						
		
			</cfif>			
		
		</cfif>
			
		<!--- maintenance option ONLY (disabled)
			to record the settlement always in the month of the entitlement --->
					
		<cfif form.PersonNo neq "" and url.forceSettle eq "1">	
			<cfset CALCSTR = SALSTR>  		
			<cfset CALCEND = SALEND>					
		</cfif>							
		
		<cfset calcid = calculationid>							
						
		<cfif SalarySchedule neq sch>
		
			<cfif processmodality neq "InCycleBatch">	
														
				<cfquery name="Person"
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT    * 
					FROM      Person
					WHERE     PersonNo = '#Form.PersonNo#' 
				</cfquery>			
							
			</cfif>
									
			<cf_CalculationProcessProgressInsert
				ProcessNo      = "#url.processno#"
				ProcessBatchId = "#calculationid#"				
				Description    = "Initializing">
						
				<cfinclude template="CalculationProcess_Init.cfm"> 
				
			<cfset sch = SalarySchedule>
			
		</cfif>
											
		<!--- salary calculation ---> 	
		
		<cfoutput>#Form.schedule# #dateformat(SALSTR,client.dateformatshow)#-#dateformat(SALEND,client.dateformatshow)# : </cfoutput>
									
		<cf_CalculationProcessProgressInsert
				ProcessNo      = "#url.processno#"
				ProcessBatchId = "#calculationid#"				
				Description    = "Preparation <b>#Form.Schedule# #DateFormat(PayrollStart,CLIENT.DateFormatShow)#">			 
											
			<!--- prepare payroll files calculation ---> 
		<cfinclude template="CalculationProcess_BaseFiles.cfm"> 
				
		<!--- we remove entitlement lines --->
				
		<cfquery name="CleanEntitlement" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				DELETE FROM Payroll.dbo.EmployeeSalary
				WHERE  PayrollStart   = #SALSTR#
				AND    Mission        = '#Form.Mission#'
				AND    SalarySchedule = '#Form.Schedule#' 
				<cfif processmodality neq "InCycleBatch">	
				AND    PersonNo       = '#Form.PersonNo#'						
				<cfelse>
				<!--- we did not remove if there are settlement lines with status 0 (pending) or 3 (out-of-cycle) here 
				I am not sure if this is still needed here	
				AND    PersonNo NOT IN (#preservesingleQuotes(selper)#)		
					--->							
				</cfif>
				
				<!--- ---------------------------------------------------------------------------------- --->
				<!--- 19/5/2014 adjustment Hanno do not reset entitlement if a person has an action to 
				prevent entitlement correction                                                           --->
				<!--- ---------------------------------------------------------------------------------- --->
				
				AND    PersonNo NOT IN (SELECT PersonNo 
										FROM   Employee.dbo.PersonAction 
										WHERE  Mission       = '#Form.Mission#' 
										AND    ActionCode    = '4002' 
										AND    ActionStatus  = '1'
										AND    DateEffective  <= #SALEND#
										AND    DateExpiration >= #SALSTR#) 
										
				<!--- ---------------------------------------------------------------------------------- --->		
				
				
								
		</cfquery>	 
				
		<cf_CalculationProcessProgressInsert
				ProcessNo      = "#url.processno#"
				ProcessBatchId = "#calculationid#"				
				Description    = "Reset settlements <b>#Form.Schedule# #DateFormat(PayrollStart,CLIENT.DateFormatShow)#">			 
				
				<!--- initialise settlement information for this run --->				  
			<cfinclude template="CalculationProcess_BaseSettlement.cfm">
					
		<cf_progress name="Base Salary">		
										
			<!--- salary calculation ---> 
				<cfinclude template="EntitlementContract.cfm"> 		
				
		<cf_progress name="Overtime">		 
		
			<!--- overtime calculation --->
			<cfinclude template="EntitlementOvertime.cfm"> 	
								
		<cf_progress name="Entitlement Personal">
									
				<!--- rate and percentage based entitlements --->
				<cfinclude template="EntitlementPayroll.cfm"> 	
				
				<!--- PENDING : Day correction/SLWOP is period neq contract --->
				
				<cfinclude template="EntitlementPayrollIndividual.cfm">	
				
		<cf_progress name="Incidental Cost">	
					 									
				<!--- miscellaneous costs --->
				<cfinclude template="EntitlementMiscellaneous.cfm"> 			

		<cf_progress name="Entitlement">								
		
				<cfset settle="Current">	
		
				<cf_CalculationProcessProgressInsert
					ProcessNo      = "#url.processno#"
					ProcessBatchId = "#calculationid#"			
					Description    = "Entitlements, calculated on current period"> 
			
			    <!--- rates ---> 
				<cfinclude template="EntitlementPayrollRate.cfm">					
				
				<!--- percentages --->				
				<cfinclude template="EntitlementPayrollPercentage.cfm">
							
				<!--- special calculation for running entitlement like annual bonus / vakantie geld --->
				<!--- ATTENTION this has to be adjusted to the SalaryScaleComponent table to be more independent --->
			
				<cfquery name="Special" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT DISTINCT SalaryTrigger, ComponentName 
						FROM   SalaryScheduleComponent C, Ref_PayrollComponent R
						WHERE  SalarySchedule = '#Form.Schedule#' 
						AND    EntitlementRecurrent = 0	
						AND    C.ComponentName = R.Code			
				</cfquery>
			
				<cfloop query="Special">
			
				<cfset nme = replace(SalaryTrigger,  " ",  "" , "ALL")> 
				<!---
				<cftry> 
				--->
				
					<cf_CalculationProcessProgressInsert
					ProcessNo      = "#url.processno#"
					ProcessBatchId = "#calcid#"					   		
					Description    = "#SalaryTrigger#"> 
				
					<cfinclude template="Special/#nme#.cfm">
				
				<!---
				<cfcatch><table><td><font color="FF0000">#ComponentName#</font> skipped</td></table></cfcatch>
				</cftry>
				--->			
				
				</cfloop>		
			
			<!--- add function to correct for sickleave with deduction in payment 
			which is for UN purpose only for now --->
			
			<cf_CalculationProcessProgressInsert
				ProcessNo      = "#url.processno#"
				ProcessBatchId = "#calcid#"					   		
				Description    = "SickLeave50"> 
				
			<cfinclude template="Special/SickLeave50.cfm">								
			<cfinclude template="Special/LeaveConmutation.cfm">		
			
			<cf_progress name="Settlement">		
							
			<!--- 6. Payment --->
			<cfset SettlementMode = "Regular">	
			<cfinclude template="CalculationProcess_Settlement.cfm">		
			
			<cfset settle="Prior"> 	
			
			<cfquery name="getPrior" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT TOP 1 * 
				FROM   userTransaction.dbo.sal#SESSION.thisprocess#Percentage
				WHERE  SettleUntilPeriod = '#settle#' 
			</cfquery>
									
			<cfif getPrior.recordcount gte "1">
							
				<cf_CalculationProcessProgressInsert
					ProcessNo      = "#url.processno#"
					ProcessBatchId = "#calculationid#"				
					Description    = "Entitlements, calculated on PRIOR period"> 
					
					<!--- reminder : SAT aguinaldo was to be calculated until the prior month --->
					
					<cfinclude template="EntitlementPayrollRate.cfm">						
					<cfinclude template="EntitlementPayrollPercentage.cfm">		 
					
			</cfif>	 			
			
			<!--- to be adjusted for SAT as Aguinaldo comes afterwards 
			
			<!--- 8. Special provision to trigger entitlements usually delayed but now to be release as part of Final payment
			like : Aguinaldo to be released   --->
								
			<!--- special calculation for running entitlement like annual bonus / vakantie geld --->
			<!--- ATTENTION this has to be adjusted to the SalaryScaleComponent table to be more independent --->
			
			<cfquery name="Special" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT DISTINCT SalaryTrigger 
					FROM   SalaryScheduleComponent C, Ref_PayrollComponent R
					WHERE  SalarySchedule = '#Form.Schedule#' 
					AND    EntitlementRecurrent = 0	
					AND    C.ComponentName = R.Code			
			</cfquery>
			
			<cfloop query="Special">
			
				<cfset nme = replace(SalaryTrigger,  " ",  "" , "ALL")> 
								
				<cf_CalculationProcessProgressInsert
				ProcessNo      = "#url.processno#"
				ProcessBatchId = "#calcid#"					   		
				Description    = "#SalaryTrigger#"> 
				
				<cfinclude template="Special/#nme#.cfm">
							
			</cfloop>		
			
			--->	
		
		<cfset SettlementMode = "Final">			
		<cfinclude template="CalculationProcess_Settlement.cfm">	
					
		<cfif wffinal eq "0" and DisableDistribution eq "0"> 
		
			<cfinvoke component = "Service.Process.Payroll.Payable"  
				method           = "setDistribution" 
				Mission          = "#Form.Mission#" 
				Salaryschedule   = "#Form.Schedule#" 
				PaymentStatus    = "0"
				PaymentDate      = "#dateformat(SALEND,client.dateformatshow)#"
				SettlementPhase  = "#settlementstatus#"
				PersonNo         = "#Form.PersonNo#">	
			
		</cfif>   
		
		<cf_CalculationProcessProgressInsert
				ProcessNo      = "#url.processno#"
				ProcessBatchId = "#calculationid#"					  	
				Description    = "Completed"> 
				
				<br>
				
		<!--- 7. Wrapping up --->		
		
		<cfquery name="Payroll"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     COUNT(DISTINCT PersonNo) as Count
			FROM       EmployeeSalary  
			WHERE      Mission        = '#URL.Mission#'		   
			AND        SalarySchedule = '#SalarySchedule#'
			AND		   PayrollStart   = #SALSTR#    
		</cfquery>
					
		<cfquery name="Total"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     SUM(PaymentAmount) AS Amount
			FROM       EmployeeSalaryLine L INNER JOIN
						EmployeeSalary S ON L.PersonNo = S.PersonNo AND L.PayrollStart = S.PayrollStart AND L.PayrollCalcNo = S.PayrollCalcNo
			WHERE      S.Mission         = '#URL.Mission#'		   
			AND        S.SalarySchedule  = '#SalarySchedule#'
			AND		   S.PayrollStart    = #SALSTR#   
		</cfquery>
		
		<cfquery name="Payment"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     SUM(PaymentAmount) AS Amount, 
					   SUM(Amount) AS PostingAmount
			FROM       EmployeeSettlementLine
			WHERE      Mission        = '#URL.Mission#'		   
			AND        SalarySchedule = '#SalarySchedule#'
			AND		   PaymentDate    =  #SALEND#  
			<cfif SettlementStatus eq "Initial">
			AND        SettlementPhase = '#settlementstatus#'  
			</cfif>
		</cfquery>
		
		<cfif Payroll.count eq "">
			<cfset cnt = 0>
		<cfelse>	
			<cfset cnt = payroll.count>		
		</cfif>
		
		<cfif Total.amount eq "">
			<cfset amt = 0>
		<cfelse>	
			<cfset amt = Total.amount>		
		</cfif>	
		
		<cfif Payment.amount eq "">
			<cfset pay = 0>
		<cfelse>	
			<cfset pay = Payment.amount>		
		</cfif>	
		
		<cfif Payment.postingAmount eq "">
			<cfset post = 0>
		<cfelse>	
			<cfset post = Payment.postingAmount>		
		</cfif>	
		
		<cfquery name="UpdateEntitlement"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE SalarySchedulePeriod 
				SET    CalculationDate     = #now()#, 
						TransactionCount   = '#cnt#',
						TransactionValue   = '#amt#',					   
						OfficerUserId      = '#SESSION.acc#',
						OfficerLastName    = '#SESSION.last#',
						OfficerFirstName   = '#SESSION.first#'
				WHERE  CalculationId       = '#CalculationId#'				
		</cfquery>
		
		<cfif SettlementStatus eq "Initial">
						
			<cfquery name="UpdatePayment"
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
							
					UPDATE SalarySchedulePeriod 
					SET    CalculationDate          = #now()#, 
							CalculationStatus       = '1',
							TransactionPayment      = '#pay#',
							TransactionPosting      = '#post#',
							SettlementDate          = #now()#,
							TransactionPaymentFinal = '0',
							SettlementFinalDate     = NULL,
							OfficerUserId           = '#SESSION.acc#',
							OfficerLastName         = '#SESSION.last#',
							OfficerFirstName        = '#SESSION.first#'
					WHERE  CalculationId            = '#CalculationId#'		
					AND    CalculationStatus IN ('0','1')	
						
			</cfquery>
		
		<cfelse>
		
			<!--- inital settlement calculation was already done --->
		
			<cfquery name="UpdatePayment"
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
			
				UPDATE SalarySchedulePeriod 
				SET    CalculationDate          = #now()#, 
					   CalculationStatus        = '2',
					   TransactionPaymentFinal  = '#pay#',
					   TransactionPosting       = '#post#', 
					   SettlementFinalDate      = #now()#,
					   OfficerUserId            = '#SESSION.acc#',
					   OfficerLastName          = '#SESSION.last#',
					   OfficerFirstName         = '#SESSION.first#'
				WHERE  CalculationId            = '#CalculationId#'	
				AND    CalculationStatus IN ('0','1','2')				
			</cfquery>
		
		</cfif>
		
		<cfset pends = now()>
		
		<cfset m = timeformat(pends-pstarts,"MM")>		
		<cfset s = timeformat(pends-pstarts,"SS")>
		<cfset dur = m*60+s>
		
		<cfquery name="UpdateLogPeriod"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE CalculationLog
			SET    Duration       = '#dur#', 
					ActionStatus   = '1'
			WHERE  ProcessNo      = '#url.processno#'
			AND    ProcessBatchId = '#calcid#'			
		</cfquery>		
							
	</cfloop>
		
	<!--- fully completed --->
			
	<cfset ends = now()>
	
	<cfset m = timeformat(ends-starts,"MM")>		
	<cfset s = timeformat(ends-starts,"SS")>
	<cfset dur = m*60+s>
	
	<cfquery name="Update"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE CalculationLog 
		SET    ActionStatus = '2'
		WHERE  ProcessNo = '#url.ProcessNo#'				
	</cfquery>		
										
</cfif>

</body>
</html>
