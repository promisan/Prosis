
<!--- this will be a batch that runs around 30 of each month after the payroll is locked and posted --->

<cfparam name="URL.Period"       default="FY18,FY19">
<cfparam name="URL.ForecastDate" default="15/11/2018">

<cfquery name="MissionList" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ParameterMission P	
	WHERE   Mission IN (SELECT  Mission
					    FROM    Accounting.dbo.Journal
						WHERE   GLCategory = 'Forecast' 
						AND     Currency   = P.BudgetCurrency)
	
</cfquery>

<cfloop query="MissionList">

	<cfset misselect = mission>
			
	<cfquery name="Journal" 
	 datasource="AppsLedger" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT  *
	   FROM    Accounting.dbo.Journal
	   WHERE   GLCategory = 'Forecast' 
	   AND     Mission    = '#mission#'	   
	   AND     Currency   = '#BudgetCurrency#'
	 </cfquery>
			
	<cfloop index="period" list="#url.period#">
	
		<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "Prepare #misselect# #period#"
		StepStatus     = "1">	
	
	    <cfquery name="MissionPeriod" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_MissionPeriod
			WHERE   Mission        = '#misselect#'
			AND     isPlanPeriod   = 1
			AND     PlanningPeriod = '#period#'		
	    </cfquery>
		
		 <cfquery name="getPeriod" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_Period
			WHERE   Period = '#period#'		
	    </cfquery>
			
	    <cfset AccountPeriod = missionPeriod.AccountPeriod>
	
	    <cfquery name="Schedule" 
	 	 datasource="AppsPayroll" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT  *
			FROM    SalaryScheduleMission
			WHERE   Mission = '#misselect#'		
			AND     DateExpiration is NULL
			AND     DisableForecast = 0
	    </cfquery>
		
	    <cfquery name="clearLeader" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE  FROM TransactionHeader
			WHERE   Mission = '#misselect#'
			AND     AccountPeriod = '#AccountPeriod#'
			AND     Journal = '#journal.journal#'		
		</cfquery>
		
		<cfquery name="ClearProgram" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE  FROM ProgramPeriodForecastPosition
			WHERE   ProgramCode IN (SELECT ProgramCode FROM Program WHERE Mission = '#misselect#')
			AND     Period   = '#period#'		 			 						 											   											   
	    </cfquery>			
					
		<!--- we need to obtain the last period for all schedules to have a consistent value --->	
		
		<cfset selectiondate = "01/01/9999">
		
		<cfoutput query="schedule">		
		
			<cfquery name="LastMonth" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT      MAX(PayrollEnd) AS Date
				FROM        SalarySchedulePeriod
				WHERE       Mission           = '#misselect#' 
				AND         SalarySchedule    = '#salarySchedule#' 
				AND         CalculationStatus = '3'
				-- AND         PayrollEnd       >= '#getPeriod.DateEffective#'
			</cfquery>
									
			<cfif lastMonth.date lt selectiondate and lastmonth.date neq "">
				<cfset selectiondate = LastMonth.Date>
			</cfif>
			
		</cfoutput>
				
		<CF_DropTable dbName="AppsQuery" tblName="finForecast#misselect#_#period#">	
		
		<cfif selectiondate neq  "01/01/9999">
		
			<cfquery name="Audit" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT      *
				FROM        Ref_Audit
				WHERE       Period = '#period#'
				AND         AuditDate > '#selectiondate#'	
				<!--- temp provision --->
				AND         AuditDate >	'#dateformat(url.forecastdate,client.dateSQL)#'				
				ORDER BY AuditDate				
			</cfquery>
			
			<cfoutput>#Period#:#Audit.AuditDate#</cfoutput>					
		
			<cfquery name="ForecastStaffingBaseSet" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
		
			<!--- obtain base per person, program, objectcode, fund for this closing 
				  excluding special payments for --->
				  
				SELECT       O.OrgUnitCode, O.OrgUnitName, ES.SalarySchedule, ES.Mission, ES.PaymentDate, 
							 ES.PersonNo, P.LastName, P.FirstName, P.IndexNo, 
							 ES.PaymentFinal, 
							 ESL.PayrollItem, R.PayrollItemName,R.Source, 
							 ESL.GLAccount, ESL.GLAccountLiability, 
							 ESL.OrgUnit, 
							 
							 ESL.PositionParentId,
							 <!--- runtime value --->
							 PFL.ProgramCode, PFL.Fund, PFL.Percentage, 							 
							 
							 Pr.ProgramName, Pe.Reference,
							 ESL.Currency, ESL.PaymentAmount, ESL.Amount, 
							 ESL.DocumentCurrency, 
							 ESL.DocumentAmount, 
							 ESL.DocumentAmount as DocumentAmountCorrection							
				
				INTO         userQuery.dbo.finForecast#misselect#_#period#
				
				FROM         EmployeeSettlement AS ES 
				             INNER JOIN EmployeeSettlementLine AS ESL         ON ES.PersonNo       = ESL.PersonNo 
							                                                 AND ES.SalarySchedule = ESL.SalarySchedule 
																			 AND ES.Mission        = ESL.Mission 
																			 AND ES.PaymentDate    = ESL.PaymentDate 
							 INNER JOIN Organization.dbo.Organization AS O    ON ESL.OrgUnit       = O.OrgUnit 
							 INNER JOIN Ref_PayrollItem AS R                  ON ESL.PayrollItem   = R.PayrollItem 
							 INNER JOIN Employee.dbo.Person AS P              ON ESL.PersonNo      = P.PersonNo 
							 
							 <!--- ---------------------------------------------------------------------------- --->
							 <!--- we now take the position funding at runtime not based on the lastest payroll --->
							 <!--- ---------------------------------------------------------------------------- --->
							 
							 INNER JOIN (
							 
								 SELECT    PF.PositionParentId, PF.Fund, PF.FundClass, PF.ProgramCode, PF.Percentage
								 FROM      Employee.dbo.PositionParentFunding AS PF INNER JOIN
		                           			  (SELECT     PositionParentId, 
											              MAX(DateEffective) AS DateEffective
				                               FROM       Employee.dbo.PositionParentFunding
				                               WHERE      DateEffective <= '#audit.auditdate#'
		        		                       GROUP BY   PositionParentId) AS M ON PF.PositionParentId = M.PositionParentId AND PF.DateEffective = M.DateEffective
							 
							 ) PFL ON ESL.PositionParentid = PFL.PositionParentId
																		 
							 INNER JOIN Program.dbo.Program AS Pr             ON PFL.ProgramCode = Pr.ProgramCode 
							 INNER JOIN Program.dbo.ProgramPeriod Pe          ON PFL.ProgramCode = Pe.ProgramCode AND Period = '#Period#'
	
				WHERE        ES.PaymentDate    = '#selectiondate#' 
				AND          ESL.PaymentStatus = '0' <!--- we don't include final payment as they are not representative --->
				AND          R.Source NOT IN ('Deduction','Miscellaneous')
								
				AND          R.PayrollItem NOT IN (SELECT PayrollItem 
				                                   FROM   Ref_PayrollGroupItem 
												   WHERE  Code = 'Forecast' 
												   AND    Mission = '#misselect#') 
								
				AND          ESL.PayrollEnd    = ES.PaymentDate  <!--- no retro information included --->
								
			</cfquery>	
			
			<!--- Hanno 9/6/2018 to be included, some positions are under SLWOP and have no costs in the selection month, in that case it would be good
			to take the last one with costs --->
			
			<!--- ----------------------------------------   PENDING   --------------------------------------------------- --->
						
					
			
			
			<!--- apply business rule to make a correction based on the moment of which you are doing the first forecast    --->
			
			<cfif audit.AuditId neq "">
			
			<cfquery name="ForecastCorrection" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE userQuery.dbo.finForecast#misselect#_#period#
				SET    DocumentAmountCorrection = (DocumentAmount*F.ForecastCorrection)/100				
				FROM   userQuery.dbo.finForecast#misselect#_#period# AS I INNER JOIN
    	               Program.dbo.ProgramPeriodForecast AS F ON I.ProgramCode = F.ProgramCode AND F.Period = '#period#' AND F.AuditId = '#audit.AuditId#'
			</cfquery>	   						
			
			<cfloop query="Audit"> 
			
				<cf_ScheduleLogInsert
				   	ScheduleRunId  = "#schedulelogid#"
					Description    = "Prepare #Description#"
					StepStatus     = "1">	
			
				<!--- we loop through the remaining months of this period and define the OCCUPIED positions 
				  for a selection date and 
				  THEN use the base set to obtain the costs of those positions in the base month to be forecasted. --->
					 					 					  
				  <cfquery name="InsertBase" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
											  
					  INSERT INTO Program.dbo.ProgramPeriodForecast
                      (ProgramCode, Period, AuditId, ForecastCorrection, OfficerUserId, OfficerLastName, OfficerFirstName)
						 
					   SELECT DISTINCT ProgramCode, 
							   '#period#', 
							   '#auditid#', 
							   '100', 
							   '#session.acc#',
							   '#session.last#', 
		                       '#session.first#'
					   FROM   userQuery.dbo.finForecast#misselect#_#period#	 AS C
					   WHERE  1 = 1 
					   AND    NOT EXISTS (SELECT  'X' 
			                              FROM    Program.dbo.ProgramPeriodForecast 
	    		                          WHERE   ProgramCode = C.ProgramCode 
								    	  AND     Period      = '#period#' 
										  AND     AuditId     = '#auditid#')
					   AND    EXISTS (SELECT 'X'
					             	  FROM    Program.dbo.ProgramPeriod 
	    		                      WHERE   ProgramCode = C.ProgramCode 
								  	  AND     Period      = '#period#' 			  )
										   											   
				  </cfquery>	
					  
				  <!--- make correction of percentages to the amounts --->
				 
					  
					  
				  <!--- record the forecast, details and ledger --->
					  					  
				  <cfquery name="RecordProgramForecast" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
												  
						  INSERT INTO Program.dbo.ProgramPeriodForecastPosition
						  
		                      (ProgramCode, Period, AuditId, 
							   PositionParentId,
							   Fund,ObjectCode,							   
							   SalarySchedule,PayrollItem,
							   Currency,Amount,AmountCorrection)
						   
						  SELECT  C.ProgramCode, 
						          '#period#',
								  '#auditid#',
							      C.PositionParentId, 
								  C.Fund, AO.ObjectCode, 
								  C.SalarySchedule, C.PayrollItem, 
								  C.DocumentCurrency,
								  (C.DocumentAmount*percentage) as AmountForecast,
								  (C.DocumentAmountCorrection*percentage) as AmountForecastCorrection
						  FROM    userQuery.dbo.finForecast#misselect#_#period# AS C INNER JOIN  <!--- LEFT OUTER JOIN --->
                                  Accounting.dbo.Ref_AccountObject AS AO 
								           ON  C.Mission   = AO.Mission 
										   AND C.GLAccount = AO.GLAccount 
										   AND C.Fund      = AO.Fund		
						  WHERE   PositionParentId IN (
												
									SELECT     PositionParentId
									FROM       Employee.dbo.vwAssignment
									WHERE      Mission = '#misselect#' 
									AND        DateEffective   <= '#dateformat(AuditDate,client.dateSQL)#' 
									AND        DateExpiration >= '#dateformat(AuditDate,client.dateSQL)#' 
									AND        AssignmentClass = 'Regular' <!--- exclude TDY, Loan --->
									AND        AssignmentStatus IN ('0','1') 
									AND        AssignmentType = 'Actual' 
									AND        Incumbency > 0		
									
								    )			
									
						AND  EXISTS (SELECT 'X' FROM Program.dbo.ProgramPeriodForecast
									 WHERE ProgramCode = C.ProgramCode
									 AND   Period = '#period#'
									 AND   AuditId = '#auditid#')		
									 
						AND  AO.ObjectCode IN (SELECT Code FROM Ref_Object)			 		  					 
						 											   											   
				  </cfquery>						  					  				   
					  					  
				  <!--- adjust if a position is moved to a new unit / program during the year --->
				  
				  <cfquery name="RecordLedger" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">						
						
						SELECT ProgramCode,
							   Reference,	 
						       Fund, 
							   OrgUnit,
							   GLAccount,
							   SUM(DocumentAmountCorrection*Percentage) as AmountForecast
							   
					    FROM   userQuery.dbo.finForecast#misselect#_#period#		   
						WHERE  PositionParentId IN (
						
						
								SELECT     PositionParentId
								FROM       Employee.dbo.vwAssignment
								WHERE      Mission = '#misselect#' 
								AND        DateEffective   <= '#dateformat(AuditDate,client.dateSQL)#' 
								AND        DateExpiration >= '#dateformat(AuditDate,client.dateSQL)#' 
								AND        AssignmentStatus IN ('0','1') 
								AND        AssignmentClass = 'Regular' <!--- exclude TDY, Loan --->
								AND        AssignmentType  = 'Actual' 
								AND        Incumbency > 0		
								
							    )	
						AND     DocumentAmountCorrection is not NULL			
						GROUP BY ProgramCode,
							     Reference,	 
						         Fund, 
							     OrgUnit,
							     GLAccount	
						ORDER BY Reference, Fund	   	
					</cfquery>	
					
					<!--- aggregate by program and fund --->
					
			   	   <cfquery name="RecordLedgerHeader" dbtype="query">
						SELECT    ProgramCode,
							      Reference,	 
						          Fund,
								  OrgUnit,
							      SUM(AmountForecast) as AmountForecast
					    FROM      RecordLedger
						GROUP BY  ProgramCode,
							      Reference,	
								  OrgUnit, 
						          Fund  
						ORDER BY  Reference,
						          Fund						
					</cfquery>					
												
					<cfloop query="RecordLedgerHeader">		
					
						<cfquery name="ProgramPeriod" 
							datasource="AppsLedger" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT      TOP (1) ProgramPeriod
							FROM        stSUNPeriod
							WHERE       AccountPeriod = '#AccountPeriod#'
							AND         Mission       = '#misselect#'
							AND         Fund          = '#Fund#'
						</cfquery>							
						
						<cf_GledgerEntryHeader
							    Mission               = "#misselect#"
							    OrgUnitOwner          = "0"        
							    Journal               = "#journal.journal#"  										
								Description           = "Forecast"
								TransactionSource     = "ForecastSeries"
								AccountPeriod         = "#accountperiod#"
								TransactionCategory   = "Memorial"
								MatchingRequired      = "0"
								Reference             = "#Reference#" 
								ReferenceOrgUnit      = "#orgunit#"     								
								Workflow              = "No"
								ReferenceId           = ""
								ReferenceNo           = "Forecast"
								ReferenceName         = "Forecasting"								
								DocumentCurrency      = "#MissionList.BudgetCurrency#"
								JournalBatchDate      = "#DateFormat(Audit.AuditDate,CLIENT.dateformatshow)#"
								DocumentDate          = "#DateFormat(Audit.AuditDate,CLIENT.dateformatshow)#"
								TransactionDate       = "#DateFormat(Audit.AuditDate,CLIENT.dateformatshow)#"								
								DocumentAmount        = "#AmountForecast#">
						
						<!--- obtain the details --->
								
						<cfquery name="ForecastLine" dbtype="query">
							SELECT *
						    FROM   RecordLedger
							WHERE  ProgramCode = '#ProgramCode#'
							AND    Fund        = '#Fund#'	
							AND    Reference   = '#Reference#'
							AND    OrgUnit     = '#OrgUnit#'									
						</cfquery>		
													
						<cfloop query="ForecastLine">
						
							<cfif amountforecast neq "">
						
								<!--- obtain the OE code --->
								
								<cfquery name="Object" 
									datasource="AppsLedger" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT  *
									FROM    Ref_AccountObject
									WHERE   Mission   = '#misselect#'
									AND     GLAccount = '#GLAccount#'
									AND     Fund      = '#Fund#'
								</cfquery>	
																						
								<cf_GledgerEntryLine
										Lines                 = "1"
									    Journal               = "#journal.journal#"
										JournalNo             = "#JournalSerialNo#"										
										AccountPeriod         = "#AccountPeriod#"
										Currency              = "#MissionList.BudgetCurrency#"
										TransactionDate       = "#DateFormat(Audit.AuditDate,CLIENT.dateformatshow)#"
										LogTransaction        = "No"																		
										TransactionSerialNo1  = "1"				
										Class1                = "Debit"
										Reference1            = "#Reference#"       
										ReferenceName1        = "Forecast"
										Description1          = "#Reference#"
										GLAccount1            = "#GLAccount#"
										OrgUnit1              = "#orgunit#" 
										Fund1                 = "#fund#"								
										Costcenter1           = ""
										ObjectCode1           = "#Object.ObjectCode#"
										ProgramCode1          = "#ProgramCode#"
										ProgramPeriod1        = "#ProgramPeriod.ProgramPeriod#"  
										ReferenceId1          = ""
										TransactionType1      = "Standard"
										Amount1               = "#AmountForecast#">		
									
								</cfif>	
								
						</cfloop>							
							
						<cf_GledgerEntryLine
								Lines                 = "1"
							    Journal               = "#journal.journal#"
								JournalNo             = "#JournalSerialNo#"										
								AccountPeriod         = "#AccountPeriod#"
								Currency              = "#MissionList.BudgetCurrency#"
								TransactionDate       = "#DateFormat(Audit.AuditDate,CLIENT.dateformatshow)#"	
								LogTransaction        = "No"								
								TransactionSerialNo1  = "0"
								Class1                = "Credit"
								Reference1            = "Forecast"       
								ReferenceName1        = "#Reference#"
								Description1          = ""
								GLAccount1            = "9001"
								OrgUnit1              = "#orgunit#" 
								TransactionType1      = "Standard"
								Amount1               = "#AmountForecast#">										
													
					</cfloop>
					
			</cfloop>
			
			</cfif>
		
		</cfif> 		
		
	</cfloop>
		
</cfloop>	