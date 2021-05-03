
<!--- STANDARD IN or IN CYCLE POSTING OF THE PAYROLL --->

<!--- entity parameters to be passed for loading into GL --->
<cfparam name="url.mission"        default="OICT">

<!--- added a provision to set the journal postings referenceNo to Final --->
<!--- ------------------------------------------------------------------ --->
<!--- ----------    determine default accounting Period (Year) --------- --->
<!--- ------------------------------------------------------------------ --->

<cfquery name="Param" 
    datasource="appsOrganization"  
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Accounting.dbo.Ref_ParameterMission
		WHERE    Mission = '#SchedulePeriod.Mission#'	
</cfquery>			

<!--- define the year of the transaction in case it was not passed --->

<cfparam name="url.year" default="#Param.CurrentAccountPeriod#">

<!--- ---------------------------------------- --->
<!--- -----determine the salary schedule------ --->
<!--- ---------------------------------------- --->

<cfquery name="Period" 
    datasource="appsOrganization"  
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Payroll.dbo.SalaryScheduleMission P
	WHERE    P.Mission        = '#SchedulePeriod.Mission#'	
	AND      P.SalarySchedule = '#SchedulePeriod.SalarySchedule#'
	AND      P.GLAccount IN (SELECT GLAccount
	                         FROM   Accounting.dbo.Ref_Account 
							 WHERE  GLAccount = P.GLAccount) 
</cfquery>

<cfif Period.GLAccount eq "">

		<cf_CalculationLockProgressInsert
		    ProcessNo      = "#url.processno#"
		   	ProcessBatchId = "#url.calculationid#"	
			ActionStatus   = "9"	
			StepStatus	   = "9"
			Description    = "A Payroll payment contra account has not been defined for #SchedulePeriod.Mission#">	
			
		<cfset stop = "1">
	
</cfif>		

<!--- ---------------------------------------- --->
<!--- determine the memorial journal --------- --->	
<!--- ---------------------------------------- --->
	
<cfquery name="Journal" 
    datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   J.*
		FROM     Accounting.dbo.Journal J 
		WHERE    Mission       = '#Period.Mission#' 
		AND      SystemJournal = 'Payroll'		
		AND      Currency      = '#Schedule.PaymentCurrency#' 
</cfquery>			

<cfif Journal.recordcount eq "0">

		<cf_CalculationLockProgressInsert
		    ProcessNo      = "#url.processno#"
		   	ProcessBatchId = "#url.calculationid#"	
			ActionStatus   = "9"	
			StepStatus	   = "9"
			StepException  = "A Journal was NOT defined for #Period.Mission# #Schedule.PaymentCurrency#"	
			Description    = "Initializing">	
	
		<cfset stop = "1">
				
<cfelse>
	
	<cfparam name="url.journal"  default="#Journal.Journal#">
			
</cfif>
	
<cfif Param.AdministrationLevel eq "Tree">
	<cfset tOwner = "0">	
<cfelse>		
	<cfset tOwner = Journal.OrgUnitOwner>		
</cfif>

<cfif url.actionstatus eq "2">			
	<cfset refno = "Initial">				
<cfelse>			
	<cfset refno = "Final">			
</cfif>				

<!--- Attention : the journal will need to have the months defined as subperiods
for that journal in JournalBatch this will then match the month of the payroll --->

<!--- 

1.  Define which calculation periods that have not been financially posted already

2a. Update OE, ProgramCode and GLAccount code in the settlment line

2b. Summarize per settlement, and then per person and Account, Object (from mapping), and Program (from Position) and Fund (from position)

3. Post settlements per person = header and then per OE lines

4. Payslip -> generate a PDF, store it in archive AND send it out. --->

<!--- 14/6 added a provision to set the journal postings without a referenceNo --->

<cfquery name="reset" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE  Accounting.dbo.TransactionHeader
		SET 	ReferenceNo  = 'Final'
		WHERE   ReferenceId  = '#url.calculationid#'
		AND     (ReferenceNo = '' or ReferenceNo is NULL)		
</cfquery>	

<cfquery name="PendingPosting" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM      Payroll.dbo.SalarySchedulePeriod P
		WHERE     Mission        = '#Period.Mission#' 
		AND       SalarySchedule = '#Period.SalarySchedule#' 
		AND       CalculationId = '#url.calculationid#'
		<!--- check if this has a posted instance ---> 
		AND       CalculationId NOT IN (
								   SELECT    ReferenceId
			                       FROM      Accounting.dbo.TransactionHeader
	    		                   WHERE     ReferenceId = P.CalculationId
								   AND       ReferenceNo = '#refno#'  <!--- initial : final --->
						       )
</cfquery>	

<!--- moved on 3/10/2016 to this spot and no longer in the calculation 
            we are locking any transactions that should not be changed anymore --->
 
<cfif url.actionstatus gte "2">
	
	<cfquery name="Update" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE  Payroll.dbo.PersonMiscellaneous
			SET     Status = '5'
			FROM    Payroll.dbo.PersonMiscellaneous T
			WHERE   CostId IN (SELECT ReferenceId
			                   FROM   Payroll.dbo.EmployeeSalaryLine 
							   WHERE  ReferenceId = T.CostId)
	</cfquery>
	
	<cfquery name="Update" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE  Payroll.dbo.PersonOvertime
		    SET     Status = '5'
		    FROM    Payroll.dbo.PersonOvertime T	
			WHERE   OvertimeId IN (SELECT ReferenceId 
			                       FROM   Payroll.dbo.EmployeeSalaryLine
								   WHERE  ReferenceId = T.OvertimeId)
			AND     OvertimePayment = 1				   	
	</cfquery>

</cfif>

<!--- ----------------------------------- --->
<!--- we set the owner of the transaction --->
<!--- ----------------------------------- --->

<cfquery name="Owner" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE 	ES  
	SET    	ES.OrgUnitOwner =  P.OrgUnit 
	FROM   	Payroll.dbo.EmployeeSettlementLine ES
			INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
				ON 	ES.PersonNo 			= ESET.PersonNo
				AND ES.SalarySchedule 		= ESET.SalarySchedule
				AND ES.Mission 				= ESET.Mission
				AND ES.PaymentDate 			= ESET.PaymentDate
				AND ES.PaymentStatus		= ESET.PaymentStatus
				AND ESET.ActionStatus       = '1'
	       	INNER JOIN Organization.dbo.Organization O ON ES.OrgUnit = O.OrgUnit INNER JOIN
           	Organization.dbo.Organization P ON O.Mission = P.Mission AND O.MandateNo = P.MandateNo AND O.ParentOrgUnit = P.OrgUnitCode
	WHERE   ESET.SettlementSchedule  = '#Period.SalarySchedule#'
	AND   	ES.OrgUnitOwner is NULL
</cfquery>

<cfquery name="Param"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Payroll.dbo.Parameter	
</cfquery>

<cf_CalculationLockProgressInsert
	ProcessNo      = "#url.processno#"
	ProcessBatchId = "#url.calculationid#"				
	StepStatus	   = "1"
	Description    = "Preparation">		

<cfloop query="PendingPosting">		

	<!--- ------------------------------------------ --->
	<!--- we set the account code of the transaction --->
	<!--- ------------------------------------------ --->

	<cfquery name="LedgerUpdate" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		
		UPDATE SL
		
		SET    SL.ObjectCode         = R.ObjectCode, 
		       SL.GLAccount          = R.GLAccount,
			   SL.GLAccountLiability = R.GLAccountLiability
			   
		FROM   Payroll.dbo.EmployeeSettlementLine SL 
			   INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
					ON 	SL.PersonNo 			= ESET.PersonNo
					AND SL.SalarySchedule 		= ESET.SalarySchedule
					AND SL.Mission 				= ESET.Mission
					AND SL.PaymentDate 			= ESET.PaymentDate
					AND SL.PaymentStatus		= ESET.PaymentStatus
					AND ESET.ActionStatus = '1' <!--- released --->			

			   INNER JOIN Payroll.dbo.SalarySchedulePayrollItem R 
			   		ON SL.SalarySchedule = R.SalarySchedule 
			        AND SL.Mission = R.Mission 
					AND SL.PayrollItem = R.PayrollItem
							  
		WHERE  R.Mission                = '#Period.Mission#'
		AND    ESET.SettlementSchedule  = '#Period.SalarySchedule#'
		AND    SL.PaymentDate           = '#PayrollEnd#'	
		AND    SL.PaymentStatus         = '0'
		
	</cfquery>		
	
	<!--- special provision for STL as we do on grades ----------------- --->
	<!--- if the match is on the postgrade parent we go one level deeper --->	
	
	<cfif Param.PostingMode eq "1">		
		
		<cfquery name="LedgerUpdate2" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
			UPDATE SL
			SET    SL.GLAccount  = R.GLAccount	
					   
			FROM   Payroll.dbo.EmployeeSettlementLine SL
					INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
					ON 	SL.PersonNo 			= ESET.PersonNo
					AND SL.SalarySchedule 		= ESET.SalarySchedule
					AND SL.Mission 				= ESET.Mission
					AND SL.PaymentDate 			= ESET.PaymentDate
					AND SL.PaymentStatus		= ESET.PaymentStatus
					AND ESET.ActionStatus = '1' <!--- released --->				

					INNER JOIN Payroll.dbo.SalarySchedulePayrollItemParent R ON SL.SalarySchedule = R.SalarySchedule 
				                  AND SL.Mission = R.Mission 
								  AND SL.PayrollItem = R.PayrollItem
								  AND SL.PostGradeParent = R.PostGradeParent							   
								  
			WHERE  R.Mission               = '#Period.Mission#'
			AND    ESET.SettlementSchedule = '#Period.SalarySchedule#'			
			AND    R.GLAccount IN ( SELECT GLAccount 
			                        FROM   Accounting.dbo.Ref_Account 
									WHERE  GLAccount = R.GLAccount)
			AND    SL.PaymentDate = '#payrollend#'	
			AND    SL.PaymentStatus   = '0'
			
		</cfquery>	
		
	<cfelse>
	
		<!--- updated 11/1/2016 to read from the position funding table
		returns the last available position funding within the payroll date --->
	
		<cfsavecontent variable="MyPositions">
	
			SELECT  P.PositionParentId, PF.FundClass
			FROM    Employee.dbo.PositionParentFunding AS PF INNER JOIN
    		        Employee.dbo.Position AS P ON PF.PositionParentId = P.PositionParentId INNER JOIN (
					SELECT       PositionParentId, MAX(DateEffective) AS LastEffective
					FROM         Employee.dbo.PositionParentFunding
					WHERE        DateEffective <= <cfoutput>'#payrollend#'</cfoutput>
					GROUP BY     PositionParentId ) L ON PF.PositionParentId = L.PositionParentId AND L.LastEffective = PF.DateEffective

		</cfsavecontent>
		
		<!--- if the match is on the fund class we go deeper --->
	
		<cfquery name="GLAccountUpdateClass" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">					
			UPDATE  SL
			SET     SL.GLAccount  = R.GLAccount	
			
			FROM    Payroll.dbo.EmployeeSettlementLine SL 
					INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
						ON 	SL.PersonNo 			= ESET.PersonNo
						AND SL.SalarySchedule 		= ESET.SalarySchedule
						AND SL.Mission 				= ESET.Mission
						AND SL.PaymentDate 			= ESET.PaymentDate
						AND SL.PaymentStatus		= ESET.PaymentStatus
						AND ESET.ActionStatus = '1' <!--- released --->
						
			        INNER JOIN (#PreservesingleQuotes(MyPositions)#) P      ON SL.PositionParentId     	= P.PositionParentId 
				    INNER JOIN Payroll.dbo.SalarySchedulePayrollItemClass R ON SL.SalarySchedule 		= R.SalarySchedule 
				                                                AND SL.Mission     = R.Mission 
						 									    AND SL.PayrollItem = R.PayrollItem 
															    AND P.FundClass    = R.PostClass						   
								  
			WHERE   R.Mission                = '#Period.Mission#'
			AND     ESET.SettlementSchedule  = '#Period.SalarySchedule#'
			
			AND     R.GLAccount IN (SELECT GLAccount 
			                        FROM   Accounting.dbo.Ref_Account 
									WHERE  GLAccount = R.GLAccount)									
			AND     SL.PaymentDate  = '#payrollend#'	
			AND    SL.PaymentStatus   = '0'			
		</cfquery>	
		
		<cfquery name="GLAccountLiabilityUpdateClass" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
				
			UPDATE  SL
			SET     SL.GLAccountLiability  = R.GLAccountLiability	
			
			FROM    Payroll.dbo.EmployeeSettlementLine SL 
					INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
						ON 	SL.PersonNo 			= ESET.PersonNo
						AND SL.SalarySchedule 		= ESET.SalarySchedule
						AND SL.Mission 				= ESET.Mission
						AND SL.PaymentDate 			= ESET.PaymentDate
						AND SL.PaymentStatus		= ESET.PaymentStatus
						AND ESET.ActionStatus = '1' <!--- released --->
						
			        INNER JOIN (#PreservesingleQuotes(MyPositions)#) P      ON SL.PositionParentId     	= P.PositionParentId 
				    INNER JOIN Payroll.dbo.SalarySchedulePayrollItemClass R ON SL.SalarySchedule 		= R.SalarySchedule 
				                                                AND SL.Mission     = R.Mission 
						 									    AND SL.PayrollItem = R.PayrollItem 
															    AND P.FundClass    = R.PostClass						   
								  
			WHERE   R.Mission          = '#Period.Mission#'
			AND     ESET.SettlementSchedule  = '#Period.SalarySchedule#'			
			
			AND     R.GLAccountLiability IN (SELECT GLAccount 
			                         FROM   Accounting.dbo.Ref_Account 
									 WHERE  GLAccount = R.GLAccountLiability)
									
			AND     SL.PaymentDate  = '#payrollend#'	
			AND    SL.PaymentStatus   = '0'
			
		</cfquery>	
				
	</cfif>	
	
	<!--- check of we have all relevant account codes --->
	
	<cfquery name="MissingObject" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 *			
		FROM   Payroll.dbo.EmployeeSettlementLine SL  INNER JOIN 
		   	   Payroll.dbo.EmployeeSettlement as ESET
					ON 	SL.PersonNo 			= ESET.PersonNo
					AND SL.SalarySchedule 		= ESET.SalarySchedule
					AND SL.Mission 				= ESET.Mission
					AND SL.PaymentStatus		= ESET.PaymentStatus
					AND ESET.ActionStatus = '1' <!--- released --->

				INNER JOIN Payroll.dbo.SalarySchedulePayrollItem R ON SL.SalarySchedule = R.SalarySchedule 
			                      AND SL.Mission = R.Mission 
							      AND SL.PayrollItem = R.PayrollItem
							  
		WHERE  R.Mission               = '#Period.Mission#'
		AND    ESET.SettlementSchedule = '#Period.SalarySchedule#'
		AND    SL.PaymentDate     = '#payrollend#'	
		AND    SL.PaymentStatus   = '0'
		AND    R.GLAccount NOT IN (SELECT GLAccount 
		                           FROM   Accounting.dbo.Ref_Account 
								   WHERE  GLAccount = R.GLAccount)		
	</cfquery>
		
	<cfif MissingObject.recordcount gte "1">
	
		<cf_CalculationLockProgressInsert
		    ProcessNo      = "#url.processno#"
		   	ProcessBatchId = "#url.calculationid#"	
			ActionStatus   = "9"	
			StepStatus	   = "9"
			StepException  = "A glaccount has not been set i.e #MissingObject.PayrollItem# - #MissingObject.GLAccount#. Please update the payroll item administration"	
			Description    = "Initializing">	
	
			<cfset stop = "1">
			
	</cfif>		
	
	
		
	<!--- 1 of 3 clean prior distribution entries --->
	
	<cfquery name="DeleteSettlementFunding" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		DELETE FROM Payroll.dbo.EmployeeSettlementLineFunding
		WHERE  PaymentId IN (SELECT PaymentId 
		                     FROM   Payroll.dbo.EmployeeSettlementLine SL INNER JOIN 
								   	   Payroll.dbo.EmployeeSettlement as ESET
											ON 	SL.PersonNo 			= ESET.PersonNo
											AND SL.SalarySchedule 		= ESET.SalarySchedule
											AND SL.Mission 				= ESET.Mission
											AND SL.PaymentStatus		= ESET.PaymentStatus
											AND ESET.ActionStatus = '1' 
				 	    	 WHERE  ESET.Mission             = '#Period.Mission#' 
						     AND    ESET.SettlementSchedule  = '#Period.SalarySchedule#' 
							 AND    ESET.PaymentDate         = '#PayrollEnd#'
							 AND    ESET.PaymentStatus       = '0' <!--- IN cycle --->
							 AND    SL.SettlementPhase     = '#refno#')
	
	</cfquery>	
	
	<!--- 29/4/2018 the below query might have to be reviewed to make sure once we have several mission periods that are plan periods : not so likely --->
	
	<cfquery name="planPeriod" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT  *
		FROM    Program.dbo.Ref_Period
		WHERE   isPlanningPeriod = 1
		AND     DateEffective   <= '#PayrollEnd#' 
		AND     DateExpiration  >= '#PayrollEnd#'	
	</cfquery>
			
	<cfquery name="InsertSettlementLineFunding" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		
		INSERT INTO Payroll.dbo.EmployeeSettlementLineFunding 
		            (PaymentId,Fund,FundClass,ProgramCode,Period,Percentage)
		
		SELECT      S.PaymentId, 
		            PF.Fund, 
					PF.FundClass,
				    PF.ProgramCode, 
					'#PlanPeriod.Period#',
				    ROUND(SUM(PF.Percentage), 2) AS Percentage
					
		FROM        Employee.dbo.PositionParentFunding PF 
		
		            INNER JOIN (SELECT    PF.PositionParentId, 							             
										  MAX(PF.DateEffective) AS LastDate
	                            FROM      Employee.dbo.PositionParentFunding PF 
	                            WHERE     PF.DateEffective <= '#PayrollEnd#'
								
								<!--- Attention --->
								<!--- Hanno 22/7 only programs that belong to this mission, maybe we should even add the ProgramPeriod here 
								as otherwise it might not show in the budget execution view if it is not enabled for that year --->
								
								AND       PF.ProgramCode IN (SELECT ProgramCode 
											                 FROM   Program.dbo.Program 
												     	     WHERE  Mission = '#Period.Mission#')
								
	                            GROUP BY  PF.PositionParentId) L 
								
					ON  PF.PositionParentId = L.PositionParentId 
					AND PF.DateEffective    = L.LastDate 
	
			        INNER JOIN  (SELECT    SL.PaymentId, SL.PositionParentId
	                             FROM      Payroll.dbo.EmployeeSettlementLine as SL 
	                             		   INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
												ON 	SL.PersonNo 			= ESET.PersonNo
												AND SL.SalarySchedule 		= ESET.SalarySchedule
												AND SL.Mission 				= ESET.Mission
												AND SL.PaymentDate 			= ESET.PaymentDate
												AND SL.PaymentStatus		= ESET.PaymentStatus
												AND ESET.ActionStatus = '1' <!--- released --->
												
	                             WHERE     ESET.Mission             = '#Period.Mission#' 								 
								 AND       ESET.SettlementSchedule  = '#Period.SalarySchedule#' 
								  <!--- Hanno ticket 62 
								 AND       ESET.SettlementSchedule  = '#Period.SalarySchedule#' 
								 --->
								 AND       ESET.PaymentDate         = '#PayrollEnd#' 
								 AND       ESET.PaymentStatus       = '0'
								 AND       SL.SettlementPhase       = '#refno#') S 
								 
					ON S.PositionParentId = L.PositionParentId
								
		GROUP BY    S.PaymentId, 
		            PF.Fund, 
				    PF.ProgramCode,	
				    PF.FundClass									
	</cfquery>	
	
	
	
	<!--- check if we will post --->	
	
	<cfif Period.DateEffectivePosting lte PayrollEnd or Period.DateEffectivePosting eq "">
			 
		<!--- -------------------------------------------------------------- --->
		<!--- optionally check for missing funding at this stage : 22/7/2017 --->
		<!--- -------------------------------------------------------------- --->
		 
		<cfif Period.DisableDistribution eq "0">
		
		     <cfinvoke component = "Service.Process.Payroll.Payable"  
				   method           = "setDistribution" 
				   Mission          = "#period.Mission#" 
				   Salaryschedule   = "#period.SalarySchedule#" 
				   PaymentStatus    = "0"
				   PaymentDate      = "#dateformat(PayrollEnd,client.dateformatshow)#"
				   SettlementPhase  = "#refno#">			
					
    			 <!--- check missing/incorrect distributions --->
			 
				 <cfquery name="incompleteDistributions" 
					datasource="appsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT	Settled.PersonNo,
						        (SELECT LastName 
								 FROM   Employee.dbo.Person 
								 WHERE  PersonNo = Settled.PersonNo) as LastName,
								ISNULL(Settled.Amount, 0)            as SettledAmount,
								ISNULL(Distribution.Amount, 0)       as DistributionAmount
						FROM
							(	SELECT	S.PersonNo, SUM(S.PaymentAmount) AS Amount
								FROM	Payroll.dbo.EmployeeSettlementLine S
										INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
											ON 	S.PersonNo 				= ESET.PersonNo
											AND S.SalarySchedule 		= ESET.SalarySchedule
											AND S.Mission 				= ESET.Mission
											AND S.PaymentDate 			= ESET.PaymentDate
											AND S.PaymentStatus	    	= ESET.PaymentStatus
											AND ESET.ActionStatus = '1' <!--- released --->
												
										INNER JOIN Payroll.dbo.Ref_PayrollItem P 
											ON S.PayrollItem = P.PayrollItem								
								WHERE	S.Mission                = '#Period.Mission#' 
								AND		ESET.SettlementSchedule  = '#Period.SalarySchedule#' 
								AND		S.PaymentDate            = '#PayrollEnd#' 
								AND		S.SettlementPhase        = '#refno#'
								AND     S.PaymentStatus          = '0'
								AND		P.PrintGroup IN (	SELECT PrintGroup 
															FROM   Payroll.dbo.Ref_SlipGroup 
															WHERE  NetPayment = 1
														)
								GROUP BY S.PersonNo
							) as Settled
							LEFT OUTER JOIN	(
									SELECT	  ESD1.PersonNo, 
											  SUM(ESD1.PaymentControlAmount*ESD1.PaymentExchangeRate) AS Amount
									FROM	  Payroll.dbo.EmployeeSettlementDistribution ESD1
									WHERE 	  ESD1.Mission          = '#Period.Mission#' 
									AND		  ESD1.SalarySchedule   = '#Period.SalarySchedule#' 
									AND		  ESD1.PaymentDate      = '#PayrollEnd#' 
									AND		  ESD1.SettlementPhase  = '#refno#'
									AND 	  ESD1.PaymentStatus	  = '0'  <!--- IN cycle --->
									GROUP BY  ESD1.PersonNo	) AS Distribution ON Settled.PersonNo = Distribution.PersonNo
									
						WHERE	ABS(ISNULL(Settled.Amount, 0) - ISNULL(Distribution.Amount, 0)) > 0.05 
						AND     Settled.Amount	> 0
						
				</cfquery>
			
				<cfif incompleteDistributions.recordcount gt 0>
				
					<cf_CalculationLockProgressInsert
					    ProcessNo      = "#url.processno#"
					   	ProcessBatchId = "#url.calculationid#"	
						ActionStatus   = "9"	
						StepStatus	   = "9"
						StepException  = "Problem with the Bank Account and/or Payment Method for #incompleteDistributions.recordcount# staff: i.e. #incompleteDistributions.PersonNo# #incompleteDistributions.LastName#"
						Description    = "Initializing">	
				
					<cfset stop = "1">
						
				</cfif>			
				
				<cfquery name="validGLAccounts" 
						datasource="appsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
						SELECT TOP 1 L.PersonNo, 'PersonGledger' origin 
						FROM       Payroll.dbo.EmployeeSettlementDistribution as L
						WHERE      L.Mission         = '#Period.Mission#' 					
						AND        L.SalarySchedule  = '#Period.SalarySchedule#'
						AND        L.PaymentDate     = '#payrollend#' 	
						AND        L.SettlementPhase = '#refno#'							
						AND        L.PaymentStatus   = '0'
						<cfif Period.DistributionMode eq "1">
						AND        L.PaymentMode IN ('Check')
						</cfif>
						AND NOT EXISTS (SELECT 'X' 
						                FROM   Employee.dbo.PersonGLedger 
										WHERE  Area= 'Payroll' 
										AND    PersonNo = L.PersonNo)
								
						
						UNION
						
						SELECT     TOP 1 L.PersonNo, 'Ref_Account' origin 
						FROM       Payroll.dbo.EmployeeSettlementDistribution as L
						WHERE      L.Mission         = '#Period.Mission#' 					
						AND        L.SalarySchedule  = '#Period.SalarySchedule#'
						AND        L.PaymentDate     = '#payrollend#' 	
						AND        L.SettlementPhase = '#refno#'
						AND        L.PaymentStatus   = '0'
						<cfif Period.DistributionMode eq "1">
						AND        L.PaymentMode IN ('Check')
						</cfif>
						AND NOT EXISTS (SELECT 'X' 
						                FROM   Accounting.dbo.Ref_Account 
						                WHERE  GLAccount IN (SELECT GLAccount 
										                     FROM   Employee.dbo.PersonGledger as PG 
															 WHERE  PG.PersonNo = L.PersonNo 
															 AND    Area        = 'Payroll')
										 )
				</cfquery>
										
				<cfif validGLaccounts.recordCount gte 1>
				
					<cf_CalculationLockProgressInsert
			   			ProcessNo      = "#url.processno#"
			  			ProcessBatchId = "#url.calculationid#"	
						ActionStatus   = "9"	
						StepStatus	   = "9"
						StepException  = "Distribution problem: Record a GLaccount type for Person: #validGLaccounts.PersonNo# for #validGlaccounts.Origin#"
						Description    = "Initializing">	
						
					<cfset stop = "1">
											
				</cfif>
	
		</cfif>
		 				
		<cfif stop eq "0">	
		
			<cfquery name="Total" 
					datasource="appsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					SELECT    ROUND(SUM(Amount), 2) AS PostingAmount
					FROM      Payroll.dbo.EmployeeSettlementLine as SL 
							  INNER JOIN Payroll.dbo.EmployeeSettlement as ESET
								ON 	SL.PersonNo 			= ESET.PersonNo
								AND SL.SalarySchedule 		= ESET.SalarySchedule
								AND SL.Mission 				= ESET.Mission
								AND SL.PaymentDate 			= ESET.PaymentDate
								AND SL.PaymentStatus		= ESET.PaymentStatus
								AND ESET.ActionStatus       = '1' <!--- released --->
								
					WHERE     ESET.Mission                  = '#Period.Mission#' 					
					AND       ESET.SettlementSchedule       = '#Period.SalarySchedule#'
					AND       ESET.PaymentDate              = '#payrollend#' 		
					AND       SL.SettlementPhase            = '#refno#'	
					AND       SL.PaymentStatus              = '0'
			</cfquery>	
			
			<cfquery name="getPeriod" 
		    		datasource="appsOrganization"		 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
					SELECT * 
					FROM   Accounting.dbo.Period
					WHERE  PeriodDateEnd   >= '#payrollend#'
					AND    PeriodDateStart <= '#payrollend#'
					AND    ActionStatus = '0'						
					ORDER BY AccountPeriod
			</cfquery>
			
			<cfif getPeriod.recordcount gte "1">
			
				<cfset per = getPeriod.AccountPeriod>
				
			<cfelse>
			
				<cfset per = url.year>
			
			</cfif>
			
			<cfif total.PostingAmount neq "">	
			
				<!--- base payroll glaccount posting we have 3 modes of details
				
				   Schedule / entity posting per program / object 
				   Schedule / entity posting per program / object / orgunit booking
				   
				   Schedule / entity / person booking : disabled 
				   
			     --->
			   							
				<cf_GledgerEntryHeader
					    Mission               = "#SchedulePeriod.Mission#"
					    OrgUnitOwner          = "#tOwner#"
						Datasource            = "appsOrganization"
					    Journal               = "#URL.Journal#"
						AccountPeriod         = "#per#"							
						JournalTransactionNo  = "#year(payrollend)#-#month(payrollend)#"
						Description           = "#SchedulePeriod.SalarySchedule#: #DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
						TransactionSource     = "PayrollSeries"		
						TransactionSourceId   = "#SchedulePeriod.CalculationId#"		
						TransactionCategory   = "Memorial"
						MatchingRequired      = "1"							
						Reference             = "Posting of Payroll"       
						ReferenceName         = "Payroll Settlement"
						ReferenceNo           = "#refno#"
						ReferenceId           = "#SchedulePeriod.CalculationId#"							
						Workflow              = "Yes"
						DocumentCurrency      = "#Schedule.PaymentCurrency#"
						CurrencyDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
						DocumentDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
						TransactionDate       = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
						DocumentAmount        = "#total.PostingAmount#"
						OfficerUserId         = "#SESSION.acc#"
						OfficerLastName       = "#SESSION.last#"
						OfficerFirstName      = "#SESSION.first#">
						
						<!--- 21/7/2017 adjust this to take the new table instead --->
													
						<cfquery name="PayrollLines" 
								datasource="appsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">	
								
								SELECT    T.SalarySchedule, 							          
										  T.PaymentYear, 
										  T.PaymentMonth, 
										  T.Currency,		
										  <cfif Period.OrgUnit eq "1">						 
										  OrgUnit, 
										  </cfif>	
										  PF.ProgramCode, 
										  PF.Fund,									   
										  ObjectCode, 
										  GLAccount,
										  <!---  T.PersonNo, --->
										  ROUND(SUM(Amount*PF.Percentage), 2) AS PostingAmount
										  
								FROM      Payroll.dbo.EmployeeSettlementLine T 
										  INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
										  	ON 	T.PersonNo 				= ESET.PersonNo
											AND T.SalarySchedule 		= ESET.SalarySchedule
											AND T.Mission 				= ESET.Mission
											AND T.PaymentDate 			= ESET.PaymentDate
											AND T.PaymentStatus		    = ESET.PaymentStatus
											AND ESET.ActionStatus = '1' <!--- released --->
											
										  INNER JOIN
								          Payroll.dbo.EmployeeSettlementLineFunding PF ON PF.PaymentId = T.PaymentId
								WHERE     (T.Mission           = '#SchedulePeriod.Mission#') 					
								AND       T.SalarySchedule     = '#SchedulePeriod.SalarySchedule#'
								AND       T.PaymentDate        = '#payrollend#' 
								AND       T.SettlementPhase    = '#refno#'		
								AND       T.PaymentStatus      = '0'					      
								GROUP BY  T.SalarySchedule, 			
								         <!--- post on unit level --->				          
										 <cfif Period.OrgUnit eq "1">
								          OrgUnit, 									 
										  </cfif>
										  PF.ProgramCode, 
										  PF.Fund, 
										  ObjectCode, 
										  PaymentYear, 
										  Currency,
										  PaymentMonth, 
										  GLAccount
										  <!--- , T.PersonNo --->
									
								UNION ALL
								
								<!--- we want to prevent this --->
									
								SELECT    T.SalarySchedule, 							          
										  T.PaymentYear, 
										  T.PaymentMonth, 
										  T.Currency,		
										  <cfif Period.OrgUnit eq "1">						 
										  OrgUnit, 
										  </cfif>	
										  '' as ProgramCode, 
										  '' as Fund, 
										  ObjectCode, 
										  GLAccount,
										  <!--- T.PersonNo, --->									  
										  ROUND(SUM(Amount), 2) AS PostingAmount
								FROM      Payroll.dbo.EmployeeSettlementLine T
										  INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
											ON 	T.PersonNo 			= ESET.PersonNo
											AND T.SalarySchedule 		= ESET.SalarySchedule
											AND T.Mission 				= ESET.Mission
											AND T.PaymentDate 			= ESET.PaymentDate
											AND T.PaymentStatus		    = ESET.PaymentStatus
											AND ESET.ActionStatus = '1' <!--- released --->
											
								WHERE     T.Mission           = '#SchedulePeriod.Mission#' 					
								AND       T.SalarySchedule    = '#SchedulePeriod.SalarySchedule#'
								AND       T.PaymentDate       = '#payrollend#' 
								AND       T.SettlementPhase   = '#refno#'
								AND       T.PaymentStatus     = '0'
								AND       NOT EXISTS (SELECT 'X' 
								                      FROM   Payroll.dbo.EmployeeSettlementLineFunding 
													  WHERE  PaymentId = T.PaymentId)
													  
								GROUP BY  T.SalarySchedule, 							          
										 <cfif Period.OrgUnit eq "1">
								          OrgUnit, 									 
										  </cfif>									  
										  ObjectCode, 
										  PaymentYear, 
										  Currency,
										  PaymentMonth, 
										  GLAccount
										  <!--- ,
										  T.PersonNo						  
										  --->
	
										  
						</cfquery>	
						
						<!--- obtain the executionperiod --->
						
						<cfquery name="getPeriod" 
							datasource="appsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">	
								SELECT     M.Period, 
								           M.PlanningPeriod
								FROM       Ref_MissionPeriod AS M INNER JOIN
					                       Program.dbo.Ref_Period AS P ON M.Period = P.Period
								WHERE      M.Mission = '#SchedulePeriod.Mission#' 
								AND        P.DateEffective  <= '#payrollend#'
								AND        P.DateExpiration >= '#payrollend#'
								AND	       M.isPlanPeriod = '1'
						</cfquery>
																
						<!--- posting source lines --->		  
						
						<cfset parentJournalSerialNo = journalSerialNo>
								
						<cfoutput query="PayrollLines">
						
							 <cfquery name="ProgramPeriod" 
							datasource="appsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">	
								SELECT     *
								FROM       Program.dbo.ProgramPeriod
								WHERE      ProgramCode = '#ProgramCode#'
								AND        Period      = '#getPeriod.PlanningPeriod#'							
							</cfquery> 
						
							 <cfif Period.OrgUnit eq "0">	
							 	<cfset OrgUnit = "">
							 </cfif>	
							 
							 	<cfquery name="getAccount" 
								    datasource="AppsOrganization" 
								    username="#SESSION.login#" 
								    password="#SESSION.dbpw#">
									    SELECT    *
									    FROM      Accounting.dbo.Ref_AccountMission
										WHERE     Mission   = '#SchedulePeriod.Mission#'
										AND       GLAccount = '#GLAccount#'
									</cfquery>
							 					 
							<cfif getAccount.recordcount eq "0">
									
									<cf_message message = "#GLAccount# not defined for #SchedulePeriod.Mission#. Operation aborted." return = "no">
									<cfabort>
																									
							</cfif>		
							
							<cfif GLAccount eq Period.GLAccount>
							
									<cf_GledgerEntryLine
										Lines                 = "1"
										Datasource            = "appsOrganization"
									    Journal               = "#URL.Journal#"										
										JournalNo             = "#JournalSerialNo#"
										JournalTransactionNo  = "PR#PaymentYear#-#PaymentMonth#"	
										LogTransaction        = "No"
										AccountPeriod         = "#per#"					
										Currency              = "#Currency#"
										CurrencyDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
										TransactionDate       = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"															
										TransactionSerialNo1  = "#currentrow#"				
										Class1                = "Debit"
										Reference1            = "Payroll cost" 		
										ReferenceNo1          = "#ProgramPeriod.reference#"										
										ReferenceName1        = "#SchedulePeriod.SalarySchedule#: #PaymentYear#-#PaymentMonth#"
										GLAccount1            = "#GLAccount#"											
										Fund1                 = "#Fund#"			
										Costcenter1           = "#orgUnit#"				
										ProgramCode1          = "#ProgramCode#"
										ObjectCode1           = "#ObjectCode#"
										ProgramPeriod1        = "#getPeriod.Period#" 
										ReferenceId1          = ""
										TransactionType1      = "Standard"
										Amount1               = "#PostingAmount#">
										
										<!--- Description1		  = "#PayrollLines.PersonNo#" --->
							
							<cfelse>					 						 
								
								<cf_GledgerEntryLine
										Lines                 = "1"
										Datasource            = "appsOrganization"
									    Journal               = "#URL.Journal#"										
										JournalNo             = "#JournalSerialNo#"
										JournalTransactionNo  = "PR#PaymentYear#-#PaymentMonth#"	
										LogTransaction        = "No"
										AccountPeriod         = "#per#"					
										Currency              = "#Currency#"
										CurrencyDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
										TransactionDate       = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"															
										TransactionSerialNo1  = "#currentrow#"				
										Class1                = "Debit"
										Reference1            = "Payroll cost" 		
										ReferenceNo1          = "#ProgramPeriod.reference#"													
										ReferenceName1        = "#SchedulePeriod.SalarySchedule#: #PaymentYear#-#PaymentMonth#"
										GLAccount1            = "#GLAccount#"											
										Fund1                 = "#Fund#"			
										Costcenter1           = "#orgUnit#"				
										ProgramCode1          = "#ProgramCode#"
										ObjectCode1           = "#ObjectCode#"
										ProgramPeriod1        = "#getPeriod.Period#"  
										ReferenceId1          = ""
										TransactionType1      = "Standard"
										Amount1               = "#PostingAmount#">
									
									<!--- Description1 		  = "#PayrollLines.PersonNo#"	--->
									
							</cfif>		
																
						</cfoutput>
						
						<!--- posting destination lines --->
													
						<cfquery name="LiabilityLines" 
								datasource="appsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">		
								SELECT    SalarySchedule, 							          
										  PaymentYear, 
										  PaymentMonth, 
										  Currency,													 
										  GLAccountLiability, 
										  <!--- PersonNo, --->
										  ProgramCode, 
										  Fund,									   
										  ObjectCode,
										  ROUND(SUM(Amount), 2) AS PostingAmount
										  --,PayrollItem
								FROM     (
											SELECT		esl.SalarySchedule, 							          
										  				esl.PaymentYear, 
										  				esl.PaymentMonth, 
										  				esl.Currency,
										  				esl.PayrollItem,
														<!--- 
														esl.PersonNo,
														--->
														PF.ProgramCode, 
														PF.Fund,									   
														ObjectCode,													 
										  				CASE WHEN esl.PayrollItem IN (SELECT PayrollItem 
																	FROM Payroll.dbo.Ref_PayrollGroupItem as PGI 
																	WHERE PGI.PayrollItem = esl.PayrollItem AND  Code = 'Retention') THEN
											  				(SELECT PG.GLAccount FROM Employee.dbo.PersonGLedger as PG WHERE PG.PersonNo = esl.PersonNo  AND Area= 'Payroll')
											  			ELSE
												 			GLAccountLiability
										  				END as GLAccountLiability
														,Amount*ISNULL(PF.Percentage,1) as Amount
											FROM      Payroll.dbo.EmployeeSettlementLine as esl
														INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
														ON 	esl.PersonNo 		= ESET.PersonNo
														AND esl.SalarySchedule 	= ESET.SalarySchedule
														AND esl.Mission 		= ESET.Mission
														AND esl.PaymentDate 	= ESET.PaymentDate
														AND esl.PaymentStatus	= ESET.PaymentStatus
														AND ESET.ActionStatus = '1' <!--- released --->
														
														LEFT OUTER JOIN Payroll.dbo.EmployeeSettlementLineFunding PF ON PF.PaymentId = ESL.PaymentId
											WHERE     esl.Mission            = '#SchedulePeriod.Mission#' 					
											AND       esl.SalarySchedule     = '#SchedulePeriod.SalarySchedule#'
											AND       esl.PaymentDate        = '#payrollend#' 
											AND       esl.SettlementPhase    = '#refno#'
											AND       esl.PaymentStatus      = '0' <!--- in cycle --->
									) as LiabilityLin
								GROUP BY  SalarySchedule, 							          											
										  PaymentYear, 
										  Currency,
										  PaymentMonth, 
										  GLAccountLiability,
										  <!---  PersonNo, --->
										  ProgramCode, 
										  Fund,									   
										  ObjectCode 
						</cfquery>
							
						
						<cfoutput query="LiabilityLines">	
						
							<cfif GLAccountLiability eq "">
								<cfset glaccount =  Period.GLAccount>
							<cfelse>
							    <cfset glaccount =  GLAccountLiability>
							</cfif>
							
							<cfquery name="ProgramPeriod" 
							datasource="appsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">	
								SELECT     *
								FROM       Program.dbo.ProgramPeriod
								WHERE      ProgramCode = '#ProgramCode#'
								AND        Period      = '#getPeriod.PlanningPeriod#'							
							</cfquery> 
						
							 <cfif Period.OrgUnit eq "0">	
							 	<cfset OrgUnit = "">
							 </cfif>	
							 
							 	<cfquery name="getAccount" 
								    datasource="AppsOrganization" 
								    username="#SESSION.login#" 
								    password="#SESSION.dbpw#">
									    SELECT    *
									    FROM      Accounting.dbo.Ref_AccountMission
										WHERE     Mission   = '#SchedulePeriod.Mission#'
										AND       GLAccount = '#GLAccount#'
									</cfquery>
							 					 
							<cfif getAccount.recordcount eq "0">
									
									<cf_message message = "#GLAccount# not defined for #SchedulePeriod.Mission#. Operation aborted." return = "no">
									<cfabort>
																									
							</cfif>
														
							<cf_GledgerEntryLine
									Lines                 = "1"
									Datasource            = "appsOrganization"
								    Journal               = "#URL.Journal#"
									JournalNo             = "#JournalSerialNo#"
									JournalTransactionNo  = "#year(SchedulePeriod.payrollend)#-#month(SchedulePeriod.PayrollEnd)#"		
									LogTransaction        = "No"
									AccountPeriod         = "#per#"				
									Currency              = "#Schedule.PaymentCurrency#"
									CurrencyDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
									TransactionDate       = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
																			
									TransactionSerialNo1  = "0"				
									Class1                = "Credit"
									Reference1            = "Liability"       
									ReferenceName1        = "#SchedulePeriod.SalarySchedule#: #url.year#-#month(SchedulePeriod.payrollend)#"
									GLAccount1            = "#GLAccount#"
									Fund1                 = "#Fund#"			
									Costcenter1           = "#orgUnit#"				
									ProgramCode1          = "#ProgramCode#"
									ObjectCode1           = "#ObjectCode#"
									ProgramPeriod1        = "#getPeriod.Period#" 
									ReferenceId1          = ""
									ReferenceNo1          = "#ProgramPeriod.reference#"
									TransactionType1      = "Contra-Account"									
									Amount1               = "#PostingAmount#">		
									
									<!--- Description1		  = "#LiabilityLines.PersonNo#" --->
								
						</cfoutput>										
				
						<cfquery name="CrossReference" 
						datasource="appsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
							
								UPDATE   SL
								SET      SL.Journal           = '#URL.Journal#', 
								         SL.JournalSerialNo   = '#JournalSerialNo#'
								FROM     Payroll.dbo.EmployeeSettlementLine SL 
										 INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
											ON 	SL.PersonNo 			= ESET.PersonNo
											AND SL.SalarySchedule 		= ESET.SalarySchedule
											AND SL.Mission 				= ESET.Mission
											AND SL.PaymentDate 			= ESET.PaymentDate
											AND SL.PaymentStatus		= ESET.PaymentStatus
											AND ESET.ActionStatus = '1' <!--- released --->
											
										 INNER JOIN Payroll.dbo.SalarySchedulePayrollItem R ON SL.SalarySchedule = R.SalarySchedule 
							                   AND SL.Mission = R.Mission 
									 		   AND SL.PayrollItem = R.PayrollItem
											   
								WHERE    R.Mission             = '#Period.Mission#'
								AND      SL.SalarySchedule     = '#Period.SalarySchedule#'
								AND      SL.PaymentDate        = '#payrollend#'	
								AND      SL.SettlementPhase    = '#refno#'
								AND      SL.PaymentStatus      = '0' 
						</cfquery>		
											
						<!--- ------------------------------------------------------------------------------------------------------------------- --->
						<!--- we now post D/C offset transaction using the journal for offset to correctly offset again the original transaction. --->
						<!--- ------------------------------------------------------------------------------------------------------------------- --->
												
						<cfquery name="Offset" 
							datasource="appsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">		
							
							SELECT   SL.PersonNo,
							         SL.Currency, 
									 SL.Amount, 
									 (SELECT GLAccount 
									 FROM   Accounting.dbo.TransactionLine
									 WHERE  Journal = H.Journal
									 AND    JournalSerialNo = H.JournalSerialNo
									 AND    TransactionSerialNo = '1') as OffsetGLAccount,
									 SL.GLAccountLiability, 
							         H.Journal         as OffsetJournal, 
									 H.JournalSerialNo as OffsetJournalSerialNo, 
									 H.TransactionId
							FROM     Payroll.dbo.EmployeeSettlementLine SL 
							
									 INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
												ON 	SL.PersonNo 			= ESET.PersonNo
												AND SL.SalarySchedule 		= ESET.SalarySchedule
												AND SL.Mission 				= ESET.Mission
												AND SL.PaymentDate 			= ESET.PaymentDate
												AND SL.PaymentStatus		= ESET.PaymentStatus
												AND ESET.ActionStatus = '1' <!--- released --->		
												
									INNER JOIN 	Accounting.dbo.TransactionHeader H ON SL.SourceId = H.TransactionId	
								   
							WHERE    SL.Mission            = '#Period.Mission#'
							AND      SL.SalarySchedule     = '#Period.SalarySchedule#'
							AND      SL.PaymentDate        = '#payrollend#'	
							AND      SL.SettlementPhase    = '#refno#'
							AND      SL.PaymentStatus      = '0' 										
							AND      SL.Source = 'Offset' 					 
							
						</cfquery>	
						
						<!--- we create one transaction header with offset lines --->
						
						<cfquery name="thisJournal" 
								datasource="appsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT TOP 1 * 
								FROM   Accounting.dbo.Journal 
								WHERE  SystemJournal   = 'Offset'
								AND    Mission         = '#SchedulePeriod.Mission#'
								AND    Currency        = '#Schedule.PaymentCurrency#'								
						</cfquery>
							
						<cfif thisJournal.recordcount eq "0">
							
								<cfquery name="thisJournal" 
									datasource="appsOrganization" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT TOP 1 * 
									FROM   Accounting.dbo.Journal 
									WHERE  Journal = '#get.Journal#'														
								</cfquery>
							
						</cfif>
						
						<cfloop query="Offset">
					
							<cf_GledgerEntryHeader
							    Mission               = "#SchedulePeriod.Mission#"
							    OrgUnitOwner          = "#tOwner#"							
								Datasource            = "appsOrganization"
							    Journal               = "#thisJournal.Journal#"
								AccountPeriod         = "#per#"							
								JournalTransactionNo  = "#year(PendingPosting.payrollend)#-#month(PendingPosting.payrollend)#"
								Description           = "Offset advance through Payroll"
								TransactionSource     = "PayrollSeries"		
								TransactionSourceId   = "#SchedulePeriod.CalculationId#"			
								TransactionCategory   = "Memorial"
								MatchingRequired      = "0"			
								Workflow              = "No"  		
								ActionStatus          = "1"		
								Reference             = "Offset"  																		
								ReferencePersonNo     = "#PersonNo#"																								
								TransactionDate       = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
								DocumentCurrency      = "#Currency#"
								CurrencyDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
								DocumentDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"										
								DocumentAmount        = "#Amount#"
								OfficerUserId         = "#SESSION.acc#"
								OfficerLastName       = "#SESSION.last#"
								OfficerFirstName      = "#SESSION.first#">																							
									
								<cf_GledgerEntryLine
									Lines                    = "2"
									Datasource               = "appsOrganization"
								    Journal                  = "#thisJournal.Journal#"
									JournalNo                = "#JournalSerialNo#"
									JournalTransactionNo     = "#year(SchedulePeriod.PayrollEnd)#-#month(SchedulePeriod.PayrollEnd)#"		
									LogTransaction           = "Yes"
									AccountPeriod            = "#per#"																								 
									DocumentCurrency         = "#Currency#"
									AmountCurrency           = "#Currency#"
									CurrencyDate             = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
									TransactionDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
									ParentJournal            = "#OffsetJournal#"
								    ParentJournalSerialNo    = "#OffsetJournalSerialNo#"
																			
									TransactionSerialNo1     = "1"				
									Class1                   = "Credit"
									Reference1               = "Offset Individual"       
									ReferenceName1           = "Offset #year(PendingPosting.payrollend)#-#month(PendingPosting.payrollend)#"										
									Description1             = ""
									GLAccount1               = "#OffsetGLAccount#"											
									ReferenceId1             = ""
									TransactionType1         = "Contra-Account"
									Amount1                  = "#Amount#"
									
									TransactionSerialNo2     = "0"				
									Class2                   = "Debit"
									Reference2               = "Payroll deduction" 						
									ReferenceName2           = "Offset: #year(PendingPosting.payrollend)#-#month(PendingPosting.payrollend)#"
									Description2             = ""																							
									GLAccount2               = "#GLAccountLiability#"
									ReferenceId2             = ""
									TransactionType2         = "Standard"
									Amount2                  = "#Amount#">						
					
						</cfloop>				
						
					<!--- if individual posting mode is enabled then we make another booking 
					    for the amount posted on the account of the	schedule/mission --->					
																	
					<cfif Period.PostingMode eq "Schedule">  
					
					    <!--- default mode to make postings for the AP --->
					
						<cfif Period.DisableDistribution eq "0">
						
							   <!--- only if distribution is not disabled --->
						
						      <cfquery name="OffsetScheduleAccount" 
										datasource="appsOrganization" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">										
										
										SELECT     ESD.SalaryScheduleGLAccount, 
										           ESD.PayThroughGLAccount, 
												   ESD.PayThroughBankName, 
												   ESD.PaymentCurrency, 
												   ESD.PersonNo,
												   CASE WHEN (SELECT  GLAccount 
											              FROM    Employee.dbo.PersonGLedger
								 						  WHERE   PersonNo = ESD.PersonNo 
														  AND     Area = 'Payroll') IS NOT NULL 
														  
												    THEN (SELECT  GLAccount
								                          FROM    Employee.dbo.PersonGLedger
						                                  WHERE   PersonNo = ESD.PersonNo 
														  AND     Area = 'Payroll') ELSE '599999999' END AS PersonGLAccount,
												   ROUND(SUM(ESD.PaymentAmount), 2) AS PaymentAmount
												   
										FROM       Payroll.dbo.EmployeeSettlementDistribution AS ESD
												   INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
														ON 	ESD.PersonNo 			= ESET.PersonNo
														AND ESD.SalarySchedule 		= ESET.SalarySchedule
														AND ESD.Mission 			= ESET.Mission
														AND ESD.PaymentDate 		= ESET.PaymentDate
														AND ESD.PaymentStatus		= ESET.PaymentStatus
														AND ESET.ActionStatus = '1' <!--- released --->
													
										WHERE      ESD.Mission         = '#Period.Mission#' 					
										AND        ESD.SalarySchedule  = '#Period.SalarySchedule#'
										AND        ESD.PaymentDate     = '#payrollend#' 	
										AND        ESD.SettlementPhase = '#refno#'	
										AND        ESD.PaymentStatus   = '0'
										
										<!--- only for checks --->
										
										<cfif Period.DistributionMode eq "1">
										<!--- only for checks --->
										AND        ESD.PaymentMode IN ('Check')
										</cfif>
																		
										GROUP BY   ESD.SalaryScheduleGLAccount, 
										           ESD.PayThroughGLAccount, 
												   ESD.PayThroughBankName, 
												   ESD.PaymentCurrency,
												   ESD.PersonNo						
												   <!--- rfuentes to avoid offset for the ones on LWOP in negative settlement --->
										/*HAVING ROUND(SUM(ESD.PaymentAmount), 2) >0*/
							</cfquery>
							
							<cfquery name="thisJournal" 
								datasource="appsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT TOP 1 * 
								FROM   Accounting.dbo.Journal 
								WHERE  TransactionCategory IN ('Payables','DirectPayment')
								AND    Mission             = '#SchedulePeriod.Mission#'
								AND    Currency            = '#Schedule.PaymentCurrency#'
								AND    SystemJournal       = 'Settlement' 
							</cfquery>
							
							<cfif thisJournal.recordcount eq "0">
							
								<cfquery name="thisJournal" 
									datasource="appsOrganization" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT TOP 1 * 
									FROM   Accounting.dbo.Journal 
									WHERE  TransactionCategory IN ('Payables','DirectPayment')
									AND    Mission             = '#SchedulePeriod.Mission#' 
									AND    Currency            = '#Schedule.PaymentCurrency#'									
								</cfquery>
							
							</cfif>
														
							<!--- this records offsets the payroll for an AP transaction to actually pay the person : check or transfer 
							but for that we need to know the correct bank account to be set in the transaction itself : Ana --->
							
							<cfloop query="OffsetScheduleAccount">
													
								<cf_GledgerEntryHeader
								    Mission               = "#SchedulePeriod.Mission#"
								    OrgUnitOwner          = "#tOwner#"							
									Datasource            = "appsOrganization"
								    Journal               = "#thisJournal.Journal#"
									AccountPeriod         = "#per#"							
									JournalTransactionNo  = "#year(PendingPosting.payrollend)#-#month(PendingPosting.payrollend)#"
									Description           = "#PayThroughBankName#: #DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
									TransactionSource     = "PayrollSeries"		
									TransactionSourceId   = "#SchedulePeriod.CalculationId#"			
									TransactionCategory   = "Payables"
									MatchingRequired      = "1"			
									Workflow              = "Yes"  		
									ActionStatus          = "0"		
									Reference             = "Payment"  									
									ReferenceName         = "#PayThroughBankName#"
									ReferencePersonNo     = "#PersonNo#"																								
									TransactionDate       = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
									DocumentCurrency      = "#PaymentCurrency#"
									CurrencyDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
									DocumentDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"										
									DocumentAmount        = "#PaymentAmount#"
									OfficerUserId         = "#SESSION.acc#"
									OfficerLastName       = "#SESSION.last#"
									OfficerFirstName      = "#SESSION.first#">
									
									<!--- validate if negative settlement, to set an AR for the Employee instead of the Bank dist  --->
									<cfset DebitGLAccount =  OffsetScheduleAccount.PayThroughGLAccount>
									
									<cfif PaymentAmount lt 0>
										<cfset DebitGLAccount =  OffsetScheduleAccount.PersonGLAccount>
									</cfif>										
									
									<cf_GledgerEntryLine
										Lines                    = "2"
										Datasource               = "appsOrganization"
									    Journal                  = "#thisJournal.Journal#"
										JournalNo                = "#JournalSerialNo#"
										JournalTransactionNo     = "#year(SchedulePeriod.PayrollEnd)#-#month(SchedulePeriod.PayrollEnd)#"		
										LogTransaction           = "Yes"
										AccountPeriod            = "#per#"																								 
										DocumentCurrency         = "#PaymentCurrency#"
										AmountCurrency           = "#PaymentCurrency#"
										CurrencyDate             = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
										TransactionDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
										ParentJournal            = "#URL.Journal#"
									    ParentJournalSerialNo    = "#parentJournalSerialNo#"
																				
										TransactionSerialNo1     = "1"				
										Class1                   = "Credit"
										Reference1               = "Bank Charge"       
										ReferenceName1           = "#PayThroughBankName#: #year(PendingPosting.payrollend)#-#month(PendingPosting.payrollend)#"										
										Description1             = "#PayThroughBankName#"
										GLAccount1               = "#DebitGLAccount#"											
										ReferenceId1             = ""
										TransactionType1         = "Contra-Account"
										Amount1                  = "#PaymentAmount#"
										
										TransactionSerialNo2     = "0"				
										Class2                   = "Debit"
										Reference2               = "Offset" 						
										ReferenceName2           = "#SchedulePeriod.SalarySchedule#: #year(PendingPosting.payrollend)#-#month(PendingPosting.payrollend)#"
										Description2             = "#PayThroughBankName#"																							
										GLAccount2               = "#SalaryScheduleGLAccount#"
										ReferenceId2             = ""
										TransactionType2         = "Standard"
										Amount2                  = "#PaymentAmount#">										
																																										
							</cfloop>			
												
						</cfif>
											
					<cfelse>
					
						   <!--- individual : STL posting 
						   
						   first we make 
						   
						   --->
											
						   <cfif Period.DisableDistribution eq "1">
							
								<!--- no distribution so we make a 
								  per personal cost account offsetting the booking above --->	
													
								 <cfquery name="Journal" 
									datasource="appsOrganization"  
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
											SELECT   *
											FROM     Accounting.dbo.Journal
											WHERE    Journal = '#Period.Journal#'	
								   </cfquery>												
								
								   <cfif Journal.TransactionCategory eq "Payables" or Journal.TransactionCategory eq "DirectPayment">													   
																   
									   <!--- contra account --->
									   
									   <cfquery name="getAccount" 
										datasource="appsOrganization" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										     SELECT     TOP 1 *
											 FROM       Accounting.dbo.JournalAccount
											 WHERE      Journal = '#Period.Journal#'
											 ORDER BY   ListDefault DESC, 
											            ListOrder
										</cfquery>
										
										<cfif getAccount.recordcount gte "1">
																
											<cfquery name="Persons" 
											datasource="appsOrganization" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											
												SELECT     P.PersonNo, 
												           LastName, 
														   FirstName, 											   											   
														   '#Period.GLAccount#' AS GLAccountLiability,												
												           ROUND(SUM(PaymentAmount), 2) AS PaymentAmount
														   
												FROM       Payroll.dbo.EmployeeSettlementLine as L 									          															
														 	INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
																ON 	L.PersonNo 				= ESET.PersonNo
																AND L.SalarySchedule 		= ESET.SalarySchedule
																AND L.Mission 				= ESET.Mission
																AND L.PaymentDate 			= ESET.PaymentDate
																AND L.PaymentStatus		    = ESET.PaymentStatus
																AND ESET.ActionStatus = '1' <!--- released --->															
														   INNER JOIN Employee.dbo.Person P ON P.PersonNo  = L.PersonNo
														   
												WHERE      L.Mission         = '#Period.Mission#' 					
												AND        L.SalarySchedule  = '#Period.SalarySchedule#'
												AND        L.PaymentDate     = '#payrollend#' 
												
												AND        (L.GLAccount      = '#Period.GLAccount#' 
												             OR L.GLAccountLiability = '#Period.GLAccount#')
												
												AND        L.SettlementPhase = '#refno#'
												AND        L.PaymentStatus   = '0'
												
												GROUP BY    P.PersonNo,
												            LastName, 
															FirstName									
																											
											</cfquery>
										
											<!--- create postings for the account --->								
										
											<cfloop query="Persons">
											
												<!--- references the payroll master calculation record --->	
										
												<cf_GledgerEntryHeader
												    Mission               = "#SchedulePeriod.Mission#"
												    OrgUnitOwner          = "#tOwner#"							
													Datasource            = "appsOrganization"
												    Journal               = "#Period.Journal#"
													AccountPeriod         = "#per#"							
													JournalTransactionNo  = "#year(PendingPosting.payrollend)#-#month(PendingPosting.payrollend)#"
													Description           = "#SchedulePeriod.SalarySchedule#: #DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
													TransactionSource     = "PayrollSeries"		
													TransactionSourceId   = "#SchedulePeriod.CalculationId#"			
													TransactionCategory   = "Payables"
													MatchingRequired      = "1"							
													Reference             = "Settlement"  
													ReferencePersonNo     = "#PersonNo#"     
													ReferenceName         = "#FirstName# #LastName#"	
													ActionStatus          = "1"														
													Workflow              = "No"
													TransactionDate       = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
													DocumentCurrency      = "#Schedule.PaymentCurrency#"
													CurrencyDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
													DocumentDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"										
													DocumentAmount        = "#PaymentAmount#"
													OfficerUserId         = "#SESSION.acc#"
													OfficerLastName       = "#SESSION.last#"
													OfficerFirstName      = "#SESSION.first#">
													
													<cf_GledgerEntryLine
														Lines                    = "2"
														Datasource               = "appsOrganization"
													    Journal                  = "#Period.Journal#"
														JournalNo                = "#JournalSerialNo#"
														JournalTransactionNo     = "#year(SchedulePeriod.payrollend)#-#month(SchedulePeriod.PayrollEnd)#"	
														LogTransaction           = "No"	
														AccountPeriod            = "#per#"				
														Currency                 = "#Schedule.PaymentCurrency#"
														CurrencyDate             = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
														TransactionDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
														ParentJournal            = "#URL.Journal#"
													    ParentJournalSerialNo    = "#parentJournalSerialNo#"
																								
														TransactionSerialNo1     = "0"				
														Class1                   = "Credit"
														Reference1               = "Payroll payment"       
														ReferenceName1           = "#SchedulePeriod.SalarySchedule#: #url.year#-#month(PendingPosting.payrollend)#"
														ReferenceNo1		     = "#Persons.PersonNo#"
														Description1             = "#FirstName# #LastName#"
														GLAccount1               = "#getaccount.glaccount#"											
														ReferenceId1             = ""
														TransactionType1         = "Contra-Account"
														Amount1                  = "#PaymentAmount#"
														
														TransactionSerialNo2     = "1"				
														Class2                   = "Debit"
														Reference2               = "Liability offset" 						
														ReferenceName2           = "#SchedulePeriod.SalarySchedule#: #url.year#-#month(PendingPosting.payrollend)#"
														Description2             = "Payroll Liability #SchedulePeriod.SalarySchedule#"													
														ReferenceNo2		     = "#Persons.PersonNo#"
														GLAccount2               = "#Persons.GLAccountLiability#"
														ReferenceId2             = ""
														TransactionType2         = "Standard"
														Amount2                  = "#PaymentAmount#">										
																																									
											</cfloop>					
										
								        </cfif> 
										 
							  	  </cfif>	 
													   
						    <cfelse>
													
								<!--- distribution / settlement 
								
								I    We post for each person the amount to be settled & the amount paid to that person for the distribution
								             
								II.  We post based on the information above the offset of the net schedule account 4003 onbehalf of the
								various bank accounts we use as we assume the full process is completed 
								
								--->
							
								<!--- post the offset of the bank accounts as II --->								
															
								<cfquery name="OffsetScheduleAccount" 
											datasource="appsOrganization" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											
											SELECT     ESD.SalaryScheduleGLAccount, 
											           ESD.PayThroughGLAccount, 
													   ESD.PayThroughBankName, 
													   ESD.PaymentCurrency, 
													   ESD.PersonNo,
													   CASE WHEN (SELECT  GLAccount 
												              FROM    Employee.dbo.PersonGLedger
									 						  WHERE   PersonNo = ESD.PersonNo 
															  AND     Area = 'Payroll') IS NOT NULL 
															  
													    THEN (SELECT  GLAccount
									                          FROM    Employee.dbo.PersonGLedger
							                                  WHERE   PersonNo = ESD.PersonNo 
															  AND     Area = 'Payroll') ELSE '599999999' END AS PersonGLAccount,
													   ROUND(SUM(ESD.PaymentAmount), 2) AS PaymentAmount
													   
											FROM       Payroll.dbo.EmployeeSettlementDistribution AS ESD
													   INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
															ON 	ESD.PersonNo 			= ESET.PersonNo
															AND ESD.SalarySchedule 		= ESET.SalarySchedule
															AND ESD.Mission 			= ESET.Mission
															AND ESD.PaymentDate 		= ESET.PaymentDate
															AND ESD.PaymentStatus		= ESET.PaymentStatus
															AND ESET.ActionStatus = '1' <!--- released --->
														
											WHERE      ESD.Mission         = '#Period.Mission#' 					
											AND        ESD.SalarySchedule  = '#Period.SalarySchedule#'
											AND        ESD.PaymentDate     = '#payrollend#' 	
											AND        ESD.SettlementPhase = '#refno#'	
											AND        ESD.PaymentStatus   = '0'
																			
											GROUP BY   ESD.SalaryScheduleGLAccount, 
											           ESD.PayThroughGLAccount, 
													   ESD.PayThroughBankName, 
													   ESD.PaymentCurrency,
													   ESD.PersonNo						
													   <!--- rfuentes to avoid offset for the ones on LWOP in negative settlement --->
											/*HAVING ROUND(SUM(ESD.PaymentAmount), 2) >0*/
								</cfquery>
							
								<cfloop query="OffsetScheduleAccount">
														
									<cf_GledgerEntryHeader
									    Mission               = "#SchedulePeriod.Mission#"
									    OrgUnitOwner          = "#tOwner#"							
										Datasource            = "appsOrganization"
									    Journal               = "#URL.Journal#"
										AccountPeriod         = "#per#"							
										JournalTransactionNo  = "#year(PendingPosting.payrollend)#-#month(PendingPosting.payrollend)#"
										Description           = "#PayThroughBankName#: #DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
										TransactionSource     = "PayrollSeries"		
										TransactionSourceId   = "#SchedulePeriod.CalculationId#"			
										TransactionCategory   = "Payables"
										MatchingRequired      = "0"			
										Workflow              = "No"  		
										ActionStatus          = "1"		
										Reference             = "Transfer"  									
										ReferenceName         = "#PayThroughBankName#"
										ReferencePersonNo     = "#PersonNo#"																								
										TransactionDate       = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
										DocumentCurrency      = "#PaymentCurrency#"
										CurrencyDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
										DocumentDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"										
										DocumentAmount        = "#PaymentAmount#"
										OfficerUserId         = "#SESSION.acc#"
										OfficerLastName       = "#SESSION.last#"
										OfficerFirstName      = "#SESSION.first#">
										
										<!--- validate if negative settlement, to set an AR for the Employee instead of the Bank dist  --->
										<cfset DebitGLAccount =  OffsetScheduleAccount.PayThroughGLAccount>
										
										<cfif PaymentAmount lt 0>
											<cfset DebitGLAccount =  OffsetScheduleAccount.PersonGLAccount>
										</cfif>										
										
										<cf_GledgerEntryLine
											Lines                    = "2"
											Datasource               = "appsOrganization"
										    Journal                  = "#url.Journal#"
											JournalNo                = "#JournalSerialNo#"
											JournalTransactionNo     = "#year(SchedulePeriod.PayrollEnd)#-#month(SchedulePeriod.PayrollEnd)#"		
											LogTransaction           = "No"
											AccountPeriod            = "#per#"																								 
											DocumentCurrency         = "#PaymentCurrency#"
											AmountCurrency           = "#PaymentCurrency#"
											CurrencyDate             = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
											TransactionDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
											ParentJournal            = "#URL.Journal#"
										    ParentJournalSerialNo    = "#parentJournalSerialNo#"
																					
											TransactionSerialNo1     = "1"				
											Class1                   = "Credit"
											Reference1               = "Bank Charge"       
											ReferenceName1           = "#PayThroughBankName#: #year(PendingPosting.payrollend)#-#month(PendingPosting.payrollend)#"										
											Description1             = "#PayThroughBankName#"
											GLAccount1               = "#DebitGLAccount#"											
											ReferenceId1             = ""
											TransactionType1         = "Contra-Account"
											Amount1                  = "#PaymentAmount#"
											
											TransactionSerialNo2     = "0"				
											Class2                   = "Debit"
											Reference2               = "Offset" 						
											ReferenceName2           = "#SchedulePeriod.SalarySchedule#: #year(PendingPosting.payrollend)#-#month(PendingPosting.payrollend)#"
											Description2             = "#PayThroughBankName#"																							
											GLAccount2               = "#SalaryScheduleGLAccount#"
											ReferenceId2             = ""
											TransactionType2         = "Standard"
											Amount2                  = "#PaymentAmount#">										
																																											
								</cfloop>			
																
								<!--- record the details per person as well --->
																													
								<cfquery name="Persons" 
									datasource="appsOrganization" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT     L.PersonNo, 
										           LastName, 
												   FirstName, 		
												   CASE WHEN (SELECT  GLAccount 
												              FROM    Employee.dbo.PersonGLedger
									 						  WHERE   PersonNo = L.PersonNo 
															  AND     Area = 'Payroll') IS NOT NULL 
															  
													    THEN (SELECT  GLAccount
									                          FROM    Employee.dbo.PersonGLedger
							                                  WHERE   PersonNo = L.PersonNo 
															  AND     Area = 'Payroll') ELSE '599999999' END AS GLAccount,
											
												   L.PaymentCurrency,
										           ROUND(SUM(L.PaymentAmount), 2) AS PaymentAmount
												   
										FROM       Payroll.dbo.EmployeeSettlementDistribution L
													   INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
														ON 	L.PersonNo 			= ESET.PersonNo
														AND L.SalarySchedule 		= ESET.SalarySchedule
														AND L.Mission 				= ESET.Mission
														AND L.PaymentDate 			= ESET.PaymentDate
														AND L.PaymentStatus	    	= ESET.PaymentStatus
														AND ESET.ActionStatus = '1' <!--- released --->					          															
												   INNER JOIN Employee.dbo.Person P ON P.PersonNo  = L.PersonNo											   
										WHERE      L.Mission          = '#SchedulePeriod.Mission#' 					
										AND        L.SalarySchedule   = '#Period.SalarySchedule#'
										AND        L.PaymentDate      = '#payrollend#' 	
							    		AND        L.SettlementPhase  = '#refno#'
										AND        L.PaymentStatus    = '0'
																			
										
										GROUP BY   L.PersonNo,
										           P.LastName, 
												   P.FirstName,											  
												   L.PaymentCurrency
												   
										-- HAVING ROUND(SUM(L.PaymentAmount), 2) > 0
										ORDER BY   L.PaymentCurrency ASC   
								</cfquery>
	
								<cfloop query="Persons">
								
									<!--- obtain the journal and post the Payable to the staff --->
	
									<cfquery name="thisJournal" 
										datasource="appsOrganization" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT TOP 1 * 
										FROM   Accounting.dbo.Journal 
										WHERE  TransactionCategory = 'Payables' 
										AND    Mission             = '#SchedulePeriod.Mission#'
										AND    Currency            = '#Persons.PaymentCurrency#'
										AND    SystemJournal       = 'Settlement'
									</cfquery>
									
									<cfif thisJournal.recordcount eq "0">
									
										<cfquery name="thisJournal" 
											datasource="appsOrganization" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											SELECT TOP 1 * 
											FROM   Accounting.dbo.Journal 
											WHERE  TransactionCategory = 'Payables' 
											AND    Mission             = '#SchedulePeriod.Mission#'
											AND    Currency            = '#Persons.PaymentCurrency#'										
										</cfquery>
									
									</cfif>
									
									<cf_GledgerEntryHeader
									    Mission               = "#SchedulePeriod.Mission#"
									    OrgUnitOwner          = "#tOwner#"							
										Datasource            = "appsOrganization"
									    Journal               = "#thisJournal.Journal#"
										AccountPeriod         = "#per#"							
										JournalTransactionNo  = "#year(PendingPosting.payrollend)#-#month(PendingPosting.payrollend)#"
										Description           = "#SchedulePeriod.SalarySchedule#: #DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
										TransactionSource     = "PayrollSeries"		
										TransactionSourceId   = "#SchedulePeriod.CalculationId#"			
										TransactionCategory   = "Payment"
										MatchingRequired      = "0"							
										Reference             = "Settlement"  
										ReferencePersonNo     = "#PersonNo#"     
										ReferenceName         = "#FirstName# #LastName#"															
										Workflow              = "No"   	<!--- was yes --->							
										TransactionDate       = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
										CurrencyDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
										DocumentCurrency      = "#Persons.PaymentCurrency#"									
										DocumentDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"										
										DocumentAmount        = "#PaymentAmount#"
										OfficerUserId         = "#SESSION.acc#"
										OfficerLastName       = "#SESSION.last#"
										OfficerFirstName      = "#SESSION.first#">
										
										<cf_GledgerEntryLine
											Lines                    = "2"
											Datasource               = "appsOrganization"
										    Journal                  = "#thisJournal.Journal#"
											JournalNo                = "#JournalSerialNo#"
											JournalTransactionNo     = "#year(SchedulePeriod.PayrollEnd)#-#month(SchedulePeriod.PayrollEnd)#"		
											LogTransaction           = "No"
											AccountPeriod            = "#per#"				
											Currency                 = "#Persons.PaymentCurrency#"
											CurrencyDate             = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"
											TransactionDate          = "#DateFormat(SchedulePeriod.PayrollEnd,CLIENT.DateFormatShow)#"	
											ParentJournal            = "#URL.Journal#"
									    	ParentJournalSerialNo    = "#parentJournalSerialNo#"									
																					
											TransactionSerialNo1     = "0"				
											Class1                   = "Credit"
											Reference1               = "Payment"       
											ReferenceName1           = "#SchedulePeriod.SalarySchedule#: #year(PendingPosting.payrollend)#-#month(PendingPosting.payrollend)#"
											ReferenceNo1		     = "#Persons.PersonNo#"
											Description1             = "#FirstName# #LastName#"
											GLAccount1               = "#Persons.glaccount#"											
											ReferenceId1             = ""
											TransactionType1         = "Contra-Account"
											Amount1                  = "#PaymentAmount#"
											
											TransactionSerialNo2     = "1"				
											Class2                   = "Debit"
											Reference2               = "Offset" 						
											ReferenceName2           = "#SchedulePeriod.SalarySchedule#: #year(PendingPosting.payrollend)#-#month(PendingPosting.payrollend)#"
											Description2             = "Payroll Liability #SchedulePeriod.SalarySchedule#"													
											ReferenceNo2		     = "#Persons.PersonNo#"
											GLAccount2               = "#Persons.GLAccount#"
											ReferenceId2             = ""
											TransactionType2         = "Standard"
											Amount2                  = "#PaymentAmount#">										
																																										
								</cfloop>					
																				
						   </cfif>	  
					
				 	</cfif>  
			
			<!--- process if posting amount > 0 --->
								
			</cfif>	
							
		</cfif>		
		
	</cfif>										
									
</cfloop>						

<!--- output for the view to be closed

<cfoutput>
	
	<cfparam name="reference" default="">
	<cfset url.status = "3">
	
	<font color="408080"><b>Final Closing</b>&nbsp;
		
	
</cfoutput>

--->