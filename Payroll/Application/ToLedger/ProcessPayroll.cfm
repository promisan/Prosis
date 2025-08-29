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
<!--- tune template for usuage within the batch
      enable umoja, as we keep all entries under OICT here
	  default program ---> 

<!--- entity parameters to be passed for loading into GL 
<cfparam name="mission"  default="OICT">
<cfparam name="url.year"     default="2011">
--->

<!--- -------------------------------------------------- --->
<!--- ----determine default accounting Period (Year) --- --->
<!--- -------------------------------------------------- --->

<cfquery name="Param" 
    datasource="appsLedger">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#Mission#'	
</cfquery>			

<!--- define the year of the transaction in case it was not passed --->


<!---
<cfparam name="url.year" default="#Param.CurrentAccountPeriod#">
--->

<!--- 07/07/2010 : Hanno : the budget period needs to be generictly defined, 

this is pending, maybethis needs to be part of the settlement table 

The fund of the position will be used for a loop and then for each 
- position fund
- determined accountyear

the prosis budget PERIOD will be determined through the editionfund combination

--->

<!--- ---------------------------------------- --->
<!--- -----determine the salary schedule------ --->
<!--- ---------------------------------------- --->

<cfquery name="Schedule" 
    datasource="appsPayroll">
	SELECT   *
	FROM     SalaryScheduleMission
	WHERE    Mission = '#Mission#'	
</cfquery>

<cfif schedule.recordcount eq "1">

	<cfset url.schedule = schedule.salaryschedule>

<cfelse>
	
	<cf_message message="Problem: Entity was not associated to a payroll schedule : #mission#.">
	<cfabort>

</cfif>		

<!--- ---------------------------------------- --->
<!--- determine the journal and contra account --->	
<!--- ---------------------------------------- --->

<cfquery name="Journal" 
    datasource="appsLedger">
	SELECT   *
	FROM     Journal
	WHERE    Mission       = '#mission#' 
	AND      SystemJournal = 'Payroll'		
</cfquery>			

<cfoutput>

<cfif Journal.recordcount eq "0">

	<cf_message message="Problem: A Payroll journal has not been defined for #mission#">
	<cfabort>
	
<cfelse>
	
	<cfset url.journal  = journal.journal>
	<cfset url.GLContra = Journal.GLAccount>
		
</cfif>

</cfoutput>

<table width="80%" align="center" class="formpadding">

<!--- Attention : the journal will need to have the months defined as subperiods
for that journal in JournalBatch this will then match the month of the payroll --->

<!--- ---------------------------------------- --->
<!--- -------loop through the subperiod------- --->
<!--- ---------------------------------------- --->

<cfquery name="BatchPeriod" 
    datasource="appsLedger">
	SELECT   *
	FROM     JournalBatch
	WHERE    Journal = '#journal.journal#'	
	AND      Operational = 1
</cfquery>		

<cfloop query="BatchPeriod">

	<cfif JournalBatchno gte "10">
		<cfset mth = JournalBatchNo>
	<cfelse>
		<cfset mth = "0#JournalBatchNo#">
	</cfif>
		
	<cfset url.start = "01/#mth#/#url.year#">
	<cfset url.end   = "28/#mth#/#url.year#">
		
	<CF_DateConvert Value="#url.start#">
	<cfset STR = dateValue>
	
	<CF_DateConvert Value="#url.end#">
	<cfset END = dateValue>
	
	<!--- to be validated as part of the process
	
		- Prevent double counting (stop)
		- All defined positions do have a mapping 
		- All Funds and programs are valid
		- The defined programs indeed belong to OICT mission
		- All lines have entry in SalarySchedulePayrollItem 
		
	--->
	
	<!--- pupulate entries for object code --->
	
	<cfquery name="Insert" 
	    datasource="appsPayroll">
		INSERT INTO SalarySchedulePayrollItem
	                (SalarySchedule, Mission, PayrollItem,OfficerUserId,OfficerLastName,OfficerFirstName)
		SELECT     '#URL.Schedule#', 
		    	   '#mission#', 
				    PayrollItem,
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#'
		FROM        Ref_PayrollItem R
		WHERE       PayrollItem NOT IN (
		                                SELECT  PayrollItem
	                                    FROM    SalarySchedulePayrollItem
	                                    WHERE   Mission        = '#mission#'
										AND     PayrollItem    = R.PayrollItem
								        AND     SalarySchedule = '#URL.Schedule#'
									    )
	</cfquery>							
	
	<!--- -------------------- Load payroll to ledger balance --------------- --->
		
	<!--- --- 1. loop per batch/month --- --->	
	
	<!--- --- 2. get list of the positions for the employee in the organization --->
	
	<cfquery name="Audit" 
	    datasource="appsEmployee">
		SELECT   DISTINCT 
		         P.PersonNo, 
		         P.IndexNo, 
				 P.LastName, 
				 P.FirstName
		FROM     PersonAssignment AS PA 
				 INNER JOIN Person AS P  ON PA.PersonNo   = P.PersonNo 
				 INNER JOIN Position Pos ON PA.PositionNo = Pos.PositionNo
	    WHERE    Pos.Mission = '#mission#'
		AND      PA.DateEffective <= #END#
	    AND      PA.DateExpiration >= #STR# 
		AND      PA.AssignmentStatus IN ('0', '1')	 
		
		<!--- only fully encumberred assignments --->
		AND      PA.Incumbency = 100
				
		<!--- select only payroll enabled positions 7/7/2010 --->
				
		AND      Pos.PostType IN (SELECT PostType 
		                          FROM   Ref_PostType 
								  WHERE  PostType = Pos.PostType
								  AND    Procurement = 0)		
								  
		
	</cfquery>
		
	<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#OnPayroll"> 
		
	<cfquery name="onPayroll" 
	    datasource="appsEmployee">		
			SELECT DISTINCT P.PersonNo,
						    P.LastName, 
						    P.FirstName, 
						    P.IndexNo,
							MAX(PA.FunctionNo) as FunctionNo,
							MAX(PA.OrgUnit) as OrgUnit,
						    MAX(Pos.PositionParentId) as PositionParentId 
					  
			INTO      userQuery.dbo.#SESSION.acc#OnPayroll		  
			FROM      PersonAssignment AS PA 
			          INNER JOIN Person AS P ON PA.PersonNo = P.PersonNo 
					  INNER JOIN Position Pos ON PA.PositionNo = Pos.PositionNo
			WHERE     Pos.Mission        = '#mission#' 		  
			     AND  PA.DateExpiration  >= #END#
	             AND  PA.DateEffective   <= #END# <!--- ensure only one parent position is found to be used for distribution --->
				 AND  PA.AssignmentStatus IN ('0', '1') 	
				 
				 <!--- to be defined if this is a good idea here --->				    
				 AND  PA.Incumbency = 100
				 
				 <!--- select only payroll enabled positions 7/7/2010 --->
				
				AND      Pos.PostType IN (SELECT PostType 
		                                  FROM   Ref_PostType 
								          WHERE  PostType = Pos.PostType
								          AND    Procurement = 0)		
				 
				 <!--- check if data is found --->
				 AND  PA.PersonNo IN (
					                    SELECT  PersonNo
				                        FROM    Payroll.dbo.EmployeeSettlementLine
										WHERE   PersonNo     = PA.PersonNo
				                        AND     PaymentYear  = '#url.year#' 
										AND     PaymentMonth = '#mth#' 
									  )
			GROUP BY P.PersonNo,
				     P.LastName, 
				     P.FirstName, 
				     P.IndexNo					
			ORDER BY P.PersonNo 	
	</cfquery>	
	
	<cfquery name="onPayroll" 
	    datasource="appsQuery">
		SELECT *
		FROM   #SESSION.acc#OnPayroll
	</cfquery>	
			
	<cfif onPayroll.recordcount eq "0">
	
		<cf_ScheduleLogInsert
	   		ScheduleRunId  = "#schedulelogid#"
			Description    = "#mission#: #url.year#.#mth# : No data found"
			StepStatus     = "9">	
	
	<cfelse>
				
		<cfquery name="Delete" 
		    datasource="appsPayroll">		
				DELETE FROM EmployeeSettlementLedger
				WHERE  Mission      = '#mission#'
				AND    PaymentYear  = '#url.year#'
				AND    PaymentMonth = '#mth#'								
		</cfquery>	
		
		<cfif abs(onPayroll.recordcount-Audit.recordcount) gte "1">
		
			<!--- compare with the base set of records for this month --->
				
			<cfquery name="Diff" dbtype="query">
					SELECT DISTINCT PersonNo
					FROM   Audit
					WHERE  PersonNo NOT IN (#QuotedValueList(onPayroll.Personno)#)			
			</cfquery>				
					
			<cf_ScheduleLogInsert
		   		ScheduleRunId  = "#schedulelogid#"
				Description    = "#mission#: #url.year#.#mth# Staff: #Audit.recordcount# but payroll was NOT FOUND for <b>#diff.Recordcount#</b>"
				StepStatus     = "9">						
							
			<cfoutput query="Diff">
			
			       <cftry>
			
					<cfquery name="Insert" 
					    datasource="appsPayroll">		
							INSERT INTO EmployeeSettlementLedger
								(Mission,PersonNo, PaymentYear, PaymentMonth,LedgerStatus)
							VALUES
								('#mission#',
								 '#PersonNo#',
								 '#url.year#',
								 '#mth#',
								 'Missing in Payroll')								
					</cfquery>		
					
					<cfcatch></cfcatch>
					
					</cftry>
								
			</cfoutput>
						
		<cfelse>
		
			<cf_ScheduleLogInsert
		   		ScheduleRunId  = "#schedulelogid#"
				Description    = "#mission#: #url.year#.#mth# Payroll data found for all #onPayroll.recordcount# staff"
				StepStatus     = "1">
					
		</cfif>		
		
		<!--- ------------------------------------------------------------------------------------------------- --->
		<!--- 3. Analyse the data for missing program/project information to associate the cost to------------- --->				
		<!--- ------------------------------------------------------------------------------------------------- --->
		
		<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#OnBoardProject"> 
				
		<cfquery name="PayrollWithProjectDefine" 
			    datasource="appsEmployee">		
				SELECT   T.*, 
				
				         (SELECT  TOP 1 Fund
			              FROM   PositionParentFunding
			              WHERE  DateEffective <= #END# 											
						  AND    ProgramCode IN (SELECT ProgramCode 
								                 FROM   Program.dbo.Program 
									    	     WHERE  Mission = '#mission#')
						  AND    PositionParentId = T.PositionParentId) as Fund,
						  
						 (SELECT  TOP 1 ProgramCode
			              FROM   PositionParentFunding
			              WHERE  DateEffective <= #END# 											
						  AND    ProgramCode IN (SELECT ProgramCode 
								                 FROM   Program.dbo.Program 
									    	     WHERE  Mission = '#mission#')
						  AND    PositionParentId = T.PositionParentId) as ProgramCode,
						  
						  (SELECT  TOP 1 ObjectCode
			              FROM   PositionParentFunding
			              WHERE  DateEffective <= #END# 											
						  AND    ProgramCode IN (SELECT ProgramCode 
								                 FROM   Program.dbo.Program 
									    	     WHERE  Mission = '#mission#')
						  AND    PositionParentId = T.PositionParentId) as ProgramObject 
				
  				INTO     userQuery.dbo.#SESSION.acc#OnBoardProject
				FROM     userQuery.dbo.#SESSION.acc#OnPayroll T 
									
		</cfquery>	
				
					
		<!--- Define any people that are not matched to a activity/project 
			
		<cfquery name="MissingProgram" 
		    datasource="appsEmployee">		
				SELECT  *
				FROM     userQuery.dbo.#SESSION.acc#OnBoardProject
				WHERE    ProgramCode is NULL								
		</cfquery>				
			
		<cfif MissingProgram.recordcount gte "1">
					
				<cfoutput query="MissingProgram">
									
					<cfquery name="Insert" 
					    datasource="appsPayroll">		
							INSERT INTO EmployeeSettlementLedger
								(Mission,PersonNo,PaymentYear,PaymentMonth,LedgerStatus)
							VALUES
								('#mission#',
								 '#PersonNo#',
								 '#url.year#',
								 '#mth#',
								 'No program/activity')								
					</cfquery>							
										
				</cfoutput>
				
		</cfif>
		
		--->		
				
		<!--- ------------------------------------------------------------------------------------------------- --->			
		<!--- 3. define Project and Fund based on the Position Fund with the last effective date lt 11/30/2009  --->
		<!--- ------------------------------------------------------------------------------------------------- --->
				
		<cfquery name="FundList" 
		    datasource="appsEmployee">		
				SELECT  DISTINCT Fund				
				FROM    userQuery.dbo.#SESSION.acc#OnPayroll T INNER JOIN
				        PositionParentFunding P ON T.PositionParentId = P.PositionParentId
				WHERE   P.DateEffective =
	                          (SELECT  MAX(DateEffective)
	                            FROM   PositionParentFunding
	                            WHERE  DateEffective <= #END# 										
								AND    ProgramCode IN (SELECT ProgramCode 
								                       FROM   Program.dbo.Program 
											    	   WHERE  Mission = '#mission#')
								AND    PositionParentId = T.PositionParentId)	
				AND Fund IN (SELECT Code 
				             FROM   Program.dbo.Ref_Fund
							 WHERE  Fund = P.Fund)	
							 										
		</cfquery>	
		
										
		<cfif FundList.recordcount eq "0">
					
			<cf_ScheduleLogInsert
		   		ScheduleRunId  = "#schedulelogid#"
				Description    = "#mission#: #url.year#.#mth#. No Position allocation data found. Operation interupted."
				StepStatus     = "1">		
				
		<cfelse>		
							
				<cfloop query="FundList">
															
					<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#OnBoardProject"> 
							
					<!--- determine the period based on the fund --->
											
					<cfquery name="Period"
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					    SELECT TOP 1 Period
						FROM  Ref_AllotmentEdition
						WHERE Mission = '#mission#'	
						AND   EditionId IN (
						                 SELECT EditionId 
										 FROM   Ref_AllotmentEditionFund 
										 WHERE  Fund = '#fund#'
										 )
						AND   Period IN (
						                 SELECT   Period 
						                 FROM     Ref_Period 
										 WHERE    DateExpiration > '01/01/#url.year#' 				 
										)
						ORDER BY Period
					</cfquery>	
																				
					<cfif period.recordcount eq "0">
					
						<cf_ScheduleLogInsert
				   		ScheduleRunId  = "#schedulelogid#"
						Description    = "#mission#: #url.year#.#mth# The period could not be identified. Operation interupted"
						StepStatus     = "9"
						Abort          = "Yes">	
						
					</cfif>									
							
					<cfquery name="PayrollProject" 
					    datasource="appsEmployee">	
										
							SELECT   '#URL.Year#' as Year,
							         '#mth#' as Month,
							         T.*, 					         
									 '#Period.Period#' as Period,
									 
									  (SELECT  TOP 1 Fund
						              FROM   PositionParentFunding
						              WHERE  DateEffective <= #END# 											
									  AND    ProgramCode IN (SELECT ProgramCode 
											                 FROM   Program.dbo.Program 
												    	     WHERE  Mission = '#mission#')
									  AND    PositionParentId = T.PositionParentId) as Fund,
									  
									 (SELECT  TOP 1 ProgramCode
						              FROM   PositionParentFunding
						              WHERE  DateEffective <= #END# 											
									  AND    ProgramCode IN (SELECT ProgramCode 
											                 FROM   Program.dbo.Program 
												    	     WHERE  Mission = '#mission#')
									  AND    PositionParentId = T.PositionParentId) as ProgramCode,
									  
									  (SELECT  TOP 1 ObjectCode
						              FROM   PositionParentFunding
						              WHERE  DateEffective <= #END# 											
									  AND    ProgramCode IN (SELECT ProgramCode 
											                 FROM   Program.dbo.Program 
												    	     WHERE  Mission = '#mission#')
									  AND    PositionParentId = T.PositionParentId) as ProgramObject
									 
							INTO     userQuery.dbo.#SESSION.acc#OnBoardProject
							FROM     userQuery.dbo.#SESSION.acc#OnPayroll T 										
							ORDER BY LastName, FirstName					
																			
					</cfquery>	
					
					
					<!--- only the selected fund to be summed for posting --->	
					
					<cfquery name="FilterFund" 
					    datasource="appsEmployee">									
							DELETE FROM userQuery.dbo.#SESSION.acc#OnBoardProject
							WHERE  Fund != '#fund#'																	
					</cfquery>		
												
					<!--- 4. now link to the settlement table and SUM which is the basis for loading into GL --->
					
					<!--- clean --->
					
					<cfquery name="Ledger" 
					    datasource="appsLedger">			
						DELETE FROM TransactionHeader
						WHERE   AccountPeriod  = '#Param.CurrentAccountPeriod#'
						AND     Description    = 'Payroll: #URL.Year#/#mth#'
						AND     Journal        = '#URL.Journal#'  
						AND     JournalBatchNo = '#mth#'
						AND     Reference      = '#Fund#'
					</cfquery>
											
					<cfquery name="Payroll" 
					    datasource="appsPayroll"
						username="#SESSION.login#" 
		   			    password="#SESSION.dbpw#">			
						SELECT    T.PersonNo, 
						          T.IndexNo,
								  T.LastName,
								  T.FirstName,
								  T.OrgUnit,
								  T.FunctionNo,
						          T.Fund, 
								  T.ProgramCode, 
								  T.ProgramObject,
								 							 
								 ( SELECT Reference 
								   FROM   Program.dbo.ProgramPeriod 
								   WHERE  Period = '#Period.Period#' 
								   AND    ProgramCode = T.ProgramCode) as Reference,
								
								<!--- not needed the OE is preserved in the transaction line already 	   						 
								for now we book this on the salaries account of the GL
								 ( SELECT GLAccount 
								   FROM   Accounting.dbo.Ref_Account 
								   WHERE  ObjectCode = T.ProgramObject) as GLAccount,					
								   --->	
								  
								 ( SELECT ProgramCode 
								   FROM   Program.dbo.ProgramPeriod 
								   WHERE  Period = '#Period.Period#' 
								   AND    ProgramCode = T.ProgramCode) as ProgramCodeEnableForPeriod,		   
									   
								  S.Currency, 			
								  									   
								  ROUND(SUM(S.PaymentAmount), 2) AS Amount
								  
						FROM      userQuery.dbo.#SESSION.acc#OnBoardProject T 
								  INNER JOIN Payroll.dbo.EmployeeSettlementLine S ON T.PersonNo = S.PersonNo 
								  INNER JOIN Payroll.dbo.SalarySchedulePayrollItem I ON S.PayrollItem = I.PayrollItem AND S.Mission = I.Mission AND S.SalarySchedule = I.SalarySchedule
								 				
						WHERE     S.PaymentYear  = '#url.year#' 
						AND       S.PaymentMonth = '#mth#'  
						
						<!--- ----------------------- IMPORTANT -------------------------- --->
						<!--- if already posted for another fund we do exclude this person --->
						<!--- ------------------------------------------------------------ --->
						
						AND       '#url.year#-#mth#-'+T.PersonNo NOT IN 
						
													(
													 SELECT JournalTransactionNo 
						                             FROM   Accounting.dbo.TransactionHeader
													 WHERE  Journal           = '#URL.Journal#'
													 AND    ReferencePersonNo = T.PersonNo
													) 
							
						GROUP BY  T.PersonNo, 
								  T.IndexNo,
								  T.LastName,
								  T.FirstName,
						          T.Fund, 
								  T.OrgUnit,
								  T.FunctionNo,
								  T.ProgramCode, 						  
								  T.ProgramObject,												 
								  S.Currency 	
								  
						ORDER BY T.ProgramCode, T.LastName												  			  
													  
					</cfquery>	
											
					<cftransaction>	
																									  
					<cfoutput query="Payroll">
					
						<cfquery name="getPeriod" 
					    datasource="appsLedger">			
							SELECT * 
							FROM   Period
							WHERE  PeriodDateEnd   >= #END# 
							AND    PeriodDateStart <= #END#
							AND    ActionStatus = '0'						
							ORDER BY AccountPeriod
						</cfquery>
						
						<cfif getPeriod.recordcount gte "1">
						
							<cfset per = getPeriod.Period>
							
						<cfelse>
						
							<cfset per = Param.CurrentAccountPeriod>
						
						</cfif>
					
						<!--- we book payroll on a payroll GL account 
						      and use the OE for differentation --->	
							  
					    <cfif Schedule.GLAccount neq "" and ProgramCodeEnableForPeriod neq "">	
												
							<cf_GledgerEntryHeader
								    Mission               = "#mission#"
								    OrgUnitOwner          = ""
								    Journal               = "#URL.Journal#"
									AccountPeriod         = "#per#"
									JournalBatchNo        = "#mth#" 
									JournalTransactionNo  = "#URL.Year#-#mth#-#PersonNo#"
									Description           = "Payroll: #URL.Year#/#mth#"
									TransactionSource     = "PayrollSeries"				
									TransactionCategory   = "Memorial"
									MatchingRequired      = "0"
									ReferencePersonNo     = "#PersonNo#"
									Reference             = "#fund#"       
									ReferenceName         = "#FirstName# #LastName#"
									ReferenceId           = ""
									ReferenceNo           = "#IndexNo#"
									DocumentCurrency      = "#Currency#"
									TransactionDate       = "#DateFormat(url.end,CLIENT.DateFormatShow)#"
									DocumentDate          = "#DateFormat(url.end,CLIENT.DateFormatShow)#"
									DocumentAmount        = "#Amount#"
									OfficerUserId         = "#SESSION.acc#"
									OfficerLastName       = "#SESSION.last#"
									OfficerFirstName      = "#SESSION.first#"
									ParentJournal         = ""
									ParentJournalSerialNo = "">
									
							<cf_GledgerEntryLine
									Lines                 = "2"
								    Journal               = "#URL.Journal#"
									JournalNo             = "#JournalSerialNo#"
									JournalTransactionNo  = "#URL.Year#-#mth#-#PersonNo#"				
									Currency              = "#Currency#"
									AccountPeriod         = "#per#"
									TransactionDate       = "#DateFormat(url.end,CLIENT.DateFormatShow)#"
																	
									TransactionSerialNo1  = "1"				
									Class1                = "Debit"
									Reference1            = "Payment"       
									ReferenceName1        = "#FirstName# #LastName#"
									Description1          = "Payroll"
									GLAccount1            = "#Schedule.GLAccount#"
									Costcenter1           = "#OrgUnit#"					
									Fund1                 = "#Fund#"
									ProgramCode1          = "#ProgramCode#"
									ObjectCode1           = "#ProgramObject#"
									ProgramPeriod1        = "#Period.Period#"
									ReferenceId1          = ""
									TransactionType1      = "Standard"
									Amount1               = "#Amount#"
									
									TransactionSerialNo2  = "2"
									Class2                = "Credit"
									Reference2            = "Payable"       
									ReferenceName2        = "#FirstName# #LastName#"
									Description2          = "Payment"
									GLAccount2            = "#url.GLContra#"
									TransactionType2      = "Standard"
									Amount2               = "#Amount#">
									
									<cfquery name="Insert" 
									    datasource="appsLedger" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">	
											
										INSERT INTO Payroll.dbo.EmployeeSettlementLedger
												(Mission,
												 PersonNo, 
												 PaymentYear, 
												 PaymentMonth,
												 LedgerStatus,
												 Journal, 
												 JournalSerialNo, 
												 Fund, 
												 OrgUnit,
												 FunctionNo,
												 ProgramCode, 
												 ProgramPeriod, 
												 Currency, 
												 Amount)										 
										VALUES  ('#mission#',
												 '#PersonNo#',
												 '#url.year#',
												 '#mth#',
												 'Posted',
												 '#url.journal#',
												 '#JournalSerialNo#',
												 '#fund#',
												 '#OrgUnit#',
												 '#FunctionNo#',
												 '#ProgramCode#',
												 '#Period.Period#',
												 '#currency#',
												 '#amount#')	
												 							
									</cfquery>		
																		
							<cfelse>														
																		
								<cfif Schedule.GLAccount eq "">		
								
									<cftry>				
								    						 
										<cfquery name="Insert" 
								    	datasource="appsLedger" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">	
											
										INSERT INTO Payroll.dbo.EmployeeSettlementLedger
											(Mission,
											 PersonNo,
											 PaymentYear,
											 PaymentMonth,
											 LedgerStatus,
											 ProgramCode,
											 Fund,
											 Currency,
											 Amount)
										VALUES
											('#mission#',
											 '#PersonNo#',
											 '#url.year#',
											 '#mth#',
											 'Incorrect GL Account',											 
											 '#ProgramCode#',
											 '#Fund#',
											 '#currency#',
											 '#amount#')	
											 							
										</cfquery>	
									
										<cfcatch></cfcatch>
									
									</cftry>
																
									<cfset exc = "Undefined Account">
								
							    <cfelse>
								
									<cftry>		
														   							
									<cfquery name="Insert" 
								    	datasource="appsLedger" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">		
										INSERT INTO Payroll.dbo.EmployeeSettlementLedger
											(Mission,
											 PersonNo,
											 PaymentYear,
											 PaymentMonth,
											 LedgerStatus,
											 ProgramCode,
											 Fund,
											 Currency,
											 Amount)
										VALUES
											('#mission#',
											 '#PersonNo#',
											 '#url.year#',
											 '#mth#',
											 'Error Program/Period',
											 '#ProgramCode#',
											 '#fund#',
											 '#currency#',
											 '#amount#')								
									</cfquery>	
									
									<cfcatch></cfcatch>
									
									</cftry>
																
									<cfset exc = "Invalid Program code for period">
														
								</cfif>								
								  										
						</cfif>
							
				</cfoutput>		
					
			</cftransaction>	
			
			<cfquery name="getPosted" 
			   datasource="appsPayroll"
			   username="#SESSION.login#" 
   			   password="#SESSION.dbpw#">	
			   			
				SELECT   count(*) as Posted
				FROM     EmployeeSettlementLedger
				WHERE    Mission      = '#mission#' 
				AND      PaymentYear  = '#url.year#' 
				AND      PaymentMonth = '#mth#' 
				AND      Fund         = '#fund#'
				AND      LedgerStatus IN ('Posted')
				
			</cfquery>
			
			<cf_ScheduleLogInsert
				   		ScheduleRunId  = "#schedulelogid#"
						Description    = "#Fund#: Posted: #getPosted.Posted#"
						StepStatus     = "1">	  
			
			</cfloop>	
			
			<cfquery name="getPosted" 
			   datasource="appsPayroll" 
			   username="#SESSION.login#" 
   			   password="#SESSION.dbpw#">				
			   
				SELECT   count(*) as Posted
				FROM     EmployeeSettlementLedger
				WHERE    Mission = '#mission#' 
				AND      PaymentYear = '#url.year#' 
				AND      PaymentMonth = '#mth#' 
				AND      LedgerStatus IN ('Posted')
				
			</cfquery>
			
			<cfquery name="getMissing" 
			   datasource="appsPayroll"
			   username="#SESSION.login#" 
   			   password="#SESSION.dbpw#">				
			   
				SELECT   count(*) as Missing
				FROM     EmployeeSettlementLedger
				WHERE    Mission = '#mission#' 
				AND      PaymentYear = '#url.year#' 
				AND      PaymentMonth = '#mth#' 
				AND      LedgerStatus NOT IN ('Posted', 'Missing in Payroll')
				
			</cfquery>
			
			<cf_ScheduleLogInsert
				   		ScheduleRunId  = "#schedulelogid#"
						Description    = "Stf:#Audit.recordcount# onPay:#OnPayroll.recordcount# Posted:<b>#getPosted.Posted#</b> <font color='FF0000'>Missing: <b>#getMissing.Missing#</b>"
						StepStatus     = "1">	  	
			
		</cfif>			
	
	</cfif>	

</cfloop>

</table>

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "#mission#: #url.year# : Completed"
	StepStatus     = "1">				  	
	
