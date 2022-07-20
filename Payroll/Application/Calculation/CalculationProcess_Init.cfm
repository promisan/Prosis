
<!--- in the INIT process the following preparing actions are done :

1. Reset the prior calculation period
2. Reset where needed the recordstatus to determine which master records for 
     contract
	 SPA
	 dependents
	 entitlemnents are to be considered,
3.   check contract enabled entitlement	 
4.   start process

--->

<cftransaction>

<!--- ---- STEP 1 of 4 ---- --->
<!--- reset calculation period --->

<cfquery name="ResetPeriodEntitlement" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE   SalarySchedulePeriod
		SET      TransactionCount = 0, 
		         TransactionValue = 0
		WHERE    PayrollStart   >= #SALSTR#
		AND      Mission        = '#Form.Mission#'
		AND      SalarySchedule = '#Form.Schedule#' 		
</cfquery>

<cfif settlement eq "Initial">
	
	<cfquery name="ResetPeriodSettlement" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE SalarySchedulePeriod
			SET    TransactionPayment = 0
			WHERE  PayrollStart   >= #SALSTR#
			AND    Mission        = '#Form.Mission#'
			AND    SalarySchedule = '#Form.Schedule#' 		
			AND    CalculationStatus IN ('0','1')
	</cfquery>

<cfelse>
		
	<cfquery name="ResetPeriodSettlement" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE SalarySchedulePeriod
			SET    TransactionPaymentFinal = 0
			WHERE  PayrollStart   >= #SALSTR#
			AND    Mission        = '#Form.Mission#'
			AND    SalarySchedule = '#Form.Schedule#' 		
			AND    CalculationStatus IN ('0','1','2')
	</cfquery>

</cfif>

<!--- ---- STEP 2 of 4 ---- --->

<!--- ------------------------------------------- --->
<!--- determine the person contract record status --->
<!--- ------------------------------------------- --->

<cfquery name="Reset1" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Employee.dbo.PersonContract
		SET    RecordStatus = '1'
		WHERE  Mission = '#Form.mission#'
		AND    ActionStatus = '1'		
</cfquery>

<cfquery name="Reset9" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Employee.dbo.PersonContract
		SET    RecordStatus = '9'
		WHERE  Mission = '#Form.mission#'
		AND    (ActionStatus != '1' OR HistoricContract = '1')	
		
</cfquery>

<cfloop index="itm" list="1,9">

	<cfquery name="Reset0" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Employee.dbo.PersonContract
		SET    RecordStatus = <cfif itm eq '1'>'9'<cfelse>'1' </cfif>
		WHERE  ContractId IN ( 	SELECT       ActionSourceId
								FROM         Employee.dbo.EmployeeActionSource
								WHERE        ActionDocumentNo IN  <!--- obtain PENDING contract records with the new status and then
		                                   identify the employee action --->
		            	        		         (SELECT      EAS.ActionDocumentNo
		                	            		   FROM       Employee.dbo.PersonContract AS PC INNER JOIN
				                    	                      Employee.dbo.EmployeeActionSource AS EAS ON PC.ContractId = EAS.ActionSourceId INNER JOIN
															  Employee.dbo.EmployeeAction AS EA ON PC.ContractId = EA.ActionSourceId
		        		                	       WHERE      PC.Mission       = '#Form.mission#'
												   AND        PC.ActionStatus = '0' 
												   AND        EAS.ActionStatus = '1')
								AND          ActionStatus = <cfif itm eq '1'>'1'<cfelse>'9'</cfif> )	
	
	</cfquery>
	
</cfloop>	

<!--- ------------------------------------------- --->
<!--- determine the person SPA record status --->
<!--- ------------------------------------------- --->

<cfquery name="Reset1" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Employee.dbo.PersonContractAdjustment
		SET    RecordStatus = '1'
		WHERE  ContractId IN (SELECT ContractId
		                      FROM   Employee.dbo.PersonContract
							  WHERE  Mission = '#Form.mission#')
		AND    ActionStatus = '1'		
</cfquery>

<cfquery name="Reset9" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Employee.dbo.PersonContractAdjustment
		SET    RecordStatus = '9'
		WHERE  ContractId IN (SELECT ContractId
		                      FROM   Employee.dbo.PersonContract
							  WHERE  Mission = '#Form.mission#')
		AND    ActionStatus != '1'		
</cfquery>

<cfloop index="itm" list="1,9">

	<cfquery name="Reset0" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Employee.dbo.PersonContractAdjustment
		SET    RecordStatus = <cfif itm eq '1'>'9'<cfelse>'1'</cfif>
		WHERE  PostAdjustmentId IN ( 	SELECT       ActionSourceId
										FROM         Employee.dbo.EmployeeActionSource
										WHERE        ActionDocumentNo IN  <!--- obtain PENDING contract records with the new status and then
		                                   identify the employee action --->
			            	        		         (SELECT      EAS.ActionDocumentNo
			                	            		   FROM       Employee.dbo.PersonContractAdjustment AS PC INNER JOIN
					                    	                      Employee.dbo.EmployeeActionSource AS EAS ON PC.PostAdjustmentId = EAS.ActionSourceId INNER JOIN
															      Employee.dbo.EmployeeAction AS EA ON PC.PostAdjustmentId = EA.ActionSourceId
			        		        	        	   WHERE      PC.ContractId IN (SELECT ContractId
														                            FROM   Employee.dbo.PersonContract
																			        WHERE  Mission = '#Form.mission#')
													   AND        PC.ActionStatus = '0' 
													   AND        EAS.ActionStatus = '1')
										AND          ActionStatus = <cfif itm eq '1'>'1'<cfelse>'9'</cfif> )							   

	</cfquery>
	
</cfloop>	

<!--- -------------------------------------------- --->
<!--- determine the entitlement record status --->
<!--- ------------------------------------------- --->

<cfquery name="Reset1" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE PersonEntitlement
		SET    RecordStatus = '1'
		WHERE  PersonNo IN (SELECT PersonNo
		                      FROM   Employee.dbo.PersonContract
							  WHERE  Mission = '#Form.mission#')
		AND    Status = '2'		
</cfquery>

<cfquery name="Reset9" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE PersonEntitlement
		SET    RecordStatus = '9'
		WHERE  PersonNo IN (SELECT PersonNo
		                    FROM   Employee.dbo.PersonContract
							WHERE  Mission = '#Form.mission#')
		AND    Status != '2'		
</cfquery>

<cfloop index="itm" list="1,9">

	<cfquery name="Reset0" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE PersonEntitlement
		SET    RecordStatus = <cfif itm eq '1'>'9'<cfelse>'1'</cfif>
		WHERE  EntitlementId IN ( 	SELECT       ActionSourceId
										FROM     Employee.dbo.EmployeeActionSource
										WHERE    ActionDocumentNo IN  <!--- obtain PENDING contract records with the new status and then
		                                   identify the employee action --->
			            	        		         (SELECT      EAS.ActionDocumentNo
			                	            		   FROM       PersonEntitlement AS PC INNER JOIN
					                    	                      Employee.dbo.EmployeeActionSource AS EAS ON PC.EntitlementId = EAS.ActionSourceId INNER JOIN
															      Employee.dbo.EmployeeAction AS EA ON PC.EntitlementId = EA.ActionSourceId
			        		        	        	   WHERE      PC.PersonNo IN (SELECT PersonNo
														                          FROM   Employee.dbo.PersonContract
																			      WHERE  Mission = '#Form.mission#')
													   AND        PC.Status = '0' 
													   AND        EAS.ActionStatus = '1')
										AND      ActionStatus = <cfif itm eq '1'>'1'<cfelse>'9'</cfif> )							   

	</cfquery>
		
</cfloop>	

<!--- -------------------------------------------- --->
<!--- determine the person dependent record status --->
<!--- -------------------------------------------- --->

<cfquery name="Reset1" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Employee.dbo.PersonDependent
		SET    RecordStatus = '1'
		WHERE  PersonNo IN (SELECT PersonNo 
		                    FROM   Employee.dbo.PersonContract 
							WHERE  Mission = '#Form.mission#')
		AND    ActionStatus = '2'  <!--- '1' was used to change the dependent status as part of the contract and is treated like 0 --->		 
</cfquery>

<cfquery name="Reset9" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Employee.dbo.PersonDependent
		SET    RecordStatus = '9'
		WHERE  PersonNo IN (SELECT PersonNo 
		                    FROM   Employee.dbo.PersonContract 
							WHERE  Mission = '#Form.mission#')
		AND    ActionStatus != '2' <!--- '1' was used to change the dependent status as part of the contract and is treated like 0 --->			
</cfquery>

<cfloop index="itm" list="1,9">

	<cfquery name="Reset0" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Employee.dbo.PersonDependent
		SET    RecordStatus = <cfif itm eq '1'>'9'<cfelse>'1'</cfif>
		WHERE  DependentId IN (	SELECT       ActionSourceId
								FROM         Employee.dbo.EmployeeActionSource
								WHERE        ActionDocumentNo IN  <!--- obtain PENDING contract records with the new status and then
		                                   identify the employee action --->
		            	        		         (SELECT      EAS.ActionDocumentNo
		                	            		   FROM       Employee.dbo.PersonDependent AS PD INNER JOIN
				                    	                      Employee.dbo.EmployeeActionSource AS EAS ON PD.DependentId = EAS.ActionSourceId 
															  <!--- we have dependent and contract actions here 11/7/2018
															  INNER JOIN
															  Employee.dbo.EmployeeAction AS EA ON PD.DependentId = EA.ActionSourceId
															  --->
		        		                	       WHERE      PD.PersonNo IN (SELECT PersonNo 
														                      FROM   Employee.dbo.PersonContract 
																			  WHERE  Mission = '#Form.mission#')
												   AND        PD.ActionStatus IN ('0','1') <!--- 0= dependent edit, 1=contract edit ---> 
												   AND        EAS.ActionStatus = '1')
								AND          ActionStatus = <cfif itm eq '1'>'1'<cfelse>'9'</cfif> )							   

	</cfquery>
	
</cfloop>	

<cfquery name="ResetEntitlement" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE PersonDependentEntitlement		
		SET    Status = '2'
		FROM   PersonDependentEntitlement D
		WHERE  DependentId IN (SELECT DependentId 
		                       FROM  Employee.dbo.PersonDependent 
							   WHERE DependentId = D.DependentId
							   AND   RecordStatus = '1')
		
		AND    Status != '2' 			
</cfquery>

<cfquery name="DisableByParentEntitlement" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE PersonDependentEntitlement		
		SET    Status = '9'
		FROM   PersonDependentEntitlement D
		WHERE  ParentEntitlementId IN (SELECT EntitlementId 
		                               FROM  PersonEntitlement 
							           WHERE EntitlementId = D.ParentEntitlementId
							           AND   Status = '1')		
		AND    Status != '9' 			
</cfquery>

<!--- -------------------------------------------------------------------------------------- --->
<!--- special correction to reset the status for the dependents based on the master record
       needed for some reason in CICIG Hanno : 20/4/2011                                     --->
<!--- -------------------------------------------------------------------------------------- --->   

<cfquery name="ResetEntitlement" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		UPDATE  PersonEntitlement
         SET    Status = '2'
         FROM   PersonEntitlement S
         WHERE  S.Status = '1'
         AND    S.ContractId IN ( SELECT  ContractId
			                      FROM    Employee.dbo.PersonContract
			                      WHERE   ContractId = S.ContractId 
			                      AND     RecordStatus = '1' )

</cfquery>		
	
<cfquery name="ResetEntitlement" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		 UPDATE    PersonDependentEntitlement
         SET       Status = '2'
         FROM      PersonDependentEntitlement S
         WHERE     S.Status IN ('0','1')
         AND       S.DependentId IN ( SELECT  DependentId
		                              FROM    Employee.dbo.PersonDependent
		                              WHERE   DependentId = S.DependentId 
		        				      AND     RecordStatus = '1' )
</cfquery>		

<!--- in case of children entitlements the parent entitlements should always set the dates --->

<cfquery name="ResetEntitlementDate" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE PersonDependentEntitlement
		SET    DateEffective  = E.DateEffective, 
			   DateExpiration = E.DateExpiration
		FROM   PersonDependentEntitlement AS D INNER JOIN
               PersonEntitlement AS E ON D.ParentEntitlementId = E.EntitlementId AND E.Status != '9'
		WHERE  (D.DateEffective <> E.DateEffective AND D.Status <> '9') 
		       OR
               (D.Status <> '9' AND D.DateExpiration <> E.DateExpiration)
</cfquery>

<!--- -------------------------------------------------------------------------------------- --->
<!--- END special correction to reset the status for the dependents based on the master 
       needed for some reason in CICIG Hanno : 20/4/2011                                     --->
<!--- -------------------------------------------------------------------------------------- --->   

<!--- ---- STEP 3 of 4 ---- --->

<!--- --------------------------------------------------------------- --->
<!--- reset contract entitlement records that are contract associated --->
<!--- --------------------------------------------------------------- --->

<cfquery name="ResetEntitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#"> 
	UPDATE    PersonEntitlement
	SET       DateEffective = PC.DateEffective, 
	          DateExpiration = PC.DateExpiration
	FROM      PersonEntitlement PE INNER JOIN
	                      Employee.dbo.PersonContract PC ON PE.PersonNo = PC.PersonNo AND PE.ContractId = PC.ContractId
	WHERE     (PE.DateEffective <> PC.DateEffective) OR
	                      (PE.DateExpiration <> PC.DateExpiration) OR
	                      (PE.DateExpiration IS NULL) AND (PC.DateExpiration IS NOT NULL)
	<cfif processmodality neq "InCycleBatch">	
		   AND PE.PersonNo = '#Form.PersonNo#'
	<cfelse>
		   AND PE.PersonNo NOT IN (#preservesingleQuotes(selper)#)  	   
	</cfif>					  
</cfquery>					  
					
<cfquery name="CleanEntitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE    PersonEntitlement
	SET       Status = '9'
	WHERE     ContractId NOT IN (SELECT ContractId FROM Employee.dbo.PersonContract)
	AND       ContractId is not NULL
	<cfif processmodality neq "InCycleBatch">		
		   AND PersonNo = '#Form.PersonNo#'
	<cfelse>
		   AND PersonNo NOT IN (#preservesingleQuotes(selper)#)  
	</cfif>
</cfquery>		

<cfquery name="ResetOvertime" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE  PersonOvertime
	SET     Status = '3'
	FROM    PersonOvertime T	
	WHERE   OvertimeId NOT IN (SELECT ReferenceId 
	                           FROM   EmployeeSalaryLine
							   WHERE  ReferenceId = T.OvertimeId)
	AND     Status = '5'
	AND     OvertimePayment = 1
			
</cfquery>

</cftransaction>

<!--- ---- STEP 4 of 4 ---- --->

 <!--- check payment information 
			
 <cfquery name="SettlementPeriod"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    MAX(PayrollEnd) AS LastMonth
	FROM      EmployeeSettlementLine
	WHERE     SalarySchedule = '#Form.Schedule#'
	AND       Mission        = '#Form.Mission#'
 </cfquery>		
  						
 <cfif SettlementPeriod.LastMonth gt "">
				
		<cfquery name="Calculation"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT    *
		FROM      SalarySchedulePeriod
		WHERE     SalarySchedule = '#Form.Schedule#'
		AND       Mission        = '#Form.Mission#'
		AND       CalculationStatus >= '1'	
		AND       PayrollEnd = '#dateformat(SettlementPeriod.LastMonth,client.dateSQL)#'					
		</cfquery>	
	
		<cfif Calculation.recordcount eq "0">
		
			<cf_CalculationProcessProgressInsert
			    ProcessNo          = "#url.processno#"
			   	ProcessBatchId     = "#calculationid#"		
				StepStatus         = "9"						
				StepException      = "Settlement inconsistency"
				Description        = "Settlement data for #dateformat(SettlementPeriod.LastMonth,client.dateformatshow)# is not consistent with the entitlements"> 			
			
			<cfabort>
		
		</cfif>
			
</cfif>

--->
