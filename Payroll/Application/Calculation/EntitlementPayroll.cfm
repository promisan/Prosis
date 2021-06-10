
<!--- Entitlement

	I.    Verify entitlement data that is associated to a contract
	II.   Generate a data set of active entitlements incl dependents for rates/percentages 
		  for each contract period
	III.  Define correct No of days
	IV.   Calculated the amount
	V.    Upload data
	
--->

<!--- added 2/3/2011 : reset person entitlement that are associated 
  to cancelled contract lines --->

<cfquery name="ResetContractEntitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE   PersonEntitlement
SET      Status = '9'
FROM     PersonEntitlement S
WHERE    ContractId IN ( SELECT  ContractId
		                 FROM    Employee.dbo.PersonContract
				         WHERE   Contractid = S.Contractid
                         AND     ActionStatus = '9' ) 
AND      Status <> '9'
</cfquery>


<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#Entitlements">	

<!--- Hanno 31/1/2018 entitlements are obtained for each of the legs, and then adjusted for the days/slwop, 
it is pretty unlikely days would have to be adjusted in that case, but if it does
it is well possible that we need to embed the code as we do for the legs to calculate
the currect number of days / SLWOP and suspect, SO WE KEEP TUNED FOR THIS TO HAPPEN --->


<cfquery name="Entitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

<!--- implicit related entitlements --->

SELECT     newid() as RecordId,
           P.PersonNo, 
           '00000000-0000-0000-0000-000000000000' as DependentId,
		   P.ContractId as EntitlementId, 
		   P.DateEffective, 
		   P.DateExpiration, 
		   P.DateEffective as EntitlementDate, 
		   '#Form.Schedule#' as SalarySchedule, 		 
		   'Percentage'      as EntitlementClass, 
		   'Contract'        as SalaryTrigger, 
		   S.TriggerDependent,
		   S.PayrollItem, 
		   S.Period, 
		   ' ' as Currency, 
		   0 as Amount, 
           ' ' as DocumentReference,
		   '2' as Status,
		   
		   CONVERT(float, 0) as EntitlementDays, 
		   '0' as EntitlementDaysRevised, 
		   '0' as EntitlementDaysCorrectionPointer,
		   CONVERT(float, 0)  as EntitlementLWOP,
		   CONVERT(float, 0)  as EntitlementSuspend,
		   P.PayrollSickLeave as EntitlementSickLeave,
			
		   P.Line,
		   
		   P.ServiceLocation,
		   P.ContractLevel,    
		   P.ContractStep,
		   
		   <!--- SPA level --->
		   P.ContractScheduleSPA,    
		   P.ContractLocationSPA,		
		   P.ContractLevelSPA,    
		   P.ContractStepSPA,		 
		   
		   P.EnforceFinalPay,		   
		   P.ContractTime,
		   P.DateEffective  AS ContractEffective, 
		   P.DateExpiration AS ContractExpiration,
		   P.EntitlementPointer,
		   P.LeaveId,
		   P.EntitlementSubsidyPointer,
		   P.SalaryGroup,
		   P.EntitlementGroup,	
		   S.SalaryDays as EntitlementSalaryDays, <!--- setting to apply the days ---> 		  
		   P.WorkDays, 
		   P.PayrollDays, 
		   P.PayrollDaysCorrectionPointer,
		   P.PayrollSLWOP,
		   P.PayrollSuspend,
		   P.PayrollSickLeave

INTO 	   userTransaction.dbo.sal#SESSION.thisprocess#Entitlements

<!--- 17/1/2018 adjusted in order to prevent generating duplicates that exist between scales as Ronmell left a difference --->

FROM       SalaryScale AS C 
           INNER JOIN SalaryScaleComponent AS S ON C.ScaleNo = S.ScaleNo
		   INNER JOIN userTransaction.dbo.sal#SESSION.thisprocess#Payroll P ON C.ServiceLocation = P.ContractLocationSPA 

WHERE      S.ScaleNo         IN (#quotedValueList(Scales.ScaleNo)#)

AND        S.SalaryTrigger   = 'Contract' 
AND        S.Period          = 'PERCENT'

UNION 

<!--- explicitly granted entitlements contract assocated which means the contract record leads its usage --->

SELECT     newid() as RecordId,
           E.PersonNo, 
           '00000000-0000-0000-0000-000000000000' as DependentId,
		   E.EntitlementId, 
		   E.DateEffective, 
		   E.DateExpiration, 
		   E.EntitlementDate, 
		   E.SalarySchedule, 
		   E.EntitlementClass,		
		   			
		   E.SalaryTrigger, 
		   (SELECT TOP 1 TriggerDependent
		    FROM   SalaryScaleComponent
			WHERE  ScaleNo       = '#Scale.Scaleno#'
			AND    SalaryTrigger = E.SalaryTrigger) as TriggerDependent,		 
		   E.PayrollItem, 
		   E.Period, 
		   E.Currency, 
		   E.Amount, 
           E.DocumentReference,
		   '2' as Status, <!--- E.Status, --->
		  
		   CONVERT(float, 0) as EntitlementDays, 
		   '0' as EntitlementDaysRevised, 
		   '0' as EntitlementDaysCorrectionPointer,
		   CONVERT(float, 0) as EntitlementLWOP,
		   CONVERT(float, 0) as EntitlementSuspend,
		   P.PayrollSickLeave as EntitlementSickLeave,
		  
		   P.Line,
		   P.ServiceLocation,
		   P.ContractLevel,    
		   P.ContractStep,
		   
		   P.ContractScheduleSPA,    
		   P.ContractLocationSPA,		
		   P.ContractLevelSPA,    
		   P.ContractStepSPA,
		   
		   P.EnforceFinalPay,		   
		   P.ContractTime,
		   P.DateEffective  AS ContractEffective, 
		   P.DateExpiration AS ContractExpiration,
		   P.EntitlementPointer,
		   P.LeaveId,
		   P.EntitlementSubsidyPointer,
		   P.SalaryGroup,
		   E.EntitlementGroup, <!--- P.EntitlementGroup it takes the group record in the entitlement to be matched against the rate --->
		   E.EntitlementSalaryDays, 
		   P.WorkDays, 
		   P.PayrollDays, 
		   P.PayrollDaysCorrectionPointer,
		   P.PayrollSLWOP,
		   P.PayrollSuspend,
		   P.PayrollSickLeave

FROM       PersonEntitlement E, 
           userTransaction.dbo.sal#SESSION.thisprocess#Payroll P 
WHERE      E.PersonNo       = P.PersonNo 
AND        E.SalarySchedule = P.SalarySchedule

<!--- 3/23/2018 we suppress entitlements if the leg is triggered by a leave record like SLWOP and has one or more entitlements disabled (new) --->

AND        E.SalaryTrigger NOT IN (

			SELECT       T.SalaryTrigger
			FROM         Employee.dbo.PersonLeave AS PL INNER JOIN
	                     Employee.dbo.Ref_LeaveTypeClassTrigger AS T ON PL.LeaveType = T.LeaveType AND PL.LeaveTypeClass = T.LeaveTypeClass
			WHERE        PL.LeaveId = P.LeaveId
			
			)		   

<!--- contract related entitlements and the contract line is considered valid --->
AND        EXISTS (SELECT   'X'
                   FROM     Employee.dbo.PersonContract
                   WHERE    ContractId = E.ContractId
				   AND      RecordStatus = '1') 
				   
AND        (E.ContractId is NULL 
				OR 
			E.DateExpiration >= #SALSTR# 
				OR 
			E.DateExpiration IS NULL
			)
AND        E.DateEffective   <= #SALEND#
AND        EntitlementClass IN ('Rate','Percentage','Amount') 
AND        P.PayrollDays != 0


UNION 

<!--- explicitly granted entitlements NOT  contract related and based on explicit entry --->

SELECT     newid() as RecordId,
           E.PersonNo, 
           '00000000-0000-0000-0000-000000000000' as DependentId,
		   E.EntitlementId, 
		   E.DateEffective, 
		   E.DateExpiration, 
		   E.EntitlementDate, 
		   E.SalarySchedule, 
		   E.EntitlementClass,		
		   			
		   E.SalaryTrigger, 
		   (SELECT TOP 1 TriggerDependent
		    FROM   SalaryScaleComponent
			WHERE  ScaleNo       = '#Scale.Scaleno#'
			AND    SalaryTrigger = E.SalaryTrigger) as TriggerDependent,		 
		   E.PayrollItem, 
		   E.Period, 
		   E.Currency, 
		   E.Amount, 
           E.DocumentReference,
		   E.Status,
		   
		   CONVERT(float, 0) as EntitlementDays, 
		   '0' as EntitlementDaysRevised, 
		   '0' as EntitlementDaysCorrectionPointer,
		   CONVERT(float, 0) as EntitlementLWOP,
		   CONVERT(float, 0) as EntitlementSuspend,
		   P.PayrollSickLeave as EntitlementSickLeave,
		  
		   P.Line,
		   P.ServiceLocation,
		   P.ContractLevel,    
		   P.ContractStep,
		   
		   P.ContractScheduleSPA,    
		   P.ContractLocationSPA,		
		   P.ContractLevelSPA,    
		   P.ContractStepSPA,
		   
		   P.EnforceFinalPay,		   
		   P.ContractTime,
		   P.DateEffective  AS ContractEffective, 
		   P.DateExpiration AS ContractExpiration,
		   P.EntitlementPointer,
		   P.LeaveId,	
		   P.EntitlementSubsidyPointer,
		   P.SalaryGroup,
		   E.EntitlementGroup, <!--- P.EntitlementGroup it takes the group record in the entitlement to be matched against the rate --->
		   E.EntitlementSalaryDays, 
		   P.WorkDays, 
		   P.PayrollDays, 
		   P.PayrollDaysCorrectionPointer,
		   P.PayrollSLWOP,
		   P.PayrollSuspend,
		   P.PayrollSickLeave

FROM       PersonEntitlement E, 
           userTransaction.dbo.sal#SESSION.thisprocess#Payroll P 
WHERE      E.PersonNo       = P.PersonNo 
AND        E.SalarySchedule = P.SalarySchedule
<!--- approved and not related to a contract --->
AND        E.RecordStatus = '1'  <!--- Status         = '2' --->
AND        NOT EXISTS (SELECT   'X'
                       FROM     Employee.dbo.PersonContract
                       WHERE    ContractId = E.ContractId
					   AND      RecordStatus = '1') 
AND        (E.DateExpiration >= #SALSTR# OR E.DateExpiration IS NULL) 
AND        E.DateEffective   <= #SALEND#
AND        EntitlementClass IN ('Rate','Percentage','Amount') 
AND        P.PayrollDays != 0

UNION

<!--- ---------------- --->
<!--- ---DEPENDENTS--- --->
<!--- ---------------- --->

SELECT     newid() as RecordId,
           E.PersonNo, 
           E.DependentId,
		   E.EntitlementId, 
		   E.DateEffective, 
		   E.DateExpiration, 
		   P.DateEffective as EntitlementDate, 
		   '#Form.Schedule#', 
		   <!--- we determine the entitlement class based on the logged history --->
		   (SELECT TOP 1 EntitlementClass
		    FROM   SalaryScaleComponent
			WHERE  ScaleNo       = '#Scale.Scaleno#'
			AND    SalaryTrigger = E.SalaryTrigger) as EntitlementClass,		  
		   E.SalaryTrigger, 		   
		   
		   (SELECT TOP 1 TriggerDependent
		    FROM   SalaryScaleComponent
			WHERE  ScaleNo       = '#Scale.Scaleno#'
			AND    SalaryTrigger = E.SalaryTrigger) as TriggerDependent,	
				  
		   '' as PayrollItem, 
		   '' as Period, 
		   '' as Currency, 
		   0 as Amount, 
           '' as DocumentReference, 
		   E.Status,
		   
		   CONVERT(float, 0) as EntitlementDays, 
		   '0' as EntitlementDaysRevised, 
		   '0' as EntitlementDaysCorrectionPointer,
		   CONVERT(float, 0) as EntitlementLWOP,
		   CONVERT(float, 0) as EntitlementSuspend,
		   P.PayrollSickLeave as EntitlementSickLeave,
		 
		   P.Line,
		   P.ServiceLocation,
		   P.ContractLevel,
		   P.ContractStep,
		   
		   <!--- SPA Level --->
		   P.ContractScheduleSPA,    
		   P.ContractLocationSPA,	
		   P.ContractLevelSPA,
		   P.ContractStepSPA,
		   
		   P.EnforceFinalPay,		   
		   P.ContractTime,
		   P.DateEffective  AS ContractEffective, 
		   P.DateExpiration AS ContractExpiration,
		   P.EntitlementPointer,
		   P.LeaveId,
		   P.EntitlementSubsidyPointer,
		   P.SalaryGroup,
		   E.EntitlementGroup,
		   
      		<!--- attention not sure if this is correct was ::: P.EntitlementGroup ::: as I recall we had something 
                        in CICIG to have the highest survive on the level of the Breda : EURO / US insurance rate 
				  but this is not relevant here as 'insurance' and 'housing' is only a counter --->  
				  
		   E.EntitlementSalaryDays, <!--- added to overrule calculations to include SLWOP for example  --->
		   P.WorkDays, 
		   P.PayrollDays, 		   
		   P.PayrollDaysCorrectionPointer,
		   P.PayrollSLWOP,
		   P.PayrollSuspend,
		   P.PayrollSickLeave
		   
FROM       PersonDependentEntitlement E,           
           userTransaction.dbo.sal#SESSION.thisprocess#Payroll P 
		   
WHERE      E.PersonNo = P.PersonNo 
<!---
AND        E.SalarySchedule = P.SalarySchedule
--->
<!--- record is valid --->
AND        E.Status = '2' 
<!--- parent record is valid as well
AND        E.DependentId IN (SELECT DependentId 
                             FROM   Employee.dbo.PersonDependent 
							 WHERE  DependentId = E.DependentId 
							 AND    ActionStatus IN ('1','2'))
--->							 
 AND        E.DependentId IN (SELECT DependentId 
			                  FROM   Employee.dbo.PersonDependent 
					          WHERE  DependentId  = E.DependentId									
							  AND    RecordStatus = '1')	
							  								 
AND        (E.DateExpiration >= #SALSTR# OR E.DateExpiration IS NULL) 
AND        E.DateEffective   <= #SALEND#
<!--- removed 29/3/2017 as it does not filter anything
AND        T.EntitlementClass IN ('Rate','Percentage','Amount')
--->

<!--- ------------------------------------------------------------------ --->
<!--- ------------------------added 8/6/2017---------------------------- --->

AND       EXISTS (SELECT 'X'
		          FROM   SalaryScaleComponent
			      WHERE  ScaleNo       = '#Scale.Scaleno#'
			      AND    SalaryTrigger = E.SalaryTrigger)	

<!--- ------------------------------------------------------------------- --->
<!--- medical percentage and housing are used only for COUNTING ONLY ---- --->

AND       E.SalaryTrigger NOT IN (SELECT SalaryTrigger 
                                  FROM   Ref_PayrollTrigger 
								  WHERE  TriggerGroup IN ('Insurance','Housing'))   
<!--- ------------------------------------------------------------------- 		--->
<!--- in principle any correction should bring -/+ value, but for 0 no poing 	---> 
AND       ABS(P.WorkDays) >0
	
						 
</cfquery>

<!--- now we do an effort to define the entitlement days properly based on the period of the leg that triggers them 
Comments this can be subject for adjustment as in the werner rule although not so likely to happen
 --->

<cfquery name="InitDays" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
	SET    EntitlementDays    = 0, 
	       EntitlementLWOP    = 0,
		   EntitlementSuspend = 0
</cfquery>	

<cfquery name="Entitlement1" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
	SET    DateEffective = ContractEffective
	WHERE  ContractEffective > DateEffective  	
</cfquery>

<cfquery name="Entitlement2" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
	SET    DateExpiration = ContractExpiration
	WHERE  ContractExpiration < DateExpiration 
	    OR DateExpiration is NULL
</cfquery>

<cfquery name="Entitlement2" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
	WHERE  DateExpiration < DateEffective	
</cfquery>

<!--- ---------------------------------------------------------------------- --->
<!--- we populate records that clearly map to the leg ---------------------- --->
<!--- ---------------------------------------------------------------------- --->

<cfquery name="InheritPopulationFromTheLeg" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
	SET    EntitlementDays             = PayrollDays,
	       EntitlementLWOP             = PayrollSLWOP,
		   EntitlementSuspend          = PayrollSuspend
	WHERE  DateEffective               = ContractEffective
	AND    DateExpiration              = ContractExpiration			
</cfquery>	

<!--- Kind of exceptional siation where the entitlement start or end before the end of the defined payroll --->
	
<!--- 2. now focus on the people with have 1 (one) record 

	 calculation of payroll days 
		
	1. if an entitlement starts later than the effective date of the payroll reocrd, the days are limited
	2. if an entitlement ends before the expiration date of the payroll record, the days are limited. --->
		
<!--- A. update people that start on the firstday BUT end during the month --->
	
<cfquery name="Select" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	<!--- this query was changed as we could have a situation that an entitlement would start during the month and then we needed to count
	 the days but this counting is different from the leg day counting and thus we had an issue before as we would apply leg days to the entitlenent
	 if it would coincide awhich is different from working days in such scenario as it is needed.
	 
	 all driven by SLWOP scenario's which split the period of entitlements as some entitlements are suppressed 
	 and then have to be counted differently
	 
	 The query on line 510 was stalled changed for the below, we loop through it as the select loop to apply correct counting of days --->
	
	SELECT   *,  (SELECT   SUM(PayrollDays) 
			      FROM     userTransaction.dbo.sal#SESSION.thisprocess#Payroll 
			      WHERE    PersonNo = E.PersonNo) AS PayrollDaysInLeg
				  
	FROM     userTransaction.dbo.sal#SESSION.thisprocess#Entitlements E
	WHERE    EXISTS ( SELECT 'X'
	                  FROM   
	
							(SELECT  PersonNo, 
									 DependentId,	
							         SalaryTrigger, 
									 SalarySchedule, 									 
								
									 						 
									 MIN(DateEffective)  AS DateEffective, 
									 MAX(DateExpiration) AS DateExpiration,
									 
			                         (SELECT   MIN(ContractEffective) AS Expr1
			                          FROM     userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
			                          WHERE    PersonNo = P.PersonNo
									  AND      DependentId = P.DependentId 
									  AND      PayrollDays > 0) AS ContractEffective, <!--- to pre-empt empty legs like Guillou for the last 2 days of his SLWOP --->
									  
			                         (SELECT   MAX(ContractExpiration) AS Expr1
			                          FROM     userTransaction.dbo.sal#SESSION.thisprocess#Entitlements 
			                          WHERE    PersonNo = P.PersonNo
									  AND      DependentId = P.DependentId 
									  AND      PayrollDays > 0) AS ContractExpiration
									  
							FROM     userTransaction.dbo.sal#SESSION.thisprocess#Entitlements AS P
							GROUP BY PersonNo, DependentId, SalaryTrigger, SalarySchedule 
							) as B
				
					WHERE  E.PersonNo       = B.PersonNo
					AND    E.DependentId    = B.DependentId
					AND    E.SalarySchedule = B.SalarySchedule
					AND    E.SalaryTrigger  = B.SalaryTrigger
					<!--- we compare based on the full month here in order to check on an entitlement --->
	    	        AND    (B.DateEffective > B.ContractEffective OR B.DateExpiration < B.ContractExpiration OR EntitlementDays = '0')	
				
				    )		
	ORDER BY PersonNo, DependentId, SalaryTrigger, SalarySchedule,  DateEffective DESC 	
					
						 	   								
</cfquery>	

<!--- prior old query discontinued as we have ending or starting entitleemnts that coincided with the leg 12/9/2018 and that did not work well

<cfquery name="Select" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
	WHERE    DateEffective > ContractEffective OR DateExpiration < ContractExpiration	
	ORDER BY PersonNo, DateEffective, EntitlementId		
</cfquery>	

--->

	
<cfloop query="select">

	<cfif DateEffective eq ContractEffective>	
		
		<!--- Define the workdays until the expiration of the entitlements--->

		<cfquery name="Days" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    <cfif Schedule.SalaryBasePeriodDays eq "21.75">
			  SELECT  SUM(workday) as total
			<cfelse>
			  SELECT  Count(CalendarDate) as total
			</cfif>			
			FROM   userTransaction.dbo.sal#SESSION.thisprocess#Dates
			WHERE  CalendarDate <= '#DateExpiration#'
			<!--- base for calculation which is the leg --->
			AND    CalendarDate >= '#ContractEffective#'  AND CalendarDate <= '#ContractExpiration#'  
	    </cfquery>	
		
		<cfif Days.total gte PayrollDaysInLeg and PayrollDays eq Form.SalaryDays>
			<cfset t = PayrollDays>
		<cfelse>		
			<cfset t = Days.total>
		</cfif>				
								
	<cfelseif DateExpiration lte ContractExpiration>
		
		<!--- Define the workdays until the expiration of the entitlements--->
				
		<cfquery name="Days" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  SUM(workday) as total 
			FROM    userTransaction.dbo.sal#SESSION.thisprocess#Dates 
			WHERE   CalendarDate >= '#DateEffective#' 
			AND     CalendarDate <= '#dateExpiration#'
			<!--- base for calculation --->
			AND     CalendarDate >= '#ContractEffective#' 
			AND     CalendarDate <= '#ContractExpiration#'			
	    </cfquery>	
		
		<!--- 
			 ALERT Tuning 19/07/2011 by Hanno for Karin in case of CICIG
			 
			 First tuning for net dependent payroll adjustment which was split over different dependent
			 and which total can not exceed 21.75 combined in that case as it is calculated over the payroll
			 			 
			 1. check if the entitlement is for a dependent triggered by Dependent
			 2. Define the already calculated total for the employee and deduct it from
			 the maximum 			 
		 
		 --->		 
		
	<cfelse>	
		
	<!--- nada --->		 
											
	</cfif>			
	
	<cfquery name="NetCheck" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	* 
			FROM    Payroll.dbo.Ref_PayrollTrigger
			WHERE   SalaryTrigger = '#SalaryTrigger#'
	</cfquery>
		
		<!---
		<cfif NetCheck.TriggerGroup eq "Dependent">
		
		I am not sure if we need this condition I think it applies always
		
		Ronmell: true, always applies.at least should.
					
		---> 
									
		<cfif NetCheck.TriggerCondition eq "Dependent">
											
			<cfquery name="Prior" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT  sum(EntitlementDays) as Total
					FROM    userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
					WHERE   PersonNo      = '#PersonNo#'      
					AND     DependentId   = '#DependentId#'
					AND     SalaryTrigger = '#SalaryTrigger#' 
					AND     RecordId     != '#Recordid#' 				
			</cfquery>			
			
			<cfif Prior.Total eq "">
			    <cfset maxdays = PayrollDaysInLeg>
			<cfelse>
 				<cfset maxdays = PayrollDaysInLeg - Prior.Total>
			</cfif>	
										 
			<cfif Days.total gte maxdays>
				<cfset t = maxdays>
			<cfelse>
				<cfset t = Days.total>
			</cfif>
						 
		<cfelse>	
		
			<cfif Days.total gte PayrollDays>
				<cfset t = PayrollDays>
			<cfelse>
				<cfset t = Days.total>
			</cfif> 		
		
		</cfif>		
			
	<cfquery name="Update" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
		SET    EntitlementDays = '#t#',
			   EntitlementDaysRevised = '1'  <!--- indicate the leg days have changed --->
		WHERE  RecordId        = '#recordid#'			  
		AND    EntitlementDays <> '#t#'					
	</cfquery>		
	
										
	<!--- ---------------------------- --->
	<!--- SLWOP and suspend correction --->
	<!--- ---------------------------- --->
	
	<cfif t gt "0">  <!--- 28/4 in case no entitlement days defined there is no purpoise in defining LWOP either --->
		
		<cfloop index="itm" list="LWOP,SUSPEND">
					
			<cfquery name="ProcessList" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM    PersonLeave PC 
			            INNER JOIN Ref_LeaveTypeClass C ON PC.LeaveType = C.LeaveType  AND PC.LeaveTypeClass = C.Code		
				WHERE   PC.LeaveType IN (SELECT LeaveType 
				                         FROM   Ref_LeaveType 
									     WHERE  LeaveParent = '#itm#')
				AND     PC.Status = '2'						 
				-- AND     PC.Status IN ('1','2')
				AND     PC.PersonNo              = '#PersonNo#'			
				AND     PC.DateEffective        <= '#DateExpiration#' 
				AND     PC.DateExpiration       >= '#DateEffective#'
				<!--- only if leave is not compensation by other balances it goes to payroll --->
				AND     CompensationLeaveType IS NULL		
			</cfquery>	
					
			<cfset recid = recordid>
			
			<cfloop query="ProcessList">			
			
				<cfif Select.DateEffective gt DateEffective>
				       <cfset st = Select.DateEffective>
				<cfelse>
				       <cfset st = DateEffective>
				</cfif>	
				
				<cfif Select.DateExpiration lt DateExpiration>
				       <cfset ed = Select.DateExpiration>
				<cfelse>
				       <cfset ed = DateExpiration>
				</cfif>
				
				<!--- define the working days to be counted as SLWOP in this period --->
				
				<cfquery name="Days" 
					   datasource="AppsQuery" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						SELECT  sum(workday) as total
						FROM    userTransaction.dbo.sal#SESSION.thisprocess#Dates
						WHERE   CalendarDate >= '#dateformat(st,client.dateSQL)#'
						AND     CalendarDate <= '#dateformat(ed,client.dateSQL)#'					
				</cfquery>	
					
				<cfif days.total gte "1">		
				
					 <!--- correction for percentage --->	
				
					 <cfquery name="Percent" 
					   datasource="AppsEmployee" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
							SELECT  *
							FROM    Ref_LeaveTypeClass
							WHERE   LeaveType = '#leavetype#'
							AND     Code = '#leavetypeclass#'				
					 </cfquery>	
					   
					 <cfif percent.recordcount eq "1">			   
					     <cfset tot = days.total*(percent.CompensationPointer/100)>			   
					 <cfelse>			   	
						 <cfset tot = days.total>				  
					 </cfif>						 
					 					
					<cfquery name="Days" 
						datasource="AppsQuery" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
						SET     Entitlement#itm#           = #tot#,
						        EntitlementDaysRevised     = '1' 
						WHERE   RecordId         = '#recid#'	
						AND     Entitlement#itm# <> '#tot#'											
					</cfquery>	
					
				</cfif>
						
			</cfloop>
			
		</cfloop>	
		
	</cfif>		

</cfloop>	


<!--- 16/03/2018 : if a person which has several contract legs (Chasna case) because of
	a result of the Suspend/LWOP action a correction on the workdays is triggered for
	the entitlements that do no longer appear in the suspend/LWOP period. The rationale is that those entitlements
	are	considered to be ending, and this the counting is just on working days over that period
	like 14 days instead of 15.75 days in case of a full month to the complementing part 
	likely only relevant for 21.75 scenario Hanno
 --->
 
  
<cfloop index="itm" list="LWOP,Suspend">
	
	<cfquery name="OverwriteEntitlementDays" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			UPDATE   userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
			SET      EntitlementDays                     = EntitlementDays - Entitlement#itm#, 
			         Entitlement#itm#                    = 0,
					 EntitlementDaysCorrectionPointer    = '1'
					 
			FROM     userTransaction.dbo.sal#SESSION.thisprocess#Entitlements  P
			WHERE    PayrollDaysCorrectionPointer        = '1' <!--- this indicates a correction in case of multiple legs --->		
						
			AND      EntitlementDaysRevised              = '0' 
						
			 <!--- only if LWOP and SLWOP have a value of course --->	
			AND      Entitlement#itm# <> 0		
						
			<!--- --------------------------------- IMPORTANT CONDITION----------------------------------------------- --->
			<!--- entitlement does not exist in the leg of the lwop/suspend itself, which means we 
			 correct the working days from the month's holistic view                                                   --->
			<!--- --------------------------------- IMPORTANT CONDITION----------------------------------------------- --->
			
			AND      NOT EXISTS
		    	       (SELECT  'X' AS Expr1
		        	    FROM   userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
		            	WHERE  PersonNo       = P.PersonNo 
						AND    Line          <> P.Line 
					 	AND    SalaryTrigger  = P.SalaryTrigger 						
					 	AND    Entitlement#itm# > 0) 
			     
			AND      SalaryTrigger is not NULL 
						  			
			<!--- but we make sure this HAS payroll legs with a fuller period period ---> 		
				
			AND      EXISTS
		    	       (SELECT  'X' AS Expr1
		        	    FROM   userTransaction.dbo.sal#SESSION.thisprocess#Payroll
		            	WHERE  PersonNo       = P.PersonNo 
						AND    Line          <> P.Line 							
						AND  <cfif itm eq "LWOP">PayrollSLWOP<cfelse>PayrollSuspend</cfif> = PayrollDays) 			
			
	</cfquery>	
	
</cfloop>	


<!--- 12/10/2017 : now we have all relevant days defined
contractual days, suspended days and lwop days 
we can overrule salaryday pointer set on the entitlement record ITSELF, to revert --->

<cfquery name="CorrectionHannoJan" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
	SET     EntitlementDaysCorrectionPointer = '1'
	WHERE   EntitlementDaysRevised           = '1' 
	AND     (EntitlementLWOP <> '0' or EntitlementSUSPEND <> '')
</cfquery>		

<cfquery name="OverwriteLWOPorSUSPEND" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
	SET     EntitlementLWOP         = 0,
			EntitlementSUSPEND      = 0
	WHERE   EntitlementSalaryDays   = '1'	
</cfquery>	
	
<!--- -------------------------------------------------------------------- --->
<!--- ------  CUSTOM correction on the PF SLWOP 20 for STL to count more - --->
<!--- ------- special calculation for PF only in of suspend days --------- --->
	
		 <cfquery name="DayCorrection" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    PersonNo, SUM(PayrollDays - WorkDays) AS CorrectionDays
			FROM      userTransaction.dbo.sal#SESSION.thisprocess#Payroll
			WHERE     PersonNo IN (SELECT    PersonNo
		                           FROM      userTransaction.dbo.sal#SESSION.thisprocess#Payroll
		                           WHERE     PayrollSuspend > 0)
			GROUP BY  PersonNo
			
		</cfquery>
		
		<cfloop query="DayCorrection">
		
			<cfif correctionDays neq "0">
			
				<cfquery name="Update" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE    userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
					SET		  EntitlementDays = EntitlementDays + '#CorrectionDays#'
					WHERE     PersonNo                         = '#PersonNo#'
					AND       EntitlementDaysCorrectionPointer = '1' <!--- important condition do not remove as it relates to the code above --->
					AND       SalaryTrigger = 'PensionContr' <!--- special calculation for PF only for suspend days --->
					AND       Line = (SELECT MIN(Line) 
					                  FROM   userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
									  WHERE  PersonNo = '#PersonNo#'
									  AND    SalaryTrigger = 'PensionContr')
				</cfquery>
			
			</cfif>
			   
		</cfloop>	
		
<!--- ------------------------------------------------------------- --->	
<!--- ------------------- END CUSTOM correction ------------------- --->	
<!--- ------------------------------------------------------------- --->		 
	
<!--- now we correct the entitlementpoint for the entitlement based on the value 
  set for this trigger to be considered as pointer 6/8/2017 adjustement (STL) --->	  
  	  	  
<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#PointerTrigger">	
  	  	  
 <cfquery name="Dependents" 
	 datasource="AppsPayroll" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
     
	 SELECT   P.PersonNo,
	          P.DateEffective, P.DateExpiration,
			  D.SalaryTrigger,
			  
			   COUNT(DISTINCT DependentId) as CountDependent,
			  
			  <!--- in case of overlapping we assign the group used but with the highest priority --->
			  
			  ISNULL((SELECT  TOP 1 PD.EntitlementGroup
			  FROM     PersonDependentEntitlement PD INNER JOIN
                       SalaryScaleComponent RG ON PD.SalaryTrigger = RG.SalaryTrigger AND PD.EntitlementGroup = RG.EntitlementGroup
			  WHERE    PD.PersonNo         = P.PersonNo
			  AND      PD.DateEffective   <= #SALEND# 
			  AND      (PD.DateExpiration >= #SALSTR# or PD.DateExpiration is NULL)
			  AND      PD.SalaryTrigger   = D.SalaryTrigger				 
	 		  AND      Status             = '2'
			  <!--- only valid active dependents to be removed 
			  AND      PD.DependentId IN (SELECT DependentId 
				                          FROM   Employee.dbo.PersonDependent 
								          WHERE  PersonNo     = P.PersonNo 
										  AND    DependentId  = PD.DependentId									
										  AND    ActionStatus IN ('1','2'))
			  --->							  
		 	 AND      PD.DependentId IN (SELECT DependentId 
				                          FROM   Employee.dbo.PersonDependent 
								          WHERE  PersonNo     = P.PersonNo 
										  AND    DependentId  = PD.DependentId									
										  AND    RecordStatus = '1')							  
										  
			  ORDER BY RG.EntitlementPriority DESC ),'Standard') AS EntitlementGroup,		
			  
			  <!--- we obtain the number of dependents that qualify for subsidy --->	
			  
			 (SELECT   COUNT(DISTINCT DependentId)				  
			  FROM     PersonDependentEntitlement PD 
			  WHERE    PD.PersonNo         = P.PersonNo
			  AND      PD.SalaryTrigger   = D.SalaryTrigger		
			  AND      PD.DateEffective   <=  P.DateExpiration /*#SALEND# CHANGED BY RONMELL ON KARIN CHECK for MIP person 9134*/ 
			  AND      (PD.DateExpiration >=  P.DateEffective /*#SALSTR# CHANGED BY RONMELL ON KARIN CHECK for MIP person 9134*/
			  								or PD.DateExpiration is NULL)				  		 
	 		  AND      Status             = '2'
			  
			    AND      PD.DependentId IN (SELECT DependentId 
				                          FROM   Employee.dbo.PersonDependent 
								          WHERE  PersonNo     = P.PersonNo 
										  AND    DependentId  = PD.DependentId									
										  AND    RecordStatus = '1')		
			  
			  AND      EntitlementSubsidy = 1) AS CountSubsidy		
			  
			  
	 INTO     userTransaction.dbo.sal#SESSION.thisprocess#PointerTrigger
	 
	 FROM     PersonDependentEntitlement D 
	          INNER JOIN Ref_PayrollTrigger Tr ON D.SalaryTrigger = Tr.SalaryTrigger 
			  INNER JOIN userTransaction.dbo.sal#SESSION.thisprocess#Payroll P ON D.PersonNo = P.PersonNo 
	
	 <!--- are valid for one or more days during the period of the staff calculation --->		  
     WHERE    D.DateEffective <= P.DateExpiration 		 
	 AND      (D.DateExpiration >= P.DateEffective or D.DateExpiration is NULL)
	 
	 <!--- only valid entitlements, cleared --->
	 AND      Status = '2'
		  
	 AND      D.DependentId IN (SELECT DependentId 
				                FROM   Employee.dbo.PersonDependent 
							    WHERE  PersonNo     = D.PersonNo 
								AND    DependentId  = D.DependentId									
							    AND    RecordStatus = '1')						 						
	 		 
	 GROUP BY P.PersonNo, 
	          P.DateEffective,
			  P.DateExpiration,
			  D.SalaryTrigger			  
	 		 
 </cfquery>
    
 <!--- 13/8/2017 we apply for the persons entitlements file the setting to get a correct dependent 
       entitlement pointer/group to be applied in the following --->
	   
<cfquery name="PointerResetForDependentPointer" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
 
	 UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
	 SET     EntitlementPointer         = 0,		 	
	 		 EntitlementSubsidyPointer  = 0	 
	 WHERE   TriggerDependent is not NULL 
	 AND     TriggerDependent != 'Insurance'  	<!--- Insurance is the default dependent counter ---> 
	 
</cfquery>    
     
<cfquery name="PointerAndGroupCorrection" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
 
	 UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
	 SET     EntitlementPointer         = L.CountDependent,		 	
	 		 EntitlementSubsidyPointer  = L.CountSubsidy,		
			 EntitlementGroup           = L.EntitlementGroup			 
	 FROM    userTransaction.dbo.sal#SESSION.thisprocess#Entitlements P,  
	         userTransaction.dbo.sal#SESSION.thisprocess#PointerTrigger L				 
	 WHERE   P.PersonNo                 = L.PersonNo
	  AND     P.TriggerDependent         = L.SalaryTrigger
	 <!--- Hanno 25/3 I noted that for RS the indicator was not set correctly in case of 2 RS records, like for MR West who had 2 entitlements for Rental subsidy  --->
	 AND     (P.DateEffective            = L.DateEffective  OR P.DateExpiration  = L.DateExpiration)			 
</cfquery>  

