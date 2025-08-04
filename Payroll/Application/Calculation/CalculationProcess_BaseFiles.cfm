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

<!--- preparation of the payroll calculation legs

I.  Create data set of staff on-board with contract period : legs

          correction of the legs to reflect SPA
		  correction of the legs to reflect SLWOP only SLWOP that WILL affect entitlements
		  other consistency corrections
		  
II.	  Determine the day fields per leg (Contract days, SLWOP, SUSPEND etc.)
III.  Create data set with rates to be used
		Percentage corrections
--->

<cfset SESSION.thisprocess = "#Form.Schedule#_#dateformat(SALEND,'YYYYMM')#_#SESSION.acc#">
	
<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#OnBoard">	
<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#Payroll">	
<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#Final">
<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#Pointer">	
<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#Dependent">	
<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#PayrollLine">	
<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#Exchange">	
<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#Scale">	
<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#Percentage">	

<cfinclude template="CalculationProcess_BaseWorkdays.cfm">

<!--- Requirement 1 check staff on board in the period of the requested payroll --->

<!--- ------------------------------------------------------------------------- --->
<!--- select the people that are eligible for the payroll assignment + contract --->
<!--- ------------------------------------------------------------------------- --->

<!--- if a person has several assignments this will return more than one record --->

<cfquery name="thisSchedule" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Payroll.dbo.SalarySchedule
	WHERE  SalarySchedule = '#Form.Schedule#'
</cfquery>

<!--- Enterprise adjustment Charlie : we only pay people that are actually working for the period, but we now enable staff that is working within the enterprise
	to be paid as well, so based on the selected entity we do qualify assignments outside the current entity hereto we 
	qualify all entities that share the same schedule which is calculated 	
--->

<cfquery name="AssignmentEntity" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Payroll.dbo.SalaryScheduleMission
	WHERE  SalarySchedule = '#Form.Schedule#'
</cfquery>

<cfset assmission = quotedvalueList(AssignmentEntity.Mission)>

<cfquery name="StaffOnBoardForPayrollPeriod" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	 SELECT PersonNo,
	        MIN(DateEffective)      as AssignmentEffective,
		    MAX(DateExpiration)     as AssignmentExpiration,
						
			MAX(OrgUnitOperational) as OrgUnit,  <!--- provision only if there are double records, very unlikely --->
			MAX(PositionNo)         as PositionNo
			
	 INTO   userTransaction.dbo.sal#SESSION.thisprocess#OnBoard		
		
	FROM (	   
	
	    SELECT   PA.PersonNo, 
		         PA.DateEffective, 
				 PA.DateExpiration, 
				 P.PositionNo, 
				 P.OrgUnitOperational
						
		FROM     PersonAssignment PA, 
	             Position P, 
				 Organization.dbo.Organization Org
	    WHERE    Org.Mission       IN (#preservesingleQuotes(assmission)#) 
		AND      Org.OrgUnit       = P.OrgUnitOperational
		AND      PA.PositionNo     = P.PositionNo
		AND      PA.AssignmentStatus IN ('0','1')
		AND      PA.DateEffective  <= #SALEND# 
		AND      PA.DateExpiration >= #SALSTR# 
		-- AND      PA.AssignmentClass = 'Regular'
		AND      PA.AssignmentType  = 'Actual'
		
		<cfif thisSchedule.IncumbencyZero eq "0">
		<!--- if a person has a contract and is 0 percent incumbency he will not be paid --->		
		AND      PA.Incumbency > '0'
		</cfif>
		
		<cfif processmodality neq "InCycleBatch">			
		AND      PersonNo = '#Form.PersonNo#'		
		</cfif>	
		<!--- 19/5/2014 adjustment Hanno do not reset entitlement if at person has an action to prevent retitlement correction --->
		AND      PersonNo NOT IN (SELECT PersonNo 
				                  FROM   Employee.dbo.PersonAction 
								  WHERE  Mission       = '#Form.Mission#' 
								  AND    ActionCode    = '4002' 
								  AND    ActionStatus  = '1'
								  AND    DateEffective  <= #SALEND#
								  AND    DateExpiration >= #SALSTR#) 
								  
		) as Sub		
	
	GROUP BY  PersonNo	
									  
</cfquery>

<!--- ----------------------------------- PREPARE legs 1 of 3 ----------------------------------------- --->

<cfquery name="CalculationLegs" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT      PC.Mission,
	           			  				
			    PC.PersonNo,
				
				<!--- we obtain the relevant EOD date for this person and entity for this calculation run from Contract.
				If the person joins (initial appointment) again the SAME month he/she has left as well
				and this month is calculated we determine for each leg the corresponding EOD that applies
				 --->
								
				(SELECT  TOP 1 DateEffective
				 FROM    PersonContract
				 WHERE   PersonNo 	= PC.PersonNo
				 AND     Mission 	= '#Form.Mission#' 
				 
				 AND     ActionCode    IN (SELECT   ActionCode
						                   FROM     Ref_Action
						                   WHERE    ActionSource = 'Contract' 
						 			       AND      ActionInitial = '1') <!--- code 3000 --->
										   
				 <!---	Attention in STL not all people have an action, so sometimes have to include '9' as well 			
				 AND     ContractId IN (SELECT ActionSourceId 
				                        FROM   EmployeeAction 
				                        WHERE  ActionStatus != '9') ---> 							   
										   
				 AND     ActionStatus IN ('1') <!--- active --->						   
								
				 AND     DateEffective <= (SELECT   MIN(PayrollEnd) as Date <!--- will render 30/6/2018 which then will be used to determine the valid EOD date for a person --->
										   FROM     Payroll.dbo.SalarySchedulePeriod
										   WHERE    Mission           = '#Form.Mission#'
										   AND      SalarySchedule    = '#Form.Schedule#'
										   AND      CalculationStatus IN ('0','1','2') 	)
				
								   
				 AND     DateEffective <= PC.DateEffective	
																	   
				 ORDER BY DateEffective DESC ) as EODDateMission,							
				
				(SELECT DateEffective 
				 FROM   Payroll.dbo.SalaryScheduleMission
				 WHERE  SalarySchedule = '#Form.Schedule#'
				 AND    Mission        = '#Form.Mission#') as EntitlementEffective,
				 
			    (SELECT TOP 1 OrgUnit             FROM userTransaction.dbo.sal#SESSION.thisprocess#OnBoard WHERE PersonNo = PC.PersonNo) as OrgUnit,
			    (SELECT TOP 1 PositionNo          FROM userTransaction.dbo.sal#SESSION.thisprocess#OnBoard WHERE PersonNo = PC.PersonNo) as PositionNo,								
				
				0 as PositionParentId,			
				 
				CAST('' as VARCHAR(20))  as PostType,			  
			    CAST('' as VARCHAR(12))  as PostClass,			  
			    CAST('' as VARCHAR(100)) as FunctionDescription,

	            (SELECT MIN(AssignmentEffective)  FROM userTransaction.dbo.sal#SESSION.thisprocess#OnBoard WHERE PersonNo = PC.PersonNo) as AssignmentEffective,	
			    (SELECT MAX(AssignmentExpiration) FROM userTransaction.dbo.sal#SESSION.thisprocess#OnBoard WHERE PersonNo = PC.PersonNo) as AssignmentExpiration,				   
							 
			    PC.ContractId,
			    PC.DateEffective,
			    PC.DateExpiration,
			    PC.ContractType,
			    PC.ContractTime,
			    PC.SalarySchedule,
			    PC.SalaryBasePeriod,
			    PC.ContractLevel,							
			    PC.ContractStep,
				
			    PC.SalarySchedule   as ContractScheduleSPA,
			    PC.ServiceLocation  as ContractLocationSPA,
			    PC.ContractLevel    as ContractLevelSPA,							
			    PC.ContractStep     as ContractStepSPA,
												
			    PC.ServiceLocation,
			    PC.ContractSalaryAmount,
				PC.Remarks,
				PC.StepIncrease,
				PC.StepIncreaseDate,
				PC.AppointmentStatus,
				PC.ContractStatus,
				PC.ActionStatus,
				PC.PersonnelActionNo,
				PC.EnforceFinalPay,
								
			    1 as Line,
			    '#Form.Currency#' as PaymentCurrency,
				99.999     as WorkDays, 
			    99.999     as PayrollDays, 
				0          as PayrollDaysCorrectionPointer,
								
				<!--- correction for complete entitlement correction --->
			    99.999     as PayrollSLWOP,
				
				<!--- correction for limited entitlement correct like payroll only but build annyal payments --->
				99.999     as PayrollSuspend,
				
				<!--- correction for sickleave partial payment correction which is different from SLWOP --->
				99.999     as PayrollSickLeave,
								
			    ContractSalaryAmount as SalaryDayRate,
			    0          as SalaryPointer,  <!--- pointer to apply rate on the level of the leg --->
			    0          as EntitlementPointer, <!--- pointer to apply rate on the level of the entitlement --->
				0          as EntitlementSubsidyPointer,
				
				'00000000-0000-0000-0000-000000000000' as LeaveId, 
				
				PC.ContractId as ContractEntitlement,
				
			    'Standard' as SalaryGroup,
			    'Standard' as EntitlementGroup,
				#now()# as TimeStamp				
			   
	INTO        userTransaction.dbo.sal#SESSION.thisprocess#Payroll  <!--- people that are eligible for the payroll ---> 
	
	FROM        PersonContract PC 
	
	<!--- ---------------------------------------------------------------------------- --->
	<!--- also has a valid assignment in the payroll period or was the selected person --->
	<!--- ---------------------------------------------------------------------------- --->
	
	WHERE       PersonNo IN (SELECT PersonNo 
	                         FROM   userTransaction.dbo.sal#SESSION.thisprocess#OnBoard
					 		 WHERE  PersonNo = PC.PersonNo)	          	 
	  
	  <!--- we allow for multiple schedules in case a person moves in the month from schedule A to B --->
	  
	  AND       SalarySchedule != 'NoPay'
							 
	  AND       PC.DateEffective   <= #SALEND# 
	  AND       (PC.DateExpiration >= #SALSTR# OR PC.DateExpiration IS NULL)						 
	  
	  AND       PC.Mission          = '#Form.Mission#'
	  <!--- AND  PC.ActionStatus = '1' changed 31/01/2018 --->
	  AND       PC.RecordStatus = '1' 
	ORDER BY    PC.PersonNo, 
	            PC.DateEffective											
						
</cfquery>	


<!--- remove legs prior to the EOD date as EOD is the starting point as otherwise if this is in the same month it might
calculate the wrong days and it will start from scratch 

<cfquery name="removeLegPriorEOD" 
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE sal#SESSION.thisprocess#Payroll  	
	WHERE  DateEffective < EODDateMission
</cfquery>	

--->

<cfquery name="setEntitlementDate" 
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  TMP
	SET 	TMP.EntitlementEffective = DATEADD(DAY, -DATEPART(DAY, TMP.EODDateMission) + 1, TMP.EODDateMission)
	FROM 	sal#SESSION.thisprocess#Payroll as TMP 	
	WHERE   TMP.EODDateMission > TMP.EntitlementEffective
</cfquery>	

<cfquery name="setPositionInformation" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  TMP
	SET 	TMP.PositionParentId    =   POS.PositionParentId,
			TMP.PostType			=	POS.PostType,
			TMP.PostClass			= 	POS.PostClass,
			TMP.FunctionDescription	=	POS.FunctionDescription
	FROM 	userTransaction.dbo.sal#SESSION.thisprocess#Payroll as TMP 	INNER JOIN Employee.dbo.Position as POS
			ON POS.PositionNo			= TMP.PositionNo
</cfquery>	

<!--- these are the calculation days used for calculation of amounts for each leg --->

<cfquery name="setDays" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Payroll
	   SET  Workdays           = 0,
	        PayrollDays        = 0, 		    
	        PayrollSLWOP       = 0,
			PayrollSuspend     = 0,
			PayrollSickLeave   = 0				
</cfquery>	

<!--- various Leg corrections --->

<cfquery name="UpdateStart" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Payroll
	SET    DateEffective = #SALSTR#
	WHERE  DateEffective < #SALSTR#
</cfquery>	

<cfquery name="UpdateEnd" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Payroll
	SET    DateExpiration = #SALEND#
	WHERE  DateExpiration > #SALEND# OR DateExpiration is NULL
</cfquery>	

<!--- check for double records --->

<cfquery name="CorrectAssignmentStart" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Payroll
	SET    DateEffective = AssignmentEffective
	WHERE  AssignmentEffective > DateEffective
</cfquery>	

<cfquery name="CorrectAssignmentEnd" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Payroll
	SET     DateExpiration       = AssignmentExpiration
	WHERE   AssignmentExpiration < DateExpiration
</cfquery>			

<cfquery name="Delete" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE userTransaction.dbo.sal#SESSION.thisprocess#Payroll
	WHERE  DateEffective > DateExpiration
</cfquery>		

<!--- ----------------------------------- PREPARE legs 2 of 3 ----------------------------------------- --->
<!--- now we determine if we have to split the contract records based on the SPA which might be granted --->
<!--- ------------------------------------------------------------------------------------------------- --->

<cfsavecontent variable="SPAData">

		SELECT  PostAdjustmentId,
		        ContractId,
				PersonNo,
				DateEffective,  
        		ISNULL(DateExpiration,'12/31/2099') as DateExpiration,
				PostSalarySchedule, 
				PostServiceLocation, 
				PostAdjustmentLevel, 
				PostAdjustmentStep,
				RecordStatus,
				ActionStatus
		FROM    Employee.dbo.PersonContractAdjustment
		
</cfsavecontent>

<cfquery name="ContractsWithSPA" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    C.ContractId, 
			  C.PersonNo,  
			  SPA.PostAdjustmentId        		  
	FROM      userTransaction.dbo.sal#SESSION.thisprocess#Payroll AS C INNER JOIN
	          (#preservesingleQuotes(SPAData)#) AS SPA ON C.PersonNo = SPA.PersonNo 
			  AND C.DateExpiration >= SPA.DateEffective
			  AND C.DateEffective  <= SPA.DateExpiration 
			  AND SPA.RecordStatus = '1'
			  <!--- only as safe guard --->
			  AND SPA.Contractid NOT IN (SELECT ContractId 
			                             FROM   PersonContract 
										 WHERE  PersonNo         = C.PersonNo
										 AND    HistoricContract = '1')
			  
	ORDER BY  C.PersonNo, 	          
			  SPA.DateEffective,
			  SPA.DateExpiration  
			  
</cfquery>

<!--- It is possible that in January for have 2 SPA records one ending 15/1 and one starting 16/1  --->

 <cfinvoke component  = "Service.Process.System.Database"  
      method           = "getTableFields" 
      datasource       = "AppsTransaction"         
      tableName        = "sal#SESSION.thisprocess#Payroll"
      ignoreFields     = "'ContractId','DateEffective','DateExpiration','ContractScheduleSPA','ContractLocationSPA','ContractLevelSPA','ContractStepSPA'"
      returnvariable   = "fields">  

<cfoutput query="ContractsWithSPA">
		
		<cfquery name="SPAList" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    C.ContractId, 
				  C.PersonNo,          
				  C.DateEffective, 
				  C.DateExpiration, 		  
				  C.SalarySchedule, 
				  C.ServiceLocation, 
				  C.ContractLevel, 
				  C.ContractStep,	
				  	  
				  SPA.DateEffective  AS SPAEffective, 
				  SPA.DateExpiration AS SPAExpiration, 
		          SPA.PostSalarySchedule, 
				  SPA.PostServiceLocation, 
				  SPA.PostAdjustmentLevel, 
				  SPA.PostAdjustmentStep
				  
		FROM      userTransaction.dbo.sal#SESSION.thisprocess#Payroll AS C INNER JOIN
		          (#preservesingleQuotes(SPAData)#) AS SPA ON C.PersonNo = SPA.PersonNo 
				  AND C.DateExpiration >= SPA.DateEffective
				  AND C.DateEffective <= SPA.DateExpiration 
				  AND SPA.RecordStatus = '1'
		WHERE     SPA.PostAdjustmentId = '#PostAdjustmentId#'				  
		</cfquery>
		
		<cfloop query="SPAList">
		
			<cfif SPAEffective lte DateEffective and SPAExpiration gte DateExpiration>
			
				<!--- happy day update records : SPA spans the complete period --->
				
				<cfquery name="setSPA" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Payroll
					SET     ContractScheduleSPA = '#PostSalarySchedule#', 
						    ContractLocationSPA = '#PostServiceLocation#', 
						    ContractLevelSPA    = '#PostAdjustmentLevel#', 
						    ContractStepSPA     = '#PostAdjustmentStep#'
					WHERE   ContractId = '#contractid#'
				</cfquery>
			
			<cfelseif SPAEffective gt DateEffective and SPAExpiration gte DateExpiration>	
			
			    <cfset dateValue = "">
				<CF_DateConvert Value="#DateFormat(SPAEffective,CLIENT.DateFormatShow)#">
				<cfset DTE = dateValue>
				<cfset exp = dateadd("d",-1,dte)>
					
				<!--- close record and ADD one to the end of the expiration --->
				
				<cfquery name="setStart" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Payroll
					SET     DateExpiration = #exp#
					WHERE   ContractId = '#contractid#'
				</cfquery>
				
				<cfquery name="insert" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO userTransaction.dbo.sal#SESSION.thisprocess#Payroll		
					        (ContractId,
							 DateEffective,
							 DateExpiration,
						     ContractScheduleSPA,
							 ContractLocationSPA,
							 ContractLevelSPA,
							 ContractStepSPA,
							 #fields#)				 
					SELECT  newid(),
					        #dte#,
							'#DateExpiration#',
						    '#PostSalarySchedule#',
						    '#PostServiceLocation#',
						    '#PostAdjustmentLevel#',
						    '#PostAdjustmentStep#',
						    #fields#				
					FROM    userTransaction.dbo.sal#SESSION.thisprocess#Payroll
					WHERE   ContractId = '#contractid#'
				</cfquery>
				
			<cfelseif SPAEffective lte DateEffective and SPAExpiration lt DateExpiration>	
			
				<!--- SPA ends in this period but contract continues on --->
			
				<cfset dateValue = "">
				<CF_DateConvert Value="#DateFormat(SPAExpiration,CLIENT.DateFormatShow)#">
				<cfset DTE = dateValue>
					
				<cfquery name="setSPA" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Payroll
					SET     ContractScheduleSPA = '#PostSalarySchedule#', 
						    ContractLocationSPA = '#PostServiceLocation#', 
						    ContractLevelSPA    = '#PostAdjustmentLevel#', 
						    ContractStepSPA     = '#PostAdjustmentStep#',				
							DateExpiration      = #dte#
					WHERE   ContractId = '#contractid#'
				</cfquery>
				
				<cfset eff = dateadd("d",1,dte)>
				
				<cfquery name="insert" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO userTransaction.dbo.sal#SESSION.thisprocess#Payroll		
					        (ContractId,
							 DateEffective,
							 DateExpiration,
						     ContractScheduleSPA,
							 ContractLocationSPA,
							 ContractLevelSPA,
							 ContractStepSPA,
							 #fields#)				 
					SELECT  newid(),
					        #eff#,
							'#DateExpiration#',
						    '#SalarySchedule#',
						    '#ServiceLocation#',
						    '#ContractLevel#',
						    '#ContractStep#',
						    #fields#				
					FROM    userTransaction.dbo.sal#SESSION.thisprocess#Payroll
					WHERE   ContractId = '#contractid#'
				</cfquery>	
			
			<cfelseif SPAEffective gt DateEffective and SPAExpiration lt DateExpiration>		
			
				<!--- do nothing, not supported SPA for less than one month --->
			
			</cfif>
		
		</cfloop>

</cfoutput>	  

<!--- ----------------------------------- PREPARE legs 3 of 3 --------------------------------------------------------------------------------------- --->
<!--- now we determine if we have to split the contract records based on the SLWOP which were granted and need contract entitlements to be disabled-  --->
<!--- ----------------------------------------------------------------------------------------------------------------------------------------------- --->

<cfquery name="LegsWithLWOP" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT        C.ContractId, 
				  C.PersonNo,  
				  LWOP.LeaveId  
				  
	FROM          userTransaction.dbo.sal#SESSION.thisprocess#Payroll AS C INNER JOIN
		          Employee.dbo.PersonLeave AS LWOP ON C.PersonNo = LWOP.PersonNo 
				  AND C.DateExpiration >= LWOP.DateEffective
				  AND C.DateEffective  <= LWOP.DateExpiration 
				  AND C.Mission        = LWOP.Mission
				  AND LWOP.Status IN ('2') 
				  -- AND LWOP.Status IN ('1','2') 

	<!--- only ones that qualify for leg adjustment --->				  
	WHERE        EXISTS (SELECT   'X' AS Expr1
	                     FROM     Employee.dbo.Ref_LeaveTypeClass
	                     WHERE    StopEntitlement = 1
				         AND      LeaveType IN (SELECT     LeaveType
						                        FROM       Employee.dbo.Ref_LeaveType
	                                            WHERE      LeaveParent IN ('LWOP', 'Suspend'))
						 AND      LeaveType = LWOP.LeaveType 
						 AND      Code      = LWOP.LeaveTypeClass)
				  
			  
	ORDER BY  C.PersonNo, 	          
			  LWOP.DateEffective,
			  LWOP.DateExpiration  
	 
			  
</cfquery>

<!--- It is possible that in January for have 2 Leave records one ending 15/1 and one starting 16/1  --->

 <cfinvoke component  = "Service.Process.System.Database"  
      method           = "getTableFields" 
      datasource       = "AppsTransaction"         
      tableName        = "sal#SESSION.thisprocess#Payroll"
      ignoreFields     = "'ContractId','DateEffective','DateExpiration','leaveid'"
      returnvariable   = "fields">  

<cfoutput query="LegsWithLWOP">

	<!--- obtain the LWOP records that cover this leg--->

	<cfquery name="LWOPList" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    C.ContractId, 
				  C.PersonNo,          
				  C.DateEffective, 
				  C.DateExpiration, 		  
				  C.SalarySchedule, 
				  C.ServiceLocation, 
				  C.ContractLevel, 
				  C.ContractStep,	
				  L.LeaveType,
				  
				  L.LeaveId,				  	  
				  L.DateEffective  AS LWOPEffective, 
				  L.DateExpiration AS LWOPExpiration 		         
				  
		FROM      userTransaction.dbo.sal#SESSION.thisprocess#Payroll AS C INNER JOIN
		          Employee.dbo.PersonLeave AS L ON C.PersonNo = L.PersonNo 
				  AND C.DateExpiration >= L.DateEffective
				  AND C.DateEffective  <= L.DateExpiration 
				  AND L.Status IN ('2') 
				  -- AND L.Status IN ('1','2')  
		WHERE     L.LeaveId = '#LeaveId#'		
			  
		</cfquery>
		
		<!--- all records of the leg --->
		
		
		
		<cfloop query="LWOPList">
		
			<!--- cover 4 scenarios : 
						1. LWOP overlaps (happy day)
						2. start after leg
									ends after or
									ends before, 
						3. starts before and ends before  --->
		
			<cfif LWOPEffective lte DateEffective AND LWOPExpiration gte DateExpiration>
			
				<!--- happy day update records : LWOP spans the complete period --->
				
				<cfquery name="set" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Payroll
					SET     LeaveId    = '#LeaveId#'
					WHERE   ContractId = '#contractid#'
				</cfquery>
			
			<cfelseif LWOPEffective gt DateEffective>	
			
			    <cfset dateValue = "">
				<CF_DateConvert Value="#DateFormat(LWOPEffective,CLIENT.DateFormatShow)#">				
				<cfset DTE = dateValue>
				<cfset exp = dateadd("d",-1,dateValue)>
					
				<!--- close record and ADD one to the end of the expiration --->
				
				<cfquery name="setStart" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Payroll
					SET     DateExpiration = #exp#  <!--- startdate LWOP - 1 --->
					WHERE   ContractId = '#contractid#'
				</cfquery>
				
				<cfif LWOPExpiration gte DateExpiration>
				
					<cfquery name="insert" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO userTransaction.dbo.sal#SESSION.thisprocess#Payroll		
						        (ContractId,
								 DateEffective,
								 DateExpiration,
								 LeaveId,						     
								 #fields#)				 
						SELECT  newid(),
						        #dte#,
								'#DateExpiration#',
							    '#leaveId#',
							    #fields#				
						FROM    userTransaction.dbo.sal#SESSION.thisprocess#Payroll
						WHERE   ContractId = '#contractid#'
					</cfquery>
					
									
				<cfelse>
												
					<cfquery name="insertPortion" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO userTransaction.dbo.sal#SESSION.thisprocess#Payroll		
						        (ContractId,
								 DateEffective,
								 DateExpiration,
								 LeaveId,						     
								 #fields#)				 
						SELECT  newid(),
						        #dte#,  <!--- startdate LWOP --->
								'#LWOPExpiration#', <!--- end date LWOP --->
							    '#leaveId#',
							    #fields#				
						FROM    userTransaction.dbo.sal#SESSION.thisprocess#Payroll
						WHERE   ContractId = '#contractid#'
					</cfquery>
				
					<cfset dateValue = "">
					<CF_DateConvert Value="#DateFormat(LWOPExpiration,CLIENT.DateFormatShow)#">								
					<cfset eff = dateadd("d",1,dateValue)>
								
					<cfquery name="insertClosing" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO userTransaction.dbo.sal#SESSION.thisprocess#Payroll		
						        (ContractId,
								 DateEffective,
								 DateExpiration,
								 LeaveId,						     
								 #fields#)				 
						SELECT  newid(),
						        #eff#, <!--- end date LWOP + 1 --->
								'#DateExpiration#', <!--- end of the leg --->
							    '00000000-0000-0000-0000-000000000000',
							    #fields#				
						FROM    userTransaction.dbo.sal#SESSION.thisprocess#Payroll
						WHERE   ContractId = '#contractid#'
					</cfquery>
								
				</cfif>
				
			<cfelseif LWOPEffective lte DateEffective and LWOPExpiration lt DateExpiration>	
			
				<!--- SPA ends in this period but contract continues on --->
			
				<cfset dateValue = "">
				<CF_DateConvert Value="#DateFormat(LWOPExpiration,CLIENT.DateFormatShow)#">
				<cfset DTE = dateValue>
					
				<cfquery name="setSPA" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Payroll
					SET     LeaveId         = '#leaveid#', 						    			
							DateExpiration  = #dte#
					WHERE   ContractId = '#contractid#'
				</cfquery>
				
				<cfset eff = dateadd("d",1,dte)>
				
				<cfquery name="insert" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO userTransaction.dbo.sal#SESSION.thisprocess#Payroll		
					        (ContractId,
							 DateEffective,
							 DateExpiration,
							 LeaveId,						    
							 #fields#)				 
					SELECT  newid(),
					        #eff#,
							'#DateExpiration#',
							'00000000-0000-0000-0000-000000000000',
						    #fields#				
					FROM    userTransaction.dbo.sal#SESSION.thisprocess#Payroll
					WHERE   ContractId = '#contractid#'
				</cfquery>	
				
										
			</cfif>
			
		</cfloop>	

</cfoutput>

<cfquery name="CorrectAssignmentEnd" 
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  dbo.sal#SESSION.thisprocess#Payroll
	SET     DateExpiration       = AssignmentExpiration
	WHERE   AssignmentExpiration < DateExpiration
</cfquery>			

<cfquery name="Delete" 
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE dbo.sal#SESSION.thisprocess#Payroll
	WHERE  DateEffective > DateExpiration
</cfquery>		

<!--- now we have a populated table we need to ensure calculation legs are not overlapping --->

<!--- quick set contract periods, up until 3 contract records in a month supported in the below --->

<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#PayrollTmp">	

<cfloop index="ctr" list="2,3,4,5,6,7,8,9,10,11,12">
	
	<cfset old = ctr-1>
		
	<!--- we set the line to the next partial number 2 or3 if 
	      its start date is after the lowest start date found --->
	
	<cfquery name="SetLineNumber" 
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE    dbo.sal#SESSION.thisprocess#Payroll
		SET       Line = '#ctr#'  <!--- set the line as 2 --->
		FROM      dbo.sal#SESSION.thisprocess#Payroll P,
		          ( SELECT    PersonNo,
				              MIN(DateEffective) as DateEffective		
					FROM      dbo.sal#SESSION.thisprocess#Payroll
					WHERE     Line = '#old#'
					GROUP BY  PersonNo) as T
		WHERE     P.PersonNo = T.PersonNo
		AND       P.DateEffective > T.DateEffective 
		AND       P.Line = '#old#'		  
	</cfquery>	
		
	<cfquery name="SetLine3" 
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE    dbo.sal#SESSION.thisprocess#Payroll
		SET       DateEffective = T.DateExpiration+1
		FROM      (SELECT    PersonNo,MAX(DateExpiration) as DateExpiration
				   FROM      dbo.sal#SESSION.thisprocess#Payroll
			       WHERE     Line = '#old#'
			       GROUP BY  PersonNo) as T INNER JOIN dbo.sal#SESSION.thisprocess#Payroll P2 ON T.PersonNo = P2.PersonNo
	    WHERE     P2.Line = '#ctr#'
		AND       P2.DateEffective <= T.DateExpiration
	</cfquery>	
	
</cfloop>

<!--- remove records that exceed the expiration date as part of the above --->

<cfquery name="Clean2" 
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    R.PersonNo, 
	          E.IndexNo, 
			  E.FullName, 
			  Line, 
			  COUNT(*) AS Expr1
	FROM      dbo.sal#SESSION.thisprocess#Payroll R INNER JOIN Employee.dbo.Person E ON R.PersonNo = E.PersonNo
	GROUP BY  R.PersonNo, E.IndexNo, E.FullName, Line
	HAVING    COUNT(*) > 1
</cfquery>

<script language="JavaScript">

	function  goback() {
	 	window.location = "ProcessList.cfm?Mission=#URL.Mission#"
	 }	
 
</script>

<cfif clean2.recordcount gte "1">

	<cfquery name="Update"
		 datasource="AppsPayroll" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   UPDATE CalculationLog 
			SET    ActionStatus = '9'
			WHERE  ProcessBatchId = '#calculationid#'
		</cfquery>		
			
	<cfsavecontent variable="message">
	
		<table width="100%"	
	       bgcolor="yellow"
	       class="formpadding">
		   
		   <tr class="labelmedium"><td colspan="4" align="center"><cf_tl id="Please correct contract effective dates to get correct calculation legs for the following staff"></td></tr>
		
			<cfoutput query="Clean2">
			
			<tr bgcolor="f5f5f5" class="labelmedium line">
			    <td>
				    <img src="#SESSION.root#/Images/pointer.gif"
					     alt="Employee profile"
					     name="img0_#PersonNo#"
					     id="img0_#PersonNo#"
					     width="9" height="9" border="0"
						 onclick="EditPerson('#PersonNo#')"
						 onMouseOver="document.img0_#PersonNo#.src='#SESSION.root#/Images/button.jpg'" 
						 onMouseOut="document.img0_#PersonNo#.src='#SESSION.root#/Images/pointer.gif'"
					     align="absmiddle">
				</td>
			    <td>#IndexNo#</td>
				<td><a href="javascript:EditPerson('#PersonNo#')">#PersonNo#</a></td>
			    <td>#FullName#</td>
			</tr>			
			</cfoutput>
		
		</table>
	
	</cfsavecontent>
	
	<cfquery name="Update"
		 datasource="AppsPayroll" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			    UPDATE CalculationLog 
				SET    ActionStatus   = '9',
				       ActionMemo     = '#Message#'				    
				WHERE  ProcessBatchId = '#calculationid#'
		</cfquery>
	
	<cfabort>

</cfif>

<cfquery name="Schedule" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   SalarySchedule 
	WHERE  SalarySchedule = '#Form.Schedule#' 
</cfquery>

<!--- 1= werner mode, get as many days as you possibly can  --->	
<cfset daymode = Schedule.SalaryBasePeriodMode> 

<cfif Schedule.SalaryBasePeriodDays eq "21.75">	 
	<cfinclude template="Days21.cfm">
<cfelseif Schedule.SalaryBasePeriodDays eq "30fix">	
    <cfinclude template="Days30.cfm">
<cfelse>
	<cfinclude template="Days28_31.cfm">
</cfif>	

<!--- ------------------------------------------------------------- --->		
<!--- Leave correction which applies only to Final Pay records----- --->
<!--- ------------------------------------------------------------- --->


<!--- ------------------------------------------------------------------------- --->
<!--- select the people that are eligible for the final pay calculation 
      this file is also used for the settlement processing / workflow   ------- --->
<!--- ------------------------------------------------------------------------- --->

<cfquery name="FinalPayTable" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT PersonNo, MAX(Expiration) as Expiration
	
	INTO     userTransaction.dbo.sal#SESSION.thisprocess#Final
	
	FROM (
			SELECT   PersonNo, 
			         MAX(DateExpiration) AS Expiration
		
			FROM     PersonContract PC
			WHERE    SalarySchedule  = '#Form.Schedule#' 
			AND      Mission         = '#Form.Mission#'		
			AND      RecordStatus    = '1'  <!--- transaction is to be considered for payroll 31/1/2018 --->
			AND      EnforceFinalPay = 1    <!--- final payment is requested --->
			AND      PersonNo NOT IN
		                          (SELECT   PersonNo
		                            FROM    PersonContract
		                            WHERE   (DateExpiration = '' OR DateExpiration IS NULL)
									 AND    ActionStatus != '9'
									 AND    SalarySchedule  = '#Form.Schedule#'
									 AND    Mission         = '#Form.Mission#')
			
			<!--- if there is a manual final payment record for 
			effective date of the contract record we do not include it --->
			
			AND      PersonNo NOT IN (SELECT PersonNo
			                          FROM   PersonAction
									  WHERE  ActionStatus = '1' 
						  			  AND    ActionCode = '4100'	
									  AND    year(DateExpiration)  = year(PC.DateEffective)										  
									  AND    month(DateExpiration) = month(PC.DateEffective)									 
									  )							  	 									  
									 
			  					   
			<cfif processmodality neq "InCycleBatch">
		     AND     PersonNo = '#Form.PersonNo#'		
	        </cfif>					   
			
			GROUP BY PersonNo
			HAVING   MAX(DateEffective) <= #SALEND# AND MAX(DateEffective) >= #SALSTR# 	
			
			<!--- 5/7/2018 added to include records ahead of time based on an action set
			set as payroll action, possibly this will replace the above in due course  --->
			
			UNION ALL
					
			SELECT    PersonNo, 
			          MAX(DateExpiration)
			FROM      PersonAction
			WHERE     ActionStatus   = '1' 
			AND       ActionCode     = '4100' 
			AND       DateEffective >= #SALSTR# 
			AND       DateEffective <= #SALEND#
			
			<cfif processmodality neq "InCycleBatch">
		     AND     PersonNo = '#Form.PersonNo#'		
	        </cfif>	
			
			<!--- and does have a contract for this period for this schedule --->
			
			AND       PersonNo IN (SELECT PersonNo
		                           FROM   PersonContract
		                           WHERE  SalarySchedule  = '#Form.Schedule#'
								   AND    ActionStatus IN ('0','1')
								   AND    DateExpiration >= #SALSTR#										  
								   AND    DateEffective  <= #SALEND#	 
								   AND    Mission         = '#Form.Mission#')		
								   								   
			GROUP BY  PersonNo
		
		) as B
		
		GROUP BY PersonNo
		
</cfquery>	

<!--- ------------------------------------------------------------- --->		
<!--- SLWOP correction which applies to all elements of the payroll --->
<!--- ------------------------------------------------------------- --->


<cfloop index="itm" list="LWOP,SUSPEND,SICKLEAVE">
	
		<cfquery name="SpecialLeave" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   ROW_NUMBER() OVER(PARTITION BY PersonNo ORDER BY DateEffective) AS RecordNo, *
			FROM     PersonLeave PC 
		             INNER JOIN Ref_LeaveTypeClass C ON PC.LeaveType = C.LeaveType  AND PC.LeaveTypeClass = C.Code		
			WHERE    PC.LeaveType IN (SELECT LeaveType 
			                          FROM   Ref_LeaveType 
								      WHERE  LeaveParent = '#itm#')
			AND      C.CompensationLeaveType is NULL 
			AND      C.CompensationPointer > 0 						  			
			AND      PC.Status = '2'
			AND      PC.PersonNo IN
			            (SELECT     PersonNo
			             FROM       userTransaction.dbo.sal#SESSION.thisprocess#OnBoard 
						 WHERE      PersonNo = PC.PersonNo) 
			AND      PC.DateEffective  <= #SALEND# 
			AND      PC.DateExpiration >= #SALSTR# 
			ORDER BY PC.PersonNo, 
			         PC.DateEffective		
								 				 
		</cfquery>	
		
						
	    <!--- 24/11/2017  we need to calculate the reverse, how many days without SLWOP, then the difference is the SLWOP --->
		
		<cfif Schedule.SalaryBasePeriodDays eq "21.75" and daymode eq "1" and itm neq "SICKLEAVE">
		
		<!--- we loop through the records and define all days covered by SLWOP, then we count the working
		days not under SLWOP pay and then we do 21.75 - remainder = balance --->
		
					
			<cfoutput query="SpecialLeave" group="PersonNo">	
			
				<cfset end = "0">
			
				<cfoutput>
				
				<cfif end eq "0">
					
					<!--- leave records --->
						
					<cfset LeaveStart       = "#DateEffective#">
					<cfset LeaveEnd         = "#DateExpiration#">
					<cfset thisleavetype    = "#leavetype#">
					<cfset thisleaveclass   = "#leavetypeclass#">
					<cfset ratio            = "#compensationpointer/100#">
					
					<!--- added provision for continuous leave period handling --->
					
					<cfquery name="hasNext"  
			         dbtype="query">
					   SELECT   *
					   FROM     SpecialLeave
					   WHERE    PersonNo = '#PersonNo#'				  
					   AND      RecordNo = '#RecordNo+1#'
				    </cfquery>
																		
					<cfif hasNext.recordcount eq "1">		
																	    
						<cfset cont = dateAdd("d","1",LeaveEnd)>	
						<!--- continuous period so we better treat this as one period --->			
						<cfif cont eq hasNext.DateEffective>						
							<!--- continuous date --->
							<cfset LeaveEnd = hasNext.DateExpiration>	
							<cfset end = "1">													
						</cfif>
										
					</cfif>
					
													
					<!--- we obtain the payroll legs for this person, this can be several continuous periods which stand by itself --->	
					
					<cfquery name="PayrollLegs" 
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  *
						FROM    dbo.sal#SESSION.thisprocess#Payroll
						WHERE   PersonNo = '#PersonNo#' 
						
					</cfquery>				
			
					<cfset calcdays = "">
																
					<cfloop query="PayrollLegs">
						
						<cfset condition = "">							
					
					    <!--- we match the period of SLWOP within the context of the payroll line, usually a month
						but can be split itself itself --->
									
						<cfif DateEffective gt LeaveStart>
						    <cfset st = DateEffective>
						<cfelse>
						    <cfset st = LeaveStart>
						</cfif>
						
						<cfif DateExpiration lt LeaveEnd>
						    <cfset ed = DateExpiration>
						<cfelse>
						    <cfset ed = LeaveEnd>
						</cfif>
															
						<cfif ed gte st>
														
						  <cfif condition eq "">
								<cfset condition = "CalendarDate >= '#dateformat(st,client.dateSQL)#' AND CalendarDate <= '#dateformat(ed,client.dateSQL)#'">
						  <cfelse>	
					    		<cfset condition = "#condition# AND CalendarDate >= '#dateformat(st,client.dateSQL)#' AND CalendarDate <= '#dateformat(ed,client.dateSQL)#'">		
						  </cfif> 	
							
						  <!--- obtain WORKING days that person has worked, to define different as SLWOP days like 4.75 --->
								 
						  <cfquery name="Days" 
							   datasource="AppsTransaction" 
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
								  SELECT  SUM(workday) as total
								  FROM    userTransaction.dbo.sal#SESSION.thisprocess#Dates
								  <!--- we count all working days that are not SLWOP in that month --->					  
								  WHERE   CalendarDate NOT IN (SELECT  CalendarDate 
															   FROM    userTransaction.dbo.sal#SESSION.thisprocess#Dates
														       WHERE   #preservesingleQuotes(condition)#)													  
								  <!--- scoped for the period --->					   
								  AND     CalendarDate >= '#DateEffective#'
								  AND     CalendarDate <= '#DateExpiration#'							 							 						 				   
						  </cfquery>							  
											
						  <cfif days.total neq "">	
						 						  
								  <cfset calcdays = PayrollDays - days.total>						 
								  <cfset calcdays = calcdays * ratio>
								  <cfif calcdays lt "0">
								  	   <cfset calcdays = 0>
								  </cfif>								  
								  
						  <cfelse>
								  
								  <!--- no days left in the month, means fully consumed --->
								  
								  <cfset calcdays = PayrollDays>
								  <cfset calcdays = calcdays * ratio>
								  
						  </cfif>
																				  					  					 			 				 
						  <cfquery name="Days" 
								datasource="AppsTransaction" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">	
																					
									UPDATE   dbo.sal#SESSION.thisprocess#Payroll 
									<cfif itm eq "LWOP">
									SET      PayrollSLWOP   = PayrollSLWOP + #calcdays# 
									<cfelseif itm eq "SUSPEND">
									SET      PayrollSUSPEND = PayrollSUSPEND + #calcdays# 									
									</cfif>							
									WHERE    PersonNo      = '#PersonNo#'
									AND      DateEffective = '#DateFormat(DateEffective,client.dateSQL)#'	
											
						   </cfquery>					
								  					   
						</cfif>    
											
					</cfloop>
										
					<!--- ----------------------------------------------------------------------------------------------------- --->
					<!--- 30/1/2018 now we make a correction in case we have several legs for a person on the SLWOP calculation --->
					<!--- ----------------------------------------------------------------------------------------------------- --->
					
					<cfif PayrollLegs.recordcount gte "2">
					
						<cfquery name="Payroll" 
						datasource="AppsTransaction" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  PersonNo, 
							        MIN(DateEffective) as DateEffective, 
							        MAX(DateExpiration) as DateExpiration, 
									SUM(PayrollDays)      as PayrollDays,
									<cfif itm eq "LWOP">
									SUM(PayrollSLWOP)     as Days
									<cfelseif itm eq "SUSPEND">
									SUM(PayrollSUSPEND)   as Days
									<cfelse>
									SUM(PayrollSICKLEAVE) as Days
									</cfif>
							FROM    dbo.sal#SESSION.thisprocess#Payroll
							WHERE   PersonNo = '#PersonNo#' 
							GROUP BY PersonNo
						</cfquery>	
						
						<cfloop query="Payroll">						
							
							<cfset condition = "">							
						
						    <!--- we match the period of SLWOP within the context of the payroll line, usually a month
							but can be split itself itself --->
										
							<cfif DateEffective gt LeaveStart>
							    <cfset st = DateEffective>
							<cfelse>
							    <cfset st = LeaveStart>
							</cfif>
							
							<cfif DateExpiration lt LeaveEnd>
							    <cfset ed = DateExpiration>
							<cfelse>
							    <cfset ed = LeaveEnd>
							</cfif>
											
							<cfif ed gte st>
															
							  <cfif condition eq "">
									<cfset condition = "CalendarDate >= '#dateformat(st,client.dateSQL)#' AND CalendarDate <= '#dateformat(ed,client.dateSQL)#'">
							  <cfelse>	
						    		<cfset condition = "#condition# AND CalendarDate >= '#dateformat(st,client.dateSQL)#' AND CalendarDate <= '#dateformat(ed,client.dateSQL)#'">		
							  </cfif> 	
								
							  <!--- obtain WORKING days that person has worked, to define different as SLWOP days like 4.75 --->
									 
							  <cfquery name="Days" 
								   datasource="AppsTransaction" 
								   username="#SESSION.login#" 
								   password="#SESSION.dbpw#">
									  SELECT  SUM(workday) as total
									  FROM    userTransaction.dbo.sal#SESSION.thisprocess#Dates
									  <!--- we count all working days that are not SLWOP in that month --->					  
									  WHERE   CalendarDate NOT IN (SELECT  CalendarDate 
																   FROM    userTransaction.dbo.sal#SESSION.thisprocess#Dates
															       WHERE   #preservesingleQuotes(condition)#)													  
									  <!--- scoped for the period --->					   
									  AND     CalendarDate >= '#DateEffective#'
									  AND     CalendarDate <= '#DateExpiration#'							 							 						 				   
							  </cfquery>	
							 				
							  <cfif days.total neq "">	
									  
									  <cfset calcdays = PayrollDays - days.total>						 
									  <cfset calcdays = calcdays * ratio>
									  <cfif calcdays lt "0">
									  	   <cfset calcdays = 0>
									  </cfif>
									  
							  <cfelse>
									  <!--- no days left in the month, means fully consumed --->
									  <cfset calcdays = PayrollDays>
									  <cfset calcdays = calcdays * ratio>
									  
							  </cfif>
							  
							  <cfset diff = calcdays - days>
							  						   						  
							  <cfif diff neq "0">
							  			
									  <!--- attention ------------------------------------------------------------------------------------------------------ --->				  										
									  <!--- we take the first leg, as this is also in this model the leg that is filled towards 21.75 which needs correction --->
									  <!--- as we now create a leg for the SLWOP/Suspect we can apply this only if it is 0 and then remove the save 
									        guard below ---------------------------------------------------------------------------------------------------- --->
									  <!--- ---------------------------------------------------------------------------------------------------------------- --->
							  						  																					  					  					 			 				 
									  <cfquery name="Correction" 
											datasource="AppsTransaction" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">													
												UPDATE   dbo.sal#SESSION.thisprocess#Payroll
																							
												<cfif itm eq "LWOP">
												SET      PayrollSLWOP   = PayrollSLWOP + #diff#,
														 PayrollDaysCorrectionPointer = '1'
												<cfelseif itm eq "SUSPEND">
												SET      PayrollSUSPEND = PayrollSUSPEND + #diff#,  
													     PayrollDaysCorrectionPointer = '1'												 
												</cfif>							
												
												WHERE    PersonNo      = '#PersonNo#'
												AND      Line          = '1'	
												
												<!--- to be enabled 15/5 --->
												<cfif itm eq "LWOP">
												AND      PayrollSLWOP   = 0											
												<cfelseif itm eq "SUSPEND">
												AND      PayrollSUSPEND = 0																						
												</cfif>											
																								
									   </cfquery>								   
								 						   
							   </cfif>				
									  					   
							</cfif>  												
						
						</cfloop>
									
					</cfif>
					
				</cfif>
				
				</cfoutput>				
							
			</cfoutput>
							   							
		<cfelse>	
						
			<cfoutput query="SpecialLeave" group="PersonNo">	
						     
				<cfset end = "0">
				
				<cfoutput>
						
				<cfif end eq "0">
												
					<!--- locate the payroll records for each person that has SLWOP --->		
									
					<cfset LeaveStart     = "#DateEffective#">
					<cfset LeaveEnd       = "#DateExpiration#">
					<cfset thisleavetype  = "#leavetype#">
					<cfset thisleaveclass = "#leavetypeclass#">
					<cfset thisleaveid    = "#leaveid#">
					
				   <!--- added provision for continuous leave period handling --->
					
					<cfquery name="hasNext"  
			         dbtype="query">
					   SELECT   *
					   FROM     SpecialLeave
					   WHERE    PersonNo = '#PersonNo#'				  
					   AND      RecordNo = '#RecordNo+1#'
				    </cfquery>
																		
					<cfif hasNext.recordcount eq "1">											
																	    
						<cfset cont = dateAdd("d","1",LeaveEnd)>	
						<!--- continuous period so we better treat this as one period --->			
						<cfif cont eq hasNext.DateEffective>						
							<!--- continuous date --->
							<cfset LeaveEnd = hasNext.DateExpiration>	
							<cfset end = "1">																				
						</cfif>
										
					</cfif>
						
						
					<!--- obtain the one or sometimes 2 payroll records for this person --->
					
					<cfquery name="Payroll" 
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  *
						FROM    dbo.sal#SESSION.thisprocess#Payroll
						WHERE   PersonNo = '#PersonNo#' 
					</cfquery>	
			
					<cfset calcdays = 0>
					
					<cfloop query="Payroll">
					
						<cfif DateEffective gt LeaveStart>
						    <cfset st = DateEffective>						
						<cfelse>
						    <cfset st = LeaveStart>						
						</cfif>
						
						<cfif DateExpiration lt LeaveEnd>
						    <cfset ed = DateExpiration>						
						<cfelse>
						    <cfset ed = LeaveEnd>											
						</cfif>
						
						<cfquery name="Days" 
						   datasource="AppsTransaction" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						      <cfif Schedule.SalaryBasePeriodDays eq "21.75">
							  SELECT  SUM(workday) as total
							  <cfelse>
							  SELECT  COUNT(CalendarDate) as total
							  </cfif>
							  FROM    userTransaction.dbo.sal#SESSION.thisprocess#Dates
							  WHERE   CalendarDate >= '#dateformat(st,client.dateSQL)#'
							  AND     CalendarDate <= '#dateformat(ed,client.dateSQL)#' 
							  
							  <cfif itm eq "SICKLEAVE">
							  <!--- we take only days that are also tagged as leave --->
							  AND     CalendarDate IN (SELECT CalendarDate
							                           FROM   Employee.dbo.PersonLeaveDeduct
													   WHERE  Leaveid = '#thisleaveid#'
													   AND    Deduction > 0)	
													   
							  </cfif>				   						    						  
							  
						 </cfquery>	
						 						 					
						<cfif days.total gte "1">	
															  			   
						   <cfset calcdays = calcdays + days.total>
						   	   
						   <cfset thisdays = days.total>
										   
						   <!--- we count in total so we check if we are not exceeding the 21.75 counter --->
						   
						   <cfif Schedule.SalaryBasePeriodDays eq "21.75">
													
								<cfif calcdays gt "21.75">
								
								    <!--- we reset the days to not exceed the maximum number of payroll days --->
								
									<cfset thisdays = thisdays - (calcdays - 21.75)>
													
								</cfif>
															
								<cfif st eq dateEffective and ed eq DateExpiration>
															
									<!---for the feb month and the person took a Leave the whole month, instead of deduction, the SalaryDays must be 21.75 --->
									<cfset thisdays = PayrollDays>
									
								</cfif>
								
						   </cfif>		
						   
						   <cfif Schedule.SalaryBasePeriodDays eq "30fix">
						   
						   		<cfif calcdays gt "30">
								
								    <!--- we reset the days to not exceed the maximum number of payroll days --->
								
									<cfset thisdays = thisdays - (calcdays - 30)>
													
								</cfif>			   
						   
						   </cfif>
						   
						   <!--- correction for percentage to be applied the slwop --->	
						
						   <cfquery name="Percent" 
						   datasource="AppsEmployee" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
								SELECT  *
								FROM    Ref_LeaveTypeClass
								WHERE   LeaveType = '#thisLeaveType#'
								AND     Code      = '#thisLeaveClass#'			
						   </cfquery>			   
						   			   
						   <cfif percent.recordcount eq "1">
						   
						      <cfset tot = thisdays*(percent.CompensationPointer/100)>
							 			   
						   <cfelse>
						   	
							  <cfset tot = thisdays>
							  
						   </cfif>							   							  
													
						   <cfquery name="Days" 
							datasource="AppsTransaction" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
														
								UPDATE   dbo.sal#SESSION.thisprocess#Payroll 
								
								<cfif itm eq "LWOP">
								SET      PayrollSLWOP          = PayrollSLWOP + #tot#,  
										 PayrollDaysCorrectionPointer = '1'    
								<cfelseif itm eq "SUSPEND">
								SET      PayrollSuspend        = PayrollSuspend + #tot#, 
										 PayrollDaysCorrectionPointer = '1'	
								<cfelse>
								SET      PayrollSickLeave      = PayrollSickLeave + #tot#							
								</cfif>
								
								WHERE    PersonNo      = '#PersonNo#'
								AND      DateEffective = '#DateFormat(DateEffective,client.dateSQL)#'				
						   </cfquery>					   
								
					     </cfif>
								
				     </cfloop>
							
				</cfif>
				
				</cfoutput>
				
				 <cfif Schedule.SalaryBasePeriodDays eq "30fix">
				
					<cfquery name="Days" 
						datasource="AppsTransaction" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
													
							UPDATE   dbo.sal#SESSION.thisprocess#Payroll 
							
							<cfif itm eq "LWOP">
							SET      PayrollSLWOP          = PayrollDays
							<cfelseif itm eq "SUSPEND">
							SET      PayrollSuspend        = PayrollDays
							<cfelse>
							SET      PayrollSickLeave      = PayrollDays					
							</cfif>
							
							WHERE    PersonNo      = '#PersonNo#'
							<cfif itm eq "LWOP">
							AND      PayrollSLWOP > PayrollDays
							<cfelseif itm eq "SUSPEND">
							AND      PayrollSuspend > PayrollDays
							<cfelse>
							AND      PayrollSickLeave > PayrollDays
							</cfif>			
									
										
					</cfquery>	
					
				
				</cfif>
								
			</cfoutput>
					
		</cfif>	
				
</cfloop>
			
<!--- ----------------------------------------------------------------------------- --->
<!--- Preparation of the table to set the rates  based on the dependent situation --->
<!--- ----------------------------------------------------------------------------- --->

<!--- get all active dependents that have 
           a valid insurance entitlement record 
		   that overlaps with the staff calculation  period --->
	
<cfquery name="Dependents" 
 datasource="AppsPayroll" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
     
	 SELECT   P.PersonNo,
	          P.DateEffective, 
			  
			  <!--- in case of overlapping we assign the group used and which has the highest priority --->
			  
			  IsNull((SELECT  TOP 1 PD.EntitlementGroup
			  FROM     PersonDependentEntitlement PD INNER JOIN
                          SalaryScaleComponent RG ON PD.SalaryTrigger = RG.SalaryTrigger AND PD.EntitlementGroup = RG.EntitlementGroup
			  WHERE    PD.PersonNo         = P.PersonNo
			  AND      PD.DateEffective   <= #SALSTR# 
			  AND      (PD.DateExpiration >= #SALEND# or PD.DateExpiration is NULL)
			  AND      RG.TriggerGroup    = 'Insurance' 
	 		  AND      Status             IN ('2')
			  ORDER BY RG.EntitlementPriority DESC ),'Standard') AS EntitlementGroup,			
			   
			  COUNT(*) as Dependents
			  <!--- 		  SQL2000
			  COUNT(DISTINCT DependentId) as Dependents
			  --->
			  
	 INTO     userTransaction.dbo.sal#SESSION.thisprocess#Pointer
	 
	 FROM     PersonDependentEntitlement D INNER JOIN
              Ref_PayrollTrigger Tr ON D.SalaryTrigger = Tr.SalaryTrigger INNER JOIN
			  userTransaction.dbo.sal#SESSION.thisprocess#Payroll P ON D.PersonNo = P.PersonNo 
	
	 <!--- are valid for one or more days during the period of the staff calculation --->		  
     WHERE    D.DateEffective <= P.DateExpiration 		 
	 AND      (D.DateExpiration >= P.DateEffective or D.DateExpiration is NULL)
	 
	 <!--- only valid entitlements, cleared --->
	 AND      Status IN ('2')
	  
	 <!--- only valid active dependents 
	 AND      D.DependentId IN (SELECT DependentId 
	                            FROM   Employee.dbo.PersonDependent 
							    WHERE  PersonNo     = D.PersonNo 
								AND    DependentId  = D.DependentId									
							    AND    ActionStatus IN ('1','2'))
								--->
								
	  AND     D.DependentId IN (SELECT DependentId 
				                FROM   Employee.dbo.PersonDependent 
								WHERE  PersonNo     = D.PersonNo 
								AND    DependentId  = D.DependentId									
							    AND    RecordStatus = '1')
																
	 <!--- medical insurance --->
	 AND      Tr.TriggerGroup IN('Insurance')  
	 
	 GROUP BY P.PersonNo, P.DateEffective 
	 
	 
</cfquery>
  
<!--- we apply for the persons payroll file the setting to get a correct dependent entitlement pointer/group to be applied --->

<cfquery name="PointerAndGroupCorrection" 
	 datasource="AppsPayroll" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 
		 UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Payroll
		 SET     SalaryPointer      = L.Dependents,  <!--- Hanno : likely not needed anymore as this has become a percentage to be applied instead of a scale --->
		         EntitlementPointer = L.Dependents,	
	 			<!--- 6/11/2012 set the EntitlementGroup to filter out the correct entitlement rate to be applied ---> 
				 <!--- EntitlementRatio   = L.Dependents + 1, for calculation of the staffmember itself : insurance etc. --->
				 EntitlementGroup   = L.EntitlementGroup		         
				 
		 FROM    userTransaction.dbo.sal#SESSION.thisprocess#Payroll P,  
		         userTransaction.dbo.sal#SESSION.thisprocess#Pointer L
				 
		 WHERE   P.PersonNo         = L.PersonNo
		 AND     P.DateEffective    = L.DateEffective   
		 
</cfquery>      
 	 		 
<!--- II. Payroll line reference --->	
<!--- create table with single line per employee --->
   
<cfquery name="PayrollLine" 
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	
		SELECT    P.PersonNo, 
		          P.Line, 
				  P.ContractLevel, 
				  P.ContractStep, 
				  P.ServiceLocation
		INTO      dbo.sal#SESSION.thisprocess#PayrollLine
	    FROM      (SELECT     PersonNo, 
					          MIN(DateExpiration) AS DateExpiration			   	
				    FROM      dbo.sal#SESSION.thisprocess#Payroll
					GROUP BY  PersonNo) T,
				  dbo.sal#SESSION.thisprocess#Payroll P	
	    WHERE     T.PersonNo       = P.PersonNo
		AND       T.DateExpiration = P.DateExpiration
		
</cfquery>	
		 
<!--- III. Exchange definition --->	
    	
<cfquery name="Exchange" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	
		SELECT    R.Currency, R.EffectiveDate, R.ExchangeRate
		INTO      userTransaction.dbo.sal#SESSION.thisprocess#Exchange
	    FROM      CurrencyExchange R, 		          
				  (SELECT   Currency, MAX(EffectiveDate) AS EffectiveDate		
	    		   FROM     CurrencyExchange
				   WHERE    EffectiveDate < #SALEND#
				   GROUP BY Currency ) as T
	    WHERE     T.Currency      = R.Currency
		AND       T.EffectiveDate = R.EffectiveDate		
		
   	</cfquery>
	
	<!--- is base currency <> schedule currency --->
	
	<cfif Form.Currency neq APPLICATION.BaseCurrency>
	
		<!--- additionn conversion --->
		
		<cfquery name="Payment" 
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
			SELECT    *
			FROM      sal#SESSION.thisprocess#Exchange
		    WHERE     Currency = '#Form.Currency#'   
	   	</cfquery>
		
		<cfif Payment.recordcount eq "0">		
		
			<cf_tl id="has no valid exchange rate defined" var="1">
		
			<cf_message 
			  message = "<cfoutput>#Form.Currency#</cfoutput> #lt_text#."
			  return = "back">
			<cfabort>
  		
		</cfif>
		
		<!--- now we populate the exchange table towards the payment exchange rate of the schedule 
		itself for easy reference --->
		
		<cfquery name="Update" 
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
			UPDATE sal#SESSION.thisprocess#Exchange
			SET    ExchangeRate = ExchangeRate / #Payment.ExchangeRate#
		</cfquery>	
	
	</cfif>
	
	<CF_DropTable dbName="AppsQuery" tblName="sal#SESSION.thisprocess#tmp">	
		
<!--- IV. Rate definition --->
	
<!--- select valid scales which includes schedules for SPA data as people maybe have a different SPA schedule/location --->

<cfsavecontent variable="thisScale">
	
	<cfoutput>	
	
		SELECT   SalarySchedule,
		         ServiceLocation, 				
				 MAX(SalaryFirstApplied) AS SalaryFirstApplied				 
				 
		FROM     SalaryScale S
		WHERE    SalaryEffective    <= #SALSTR#
		
		<!--- 3/10/2017 this will take all relevant schedules into the rates which includes SPA as it is relevant --->
		 AND     ( SalarySchedule   IN (SELECT DISTINCT ContractScheduleSPA 
		                                FROM   userTransaction.dbo.sal#SESSION.thisprocess#Payroll) 
				   
				   OR 
				   
				   SalarySchedule    = '#Form.Schedule#' 
				 )
										
		 AND     Mission             = '#Form.Mission#' 
		 
		 AND     (
		 
		            SalaryFirstApplied <= (
		 
			 			<!--- obtain the period which is due (MIN) for this entity/schedule and then determine if the due period is bigger than the first applied
							to kick in --->
							
						SELECT       MIN(PayrollStart) AS NextProcess
						FROM         Payroll.dbo.SalarySchedulePeriod
						WHERE        SalarySchedule = S.SalarySchedule 
						AND          Mission        = '#Form.Mission#' 
						AND          CalculationStatus IN ('0','1','2')
					
					) OR SalaryFirstApplied = SalaryEffective
					
				 )			 
		  
		 AND     Operational = 1
		GROUP BY SalarySchedule,
		         ServiceLocation	
				 
				 	
	</cfoutput>

</cfsavecontent>

		
<!--- retrieve all rates that are relevant now also incl SPA schedules --->
	
<cfquery name="Rates" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT     S.ScaleNo,
	           S.SalarySchedule, 
			   S.ServiceLocation, 
	           L.ServiceLevel, 
			   L.ServiceStep, 
			   L.ComponentName, 
			   C.ParentComponent,
			   L.Currency        as RateCurrency,
			   L.Amount          as RateAmount,
			   9999.000000       as ExchangeRate,
			   '#Form.Currency#' as PaymentCurrency, 
			   L.Amount, 			   
			   C.Period,
			   C.Source,
			   C.SalaryTrigger, 
			   C.TriggerGroup, 
			   C.TriggerCondition,
			   C.PayrollItem, 
			   C.SettleUntilPeriod,
			   C.EntitlementPointer, 
			   <!--- added filter for the group --->
			   C.EntitlementGroup, 
			   C.SalaryMultiplier,
			   C.SalaryDays,			  
               C.EntitlementClass, 
			   C.EntitlementGrade,  <!--- ADD to determine if this is going to be applied on the grade or SPA grade --->
			   C.EntitlementGradePointer
			   
	INTO       userTransaction.dbo.sal#SESSION.thisprocess#Scale	   
	
    FROM       SalaryScale S, 
	           (#preservesingleQuotes(thisScale)#) T,  
			   SalaryScaleLine L,
               SalaryScaleComponent C <!--- 29/3/2017 adjusted from SalaryScaleComponent --->			   	  
			   
	WHERE      S.Mission           = '#Form.Mission#'
		
	AND		   S.SalarySchedule       = T.SalarySchedule 
	AND        S.ServiceLocation      = T.ServiceLocation
	-- AND        S.SalaryEffective      = T.SalaryEffective
	AND        S.SalaryFirstApplied   = T.SalaryFirstApplied
	AND        S.ScaleNo              = L.ScaleNo
	AND        S.Operational          = 1 		
	AND        S.ScaleNo              = C.ScaleNo
	AND        L.ComponentName        = C.ComponentName
		
	ORDER BY   S.SalarySchedule, 
	           S.ServiceLocation, 
			   L.ServiceLevel, 
			   L.ServiceStep 		   		   
						   
</cfquery>	

<!--- just to obtain one of the scale with this to be used to query the SalaryScaleComponent table --->

<cfquery name="Scale" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT TOP 1 ScaleNo
	   FROM   userTransaction.dbo.sal#SESSION.thisprocess#Scale	 
	   WHERE  SalarySchedule    = '#Form.Schedule#' 
</cfquery>   

<!--- provision to obtain all possible relevant scales to support also cross schedule SPA --->
<cfquery name="Scales" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT DISTINCT ScaleNo
	   FROM   userTransaction.dbo.sal#SESSION.thisprocess#Scale	 	   
</cfquery>   

<cfquery name="SetValue" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Scale
	   SET    ExchangeRate = 1	  
</cfquery>   

<!--- Added 10/10/2010 converted the rate if the payment currency <> rate currency 
this is also relevant for the SPA in different schedule, in case of STL
the SPA currency is USD whereas the local schedle is EUR, this will conver this
immediately based on the EUR schedule with respect ot the rates --->

<cfquery name="CurrencyList" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT  DISTINCT RateCurrency
	   FROM    userTransaction.dbo.sal#SESSION.thisprocess#Scale
	   WHERE   RateCurrency != PaymentCurrency
</cfquery>   

<cfloop query="CurrencyList">

	<!--- define the exchange rate --->
	
	<cf_exchangerate datasource    = "appspayroll" 
	                 currencyfrom  = "#ratecurrency#" 
					 currencyto    = "#Form.Currency#" 
					 effectivedate = "#dateformat(SALEND,CLIENT.DateFormatShow)#">

	<cfquery name="Update" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Scale
		   SET    ExchangeRate  = #exc#, 
		          Amount        = round((Amount/#exc#),3)	   
		   WHERE  RateCurrency  = '#ratecurrency#'
	</cfquery>  

</cfloop>
	
<!--- V. Percentage definition --->
				
	<cfsavecontent variable="ApplicableScale">
		
		<cfoutput>	
		
			SELECT   S.Mission,
			         S.SalarySchedule,
					 S.ServiceLocation,
			         P.ComponentName,			          					
					 MAX(S.SalaryFirstApplied) AS SalaryFirstApplied			
					 	 
					 
			FROM     SalaryScale S,
			         SalaryScalePercentage P
			WHERE    S.ScaleNo = P.ScaleNo
			AND      S.SalaryEffective  <= #SALSTR#
			AND      S.Operational = 1
			AND     ( S.SalarySchedule   IN (SELECT DISTINCT ContractScheduleSPA 
		                                      FROM   userTransaction.dbo.sal#SESSION.thisprocess#Payroll) 
				     OR 
				     S.SalarySchedule    = '#Form.Schedule#' 
				     )
 			AND      S.Mission         = '#Form.Mission#'
			
			AND     (
			         SalaryFirstApplied <= (
		 
			 			<!--- obtain the period which is due for this entity/schedule, that period should trigger the application of a later schedule 
						to kick in --->
						SELECT       MIN(PayrollStart) AS NextProcess
						FROM         Payroll.dbo.SalarySchedulePeriod
						WHERE        SalarySchedule = S.SalarySchedule 
						AND          Mission        = '#Form.Mission#' 
						AND          CalculationStatus IN ('0','1','2')
					
					) OR SalaryFirstApplied = SalaryEffective )		
					 
			GROUP BY S.Mission,
			         S.SalarySchedule,			         
			         S.ServiceLocation,
					 P.ComponentName 
					 					 
		</cfoutput>
		
	</cfsavecontent>				 
	
<cfquery name="Percentages" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	
	SELECT     DISTINCT Sc.SalarySchedule, 
			   E.SalaryTrigger, 
			   E.PayrollItem,
	           Sc.ServiceLocation, 
			   '#Form.Currency#' as PaymentCurrency, 			  
			   S.CalculationBasePeriod,
			   E.SettleUntilPeriod,
			   S.Percentage,
			   S.ScaleNo,			   
			   S.DetailMode,
			   E.ComponentName,
			   E.Source,
			   E.ParentComponent,
			   E.SalaryDays,
			   S.CalculationBase, 
			   S.CalculationBaseFinal,			   
			   S.EntitlementPointer, 
			   E.EntitlementRecurrent,
			   E.SalaryMultiplier,
			   E.EntitlementGrade,  <!--- ADD to determine if this is going to be applied on the grade or SPA grade --->
			   #now()# as TimeStamp
			   
 	INTO       userTransaction.dbo.sal#SESSION.thisprocess#Percentage			   
	
    FROM       (#preservesingleQuotes(ApplicableScale)#) T, <!--- make sure it has all schedules involved --->
			   SalaryScale Sc,
			   SalaryScalePercentage S,
			   SalaryScaleComponent E
			   
	WHERE      Sc.ServiceLocation     = T.ServiceLocation	
	AND        Sc.SalarySchedule      = T.SalarySchedule
	AND        Sc.SalaryFirstApplied  = T.SalaryFirstApplied
	
	AND        Sc.Mission             = T.Mission
	AND        S.ScaleNo              = Sc.ScaleNo        
	AND        S.ComponentName        = T.ComponentName	
	AND        Sc.ScaleNo             = E.ScaleNo
	AND        S.ComponentName        = E.ComponentName
	AND        Sc.Operational         = 1
		
</cfquery>		

<!--- correct of percentage if defined for a 
                         certain MONTH like post adjustment --->

<cfquery name="CorrectionMonth" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	
	UPDATE   userTransaction.dbo.sal#SESSION.thisprocess#Percentage
	SET      Percentage            = D.Percentage
	FROM     userTransaction.dbo.sal#SESSION.thisprocess#Percentage S INNER JOIN
             Payroll.dbo.SalaryScalePercentageDetail D ON S.ScaleNo = D .ScaleNo AND S.ComponentName = D .ComponentName AND 
             S.EntitlementPointer  = D.EntitlementPointer
	WHERE    S.DetailMode          = 'Month' 
	AND      D.DetailValue         = '#month(SALSTR)#'
	 	
</cfquery>	
	
<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#SLWOP">
