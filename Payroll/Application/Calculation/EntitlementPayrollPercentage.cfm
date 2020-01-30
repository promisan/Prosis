
<!--- this component is always in the default currency, so no need to convert currencies here !! --->

<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#EntitlementRatePercentage">	

<!--- join the people in the schedule with the enabled components with rate percentages defined --->

<cfquery name="RatePercentage" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT   DISTINCT  
	         Ent.PersonNo, 
		     Ent.EntitlementId,
		     Ent.DateEffective, 
		     Ent.DateExpiration, 
			 
			 (SELECT  SUM(PayrollDays) AS Expr1
			  FROM    userTransaction.dbo.sal#SESSION.thisprocess#Payroll
			  WHERE   PersonNo = Ent.PersonNo ) as EntitlementDaysBase,
						 
		     Ent.EntitlementDays,
			 Ent.EntitlementDaysCorrectionPointer,
		     Ent.EntitlementLWOP, 
			 Ent.EntitlementSuspend,
			 Ent.EntitlementSickLeave,
			 
		     Ent.Status, 
		     Ent.ContractTime,
		     Ent.Line,
			 
			 <!--- 19/8/2017 adjustment to take the pointer 
			        based on the setting of the dependent for subsidy --->
			 (CASE WHEN R.Source = 'Contribution' 
			       THEN Ent.EntitlementSubsidyPointer 
				   ELSE Ent.EntitlementPointer END) as EntitlementPointer,						   
				   
		     R.SalaryTrigger, 
		     R.PayrollItem, 
		     R.PaymentCurrency,
		     R.Percentage, 
		     R.ScaleNo,
			 R.SalarySchedule,			
		     R.EntitlementPointer        as RatePointerPercentage,			 
		     R.ComponentName,
			 R.Source,
			 R.ParentComponent,
			 R.SalaryDays,
		     R.DetailMode,
		     R.CalculationBase,
			 (SELECT BaseAmount 
			  FROM   Ref_CalculationBase T
			  WHERE  Code = R.CalculationBase) as CalculationBaseMode,
		     R.CalculationBaseFinal,
		     R.SalaryMultiplier,
			 
			 CONVERT(float, 0) as AmountCalculationFull,
			 CONVERT(float, 0) as AmountCalculationDays,
			 CONVERT(float, 0) as AmountCalculationBase,
			 CONVERT(float, 0) as AmountCalculationWork,
						
		     CONVERT(float, 0) as AmountBase,			
						 	
			 CONVERT(float, 0) as EntitlementAmountFull, 
			 CONVERT(float, 0) as EntitlementAmountDays, 
		     CONVERT(float, 0) as EntitlementAmountBase, 
			 CONVERT(float, 0) as EntitlementAmountWork,
			
		     CONVERT(float, 0) as EntitlementAmount,
		     CONVERT(float, 0) as PaymentAmount,
			 #now()# as TimeStamp
		   
	INTO     userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage   
	
	FROM     userTransaction.dbo.sal#SESSION.thisprocess#Entitlements Ent,
	         userTransaction.dbo.sal#SESSION.thisprocess#Percentage R
		   
	WHERE    Ent.SalaryTrigger      = R.SalaryTrigger
	
	AND      R.SalarySchedule       = Ent.SalarySchedule 		   
	AND      (R.ServiceLocation     = Ent.ServiceLocation OR R.ServiceLocation = 'All')
	
	<!--- disabled to allow triggers that have percentage and rate component, like Assignment grant
	AND      Ent.EntitlementClass   = 'Percentage' 
	--->
	AND      R.EntitlementRecurrent = 1
	AND      R.SettleUntilPeriod    = '#settle#'
	<!--- link on regular level --->
	AND      R.EntitlementGrade     = 'REGULAR'
	
	UNION ALL
	
	SELECT   DISTINCT  
	         Ent.PersonNo, 
		     Ent.EntitlementId,
		     Ent.DateEffective, 
		     Ent.DateExpiration, 
			 
			 (SELECT  SUM(PayrollDays) AS Expr1
			  FROM    userTransaction.dbo.sal#SESSION.thisprocess#Payroll
			  WHERE   PersonNo = Ent.PersonNo ) as EntitlementDaysBase,
						
		     Ent.EntitlementDays,
			 Ent.EntitlementDaysCorrectionPointer,
		     Ent.EntitlementLWOP, 
			 Ent.EntitlementSuspend,		
			 Ent.EntitlementSickLeave,
			  	 
		     Ent.Status, 
		     Ent.ContractTime,
		     Ent.Line,
			 
			 <!--- 19/8/2017 adjustment to take the pointer 
			        based on the setting of the dependent for subsidy --->
			 (CASE WHEN R.Source = 'Contribution' 
			       THEN Ent.EntitlementSubsidyPointer 
				   ELSE Ent.EntitlementPointer END) as EntitlementPointer,						   
				   
		     R.SalaryTrigger, 
		     R.PayrollItem, 
		     R.PaymentCurrency,
		     R.Percentage, 
		     R.ScaleNo,
			 R.SalarySchedule,			
		     R.EntitlementPointer        as RatePointerPercentage,			 
		     R.ComponentName,
			 R.Source,
			 R.ParentComponent,
			 R.SalaryDays,
		     R.DetailMode,
		     R.CalculationBase,
			  (SELECT BaseAmount 
			  FROM   Ref_CalculationBase T
			  WHERE  Code = R.CalculationBase) as CalculationBaseMode,
		     R.CalculationBaseFinal,
		     R.SalaryMultiplier,
			 
			 CONVERT(float, 0) as AmountCalculationFull,
			 CONVERT(float, 0) as AmountCalculationDays,
			 CONVERT(float, 0) as AmountCalculationBase,
			 CONVERT(float, 0) as AmountCalculationWork,
			 
			<!--- for correction purposes --->	
		     CONVERT(float, 0) as AmountBase,
						
			 CONVERT(float, 0) as EntitlementAmountFull, 
			 CONVERT(float, 0) as EntitlementAmountDays, 
		     CONVERT(float, 0) as EntitlementAmountBase, 
			 CONVERT(float, 0) as EntitlementAmountWork, 
			
		     CONVERT(float, 0) as EntitlementAmount,
		     CONVERT(float, 0) as PaymentAmount,
			 #now()# as TimeStamp	   
		
	FROM     userTransaction.dbo.sal#SESSION.thisprocess#Entitlements Ent,
	         userTransaction.dbo.sal#SESSION.thisprocess#Percentage R
		   
	WHERE    Ent.SalaryTrigger      = R.SalaryTrigger
	
	AND      R.SalarySchedule       = Ent.ContractScheduleSPA 		   
	AND      (R.ServiceLocation     = Ent.ContractLocationSPA OR R.ServiceLocation = 'All')
	
	<!--- disabled to allow triggers that have percentage and rate component, like Assignment grant
	AND      Ent.EntitlementClass   = 'Percentage' 
	--->
	AND      R.EntitlementRecurrent = 1
	AND      R.SettleUntilPeriod    = '#settle#'
	<!--- link on SPA level --->
	AND      R.EntitlementGrade     = 'SPA'
		
	ORDER BY PersonNo 
			
</cfquery>

<!--- ----------------------------------------------------------------- --->
<!--- ----------------------------------------------------------------- --->
<!--- ------------------------- ATTENTION ----------------------------- --->
<!--- special correction LTC for STL less than 4 year old and secundary --->
<!--- ----------------------------------------------------------------- --->
<!--- ----------------------------------------------------------------- --->
<!--- ----------------------------------------------------------------- --->

    <!--- correction for PF SLWOP20 calculation with Suspend days to take a different base --->
	
	<cfquery name="CorrectionSTLPFSuspend"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE   userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage
		
		SET      CalculationBase                  = 'PensionX', <!--- this is to ensure we take the full amount to be applied --->
				 CalculationBaseFinal             = 'PensionX', 
				 CalculationBaseMode              = '1',
				 EntitlementDaysCorrectionPointer = '0', <!--- prevents a result on line 511 to be applied  --->		        
				 SalaryDays                       = '1' <!--- to ensure this is multiplied correctly 15.75 / 21.75 --->
				 
				
		FROM     userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage A INNER JOIN (
		
			        <!--- define if this person has suspend days this month  --->
					
					SELECT    PersonNo							  
					FROM      userTransaction.dbo.sal#SESSION.thisprocess#Payroll  							  						  
					WHERE     PayrollSuspend > 0					
					GROUP BY  PersonNo
					
				 ) as C ON A.PersonNo = C.PersonNo 
				
	   WHERE     SalaryTrigger IN ('PensionContr') 
	   AND       EntitlementDaysCorrectionPointer = '1'
	   
	</cfquery>
	
	
	<cfset age = dateAdd("yyyy",-5,SALEND)>
	
	<!--- correction for less than 5 year old for LTC counter --->
	
	<cfquery name="CorrectionSTLInsuranceCoverageChildren" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE   userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage
		<!--- we are correcting the pointer --->
		SET      EntitlementPointer = EntitlementPointer - Counted
		
		FROM     userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage A INNER JOIN (
		
			        <!--- define if we have any 4 year old in our population to reduce  --->
					
					SELECT    PD.PersonNo,
							  Pay.DateEffective,	
							  Pay.DateExpiration,	 
					          COUNT(*) AS Counted
							  
					FROM      PersonDependentEntitlement AS PDE INNER JOIN
					          Employee.dbo.PersonDependent AS PD ON PDE.DependentId = PD.DependentId AND PDE.PersonNo = PD.PersonNo INNER JOIN
							  userTransaction.dbo.sal#SESSION.thisprocess#Payroll Pay ON PD.PersonNo = Pay.PersonNo
							  						  
					WHERE     PDE.SalaryTrigger = 'MedicalInsurance1' <!--- medical insurance trigger --->
					AND       PDE.Status = '2' 
					<!--- 	AND   PD.ActionStatus IN ('1','2')  disabled --->
					AND   PD.Recordstatus = '1' 
					AND       PD.Birthdate > (DATEADD(year, -5, Pay.DateExpiration))
					 
					AND       PDE.DateEffective  <= Pay.DateExpiration 
				    AND      (PDE.DateExpiration >= Pay.DateEffective or PDE.DateExpiration is NULL)		
					GROUP BY  PD.PersonNo,
					          Pay.DateEffective,
							  Pay.DateExpiration  
					
				 ) as C ON A.PersonNo = C.PersonNo AND A.DateEffective = C.DateEffective
				
	   WHERE     ComponentName IN ('ContriLTC1','CignaLTC1') <!--- correction for less than 5 year old for LTC counter --->
	   
	</cfquery>
	
	<!--- correction for secundary dependents --->
	
	<cfquery name="HarcodedCorrectionSTL" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE   userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage
		SET      EntitlementPointer = EntitlementPointer - Counted
		FROM     userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage A INNER JOIN (
		
					SELECT    PD.PersonNo, COUNT(*) AS Counted
					FROM      PersonDependentEntitlement AS PDE INNER JOIN
					          Employee.dbo.PersonDependent AS PD ON PDE.DependentId = PD.DependentId AND PDE.PersonNo = PD.PersonNo
					WHERE     PDE.SalaryTrigger = 'SecDep' <!--- secundary dependents --->
					AND       PDE.Status = '2' 
					-- AND       PD.ActionStatus IN ('1', '2') 	
					AND       PD.Recordstatus = '1' 		
					AND       PDE.DateEffective  <= #SALSTR# 
				    AND      (PDE.DateExpiration >= #SALEND# or PDE.DateExpiration is NULL)		
					<!--- the same Dependent but also in MIP, must not count. --->
					AND  	  EXISTS (
										SELECT TOP 1 'X'
										FROM   Payroll.dbo.PersonDependentEntitlement as TMP1 
										WHERE  TMP1.SalaryTrigger = 'MedicalInsurance1' 
										AND    TMP1.DependentId	  = PDE.DependentId 
										AND    TMP1.Status = '2') 
					GROUP BY  PD.PersonNo ) as C ON A.PersonNo = C.PersonNo 
					<!--- annotation : the person has been disabled for subsidy in the screen already --->
	    WHERE   ComponentName IN ('CignaLTC1') 
	</cfquery>
	
	<!--- safe guuard only --->
	
	<cfquery name="HarcodedCorrectionSTL" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE   userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage
		SET      EntitlementPointer = 0
		WHERE    EntitlementPointer < 0		
	</cfquery>
	
<!--- ----------------------------------------------------------------- --->
<!--- ----------------------------------------------------------------- --->
<!--- ---------------------END of ATTENTION --------------------------- --->
<!--- ----------------------------------------------------------------- --->
<!--- ----------------------------------------------------------------- --->

<cfquery name="CorrectPointerToValidValues" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage
	
	SET    EntitlementPointer        = P.MaxPointer
	
	FROM   userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage R, 	
	
		   (SELECT   ComponentName,
		   		     ScaleNo, 
		             MAX(EntitlementPointer) AS MaxPointer	
			FROM     SalaryScalePercentage			
			GROUP BY ComponentName, ScaleNo) as P
	
	WHERE  R.ComponentName      = P.ComponentName
	AND    R.ScaleNo            = P.ScaleNo
	AND    R.EntitlementPointer > P.MaxPointer
		
</cfquery>

<!--- ----------------------------------------------------------- --->
<!--- remove entitlements lines which do not match the determined 
     pointer setting --->
<!--- ----------------------------------------------------------- --->	 
 
<cfquery name="MatchPointer" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE  FROM userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage
		WHERE   EntitlementPointer <> RatePointerPercentage
</cfquery>
  
<!--- we make a correction to calculate percentages with a different 
         base if the person has been set as final payment --->		
		 
 <cfquery name="UpdateFinalPaymentCorrection" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage
	SET     CalculationBase = CalculationBaseFinal
	FROM    userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage T
	WHERE   PersonNo IN (SELECT PersonNo
				         FROM   userTransaction.dbo.sal#SESSION.thisprocess#Final)			
</cfquery>		

<!--- define calculation base for the records to be calculated --->
<!--- 21/3/2017, we need to run this in the correct order first the ones that have no percentages, then the ones tjat
have percentages in the result --->

<!--- loop by schedule --->

 <cfquery name="setSchedule" 
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   		SELECT DISTINCT SalarySchedule 
	    FROM   userTransaction.dbo.sal#SESSION.thisprocess#Percentage 
</cfquery>

<cfloop query="setschedule">   

    <!--- select all the percentage calculations bases that needs to be applied ---> 
	
	<cfquery name="Base" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT    *, 0 as OrderProcess
		FROM      Ref_CalculationBase
		<!--- has indeed been used --->
		WHERE     Code IN (SELECT CalculationBase 
		                   FROM   userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage)
		<!--- does not have a percentage defined in itself which should come first to make sure they are available for a later base --->				   
		AND       Code NOT IN (
						SELECT    R.Code
						FROM      Ref_CalculationBaseItem R INNER JOIN
				                  userTransaction.dbo.sal#SESSION.thisprocess#Percentage S 
								  ON R.SalarySchedule = S.SalarySchedule AND R.PayrollItem = S.PayrollItem	
						WHERE     R.SalarySchedule = '#SalarySchedule#'		  				
						)
						
		UNION
		
		<!--- does not a percentage defined in itself --->		
		SELECT    *, 1 as OrderProcess
		FROM      Ref_CalculationBase
		WHERE     Code IN (SELECT CalculationBase 
		                   FROM   userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage)
		AND 	  Code IN (
						   SELECT R.Code
						   FROM   Ref_CalculationBaseItem R INNER JOIN
				                  userTransaction.dbo.sal#SESSION.thisprocess#Percentage S 
								  ON R.SalarySchedule = S.SalarySchedule AND R.PayrollItem = S.PayrollItem	
						  WHERE   R.SalarySchedule = '#SalarySchedule#'			  				   
						  )	
		
		ORDER BY 	OrderProcess		
			   
	</cfquery>
				
	<cfset myschedule = SalarySchedule>

	<cfloop query = "base">
	
		<!--- apply per base the amount per person / line(calc) to be used for the percentage  
		
		31/3/2017 we adjust that also a component which is
		itself a percentage can be recalculated as part of a new percentage 
		hereto we first apply plain bases and then we apply basis that have one or more 
		percentages as part of it 
		
		15/01/2018 we added here also the amountfull, amountdays to be carried over   
		
		--->
						
		<cfinclude template="EntitlementCalculationBase.cfm">
			
		<!--- update the base amount in the temp calculation base set --->
		
		<cfquery name="SetAmountBase" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage 
			
			<!--- added a twist to overrule the calculation based on case of corrected work (entitlements) days ---> 
			SET   	AmountBase = S.AmountCalculation,
								  
					AmountCalculationFull = S.AmountCalculationFull,					
					AmountCalculationDays = S.AmountCalculationDays,
			 		AmountCalculationBase = S.AmountCalculationBase,
					AmountCalculationWork = S.AmountCalculationWork				
			        		      
			FROM    userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage T,	
			        userTransaction.dbo.sal#SESSION.thisprocess#CalculationBase#code# S
					
			WHERE   S.PersonNo            = T.PersonNo
			AND     S.PayrollCalcNo       = T.Line	
			AND     T.CalculationBase     = '#code#' 
			AND     T.SalarySchedule      = '#myschedule#'					
		</cfquery>						
	
		<!--- -------------------------------------------------------------------------------------------------------- --->
		<!--- update percentage (if needed based on a subtable) based on the base value and correct for the full month --->
		<!--- -------------------------------------------------------------------------------------------------------- --->
	
		<cfquery name="Update" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage
			SET   	Percentage = D.Percentage	
				       
			FROM    userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage T,	
					SalaryScalePercentageDetail D
					
			WHERE   T.ScaleNo            = D.ScaleNo
			AND     T.ComponentName      = D.ComponentName
			AND     T.EntitlementPointer = D.EntitlementPointer
			AND     T.SalarySchedule      = '#myschedule#'	
			AND     T.DetailMode         = 'Amount'
			AND     D.DetailValue =
									(
									SELECT  TOP 1 D2.DetailValue		
									FROM    userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage T2,	
											SalaryScalePercentageDetail D2
									WHERE   T2.ScaleNo            = D2.ScaleNo
									AND     T2.ComponentName      = D2.ComponentName
									AND     T2.EntitlementPointer = D2.EntitlementPointer
									AND     T2.DetailMode         = 'Amount'
									AND     T2.AmountBase * (#CalculationBaseDays#/(T2.EntitlementDays-T2.EntitlementLWOP)) <= D2.DetailValue 
									AND		T2.personNo=T.personNo
									AND 	T2.EntitlementDays>T2.EntitlementLWOP	
									ORDER BY DetailValue ASC		
									)		
			AND 	T.EntitlementDays > T.EntitlementLWOP	
		</cfquery>
					  				
		<cfquery name="DeleteZeroEntitlementDays" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE  FROM userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage
				WHERE   (EntitlementLWOP + EntitlementSuspend) >= EntitlementDays		
				AND     SalaryDays IN ('0','3')  
				AND     SalarySchedule      = '#myschedule#'	
		</cfquery>		
		
		
		<!--- NEWLY ADDED the calculated amount base to be applied to the percentage does not have to be correct 
		in case the entitlement was a corrected days because of SLWOP handling of the period (werner for Jasna case) 
		
		Explain more ......
		
		--->
						
		<cfquery name="SetAmountBase" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage 
			SET   	AmountBase = AmountCalculationWork			
			WHERE   EntitlementDaysCorrectionPointer = 1 
			<!--- 18-12-2018 added by Hanno, to be clarified as to why we needed this code --->			
		</cfquery>
									
		<cfloop index="itm" list="0,1,2,3" delimiters=",">
		
			<cfquery name="CalculatePayrollAmountPercentage" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage
														
				<cfif itm eq "1">
				<!--- (1) Entitlement days --->
				SET   	EntitlementAmountFull = ((Percentage/100)*AmountCalculationFull)*SalaryMultiplier,
						EntitlementAmountDays = ((Percentage/100)*AmountCalculationDays)*SalaryMultiplier, 
				        EntitlementAmountBase = ((Percentage/100)*AmountCalculationBase)*SalaryMultiplier,
						EntitlementAmountWork = ((Percentage/100)*AmountCalculationWork)*SalaryMultiplier,
				        EntitlementAmount     = ((Percentage/100)*AmountBase)*SalaryMultiplier*(EntitlementDays/EntitlementDaysBase),
					    PaymentAmount         = ((Percentage/100)*AmountBase)*SalaryMultiplier*(EntitlementDays/EntitlementDaysBase)			
						
				<cfelseif itm eq "0">
				<!--- (0) Entitlement days -/- LWOP   --->
				
				<!--- 	Hanno note : this variation was introduced if a percentage would beed needed for a dependent which entitlement start
						at a different moment than the entitlement days itself which means it needs to be pro-rated against 
						the base cacluation that is generated by the staffmember so in that case the period of base amount usually 21.75
						is then adjusted for the period of the depedent entitlement that fall into it --->
									
				SET   	EntitlementAmountFull = ((Percentage/100)*AmountCalculationFull)*SalaryMultiplier, 
						EntitlementAmountDays = ((Percentage/100)*AmountCalculationDays)*SalaryMultiplier, 
					    EntitlementAmountBase = ((Percentage/100)*AmountCalculationBase)*SalaryMultiplier, 
						EntitlementAmountWork = ((Percentage/100)*AmountCalculationWork)*SalaryMultiplier,
				        EntitlementAmount     = ((Percentage/100)*AmountBase)*SalaryMultiplier*((EntitlementDays-EntitlementLWOP)/EntitlementDaysBase),
					    PaymentAmount         = ((Percentage/100)*AmountBase)*SalaryMultiplier*((EntitlementDays-EntitlementLWOP)/EntitlementDaysBase)							
						
				<cfelseif itm eq "3">
				<!--- (3) Entitlement days -/- (LWOP + Suspended) --->
																	
				SET   	EntitlementAmountFull = ((Percentage/100)*AmountCalculationFull)*SalaryMultiplier, 
						EntitlementAmountDays = ((Percentage/100)*AmountCalculationDays)*SalaryMultiplier, 
					    EntitlementAmountBase = ((Percentage/100)*AmountCalculationBase)*SalaryMultiplier, 
						EntitlementAmountWork = ((Percentage/100)*AmountCalculationWork)*SalaryMultiplier,
						EntitlementAmount     =
						CASE  WHEN CalculationBaseMode =  '1'    THEN ((Percentage/100)*AmountBase)*SalaryMultiplier*((EntitlementDays-EntitlementLWOP-EntitlementSUSPEND)/#Form.SalaryDays#)
							  ELSE ((Percentage/100)*AmountBase)*SalaryMultiplier*((EntitlementDays-EntitlementLWOP-EntitlementSUSPEND)/EntitlementDaysBase)					    			    
						END,	
											  
						PaymentAmount        =
						CASE  WHEN CalculationBaseMode =  '1'    THEN ((Percentage/100)*AmountBase)*SalaryMultiplier*((EntitlementDays-EntitlementLWOP-EntitlementSUSPEND)/#Form.SalaryDays#)
							  ELSE ((Percentage/100)*AmountBase)*SalaryMultiplier*((EntitlementDays-EntitlementLWOP-EntitlementSUSPEND)/EntitlementDaysBase)					    			    
						END										
						
				<cfelseif itm eq "2">
										
				SET   	EntitlementAmountFull = ((Percentage/100)*AmountCalculationFull)*SalaryMultiplier,  <!--- correction in case this generated amount is used another percentage --->						
					    EntitlementAmountDays = ((Percentage/100)*AmountCalculationDays)*SalaryMultiplier,  <!--- correction in case this generated amount is used another percentage --->			
				        EntitlementAmountBase = ((Percentage/100)*AmountCalculationBase)*SalaryMultiplier,  <!--- correction in case this generated amount is used another percentage --->
						EntitlementAmountWork = ((Percentage/100)*AmountCalculationWork)*SalaryMultiplier,
						
				        EntitlementAmount     = ((Percentage/100)*AmountBase)*SalaryMultiplier,
					    PaymentAmount         = ((Percentage/100)*AmountBase)*SalaryMultiplier
						
				FROM    userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage T
				</cfif>
				WHERE   SalaryDays            = '#itm#'
				AND     SalarySchedule        = '#myschedule#'	
		    </cfquery>	
				
		</cfloop>
						
	</cfloop>
	
</cfloop>	

<!--- correction of Medical insurance charge will always be based on the full period of being entitled, this does not apply for PF --->

<cfquery name="MIPBasedOnFulltime" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage
		SET     EntitlementAmount = EntitlementAmount * (100 / ContractTime), 
		        PaymentAmount     = PaymentAmount * (100 / ContractTime)
		WHERE   CalculationBase   = 'CigDeduct' 
		AND     Source            = 'Deduction'
		
</cfquery>		


<!--- -------------------------------------------------------------------- --->
<!--- -----------19/8 medical insurance premium handling------------------ --->
<!--- -------------------------------------------------------------------- --->

<!--- Hanno updated 9/28/2017
      now is the moment to update the percentage of the deduction 
      based on the percentage of the subsidy : used for medical insurance 
	  19/8 of STL, to subsidise based on a variety of settings ensuring the staffmember pays the full mode. 

	  Source = Contribution and ParentComponent is not NULL 
	 
	  THEN update the parent component for this person with the same lineNo 
	  with percentage - (this percentage * ContractTime/100) and set the contract time = 100 and entitement	 	
	 
 ---> 
 
 <!--- we adjust the deduction based on the calculated subsidy which is dependent on working days and SLWOP --->
  
 <cfquery name="ResetMedicalContributionFromSubsidy" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			
	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage
	
	SET     EntitlementAmountFull = EntitlementAmountFull - S.AmountFull, 	
			EntitlementAmountDays = EntitlementAmountDays - S.AmountDays,
			EntitlementAmountBase = EntitlementAmountBase - S.AmountBase, 
			EntitlementAmount     = EntitlementAmount - S.Amount, 
			PaymentAmount         = EntitlementAmount - S.Amount		
							  
    FROM    userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage AS P 
	        INNER JOIN        (SELECT       PersonNo, 
			                                Line, 
											ParentComponent, 
											EntitlementAmountFull as AmountFull,
											EntitlementAmountDays as AmountDays,											
											EntitlementAmountBase as AmountBase,											
											EntitlementAmount as Amount
                               FROM         userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage
                               WHERE        Source = 'Contribution'   <!--- subsidy --->
							   AND          ParentComponent IS NOT NULL) AS S 
							   
		    ON P.PersonNo = S.PersonNo AND P.Line = S.Line AND P.ComponentName = S.ParentComponent

    WHERE   P.Source = 'Deduction' 
	
	AND     EXISTS (SELECT 'X' 
	                FROM   userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage AS V
                    WHERE  PersonNo        = P.PersonNo 
			        AND    Line            = P.Line 
				    AND    ParentComponent = P.ComponentName) 		
					
			 
 </cfquery>		  
 
<!--- --------------------------------------------------- --->
<!--- added 8/1/2015 is a deduction we need to correct it --->
<!--- --------------------------------------------------- --->
	
<cfquery name="MultiplierCorrection" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage 
	SET     PaymentAmount  = -PaymentAmount		        
	WHERE   PayrollItem IN (SELECT PayrollItem 
	                        FROM   Ref_PayrollItem 							
							WHERE  PaymentMultiplier = '-1')		
</cfquery>
	
<cfquery name="InsertLine" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO EmployeeSalaryLine
			(SalarySchedule, 
			 PersonNo, 
			 PayrollStart, 
			 PayrollCalcNo,
			 PayrollItem, 
			 EntitlementPercentage,
			 EntitlementPeriod,
			 EntitlementSLWOP,
			 EntitlementSuspend,
			 EntitlementSickLeave,
			 EntitlementSalarySchedule,
			 EntitlementPeriodUoM,
			 EntitlementPointer,
			 ComponentName,
			 Currency, 
			 
			 AmountCalculationFull,
			 AmountCalculationDays,
			 AmountCalculationBase,
			 AmountCalculation, 
			 
			 AmountPayroll, 
			 PaymentCurrency, 
			 PaymentCalculation, 
			 PaymentAmount, 
		     Reference, 
			 ReferenceId, 
			 CalculationSource,
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName)
			 
	SELECT   '#Form.Schedule#',
			 PersonNo, 
			 #SALSTR#, 
			 Line,
			 PayrollItem,
			 Percentage,
			 EntitlementDays,
			 EntitlementLWOP,
			 EntitlementSuspend,
			 EntitlementSickLeave,
			 SalarySchedule,
			 'Percentage',
			 EntitlementPointer,
			 ComponentName,
			 PaymentCurrency,
			 
			 ROUND(EntitlementAmountFull,6),
			 ROUND(EntitlementAmountDays,6),
			 ROUND(EntitlementAmountBase,6),
			 ROUND(EntitlementAmount,6), 
			 
			 ROUND(PaymentAmount,6), 
			 PaymentCurrency, 
			 ROUND(EntitlementAmount, #roundsettle#), 
			 ROUND(PaymentAmount,     #roundsettle#), 
			 'Entitlement',
		     EntitlementId, 
			 'RatePercentage',
			 '#SESSION.acc#', 
			 '#SESSION.last#', 
			 '#SESSION.first#'
			 
	FROM     userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage P
	WHERE    EntitlementAmount != '0' 
	AND      EXISTS (SELECT 'X' 
	                 FROM  EmployeeSalary
				     WHERE PersonNo       = P.PersonNo
				     AND   PayrollCalcNo  = P.Line
				     AND   SalarySchedule = '#Form.Schedule#'
				     AND   PayrollStart   = #SALSTR#)
					 
</cfquery>
