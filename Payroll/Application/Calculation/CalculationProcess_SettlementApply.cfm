

<cftransaction>
  
  <!--- 1 of 3 create a settlement header record --->
    
  <cfquery name="InsertSettlement" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				
			INSERT INTO Payroll.dbo.EmployeeSettlement
					(PersonNo, 
					 SalarySchedule, 
					 SettlementSchedule,
					 Mission,	
					 PaymentDate,
					 PaymentStatus,										 
					 ActionStatus,	
					 PaymentFinal,	
					 Source,			 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName)
			SELECT DISTINCT 
					 D.PersonNo, 
					 '#Form.schedule#',
					 '#Form.schedule#',
					 '#Form.Mission#',	
					 #CALCEND#, 	
					 <!--- pay status, action, workflow trigger --->
					 <cfif processmodality eq "InCycleBatch" or processmodality eq "PersonalNormal">	
					 '0','1','0','Standard',
					 <cfelseif processmodality eq "WorkflowFinal">	<!--- off cycle + amounts --->
					 '1','1','0','Final',
					 <cfelseif processmodality eq "PersonalForce">  <!--- off cycle + amount --->
					 '1','1','1','Force',					
					 </cfif>						 
					 '#SESSION.acc#', 
					 '#SESSION.last#', 
					 '#SESSION.first#'
			FROM    userTransaction.dbo.sal#SESSION.thisprocess#SettledDiff D
			
			<!--- it creates only a settlement record if there is something to settle --->
			WHERE   (abs(DiffCalc) > 0.01 OR abs(DiffPay) > 0.01)	
			
			 <cfif processmodality eq "InCycleBatch">	
				    AND     D.PersonNo IN (SELECT PersonNo FROM userTransaction.dbo.sal#SESSION.thisprocess#Catchup)	
					AND     D.PersonNo IN (SELECT PersonNo FROM userTransaction.dbo.sal#SESSION.thisprocess#OnBoard WHERE PersonNo = D.PersonNo) 
					
					<!--- only if the person is in the organization at this moment of settlement --->
					AND     D.PersonNo IN (SELECT PersonNo FROM userTransaction.dbo.sal#SESSION.thisprocess#Payable WHERE PersonNo = D.PersonNo)	
			 <cfelseif processmodality eq "WorkflowFinal">		
			        <!--- if you do a final payment process there is always a portion that falls inside the contract period and will create a record 
					sisabled to allow calculation
					AND     D.PersonNo IN (SELECT PersonNo FROM userTransaction.dbo.sal#SESSION.thisprocess#OnBoard WHERE PersonNo = D.PersonNo)	
					--->	        
					
			 <cfelseif processmodality eq "PersonalForce">
					<!--- no condition --->
			 <cfelse>
			 
					AND     D.PersonNo IN (SELECT PersonNo FROM userTransaction.dbo.sal#SESSION.thisprocess#Catchup)	
					AND     D.PersonNo IN (SELECT PersonNo FROM userTransaction.dbo.sal#SESSION.thisprocess#OnBoard WHERE PersonNo = D.PersonNo) 					
					<!--- only if the person is in the organization at this moment of settlement --->
					AND     D.PersonNo IN (SELECT PersonNo FROM userTransaction.dbo.sal#SESSION.thisprocess#Payable WHERE PersonNo = D.PersonNo)	
					<!--- in the old code it would not have this condition --->
			 </cfif>		
									
			<!--- pey the difference if the current contract schedule of the employee = calculation schedule
			or if the current schedule allows for it --->							
						
			AND     D.PersonNo NOT IN (SELECT PersonNo 
			                           FROM	  Payroll.dbo.EmployeeSettlement
									   WHERE  PersonNo       = D.PersonNo
									   AND    Mission        = '#Form.Mission#'
									   AND    SalarySchedule = '#Form.Schedule#' 
									   AND	  PaymentDate    = #CALCEND#									   
									     <!--- if this runs as part of the in-cycle batch we only
									   add if no record exists for this period --->
									   <cfif processmodality eq "WorkflowFinal" or processmodality eq "PersonalForce"> 
									   AND    PaymentStatus  = '1'		
									   <cfelse>
									   AND    ActionStatus != '3'							   
									   </cfif>									   
									   )			
	
				
	</cfquery>		
	
	
			
		
	<!--- We also create a settlement record if the person is onboard and has a final payment instance and somehow it was not created yet.
	
	RATIONALE : because a person has not gotten any payment for some reason (SLWOP) over that month so there was no settlement 
	         record to connect the final payment to 
			 
	--->
	
	<cfquery name="FinalWithoutSettlement" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   DISTINCT PersonNo				    
		FROM     userTransaction.dbo.sal#SESSION.thisprocess#Final D
		
		<!--- has no settlement record in the selected month for this schedule even though he/she is in the final for this calculation month --->
		WHERE   PersonNo NOT IN (SELECT  PersonNo
                                  FROM    Payroll.dbo.EmployeeSettlement
                                  WHERE   PersonNo       = D.PersonNo
								  AND     SalarySchedule = '#Form.Schedule#'	
								  AND     Mission        = '#Form.Mission#'							
							      AND     PaymentDate    = #SALEND#)
								  
		<!--- does not have a single settlement record yet in the open month --->						  
		AND     PersonNo NOT IN (SELECT  PersonNo
                                  FROM    Payroll.dbo.EmployeeSettlement
                                  WHERE   PersonNo       = D.PersonNo		
								  AND     Mission        = '#Form.Mission#'								  							  							 								  
							      AND     PaymentDate    = #CALCEND#)	
								  
		<!--- does NOT have an open final payment record being processed --->
		AND     PersonNo NOT IN (SELECT  ES.PersonNo
					     	      FROM    OrganizationObject AS OO INNER JOIN
							              OrganizationObjectAction AS OOA ON OO.ObjectId = OOA.ObjectId INNER JOIN
										  Payroll.dbo.EmployeeSettlement ES ON OO.ObjectKeyValue4 = ES.SettlementId
							      WHERE   ES.PersonNo = D.PersonNo
								  AND     ES.Mission = '#form.mission#'
								  AND     ES.PaymentFinal = 1  <!--- is supposed to have a FP workflow --->
								  AND     ES.PaymentDate    > #CALCEND-90#   <!--- recent, can be removed in my views  --->	
							      AND     OOA.ActionStatus = '0' <!--- has one ore more steps open --->
							      AND     OO.Operational = 1) 	
		<!--- added Hanno 7/10 : does NOT have a last record which is off-cycle and this not needed --->				
		AND     PersonNo NOT IN (SELECT PersonNo
								  FROM   Payroll.dbo.EmployeeSettlement ES 
								  <!--- does NOT have a last record which is off-cycle --->			
								  WHERE  SettlementId = ( SELECT  TOP 1 SettlementId
											     	      FROM    Payroll.dbo.EmployeeSettlement ES 
													      WHERE   ES.PersonNo = D.PersonNo
														  AND     ES.Mission = '#form.mission#'
														  ORDER BY Created DESC )
								  AND    PaymentStatus = '1'								 	
							      ) 						  								  
								  
		AND 	PersonNo IN (SELECT PersonNo FROM   userTransaction.dbo.sal#SESSION.thisprocess#OnBoard)								  									  
	  	
	</cfquery>
	
	<cfloop query="FinalWithoutSettlement">		
	
	    <!--- we create them as off-cycle --->
			
		<cfquery name="Insert" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
									
				INSERT INTO Payroll.dbo.EmployeeSettlement
						(PersonNo, 
						 SalarySchedule, 
						 SettlementSchedule,
						 Mission,	
						 PaymentDate,
						 PaymentStatus,	
						 ActionStatus,		
						 PaymentFinal,							 				 
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName)
						 
				SELECT   '#PersonNo#',
				         '#Form.Schedule#',
						 '#Form.Schedule#',
						 '#Form.Mission#',
						 #CALCEND#,
						 '1', <!--- by default as OFF cycle as cost would need to be added --->
						 '0', <!--- no amount : in the workflow we set those as release --->
						 '1', <!--- to trigger the workflow --->						
						 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#' 
						
			</cfquery>				
	
	</cfloop>	
	
	<!--- obtain the last grade of the person --->
	
	<cfquery name="setGradeStep" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			UPDATE   Payroll.dbo.EmployeeSettlement
			SET      ContractLevel = S.ContractLevel, 
			         ContractStep  = S.ContractStep
			FROM     Payroll.dbo.EmployeeSettlement E INNER JOIN 
			
			       <!--- for the period processed we determine the contract that should be shown here --->
					(
					SELECT     P.PersonNo, P.ContractLevel, P.ContractStep
					FROM       Employee.dbo.PersonContract AS P INNER JOIN
			                    (SELECT   PersonNo, MAX(DateExpiration) AS DateExpiration
			                     FROM     Employee.dbo.PersonContract
			                     WHERE    RecordStatus    = '1' 
							     AND      DateExpiration >= #SALSTR# 
								 AND      DateEffective  <= #SALEND#
								 AND      Mission         = '#Form.Mission#'
			                     GROUP BY PersonNo) AS LAST ON P.PersonNo = LAST.PersonNo AND P.DateExpiration = LAST.DateExpiration
					WHERE      P.RecordStatus = '1' 
					AND        P.Mission = '#Form.Mission#'
					) S ON S.PersonNo = E.PersonNo
								 
			WHERE   E.Mission = '#Form.Mission#'
			AND     E.PaymentDate = #CALCEND#
			-- AND    E.ContractLevel is NULL 		
			<cfif form.PersonNo neq "">
			AND    E.PersonNo = '#Form.Personno#'
			</cfif>
	</cfquery>	
				
	<!--- below is only a safeguard only
	we check if there is final payment record without a final indicator set 
	 --->
	
	<cfquery name="getFinalPayment" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT *  
		FROM   userTransaction.dbo.sal#SESSION.thisprocess#Final D
		<!--- exclude the correction process if there is a recent final payment found for this person then we are not going to 
		perform this correction --->
		WHERE    PersonNo NOT IN (SELECT  ES.PersonNo
					     	      FROM    OrganizationObject AS OO INNER JOIN
							              OrganizationObjectAction AS OOA ON OO.ObjectId = OOA.ObjectId INNER JOIN
										  Payroll.dbo.EmployeeSettlement ES ON OO.ObjectKeyValue4 = ES.SettlementId
							      WHERE   ES.PersonNo = D.PersonNo
								  AND     ES.Mission = '#form.mission#'
								  AND     ES.PaymentFinal = 1  <!--- is supposed to have a FP workflow --->
								  AND     ES.PaymentDate    > #CALCEND-90#   <!--- recent, can be removed in my views  --->								      
							      AND     OO.Operational = 1) 		
	</cfquery>	
	
	<cfloop query="getFinalPayment">
	
		<!--- check for workflow object was created already this can be for paymentstatus 1 or 0 --->
		
		<cfquery name="checkFlow" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			SELECT *
			-- FROM    Payroll.dbo.EmployeeSettlement E INNER JOIN Organization.dbo.OrganizationObject O ON E.SettlementId = O.ObjectKeyValue4 
			FROM    Payroll.dbo.EmployeeSettlement E 			
			WHERE   E.PersonNo       = '#PersonNo#'	 			
			AND     E.SalarySchedule = '#Form.Schedule#'
			AND     E.PaymentDate    = #SALEND#
			AND     E.Mission        = '#Form.Mission#'		
			ORDER BY E.PaymentStatus
		</cfquery>
		
		<cfif checkflow.recordcount gte "1">
		
			<cfif checkflow.paymentstatus eq "0">
			
				<cfquery name="checkPeriod" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
						SELECT  *
						FROM    Payroll.dbo.SalarySchedulePeriod
						WHERE   Mission = '#Form.Mission#' 
						AND     SalarySchedule = '#Form.Schedule#' 
						AND     PayrollEnd = #SALEND#        
				</cfquery>
				
				<cfif checkPeriod.calculationStatus eq "3">
				
					<cfquery name="checkPeriod" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
						SELECT   *
						FROM     Payroll.dbo.SalarySchedulePeriod
						WHERE    Mission = '#Form.Mission#' 
						AND      SalarySchedule = '#Form.Schedule#' 
						AND      CalculationStatus < '3'
						ORDER BY PayrollEnd       
				   </cfquery>
				   
				   <cfquery name="checkEntry" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">			
						SELECT *						
						FROM    Payroll.dbo.EmployeeSettlement E 			
						WHERE   E.PersonNo       = '#PersonNo#'	 			
						AND     E.SalarySchedule = '#Form.Schedule#'
						AND     E.PaymentDate    = '#checkPeriod.PayrollEnd#'
						AND     E.Mission        = '#Form.Mission#'		
						ORDER BY E.PaymentStatus
					</cfquery>
					
					<cfif checkEntry.recordcount eq "0">				   
				
					    <!--- we create them as off-cycle in the future --->
				
						<cfquery name="Insert" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
													
								INSERT INTO Payroll.dbo.EmployeeSettlement
										(PersonNo, 
										 SalarySchedule, 
										 SettlementSchedule,
										 Mission,	
										 PaymentDate,
										 PaymentStatus,	
										 ActionStatus,		
										 PaymentFinal,							 				 
										 OfficerUserId, 
										 OfficerLastName, 
										 OfficerFirstName)
										 
								SELECT   '#PersonNo#',
								         '#Form.Schedule#',
										 '#Form.Schedule#',
										 '#Form.Mission#',
										 '#checkPeriod.PayrollEnd#',
										 '1', <!--- by default as OFF cycle as cost would need to be added --->
										 '0', <!--- no amount : in the workflow we set those as release --->
										 '1', <!--- to trigger the workflow --->						
										 '#SESSION.acc#',
										 '#SESSION.last#',
										 '#SESSION.first#' 
										
							</cfquery>		
							
						</cfif>						
								
				<cfelse>
				
				<cfquery name="UpdateSettlement" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE  Payroll.dbo.EmployeeSettlement
						SET     PaymentFinal = '1'
						FROM    Payroll.dbo.EmployeeSettlement
						WHERE   SettlementId   = '#checkflow.settlementid#'				
				</cfquery>
				
				</cfif>
			
			<cfelse>
												
				<cfquery name="UpdateSettlement" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE  Payroll.dbo.EmployeeSettlement
						SET     PaymentFinal = '1'
						FROM    Payroll.dbo.EmployeeSettlement
						WHERE   SettlementId   = '#checkflow.settlementid#'				
				</cfquery>
		
			</cfif>
			
		</cfif>		
		
				
	</cfloop>
	
	<!--- we now ensure that the workflow object is enabled for record which have the indicator --->
	
	<cfquery name="getWorkflow" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT    *
		FROM      Payroll.dbo.EmployeeSettlement AS D
		WHERE     PaymentDate    = #SALEND# 
		AND       Mission        = '#Form.mission#'
		AND       SalarySchedule = '#form.Schedule#'
		AND       PaymentFinal = '1' <!--- requires a workflow --->
		<!--- no workflow object --->
		AND       NOT EXISTS  (SELECT  'X' AS Expr1
                               FROM    Organization.dbo.OrganizationObject
                               WHERE   ObjectKeyValue4 = D.SettlementId 
							   AND     Operational = 1)
	</cfquery>		
	
	<cfloop query="getWorkflow">
			
		 <!--- establish workflow object dependent on the source ---> 
	
		<cfquery name="getSettlementHeader" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM    Payroll.dbo.EmployeeSettlement E
			WHERE   E.PersonNo       = '#PersonNo#'	 			
			AND     E.SalarySchedule = '#Form.Schedule#'
			AND     E.PaymentDate    = #SALEND#
			AND     E.Mission        = '#Form.Mission#'			
		</cfquery>
		 
		<cfquery name="Person" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM    Employee.dbo.Person E
			WHERE   E.PersonNo       = '#PersonNo#'	 							
		</cfquery>
		
		<cfif getSettlementHeader.recordcount gte "1">
		 
			<cfparam name="url.systemfunctionid" default="">
		
			<cfset link = "Payroll/Application/Payroll/FinalPayment/FinalPaymentView.cfm?settlementid=#getSettlementHeader.settlementid#&systemfunctionid=#url.systemfunctionid#">			  	
			
			<cfif source eq "Force">
			
				 <cf_ActionListing 
				    EntityCode       = "FinalPayment"
					EntityClass      = "Offcycle"
					EntityGroup      = ""
					EntityStatus     = ""
					Mission          = "#Form.mission#"
					PersonNo         = "#PersonNo#"		
					ObjectReference  = "Offcycle Payment"												
					ObjectReference2 = "#Person.FirstName# #Person.LastName# #Person.IndexNo#"																		
				    ObjectKey1       = "#PersonNo#"
					ObjectKey4       = "#getSettlementHeader.SettlementId#"
					ObjectURL        = "#link#"
					Show             = "No">	
			
			<cfelse>
					
				 <cf_ActionListing 
				    EntityCode       = "FinalPayment"
					EntityClass      = "Standard"
					EntityGroup      = ""
					EntityStatus     = ""
					Mission          = "#Form.mission#"
					PersonNo         = "#PersonNo#"		
					ObjectReference  = "Separation and Final Payment"												
					ObjectReference2 = "#Person.FirstName# #Person.LastName# #Person.IndexNo#"																		
				    ObjectKey1       = "#PersonNo#"
					ObjectKey4       = "#getSettlementHeader.SettlementId#"
					ObjectURL        = "#link#"
					Show             = "No">	
					
				<cfquery name="UpdateSettlement" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE  Payroll.dbo.EmployeeSettlement
						SET     ActionStatus    = '0' <!--- we enable in the workflow to release the monies --->
						FROM    Payroll.dbo.EmployeeSettlement E INNER JOIN  
							    userTransaction.dbo.sal#SESSION.thisprocess#SettledDiff D ON E.PersonNo = D.PersonNo
						WHERE   D.PersonNo = '#PersonNo#'	 					     
						AND     E.SalarySchedule = '#Form.Schedule#'
						AND     E.PaymentDate    = #SALEND#
						AND     E.Mission        = '#Form.Mission#'
						AND     (DiffCalc != 0 OR DiffPay != 0)	<!--- there is something to settle for this month still --->	
											
				</cfquery>			 		
				
			 </cfif>	
				
		</cfif> 	
						
	</cfloop>				   
	
		
	<!--- 3 of 3 if a process was already SET for final payment a
	    and no longer has this we also revert this to release this for processing --->
	
	<cfif processmodality neq "InCycleBatch">	
				
		<!--- this we can't have happening if an individual person is calculated --->
						
		 <cfquery name="getSettlement" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			SELECT  *		
			FROM    Payroll.dbo.EmployeeSettlement
			WHERE   SalarySchedule = '#Form.Schedule#'
			AND     PaymentDate    = #SALEND#
			AND     Mission        = '#Form.Mission#'
			AND     PaymentFinal   = 1
			
			AND     PersonNo NOT IN (SELECT PersonNo 
			                         FROM   userTransaction.dbo.sal#SESSION.thisprocess#Final)	
									 
			AND     PersonNo IN (SELECT PersonNo FROM userTransaction.dbo.sal#SESSION.thisprocess#OnBoard)							 							 
		</cfquery>	
		
		<cfif getSettlement.recordcount gte "1">
		
			<cfquery name="resetFP" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE  Payroll.dbo.EmployeeSettlement
				SET     PaymentFinal  = '0', 
				        ActionStatus  = '1',
						PaymentStatus = '0'
				FROM    Payroll.dbo.EmployeeSettlement E	
					
				WHERE   SettlementId IN (#quotedvaluelist(getSettlement.SettlementId)#)  
				
				AND     NOT EXISTS (SELECT 'X'
				                    FROM   Payroll.dbo.EmployeeSettlement
									WHERE  SalarySchedule = E.SalarySchedule
									AND    PaymentDate    = E.PaymentDate
									AND    Mission        = E.Mission
									AND    Personno       = E.PersonNo
									AND    PaymentStatus = '0')
			</cfquery>
			
			<cfquery name="resetWF" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM OrganizationObject
				WHERE ObjectKeyValue4 IN (#quotedvaluelist(getSettlement.SettlementId)#)			
			</cfquery>				
		
		</cfif>	
			
	</cfif>
				
	<!--- Now we add the settlement detail lines --->
				
	<cfquery name="InsertSettlementLine" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		INSERT INTO Payroll.dbo.EmployeeSettlementLine
		
			(PersonNo, 
			 SalarySchedule, 
			 PaymentDate,
			 PaymentStatus,
			 PayrollStart,
			 PayrollEnd,
			 SettlementPhase,
			 PayrollItem,
			 Source,
			 Mission,
			 PositionParentId,			
			 PostGradeParent,
			 OrgUnit,
			 Currency,
			 Amount,
			 PaymentAmount,
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName )
		 
		SELECT 
						
			   D.PersonNo, 
			   '#Form.schedule#',
			   #CALCEND#, 
			   <cfif processmodality eq "WorkflowFinal">			  
			   <!--- this has to be off cycle --->
			   '1',
			   <cfelse>			   
			   (SELECT TOP 1 PaymentStatus 
                FROM   Payroll.dbo.EmployeeSettlement
			    WHERE  PersonNo       = D.PersonNo
			    AND    SalarySchedule = '#Form.Schedule#' 
			    AND	   PaymentDate    = #CALCEND#
			    AND    Mission        = '#Form.Mission#') as PaymentStatus,			   
			   </cfif>			   
			   #SALSTR#,
			   #SALEND#,			     
			   '#SettlementStatus#',			   
			   PayrollItem,
			   Source,
			   '#Form.Mission#',
			   
			   <!--- assign LAST positionNo to the settlement record which drives the
			   gl account in mode = 2 --->
			   
			      (				
				     SELECT   TOP 1 P.PositionParentId			
					 FROM     Employee.dbo.PersonAssignment PA, 
				              Employee.dbo.Position P
				     WHERE    P.Mission          = '#Form.Mission#' 				
					 AND      PA.PositionNo      = P.PositionNo
					 AND      PA.AssignmentStatus IN ('0','1')
					 AND      PA.DateEffective  <= #CALCEND# 									 
					 AND      PA.AssignmentType  = 'Actual'
					 <cfif thisSchedule.IncumbencyZero eq "0">
					 AND      PA.Incumbency      > '0'	
					 </cfif>
					 AND      PA.PersonNo = D.PersonNo
					 ORDER BY PA.DateEffective DESC, PA.Incumbency DESC 
				
				), 
												
			   <!--- assign last last parent grade to the settlement --->
			   
			   (
			   
				     SELECT    TOP 1 R.PostGradeParent
				     FROM      Employee.dbo.PersonContract PC INNER JOIN
	                           Employee.dbo.Ref_PostGrade R ON PC.ContractLevel = R.PostGrade
				     WHERE     PC.Mission        = '#form.mission#'					
					 AND       PC.RecordStatus   = '1'				     
				     AND       PC.DateEffective <= #CALCEND# 
				     AND       PC.PersonNo       = D.PersonNo
				     ORDER BY  DateExpiration DESC 
				 
				), 
												
				(	
							
				    SELECT   TOP 1 P.OrgUnitOperational				
					FROM     Employee.dbo.PersonAssignment PA, 
				             Employee.dbo.Position P
				    WHERE    P.Mission          = '#Form.Mission#' 				
					AND      PA.PositionNo      = P.PositionNo
					AND      PA.AssignmentStatus IN ('0','1')
					AND      PA.DateEffective  <= #CALCEND# 									
					AND      PA.AssignmentType  = 'Actual'
					<cfif thisSchedule.IncumbencyZero eq "0">
					AND      PA.Incumbency      > '0'	
					</cfif>
					AND      PA.PersonNo        = D.PersonNo
					ORDER BY PA.Incumbency DESC, PA.DateEffective DESC 
				
			   ), 			   	  
					   
			   D.PaymentCurrency, 
			   
			   <cfif SettlementStatus eq "Final">
			   
				   	ROUND(D.DiffCalc,2),
			   	    ROUND(D.DiffPay,2),
					
			   <cfelse>
			   
			   	    <!--- 1 standard, 3 only final, 4 as early as possible 
					
					Hanno 27/8/2018 : in case of a retro-active payment likely that one should not be applied the
					ratio but given the full amount 					
					--->	
			   
   		   		   <cfset ratio = "#SettleInitial#/100">
				   
				   CASE WHEN D.AllowSplit = '1' THEN ROUND(D.DiffCalc*#ratio#,2) ELSE  <!--- 1 we pay a portion : if the entitlement is from a prior month we should pay in full ?--->
				   CASE WHEN D.AllowSplit = '2' THEN ROUND(D.DiffCalc,2) ELSE          <!--- 2 we pay all from prior period, attenion 2 has been filtered from entitlement --->
				   CASE WHEN D.AllowSplit = '4' THEN ROUND(D.DiffCalc,2) ELSE          <!--- 4 we pay all what we can --->
			                                      0 END END END, 					   <!--- safeguard --->	
				
				   CASE WHEN D.AllowSplit = '1' THEN ROUND(D.DiffPay*#ratio#,2) ELSE  <!--- 1 we pay a portion : if the entitlement is from a prior month we should pay in full --->
				   CASE WHEN D.AllowSplit = '2' THEN ROUND(D.DiffPay,2) ELSE          <!--- 2 we pay all from prior period, attenion 2 has been filtered from entitlement --->
				   CASE WHEN D.AllowSplit = '4' THEN ROUND(D.DiffPay,2) ELSE          <!--- 4 we pay all what we can --->
			                                      0 END END END, 										 
			   			   
			   </cfif>			   			   
			  			   
			   '#SESSION.acc#', 
			   '#SESSION.last#', 
			   '#SESSION.first#'			   
			   
		FROM    userTransaction.dbo.sal#SESSION.thisprocess#SettledDiff D
		
		WHERE   (abs(DiffCalc) > 0.01 OR abs(DiffPay) > 0.01)	
		
		<cfif processmodality eq "InCycleBatch">	
			    AND     D.PersonNo IN (SELECT PersonNo FROM userTransaction.dbo.sal#SESSION.thisprocess#Catchup)	
				AND     D.PersonNo IN (SELECT PersonNo FROM userTransaction.dbo.sal#SESSION.thisprocess#OnBoard WHERE PersonNo = D.PersonNo) 				
				<!--- only if the person is in the organization at this moment of settlement --->
				AND     D.PersonNo IN (SELECT PersonNo FROM userTransaction.dbo.sal#SESSION.thisprocess#Payable WHERE PersonNo = D.PersonNo)	
		 <cfelseif processmodality eq "WorkflowFinal">			 
		        <!--- if you do a final payment process there is always a portion that falls inside the contract period and will create a record 
				 but we may remove this		 
				AND     D.PersonNo IN (SELECT PersonNo FROM userTransaction.dbo.sal#SESSION.thisprocess#OnBoard WHERE PersonNo = D.PersonNo) 		
				 --->	        
				
		 <cfelseif processmodality eq "PersonalForce">
				<!--- no condition --->
		 <cfelse>
				AND     D.PersonNo IN (SELECT PersonNo FROM userTransaction.dbo.sal#SESSION.thisprocess#Catchup)	
				AND     D.PersonNo IN (SELECT PersonNo FROM userTransaction.dbo.sal#SESSION.thisprocess#OnBoard WHERE PersonNo = D.PersonNo) 					
				<!--- only if the person is in the organization at this moment of settlement --->
				AND     D.PersonNo IN (SELECT PersonNo FROM userTransaction.dbo.sal#SESSION.thisprocess#Payable WHERE PersonNo = D.PersonNo)	
				<!--- in the old code it would not have this condition --->
		 </cfif>		
							
		<!--- ---------------------------------------------------------------------------------------------- --->
		<!--- we exclude people to be recorded if the employeeSettlement.ActionStatus = 0, which we have as part of final payment open
		which means we do not pay such person until its status is set as 1 in the workflow to obtain amounts !!
		onwards if for whatever reason the status remains 0, they will be settled the next month or as part of the remaining.
		--->
		<!--- ---------------------------------------------------------------------------------------------- --->		

		AND     D.PersonNo NOT IN ( SELECT      ES.PersonNo 
		                            FROM        Payroll.dbo.EmployeeSettlement AS ES INNER JOIN
							                    Payroll.dbo.EmployeeSettlementLine AS ESL ON ES.PersonNo = ESL.PersonNo AND ES.SalarySchedule = ESL.SalarySchedule AND ES.Mission = ESL.Mission AND ES.PaymentDate = ESL.PaymentDate AND 
							                         ES.PaymentStatus = ESL.PaymentStatus
								    WHERE       ES.PersonNo       = D.PersonNo
								    AND         ES.Mission        = '#Form.Mission#'
								    AND         ES.SalarySchedule = '#Form.Schedule#'
									
								    <!--- added to limit this condition to the month itself, which we might have to change a bit more  --->
								    AND         ES.PaymentDate    = #SALEND# 	
								    AND         ES.ActionStatus   = '0')	  
								   
		<!--- --------------------------------------------------------------------------------------------------- --->
		<!--- 20/10 we also exclude people that have been connected to an already closed schedule for this month  --->
		<!--- --------------------------------------------------------------------------------------------------- --->	
		
		AND     D.PersonNo NOT IN (
		
					SELECT  ES.PersonNo
					FROM    Payroll.dbo.EmployeeSettlement AS ES INNER JOIN
                    		Payroll.dbo.SalarySchedulePeriod AS SSP ON ES.Mission = SSP.Mission AND ES.SettlementSchedule = SSP.SalarySchedule AND ES.PaymentDate = SSP.PayrollEnd AND 
                            ES.SettlementSchedule = SSP.SalarySchedule
					WHERE   ES.Mission        = '#Form.Mission#'
				    AND     ES.SalarySchedule = '#Form.Schedule#' 
					AND     ES.PaymentDate    = #SALEND# 	
					AND     ES.SettlementSchedule <> ES.SalarySchedule 
					AND     SSP.CalculationStatus = '3' )	
		
								   						  																	
	</cfquery>			
			  
	<!--- now we populate the log to capture any changes observed in the
	settlement compared to any values we have logged here --->
	
	<cfquery name="clean" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Payroll.dbo.CalculationLogSettlementLine
		WHERE ProcessNo    = '#url.processno#'
		AND  ProcessBatchId = '#calculationid#'
	</cfquery>
	
	<cfquery name="InsertNewChangedSettlement" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		INSERT INTO Payroll.dbo.CalculationLogSettlementLine
		
			    (ProcessNo, 
				 ProcessBatchId, 
				 Mission, 
				 SalarySchedule,
				 PayrollStart, 
				 Source, 
				 PersonNo, 
				 PayrollItem, 				 
				 PaymentDate, 
				 PaymentStatus,
				 SettlementPhase,		         
				 Currency, 				  
				 PaymentAmount, 
				 Amount)
			    
	    SELECT  '#url.processno#', 
			    '#calculationid#', 
			    '#Form.Mission#', 
			    '#Form.Schedule#', 
			    #SALSTR#, 
			    Source,
			    PersonNo, 
			    PayrollItem,				 				 
			    PaymentDate, 
				PaymentStatus,
			    SettlementPhase, 				            
			    Currency, 
			    PaymentAmount,	
			    Amount	  
			   
		FROM  (	SELECT  Source,
						PersonNo, 
						PayrollItem,				 				 
						PaymentDate,
						PaymentStatus, 
						SettlementPhase, 				            
						Currency, 						  
						SUM(PaymentAmount) as PaymentAmount, 
						SUM(Amount) as Amount
				    
			    FROM    Payroll.dbo.EmployeeSettlementLine E
				WHERE   Mission        = '#Form.Mission#'
				AND     SalarySchedule = '#Form.Schedule#'	
				AND     PayrollStart   = #SALSTR#
				<cfif Form.PersonNo neq "">
				AND     PersonNo       = '#Form.PersonNo#'
				</cfif>
				
				GROUP BY Source,
						 PersonNo, 
						 PayrollItem,				 				 
						 PaymentDate, 
						 PaymentStatus,
						 SettlementPhase, 				            
						 Currency 				
				
						
		      ) as S
			  
		WHERE Amount <>  (
						   SELECT   TOP 1 ISNULL(Amount,0) as Amount
	                       FROM     Payroll.dbo.CalculationLogSettlementLine
						   WHERE    ProcessBatchId  = '#calculationid#'						  
						   AND      Source          = S.Source
						   AND      PersonNo        = S.PersonNo
						   AND      PayrollItem     = S.PayrollItem
						   AND      PaymentDate     = S.PaymentDate
						   AND      PaymentStatus   = S.PaymentStatus
						   AND      SettlementPhase = S.SettlementPhase
						   AND      Currency        = S.Currency
						   ORDER BY ProcessNo DESC						   					   					  
						  ) 
			  OR
			  		
			  NOT EXISTS (
						   SELECT   'X'
	                       FROM     Payroll.dbo.CalculationLogSettlementLine
						   WHERE    ProcessBatchId  = '#calculationid#'						  
						   AND      Source          = S.Source
						   AND      PersonNo        = S.PersonNo
						   AND      PayrollItem     = S.PayrollItem
						   AND      PaymentStatus   = S.PaymentStatus
						   AND      PaymentDate     = S.PaymentDate
						   AND      SettlementPhase = S.SettlementPhase
						   AND      Currency        = S.Currency						   					   					   					  
						  ) 	
		
	</cfquery>
	
	<!---
	<cfoutput>#cfquery.executiontime#</cfoutput>
	--->
		
<!--- we also need to detect a scenario in which a value in the log, has no longer an occurence in the master table, it vanished, in that case we need to set it to 0.--->


	<cfquery name="InsertVanishedSettlements" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		INSERT INTO Payroll.dbo.CalculationLogSettlementLine
		
			    (ProcessNo, 
				 ProcessBatchId, 
				 Mission, 
				 SalarySchedule,
				 PayrollStart, 
				 Source, 
				 PersonNo, 
				 PayrollItem, 				 
				 PaymentDate, 
				 PaymentStatus,
				 SettlementPhase,		         
				 Currency, 
				 PaymentAmount,
				 Amount)
			    
	    SELECT  DISTINCT '#url.processno#', 
			    '#calculationid#', 
			    '#Form.Mission#', 
			    '#Form.Schedule#', 
			    #SALSTR#, 
			    Source,
			    PersonNo, 
			    PayrollItem,				 				 
			    PaymentDate, 
				PaymentStatus,
			    SettlementPhase, 				            
			    Currency, 
			    '0', '0'	  
			   
		FROM  (	SELECT  Source,
						PersonNo, 
						PayrollItem,				 				 
						PaymentDate, 
						PaymentStatus,
						SettlementPhase, 										            
						Currency 							
				    
			    FROM    Payroll.dbo.CalculationLogSettlementLine
				WHERE   ProcessBatchId  = '#calculationid#'
				AND     SalarySchedule = '#Form.Schedule#'	
				AND     PayrollStart   = #SALSTR#
				<cfif Form.PersonNo neq "">
				AND     PersonNo       = '#Form.PersonNo#'
				</cfif>		
				AND  Amount != '0'	
						
		      ) as S
			  
		WHERE NOT EXISTS (
						   SELECT   'X'
	                       FROM     Payroll.dbo.EmployeeSettlementLine
						   WHERE    Mission          = '#Form.Mission#' 
						   AND      SalarySchedule   = '#Form.Schedule#' 
						   AND   	PayrollStart     = #SALSTR# 						   				  
						   AND      Source           = S.Source
						   AND      PersonNo         = S.PersonNo
						   AND      PayrollItem      = S.PayrollItem
						   AND      PaymentDate      = S.PaymentDate
						   AND      PaymentStatus    = S.PaymentStatus
						   AND      SettlementPhase  = S.SettlementPhase
						   AND      Currency         = S.Currency						   					   					   					  
						  ) 	
						  
		AND NOT EXISTS 	(
						   SELECT   'X'
	                       FROM     Payroll.dbo.CalculationLogSettlementLine
						   WHERE    Mission          = '#Form.Mission#' 
						   AND      SalarySchedule   = '#Form.Schedule#' 
						   AND   	PayrollStart     = #SALSTR# 						   				  
						   AND      Source           = S.Source
						   AND      PersonNo         = S.PersonNo
						   AND      PayrollItem      = S.PayrollItem
						   AND      PaymentDate      = S.PaymentDate
						   AND      PaymentStatus    = S.PaymentStatus
						   AND      SettlementPhase  = S.SettlementPhase
						   AND      Currency         = S.Currency	
						   AND      Amount           = '0'					   					   					   					  
						  ) 		  
			
	</cfquery>
	
	<!---
	<cfoutput>#cfquery.executiontime#</cfoutput>
	--->
					
</cftransaction>