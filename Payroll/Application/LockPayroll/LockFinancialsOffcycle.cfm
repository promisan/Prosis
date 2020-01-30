
<!--- STANDARD LOADING OF PAYROLL --->

<!--- entity parameters to be passed for loading into GL --->
<cfparam name="url.mission"        				default="OICT">
<cfparam name="url.settlementId"        		default="75F04F35-60D3-4CDD-A909-FA7FB0A94139">

<!--- added a provision to set the journal postings referenceNo to Final --->

<!--- -------------------------------------------------- --->
<!--- ----determine default accounting Period (Year) --- --->
<!--- -------------------------------------------------- --->


<cfquery name="get"
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">      
      SELECT  *
	   FROM   EmployeeSettlement
	   WHERE  SettlementId = '#url.settlementId#'   	
</cfquery> 

<cfquery name="Object"
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">      
      SELECT  *
	   FROM   Organization.dbo.OrganizationObject
	   WHERE  ObjectKeyValue4 = '#url.settlementId#'   	
</cfquery> 

<cfquery name="getInternal"
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">      
      SELECT DISTINCT TOP 1 ES.*
	   FROM   EmployeeSettlement AS ES 
	          INNER JOIN EmployeeSettlementLine AS ESL ON ESL.PersonNo = ES.PersonNo 
			         AND ESL.SalarySchedule = ES.SalarySchedule 
					 AND ESL.Mission        = ES.Mission 
					 AND ESL.PaymentDate    = ES.PaymentDate 
		WHERE  	ES.PersonNo = '#Object.PersonNo#' 
		AND (
				ES.PaymentStatus = '1'	 <!--- offcycle --->  
				OR
				ES.PaymentFinal = '1'    <!--- generated for final payment --->
				OR
				(ES.Source = '#get.Source#' and ES.PaymentStatus = '1')	
		)
		AND  	ES.PaymentDate >= (SELECT PaymentDate 
		                           FROM   Payroll.dbo.EmployeeSettlement 
								   WHERE  SettlementId = '#url.settlementId#')
				
		ORDER BY PaymentDate DESC				
</cfquery> 


<cfset payStatus ="1">

<cfif getInternal.recordcount lte 0>

	<table align="center">
	<tr>
	<td class="labellarge" align="center" style="padding-top:10px;font-size:21px;color:red">
	Attention : no settlement records found for this process</td>
	</tr>
	
	<tr><td class="labellarge" align="center" style="padding-top:10px;font-size:21px;color:blue">
	<cfif getInternal.recordcount gte "1">
		Likely all settlements were processed as IN-CYCLE
	</cfif>
	</td></tr>
	
	</table>
	<cfset payStatus ="0">

<cfelse>		

	<cfset Settlements = QuotedValueList(getInternal.SettlementId)>
	<cfset Settlements = "#Settlements#,'#url.settlementid#'">
		
	<cfquery name="get"
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	      SELECT     *
	      FROM       Payroll.dbo.EmployeeSettlement ES
		  WHERE      SettlementId IN (#preserveSingleQuotes(Settlements)#)  
	</cfquery> 

	<cfsavecontent variable="complementQuery">
		SELECT PaymentDate 
		FROM Payroll.dbo.EmployeeSettlement
		WHERE SettlementID IN <cfoutput>(#settlements#)</cfoutput>
	</cfsavecontent>

	<cfquery name="Param" 
	    datasource="appsOrganization"  
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Accounting.dbo.Ref_ParameterMission
			WHERE    Mission = '#get.Mission#'	
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
		WHERE    P.Mission        = '#get.Mission#'	
		AND      P.SalarySchedule = '#get.SalarySchedule#'
		AND      P.GLAccount IN (SELECT GLAccount
		                         FROM   Accounting.dbo.Ref_Account 
								 WHERE  GLAccount = P.GLAccount) 
	</cfquery>

	<cfquery name="Schedule" 
	    datasource="appsOrganization"  
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Payroll.dbo.SalarySchedule P
		WHERE    1=1
		AND      P.SalarySchedule = '#get.SalarySchedule#'
	</cfquery>

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
	

	<cfquery name="getPeriod" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT     M.Period, 
		           M.PlanningPeriod
		FROM       Ref_MissionPeriod AS M INNER JOIN
	               Program.dbo.Ref_Period AS P ON M.Period = P.Period
		WHERE      M.Mission 		= '#Period.Mission#' 
		AND        P.DateEffective  <= '#get.paymentDate#'
		AND        P.DateExpiration >= '#get.paymentDate#'
		AND	       M.isPlanPeriod 	= '1' 
	</cfquery>		

	<cfquery name="MissingObject" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  TOP 1 *			
		FROM   Payroll.dbo.EmployeeSettlementLine SL  INNER JOIN Payroll.dbo.EmployeeSettlement as ESET
					ON 	SL.PersonNo 			= ESET.PersonNo
					AND SL.SalarySchedule 		= ESET.SalarySchedule
					AND SL.Mission 				= ESET.Mission
					AND SL.PaymentDate 			= ESET.PaymentDate
					AND ESET.PaymentStatus 	 	IN ('1')
	
				INNER JOIN Payroll.dbo.SalarySchedulePayrollItem R ON SL.SalarySchedule = R.SalarySchedule 
			                  AND SL.Mission = R.Mission 
							  AND SL.PayrollItem = R.PayrollItem
		WHERE  R.Mission          		= '#Period.Mission#'
		AND    SL.SalarySchedule  		= '#Period.SalarySchedule#'
		AND    SL.PaymentDate        	IN (
			 						  SELECT     PaymentDate
								      FROM       Payroll.dbo.EmployeeSettlement ES
									  WHERE      SettlementId IN (#preserveSingleQuotes(Settlements)#)
		)
		AND    R.GLAccount NOT IN (SELECT GLAccount 
		                           FROM   Accounting.dbo.Ref_Account 
								   WHERE  GLAccount = R.GLAccount)		 
	</cfquery>
		
	<cfif MissingObject.recordcount gte "1">
		<cfoutput>
		<table width="100%" align="center">
		<tr>
		<td class="labellarge" align="center" style="padding-top:10px;font-size:21px;color:red">
			One or more glaccounts have not been defined (i.e #MissingObject.PayrollItem#). Please update the payroll item administration
		</td>
		</tr>	
		</cfoutput>
		
	<cfelse>	
	
		<cf_verifyOperational 
		  datasource= "appsOrganization"
		  module    = "Accounting" 
		  Warning   = "No">
		  
		  <cfquery name="Param" 
	    datasource="appsOrganization"  
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Program.dbo.Ref_ParameterMission
			WHERE    Mission = '#get.Mission#'	
		</cfquery>		
		  
		<cfif operational eq "1">  	
		
			<cfquery name="getDates" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT DISTINCT PayrollEnd
				FROM       Payroll.dbo.EmployeeSettlementLine
				WHERE      Mission        = '#Period.Mission#' 
				AND        SalarySchedule = '#Period.SalarySchedule#' 
				AND        PaymentDate     IN (SELECT   PaymentDate
											   FROM     Payroll.dbo.EmployeeSettlement ES
											   WHERE    SettlementId IN (#preserveSingleQuotes(Settlements)#))
				AND        PersonNo 	  = '#get.PersonNo#'
				ORDER BY   PayrollEnd
			</cfquery>	
			
			<cfloop query="getDates">
		
			    <!--- to document exchange rate --->
				
				<cf_exchangeRate 
				       datasource    = "AppsOrganization"       
				       CurrencyFrom  = "#Schedule.PaymentCurrency#" 
				       CurrencyTo    = "#param.BudgetCurrency#"
					   EffectiveDate = "#dateformat(PayrollEnd,client.dateformatshow)#">
						
				<cfif Exc eq "0" or Exc eq "">
					<cfset dexc = 1>
				<cfelse>
					<cfset dexc = exc>	
				</cfif>			
				
				<!--- to be base exchange rate --->
			
				<cf_exchangeRate 
				       datasource = "AppsOrganization"       
				       CurrencyFrom = "#Schedule.PaymentCurrency#" 
				       CurrencyTo   = "#APPLICATION.BaseCurrency#"
					   EffectiveDate = "#dateformat(PayrollEnd,client.dateformatshow)#">
						
				<cfif Exc eq "0" or Exc eq "">
					<cfset bexc = 1>
				<cfelse>
					<cfset bexc = exc>		
				</cfif>		
				
				<cfquery name="setbaseamount" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					UPDATE Payroll.dbo.EmployeeSettlementLine
					
					SET    <!--- secundary payslip --->
						   DocumentCurrency     = '#param.BudgetCurrency#',
					       DocumentExchangeRate = '#dexc#',
						   DocumentAmount       = round(PaymentAmount/#dexc#,3),
						   
						   <!--- for posting purposes --->			
					       ExchangeRate         = '#bexc#',
					       AmountBase           = round(Amount/#bexc#,2)	
						   
					WHERE  Mission          = '#Period.Mission#' 
					AND    SalarySchedule   = '#Period.SalarySchedule#' 
					AND    PersonNo 		= '#get.PersonNo#'
					AND    PayrollEnd       = '#PayrollEnd#'
					
					AND    PaymentDate     IN (SELECT   PaymentDate
											   FROM     Payroll.dbo.EmployeeSettlement ES
											   WHERE    SettlementId IN (#preserveSingleQuotes(Settlements)#))
											   
					AND    PaymentStatus   IN ('1')	<!--- off cycle --->	
					AND    SettlementPhase = 'Final'	   			
					
				</cfquery>
				
			
			</cfloop>			
			
		<cfelse>
		
			<cfset dexc = 1>
			<cfset bexc = 1>
			
			<cfquery name="setbaseamount" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				UPDATE Payroll.dbo.EmployeeSettlementLine
				
				SET    <!--- secundary payslip --->
					   DocumentCurrency     = '#param.BudgetCurrency#',
				       DocumentExchangeRate = '#dexc#',
					   DocumentAmount       = round(PaymentAmount/#dexc#,3),
					   
					   <!--- for posting purposes --->			
				       ExchangeRate         = '#bexc#',
				       AmountBase           = round(Amount/#bexc#,2)	
					   
				WHERE  Mission          = '#Period.Mission#' 
				AND    SalarySchedule   = '#Period.SalarySchedule#' 
				AND    PersonNo 		= '#get.PersonNo#'
				AND    PaymentDate     IN (SELECT   PaymentDate
										   FROM     Payroll.dbo.EmployeeSettlement ES
										   WHERE    SettlementId IN (#preserveSingleQuotes(Settlements)#))
				AND    PaymentStatus   IN ('1')	<!--- off cycle --->	
				AND    SettlementPhase = 'Final'	   			
				
			</cfquery>
			
		</cfif>					
		
		<cfquery name="DeleteSettlementDistribution" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			DELETE FROM  Payroll.dbo.EmployeeSettlementDistribution
			WHERE  Mission          = '#Period.Mission#' 
			AND    SalarySchedule   = '#Period.SalarySchedule#' 
			AND    PersonNo 		= '#get.PersonNo#'
			AND    PaymentDate     IN (SELECT   PaymentDate
									   FROM     Payroll.dbo.EmployeeSettlement ES
									   WHERE    SettlementId IN (#preserveSingleQuotes(Settlements)#))
			AND    PaymentStatus   IN ('1')	<!--- off cycle --->	
			AND    SettlementPhase = 'Final'				   
			
		</cfquery>
	
		<cfquery name="DeleteSettlementFunding" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			DELETE 
			FROM   Payroll.dbo.EmployeeSettlementLineFunding
			WHERE  PaymentId IN (SELECT PaymentId 
			                     FROM   Payroll.dbo.EmployeeSettlementLine as esl1
			                     		INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
											ON 	esl1.PersonNo 				= ESET.PersonNo
											AND esl1.SalarySchedule 		= ESET.SalarySchedule
											AND esl1.Mission 				= ESET.Mission
											AND esl1.PaymentDate 			= ESET.PaymentDate
											AND ESET.PaymentStatus 	 	IN ('1')
					 	    	 WHERE  esl1.Mission         = '#Period.Mission#' 
							     AND    esl1.SalarySchedule  = '#Period.SalarySchedule#' 
								 AND    esl1.PaymentDate     IN (SELECT     PaymentDate
									                             FROM       Payroll.dbo.EmployeeSettlement ES
										                         WHERE      SettlementId IN (#preserveSingleQuotes(Settlements)#))
								 AND 	esl1.PersonNo 		 = '#get.PersonNo#'
								 AND    esl1.SettlementPhase = 'Final') 
		
		</cfquery>

		<cfquery name="planPeriod" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				SELECT  TOP 1 *
				FROM    Program.dbo.Ref_Period
				WHERE   isPlanningPeriod = 1
				AND     DateEffective   <= (SELECT     MAX(PaymentDate)
									      	FROM       Payroll.dbo.EmployeeSettlement ES
										 	WHERE      SettlementId IN (#preserveSingleQuotes(Settlements)#)) 
				AND     DateExpiration  >=  (SELECT    MIN(PaymentDate)
									      	FROM       Payroll.dbo.EmployeeSettlement ES
										 	WHERE      SettlementId IN (#preserveSingleQuotes(Settlements)#))
				ORDER BY DateExpiration DESC 	
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
			                            WHERE     PF.DateEffective <= (SELECT     	MIN(PaymentDate) as PaymentDate
									      								FROM       	Payroll.dbo.EmployeeSettlement ES
										 								WHERE      	SettlementId IN (#preserveSingleQuotes(Settlements)#))
										
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
														AND SL.PaymentStatus = '1' <!--- released --->
														
			                             WHERE     SL.Mission         = '#Period.Mission#' 
										 AND       SL.SalarySchedule  = '#Period.SalarySchedule#' 
										 AND       SL.PaymentDate     >= (SELECT     MIN(PaymentDate) as PaymentDate
									      								  FROM       Payroll.dbo.EmployeeSettlement ES
										 								  WHERE      SettlementId IN (#preserveSingleQuotes(Settlements)#))
										 AND       SL.PaymentStatus   = '1'
										 AND 	   SL.PersonNo 		  = '#get.PersonNo#'
										 AND       SL.SettlementPhase = 'Final') S 
										 
							ON S.PositionParentId = L.PositionParentId
							
				WHERE PaymentId NOT IN (SELECT PaymentId FROM Payroll.dbo.EmployeeSettlementLineFunding)			
										
				GROUP BY    S.PaymentId, 
				            PF.Fund, 
						    PF.ProgramCode,	
						    PF.FundClass    
			</cfquery>		

			<cfset tOwner = "0">
				
			<cfset refno = "Final">
			
			<!--- we set the owner of the transaction --->

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
							AND ESET.PaymentStatus 	 	IN ('1')
							AND ESET.PersonNo 			= '#get.PersonNo#'
				       	INNER JOIN Organization.dbo.Organization O ON ES.OrgUnit = O.OrgUnit INNER JOIN
			           	Organization.dbo.Organization P ON O.Mission = P.Mission AND O.MandateNo = P.MandateNo AND O.ParentOrgUnit = P.OrgUnitCode
				WHERE  	ES.OrgUnitOwner is NULL
			</cfquery>

			<cfquery name="Param"
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT 	*
				FROM 	Payroll.dbo.Parameter	
			</cfquery>

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
							AND ESET.PaymentStatus 	 	IN ('1')
							AND ESET.PersonNo 			= '#get.PersonNo#'
		
					   INNER JOIN Payroll.dbo.SalarySchedulePayrollItem R 
					   		ON SL.SalarySchedule = R.SalarySchedule 
					        AND SL.Mission       = R.Mission 
							AND SL.PayrollItem   = R.PayrollItem
									  
				WHERE   R.Mission          = '#Period.Mission#'
				AND     SL.SalarySchedule  = '#Period.SalarySchedule#'
				

				AND     SL.PaymentDate IN ( SELECT     PaymentDate
									        FROM       Payroll.dbo.EmployeeSettlement ES
										    WHERE      SettlementId IN (#preserveSingleQuotes(Settlements)#) )	   
										  
				
			</cfquery>			
	
			<cfif Param.PostingMode eq "1">
		
				<!--- if the match is on the postgrade parent we go deeper --->
				
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
							AND ESET.PaymentStatus 	 	IN ('1')
							AND ESET.PersonNo 			= '#get.PersonNo#'
		
							INNER JOIN Payroll.dbo.SalarySchedulePayrollItemParent R ON SL.SalarySchedule = R.SalarySchedule 
						                  AND SL.Mission = R.Mission 
										  AND SL.PayrollItem = R.PayrollItem
										  AND SL.PostGradeParent = R.PostGradeParent							   
										  
					WHERE  R.Mission          = '#Period.Mission#'
					AND    SL.SalarySchedule  = '#Period.SalarySchedule#'
					
					AND    R.GLAccount IN (SELECT    GLAccount 
					                       FROM      Accounting.dbo.Ref_Account 
										   WHERE     GLAccount = R.GLAccount)
					AND    PaymentDate IN (SELECT    PaymentDate
									       FROM      Payroll.dbo.EmployeeSettlement ES
										   WHERE     SettlementId IN (#preserveSingleQuotes(Settlements)#)
					)	
					
				</cfquery>
				
			<cfelse>
	
				<cfsavecontent variable="MyPositions">
				
					SELECT  P.PositionParentId, PF.FundClass
					FROM    Employee.dbo.PositionParentFunding AS PF INNER JOIN
		    		        Employee.dbo.Position AS P ON PF.PositionParentId = P.PositionParentId INNER JOIN (
							SELECT       PositionParentId, MAX(DateEffective) AS LastEffective
							FROM         Employee.dbo.PositionParentFunding
							WHERE        DateEffective <= <cfoutput>'#get.paymentDate#'</cfoutput>
							GROUP BY     PositionParentId ) L ON PF.PositionParentId = L.PositionParentId AND L.LastEffective = PF.DateEffective
		
				</cfsavecontent>
				
				<!--- if the match is on the fund class we go deeper --->
	
				<cfquery name="LedgerUpdateAdditional" 
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
								AND ESET.PaymentStatus 	 	IN ('1')
					        INNER JOIN (#PreservesingleQuotes(MyPositions)#) P      ON SL.PositionParentId     	= P.PositionParentId 
						    INNER JOIN Payroll.dbo.SalarySchedulePayrollItemClass R ON SL.SalarySchedule 		= R.SalarySchedule 
						                                                AND SL.Mission     = R.Mission 
								 									    AND SL.PayrollItem = R.PayrollItem 
																	    AND P.FundClass    = R.PostClass						   
										  
					WHERE   R.Mission          = '#Period.Mission#'
					AND     SL.SalarySchedule  = '#Period.SalarySchedule#'
					AND 	SL.PersonNo 	   = '#get.PersonNo#'
					
					AND     R.GLAccount IN (SELECT GLAccount 
					                         FROM   Accounting.dbo.Ref_Account 
											 WHERE  GLAccount = R.GLAccount)
					AND     SL.PaymentDate  IN (
							SELECT     PaymentDate
									      FROM       Payroll.dbo.EmployeeSettlement ES
										  WHERE      SettlementId IN (#preserveSingleQuotes(Settlements)#)
					)
					
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
								AND ESET.PaymentStatus 	 	IN ('1')
					        INNER JOIN (#PreservesingleQuotes(MyPositions)#) P      ON SL.PositionParentId     	= P.PositionParentId 
						    INNER JOIN Payroll.dbo.SalarySchedulePayrollItemClass R ON SL.SalarySchedule 		= R.SalarySchedule 
						                                                AND SL.Mission     = R.Mission 
								 									    AND SL.PayrollItem = R.PayrollItem 
																	    AND P.FundClass    = R.PostClass						   
										  
					WHERE   R.Mission          = '#Period.Mission#'
					AND     SL.SalarySchedule  = '#Period.SalarySchedule#'
					AND 	SL.PersonNo 	   = '#get.PersonNo#'
					
					AND     R.GLAccountLiability IN (SELECT GLAccount 
					                         FROM   Accounting.dbo.Ref_Account 
											 WHERE  GLAccount = R.GLAccountLiability)
					AND     SL.PaymentDate  IN (
							   			  SELECT     PaymentDate
									      FROM       Payroll.dbo.EmployeeSettlement ES
										  WHERE      SettlementId IN (#preserveSingleQuotes(Settlements)#)
					)  
					
				</cfquery>	
			</cfif>	
		 
			<cfif Period.DisableDistribution eq "0">
					
				<cfinvoke component = "Service.Process.Payroll.Payable"  
		       		method           = "setDistribution" 
		       		Mission          = "#getinternal.Mission#" 
		       		Salaryschedule   = "#getinternal.SalarySchedule#" 
		       		PaymentStatus    = "1"
					PersonNo         = "#getinternal.PersonNo#"
		       		PaymentDate      = "#dateformat(getinternal.PaymentDate,client.dateformatshow)#"
		       		SettlementPhase  = "Final">
			
			</cfif>
		
			<cfquery name="Total" 
					datasource="appsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					SELECT    ROUND(SUM(Amount), 2) AS PostingAmount
					FROM      Payroll.dbo.EmployeeSettlementLine as SL 
							  INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
								ON 	SL.PersonNo 			= ESET.PersonNo
								AND SL.SalarySchedule 		= ESET.SalarySchedule
								AND SL.Mission 				= ESET.Mission
								AND SL.PaymentDate 			= ESET.PaymentDate
								AND ESET.PaymentStatus 	 	IN ('1')
					WHERE     SL.Mission         = '#Period.Mission#' 					
					AND       SL.SalarySchedule  = '#Period.SalarySchedule#'
					AND       ESET.PaymentDate      IN (SELECT     PaymentDate
									      FROM       Payroll.dbo.EmployeeSettlement ES
										  WHERE      SettlementId IN (#preserveSingleQuotes(Settlements)#))		
					AND       SL.SettlementPhase = 'Final'   
					
					
			</cfquery>	
	
			<cfquery name="getPeriod" 
		    		datasource="appsOrganization"		 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
					SELECT * 
					FROM   Accounting.dbo.Period
					WHERE  PeriodDateEnd   >= '#get.paymentDate#'
					AND    PeriodDateStart <= '#get.paymentDate#'
					AND    ActionStatus = '0'						
					ORDER BY AccountPeriod
			</cfquery>

			<cfif getPeriod.recordcount gte "1">
			
				<cfset per = getPeriod.AccountPeriod>
				
			<cfelse>
			
				<cfset per = "0000">
				<cfset total.PostingAmount = "0">
			
			</cfif>

			<cfquery name="getOrgPeriod" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				SELECT     M.Period, 
				           M.PlanningPeriod
				FROM       Ref_MissionPeriod AS M INNER JOIN
		                   Program.dbo.Ref_Period AS P ON M.Period = P.Period
				WHERE      M.Mission 			= '#Period.Mission#' 
				AND        P.DateEffective  	<= '#get.paymentDate#'
				AND        P.DateExpiration 	>= '#get.paymentDate#'
				AND	       M.isPlanPeriod 		= '1'
			</cfquery>
		
			<cfif total.PostingAmount neq "">	
				
				<!---now the xml file ---->
				<!---- call GenSUN for Offcycle now condensed in 1 file for SUN Interfaces ---->
				
				<cfinvoke component 		= "Service.Process.EDI.SUN.SUN"  
   					method           		= "genSUNFileOffCycle"  
   					ForPersonNo       		= "#get.PersonNo#"
					ForPeriod				= "#getOrgPeriod.period#"
					ForMission				= "#get.Mission#"			
					ForSchedule				= "#get.SalarySchedule#"
					ForSettlements			= "#Settlements#"
					ForGlAccount			= "#Period.glAccount#"				
   					returnvariable          = "htmlToShow">
					
				<table width="100%">
				
				<cfinvoke component = "Service.Process.Employee.PersonnelAction"
					    Method          = "getEOD"
					    PersonNo        = "#get.PersonNo#"
						Mission         = "#get.mission#"
					    ReturnVariable  = "EOD">	
				
				<tr class="labelmedium">
				<td>
				<table>
					<tr><td height="10px"></td></tr>
					<tr class="labelmedium"><td style="padding-left:34px">
					
					
					Set final payment transaction date :
					</td>
					<td style="padding-left:4px">
					<cfquery name="getPeriod" 
					datasource="appsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
						SELECT    PayrollEnd
						FROM      SalarySchedulePeriod
						WHERE     Mission        = '#get.Mission#' 
						AND       SalarySchedule = '#get.SalarySchedule#'
						<cfif get.paymentstatus eq "0">
						AND       (PayrollEnd >= (SELECT PaymentDate FROM EmployeeSettlement WHERE Settlementid = '#URL.settlementId#')	
						          OR
								  PayrollEnd = '#get.PaymentDate#')
						          					
						and       CalculationStatus > 0
						<cfelse>
						AND       PayrollEnd >= '#eod#'					     
						</cfif>
						ORDER BY PayrollEnd DESC
						
					</cfquery>
										
					<select name="PaymentDate" class="regularxl" onchange="Prosis.busy('yes');ptoken.navigate('<cfoutput>#session.root#/Payroll/Application/LockPayroll/applyPaymentDate.cfm?settlementId=#get.SettlementId#</cfoutput>&paymentdate='+this.value,'process')">
					<cfoutput query="GetPeriod">
						<option value="#dateformat(PayrollEnd,client.dateSQL)#" <cfif get.PaymentDate eq PayrollEnd>selected</cfif>>#dateformat(PayrollEnd,client.dateformatshow)#</option>
					</cfoutput>
					</select>
					
					</td>
					<td id="process"></td>
					</tr>
				</table>				
				</td></tr>
				<tr><td>
					
				<cfoutput> <!---contains the link for the PPost file generated to be downloaded ----->
					#htmlToShow#
				</cfoutput>
				
				</td></tr>
				
				<tr><td>
												
				<cfinclude template="DoABNOffcycle.cfm"> 
				
				</td></tr>		
				
				</table>		
				
				<cfoutput>
				
				<table width="100%">
				
					<tr class="labelmedium line" style="height:35px">
					<td align="center" style="font-size:17px">				
					<img src="#session.root#/images/finger.gif" alt="" border="0">				
					<a href="#SESSION.root#/custom/STL/Payroll/DataExport/FinalPayment/filedownload.cfm?filepath=#SESSION.rootDocumentPath#\FinalPaySun\Prosis_PPost_#Get.SalarySchedule#_#Get.PersonNo#.txt&filename=Prosis_PPost_#Get.SalarySchedule#_#Get.PersonNo#.txt" target="_blank" > Download Generated File for SUN import</a>				
					</td>				
					<td align="center" style="font-size:17px">				
					<img src="#session.root#/images/finger.gif" alt="" border="0">				
					<a href="#SESSION.root#/custom/STL/Payroll/DataExport/FinalPayment/filedownload.cfm?filepath=#SESSION.rootDocumentPath#\FinalPayABN\#get.PersonNo#\001_Banking.xml&filename=D#get.PersonNo#_001_Banking.xml" target="_blank" > Download Generated File for ABN import</a>				
					</td>				
					</tr>
					
					<tr><td style="height:10px"></td></tr>
				
				</table>
				
				</cfoutput>
				
			<cfelse>
			
			
				<table width="100%">
				
				<tr class="labelmedium">
				<td>
				<table>
					<tr><td height="10px"></td></tr>
					<tr class="labelmedium"><td style="padding-left:34px">
					Set final payment transaction date :
					</td>
					<td style="padding-left:4px">
					<cfquery name="getPeriod" 
					datasource="appsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
						SELECT   TOP (4) PayrollEnd
						FROM     SalarySchedulePeriod
						WHERE    Mission        = '#get.Mission#' 
						AND      SalarySchedule = '#get.SalarySchedule#'
						AND      PayrollEnd >= (SELECT PaymentDate FROM EmployeeSettlement WHERE Settlementid = '#URL.settlementId#')						
						AND      CalculationStatus > 0
						ORDER BY PayrollEnd DESC
					</cfquery>
					
					<select name="PaymentDate" class="regularxl" onchange="Prosis.busy('yes');ptoken.navigate('<cfoutput>#session.root#/Payroll/Application/LockPayroll/applyPaymentDate.cfm?settlementId=#get.SettlementId#</cfoutput>&paymentdate='+this.value,'process')">
					<cfoutput query="GetPeriod">
						<option value="#dateformat(PayrollEnd,client.dateSQL)#" <cfif get.PaymentDate eq PayrollEnd>selected</cfif>>#dateformat(PayrollEnd,client.dateformatshow)#</option>
					</cfoutput>
					</select>
					
					</td>
					<td id="process"></td>
					</tr>
				</table>				
				</td></tr>
				<tr><td align="center" class="labelmedium">			
					<cfoutput>
						Nothing to be posted!
					</cfoutput>	
				</td></tr>
				
				</table>
				
			</cfif>			
						
	</cfif>	 <!--- missing object --->
	
	<cfquery name="offset" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">

		UPDATE ES
		SET        	ES.ActionStatus ='3'
		FROM    	Payroll.dbo.EmployeeSettlement as ES
		WHERE 		ES.SettlementID IN (#preserveSingleQuotes(Settlements)#) <!--- adjusteed by hanno 22/6 --->
		AND     	ES.PaymentStatus = '1'

	</cfquery>		

</cfif> 	

	

