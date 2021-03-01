
<!--- 
	1. first define cumulative entitlement after each calculation as of the start date 
	2. and the define payment that is due after cumulative prior settlement 
	has been defined. 	
--->

<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#SettleEntitlement">	
<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#SettleEntitlementCorrection">	
<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#Settled">	
<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#SettledDiff">	
<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#CatchUp">

<cfif settlementMode eq "Regular">
	<!--- regular payment --->
	<cfset staffbase = "userTransaction.dbo.sal#SESSION.thisprocess#OnBoard">		
<cfelse>
	<!--- staff final payment calculation --->		
	<cfset staffbase = "userTransaction.dbo.sal#SESSION.thisprocess#Final">		
</cfif>

<!--- ----------------------- --->
<!--- already settled amounts --->
<!--- ----------------------- --->
	
<cfquery name="Period" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM      SalarySchedulePeriod
	WHERE     Mission        = '#Form.Mission#'
	 AND      SalarySchedule = '#Form.Schedule#' 
	 AND 	  PayrollEnd     = #CALCEND#
</cfquery>

<cfif SettleInitialMode eq "0" or Period.CalculationStatus eq "2">		
	<cfset settlementstatus = "Final">
<cfelse>			
	<cfset settlementstatus = "Initial">	
</cfif>

<!--- ------------------------------------------------------------------------------------------------------------- --->
<!--- this is AN EFFORT to correct the entitlement in case we have a settlement stop for a period but this
only work in case the full settlement has to be stopped or in case certain elements have to be stopped, otherwise
you need ALWAYS to look into a correction through SLWOP correction on the entitlement level. --->

<!--- define total entitlements up until the current settlement, 
but EXCLUDE entitlements for a COMPLETE MONTH deferred by a PAYROLL action 4001 (before 4004) to suppress the settlement --->

<cfsavecontent variable="action">
	Employee.dbo.PersonAction 
	WHERE    PersonNo       = ES.PersonNo 
	AND      Mission        = ES.Mission 
	AND      DateExpiration >= ES.SalaryCalculatedStart 
	AND      DateEffective  <= ES.SalaryCalculatedEnd 
	AND      ActionStatus = '1'
	AND      ActionCode IN ('4001')
	ORDER BY DateEffective
</cfsavecontent>

<!--- define the first month that has not been settled yet --->
<cfquery name="LastClose" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 PayrollEnd
		FROM     SalarySchedulePeriod
		WHERE    Mission            = '#Form.Mission#'
	    AND      SalarySchedule     = '#Form.Schedule#'		
		AND      CalculationStatus  = '3'									
		ORDER BY PayrollEnd DESC
</cfquery>	

<CF_DateConvert Value="#DateFormat(LastClose.PayrollEnd,CLIENT.DateFormatShow)#">
<cfset SALCLS = dateValue>

<cfif SALSTR lte SALCLS>	
	<cfset compUntilDate = SALCLS>
<cfelse>
	<cfset compUntilDate = SALSTR>
</cfif>

<!--- Hanno : line 134, 222, 299 --->

<cfquery name="Deferred" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	
	SELECT    SalarySchedule, 
	          PayrollStart, 
			  PersonNo, 
			  PayrollCalcNo, 
			  PayrollTransactionId, 
			  SalaryCalculatedStart, 
		      SalaryCalculatedEnd, 
			  DateCorrectionStart,
			  DateCorrectionEnd,
			  ActionCode,
			  PayrollItem, 
			  Source,
			  CASE WHEN DateCorrectionEnd is NULL 
			       THEN 100.00
				   ELSE 100.00 - (DATEDIFF(d, DateCorrectionStart,DateCorrectionEnd)+ 1)*100 / (DATEDIFF(d, SalaryCalculatedStart,SalaryCalculatedEnd)+ 1) END 
				   
				   as Percentage				   
				   
	INTO    userTransaction.dbo.sal#SESSION.thisprocess#SettleEntitlementCorrection	   		   
	
	FROM (
	
		SELECT    ESL.SalarySchedule, 
		          ESL.PayrollStart, 
				  ESL.PersonNo, 
				  ESL.PayrollCalcNo, 
				  ESL.PayrollTransactionId, 
				  ESL.PayrollItem, 
				  ESL.Source,
				  ES.SalaryCalculatedStart, 
		          ES.SalaryCalculatedEnd, 
				  
				  <!--- link the actioncode --->
				  ( SELECT TOP 1 ActionCode FROM #preserveSingleQuotes(action)# ) as ActionCode,
				  
				  <!--- link the effective date --->
				  (CASE WHEN (SELECT TOP 1 DateEffective FROM #preserveSingleQuotes(action)#) < ES.SalaryCalculatedStart THEN ES.SalaryCalculatedStart 
					    ELSE (SELECT TOP 1 DateEffective FROM #preserveSingleQuotes(action)#) END) 
						
				  as DateCorrectionStart,
		
				  <!--- link the expiration date --->
				  (CASE WHEN (SELECT TOP 1 DateExpiration FROM #preserveSingleQuotes(action)#) > ES.SalaryCalculatedEnd THEN ES.SalaryCalculatedEnd 
						ELSE (SELECT TOP 1 DateExpiration FROM #preserveSingleQuotes(action)#) END) 
						
				  as DateCorrectionEnd
		
		FROM      EmployeeSalary ES INNER JOIN
		          EmployeeSalaryLine ESL ON ES.SalarySchedule = ESL.SalarySchedule 
				                  AND ES.PayrollStart  = ESL.PayrollStart 
								  AND ES.PersonNo      = ESL.PersonNo 
								  AND ES.PayrollCalcNo = ESL.PayrollCalcNo
		
		<!--- only actions for people in the data set to be calculated --->
				  
		WHERE    ES.SalarySchedule  = '#Form.Schedule#'
				 
	    AND      ES.PayrollStart   <= #SALSTR# <!---  <= #compUntilDate# beofre was : #SALSTR# --->
		
	    AND      ES.Mission         = '#Form.Mission#'
		
		 <!--- 24/5/2018 we only compare entitlements that start with the determined EOD date for this mission/person --->
		 
		<cfif processmodality eq "PersonalForce" or processmodality eq "WorkflowFinal"> 
				
		AND     ES.PersonNo     = '#Form.PersonNo#'
		AND     ES.PayrollStart >= #DEFF#  <!--- pass this field value --->
						
		<cfelse> 
		 
	    AND      ES.PayrollStart >= ( SELECT TOP 1 EntitlementEffective
	                            FROM  userTransaction.dbo.sal#SESSION.thisprocess#Payroll
								WHERE PersonNo = ES.PersonNo) 
							
								
		AND      ES.PersonNo IN (SELECT PersonNo FROM  #staffbase# X WHERE  X.PersonNo = ES.PersonNo)  	  
								 
		</cfif>						 
	
	) as Subtable 	
	
					
</cfquery>

<!--- reverse correction for 4004 : removed as 4004 is no longer there

<cfquery name="resetEntitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE userTransaction.dbo.sal#SESSION.thisprocess#SettleEntitlementCorrection	
	SET    Percentage = 100
	WHERE  PayrollItem IN (SELECT PayrollItem
	                       FROM   Ref_PayrollItem 
						   WHERE  SettlementMonth <> '0')
	AND    ActionCode = '4004'		
</cfquery>

--->

<cfquery name="resetEntitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE userTransaction.dbo.sal#SESSION.thisprocess#SettleEntitlementCorrection	
	SET    Percentage = Percentage/100	
</cfquery>

<!--- total entitlements for this person starting with the month of the EOD date of that person 
for the month of the calculation --->

<cfquery name="Entitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT   H.PersonNo, 
	         L.PayrollItem, 
			 L.Source,
	         I.AllowSplit,
			 H.PaymentCurrency, 
			 I.Settlement,
			 I.SettlementMonth, 
			 			 
			 <!--- rounds up 25/7/2016 esspecially done for aguinaldo--->
			 SUM(L.PaymentCalculation*C.Percentage)          AS CalculatedAmount,
			 SUM(L.PaymentAmount*C.Percentage)               AS PaymentAmount,			 
			 CEILING(SUM(L.PaymentCalculation*C.Percentage)) AS CeilingCalculatedAmount,
			 CEILING(SUM(L.PaymentAmount*C.Percentage))      AS CeilingPaymentAmount			 
			 
	INTO     userTransaction.dbo.sal#SESSION.thisprocess#SettleEntitlement		
	 
	FROM     EmployeeSalary H, 
	         EmployeeSalaryLine L,
			 userTransaction.dbo.sal#SESSION.thisprocess#SettleEntitlementCorrection C,
			 Ref_PayrollItem I
			 
	WHERE    H.SalarySchedule       = L.SalarySchedule
	  AND    H.PersonNo             = L.PersonNo 
	  AND    H.PayrollStart         = L.PayrollStart 
	  AND    H.PayrollCalcNo        = L.PayrollCalcNo
	  
	  AND    L.SalarySchedule       = C.SalarySchedule
	  AND    L.PersonNo             = C.PersonNo 
	  AND    L.PayrollStart         = C.PayrollStart 
	  AND    L.PayrollCalcNo        = C.PayrollCalcNo
	  AND    L.PayrollTransactionId = C.PayrollTransactionId
	  
	  AND    H.SalarySchedule       = '#Form.Schedule#'
	  
	  <cfif processmodality eq "PersonalForce" or processmodality eq "WorkflowFinal"> 
	  		
		AND     H.PersonNo     = '#Form.PersonNo#'
		AND     H.PayrollStart >= #DEFF#  <!--- pass this field value --->
		
	  <cfelse> 
		 
	    AND      H.PayrollStart >= ( SELECT TOP 1 EntitlementEffective
	                            FROM  userTransaction.dbo.sal#SESSION.thisprocess#Payroll
								WHERE PersonNo = H.PersonNo) 
							
								
		AND      H.PersonNo IN (SELECT PersonNo 
		                         FROM   #staffbase# X 
								 WHERE  X.PersonNo = H.PersonNo)  	  
								 
	  </cfif>			
	  				 
								 
	  <!--- in order to define the amount to be settled we compare the cumulative entitlements until the last closing with the amounts settled, the
	  difference is the amount to be settled. Before we compare this with the SALSTR date, which was fine, but gave strange results in case
	  of overtime which did not align well with the settlements causing just plus and minus. Then i decided to compare this 
	  accross the board assuming that if things changes it was changed in the month that is being recalculated, which is a valid assumption.
	  However, in the case an amount is picked up for settlement which realy should have been settled before, the SOP is as follows
	  
	  set back SALSTR in the condition below
	  run the calculation starting the correct month
	  edit in datafix the settlementdate to the correct payment date in settlementline
	  and revert to compUntilDate
	  
	  --->	
	  
	  <cfif settlementstatus eq "Final">	
	  			 						 							 
	  
	  AND    H.PayrollStart <= #SALSTR#   <!--- #compUntilDate# #SALSTR# --->	
	  
	  <cfelse>
	  
	  <!--- we exclude considering entitlements for items that are only to be paid in the final for the current month --->
	  
	   AND   (
	   			(H.PayrollStart = #compUntilDate# AND I.AllowSplit != 2)  <!--- was : #SALSTR# --->
	            	          OR  
				(H.PayrollStart < #compUntilDate#)  		
				 
			  )	 
	  
	  </cfif>
	  	  
	  		
	  AND    H.Mission         = '#Form.Mission#'
	  AND    L.PayrollItem     = I.PayrollItem
	  
	  <cfif settlementMode eq "regular">
	  AND    (I.SettlementMonth = '0' 
	             OR I.SettlementMonth LIKE '%|#month(SALSTR)#|%') 				 
	  <cfelse>
	  AND    ExpirationPayment = '1'
	  </cfif>		 
	  
	  AND    I.Settlement   = 1
	  <!--- this entitlement is not blocked --->
	  AND    L.PaymentBlock = 0
	  					
	  	  
	GROUP BY H.PersonNo, 
	         L.PayrollItem,
			 L.Source,
	         I.AllowSplit, 
		     H.PaymentCurrency,
		     I.settlement,
		     I.SettlementMonth  	
						 			 		 
</cfquery>


<!--- ----------------------------------------------------------------------------------------- --->
<!--- added a provision to catch removed / vanished entitlement but with existing settlements
     like we had in STL for 10525 for A9                                                        --->
<!--- ----------------------------------------------------------------------------------------- --->

<cfquery name="Complement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	
	INSERT INTO userTransaction.dbo.sal#SESSION.thisprocess#SettleEntitlement
	            (PersonNo,
				 PayrollItem, 
				 Source, 
				 AllowSplit, 
				 PaymentCurrency, 
				 Settlement, 
				 SettlementMonth, 
				 CalculatedAmount,
				 PaymentAmount,CeilingCalculatedAmount,CeilingPaymentAmount)	
	
	SELECT       S.PersonNo, 
	             S.PayrollItem, 
				 S.Source, 
				 R.AllowSplit, 
				 S.Currency, 
				 R.Settlement, 
				 R.SettlementMonth,0,0,0,0
				 
	FROM         EmployeeSettlementLine AS S INNER JOIN Ref_PayrollItem AS R ON S.PayrollItem = R.PayrollItem
	
	WHERE        S.PaymentDate <= (SELECT   MAX(PayrollStart) AS Expr1
	                               FROM     EmployeeSalaryLine
	                               WHERE    PersonNo = S.PersonNo) 
								   
    AND          NOT EXISTS (SELECT   'X' 
	                         FROM     EmployeeSalaryLine AS L
	                         WHERE    PersonNo    = S.PersonNo 
							 AND      PayrollItem = S.PayrollItem 
							 AND      Source      = S.Source)
							 
	AND          S.PersonNo IN (SELECT PersonNo 
		                        FROM   #staffbase# X 
							    WHERE  X.PersonNo = S.PersonNo)  						 
							 
	GROUP BY     S.PersonNo, 
	             S.Source, 
				 S.PayrollItem, 
				 S.Currency, 
				 R.AllowSplit, 
				 R.SettlementMonth, 
				 R.Settlement
				 
	HAVING       abs(SUM(S.DocumentAmount)) > 0.01	
	
</cfquery>


<!--- not sure what it was used for --->

<cfquery name="qCeiling1" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE   userTransaction.dbo.sal#SESSION.thisprocess#SettleEntitlement
	SET      PaymentAmount = CeilingPaymentAmount
	WHERE    AllowSplit = '2'
	AND      ABS(PaymentAmount-CeilingPaymentAmount) <= 0.05
</cfquery>	

<cfquery name="qCeiling2" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE   userTransaction.dbo.sal#SESSION.thisprocess#SettleEntitlement
	SET      CalculatedAmount = CeilingCalculatedAmount
	WHERE    AllowSplit = '2'
	AND      ABS(CalculatedAmount-CeilingCalculatedAmount) <= 0.05
</cfquery>
	
<cfquery name="SettlementPrior" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT   PersonNo, 
	         PayrollItem,
			 Source,
			 Currency, 
			 SUM(Amount)        AS Calculation,
			 SUM(PaymentAmount) AS Payment
			 
	INTO     userTransaction.dbo.sal#SESSION.thisprocess#Settled			 
	
	FROM     EmployeeSettlementLine L
	WHERE    SalarySchedule = '#Form.schedule#'	 
	AND      Mission        = '#Form.Mission#'	
	
	<cfif processmodality neq "InCycleBatch"> 			
	   AND   PersonNo = '#Form.PersonNo#'
	<cfelse>
	   AND   PersonNo NOT IN (#preservesingleQuotes(selper)#)
    </cfif>		 
	
	<!--- -------------------------------------------------------------------------------------- --->
	<!--- 24/5/2018 we ONLY compare for the period since this person started his continuous work --->
	
	<cfif processmodality eq "PersonalForce" or processmodality eq "WorkflowFinal"> 		
		
	AND     (
	
			 PaymentDate >= #DEFF#							   			   
							   
			)	
	
	<cfelse>
	
	AND     (
	
			 (PaymentDate >= ( SELECT TOP 1 EntitlementEffective
	                           FROM  userTransaction.dbo.sal#SESSION.thisprocess#Payroll
							   WHERE PersonNo = L.PersonNo) 
							   
			   AND PaymentStatus = '0' )
							   
			OR
			   
			   <!--- 21/3/2019 added provision for re-contracted staff to not compare off cycle payments which are
			    being processed usually into the next month and might mix with the new contract being issued,
			    Attention : I think we better take the field payroll end here instead of PaymentDate  --->
			   
			 (PaymentDate > (  SELECT TOP 1 EntitlementEffective + 31
	                           FROM  userTransaction.dbo.sal#SESSION.thisprocess#Payroll
							   WHERE PersonNo = L.PersonNo) 
							   
			   AND PaymentStatus = '1' )  				   
							   
			)	
			
	</cfif>					   
							   
	AND      PayrollStart <= #SALSTR#	<!---  <= #compUntilDate# before was <= #SALSTR#	--->		
	
	GROUP BY PersonNo, PayrollItem, Source, Currency 	
	
</cfquery>

<!--- compare entitlement with already settled to determine additional payments --->

<cfquery name="CombineCumEntitlement_CumSettlement" 
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  E.PersonNo, 
	        E.PayrollItem, 
			E.Source,
	     	E.AllowSplit, 
	     	E.Settlement,
			E.SettlementMonth,
			E.PaymentCurrency, 
			E.CalculatedAmount, 
			E.PaymentAmount, 
			P.Calculation, 
			CONVERT(float, 0) as DiffCalc,
			P.Payment, 
			CONVERT(float, 0) as DiffPay
			
	INTO    dbo.sal#SESSION.thisprocess#SettledDiff
	
	FROM    dbo.sal#SESSION.thisprocess#SettleEntitlement E LEFT OUTER JOIN 
	        dbo.sal#SESSION.thisprocess#Settled P ON E.PersonNo         = P.PersonNo
     		    	                              AND E.PayrollItem     = P.PayrollItem 
												  AND E.Source          = P.Source 
		    	    					          AND E.PaymentCurrency = P.Currency	
												  
</cfquery>


<CF_DropTable dbName="AppsQuery" tblName="sal#SESSION.thisprocess#SettleEntitlement">	
<CF_DropTable dbName="AppsQuery" tblName="sal#SESSION.thisprocess#Settled">	

<cfquery name="Reset1" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE   userTransaction.dbo.sal#SESSION.thisprocess#SettledDiff			 
	SET      Calculation = 0
	WHERE    Calculation is NULL
	
	UPDATE   userTransaction.dbo.sal#SESSION.thisprocess#SettledDiff		 
	SET      Payment = 0
	WHERE    Payment is NULL
	
	UPDATE   userTransaction.dbo.sal#SESSION.thisprocess#SettledDiff			 
	SET      DiffCalc = round(CalculatedAmount - Calculation,2),
	         DiffPay  = round(PaymentAmount - Payment,2)
</cfquery>

<!--- now record new settlements for IN-cycle processing 
      only if person is INDEED assigned in the period of the designated settlement date --->

<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#Payable">	


<cfquery name="Payable" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   DISTINCT PA.PersonNo
	INTO     userTransaction.dbo.sal#SESSION.thisprocess#Payable
	FROM     PersonAssignment PA, 
             Position P, 
			 Organization.dbo.Organization Org
    WHERE    Org.Mission   IN (#preservesingleQuotes(assmission)#) 
	AND      Org.OrgUnit       = P.OrgUnitOperational
	AND      PA.PositionNo     = P.PositionNo
	AND      PA.AssignmentStatus IN ('0','1')
	AND      PA.DateEffective  <= '#dateformat(Period.PayrollEnd,client.dateSQL)#' 
	AND      PA.DateExpiration >= '#dateformat(Period.PayrollStart,client.dateSQL)#'  
	-- AND      PA.AssignmentClass = 'Regular'
	AND      PA.AssignmentType  = 'Actual'
	<cfif thisSchedule.IncumbencyZero eq "0">
	AND      PA.Incumbency > '0'
	</cfif>
	<cfif processmodality neq "InCycleBatch"> 			
	   AND   PersonNo = '#Form.PersonNo#'
	<cfelse>
	   AND   PersonNo NOT IN (#preservesingleQuotes(selper)#)
    </cfif>		
	
</cfquery>

<!--- define if we only settle people that have somesort of entitlement for this schedule in the month
or if we also settle people that  don't have this month entitlement but might have
a correction to be settled, like a promotion to other schedule to correct over settlement in the past --->

<cfquery name="CatchUpPayment" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT DISTINCT PersonNo 
	INTO   userTransaction.dbo.sal#SESSION.thisprocess#CatchUp	
	FROM   Payroll.dbo.EmployeeSalary Sal, Payroll.dbo.SalarySchedule Sch
    WHERE  Sal.SalarySchedule = Sch.SalarySchedule								   
	AND    (PayrollStart >= #SALSTR# AND PayrollEnd <= #SALEND#)
	AND    Sal.SalarySchedule = '#Form.schedule#'
	AND    Sch.SettleOtherSchedules = 0
	
	 <cfif Form.PersonNo neq "">
	   AND   PersonNo = '#Form.PersonNo#'
	 <cfelse>
	   AND   PersonNo NOT IN (#preservesingleQuotes(selper)#)
     </cfif>	
	 	 
    UNION
	
    SELECT DISTINCT PersonNo 
    FROM   Payroll.dbo.EmployeeSalary Sal, Payroll.dbo.SalarySchedule Sch
    WHERE  Sal.SalarySchedule = Sch.SalarySchedule								   
    AND    (PayrollStart >= #SALSTR# AND PayrollEnd <= #SALEND#)
    AND    Sch.SettleOtherSchedules = 1		
	
	 <cfif Form.PersonNo neq "">
	   AND   PersonNo = '#Form.PersonNo#'
	 <cfelse>
	   AND   PersonNo NOT IN (#preservesingleQuotes(selper)#)
     </cfif>		
						 
 </cfquery> 
  
 <cfinclude template="CalculationProcess_SettlementApply.cfm">					
