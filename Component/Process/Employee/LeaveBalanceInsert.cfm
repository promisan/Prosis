	
<!--- define the following information	
1. DEFINE ACCRUAL 
2. DEFINE TAKEN
3. INSERT BALANCE RECORD		
--->		

<cfparam name="priorPerson" default="">
<cfparam name="priorMonth"  default="">

<cfif PersonNo neq priorPerson>
	<cfset priorPerson = Personno>
</cfif>
<cfif month(START) neq priorMonth>
	<cfset priorMonth  = month(START)>
	<cfset dayFirst    = day(START)> 
	<cfset dayLast     = "0">
</cfif>

<cfparam name="bal" default="0">
	
<cfquery name="getLeave" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_LeaveType 
        WHERE  LeaveType      = '#LeaveType#' 
</cfquery>
 
<cfset CRD = "0">

<cfquery name="Initial" 
	  datasource="AppsEmployee" 	 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT    TOP 1 *
		FROM      PersonLeaveBalanceInit
		WHERE     PersonNo  = '#PersonNo#' 
		AND       LeaveType = '#LeaveType#'
		<cfif itm eq "LeaveType">
		AND       LeaveTypeClass is NULL <!--- added to provide support for class balances ---> 
		<cfelse>
		AND       LeaveTypeClass = '#itm#'
		</cfif>	 	
		ORDER BY  DateEffective DESC		
</cfquery>

 <!--- 1 define credit --->

<cfif Mode eq "Regular" or Mode eq "Batch">
		 
	  <cfquery name="credit" 
	  datasource="AppsEmployee" 	 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
        SELECT   	TOP 1 *
		FROM     	Ref_LeaveTypeCredit
		WHERE    	LeaveType      = '#LeaveType#'
		AND      	ContractType   = '#Contract.ContractType#'
		AND      	DateEffective <= #START# 
		ORDER BY 	DateEffective DESC 		
	</cfquery>	
						
	<cfset CarryOverMaximum = Credit.CarryOverMaximum>
	
	 <cfquery name="overrule" 
	  datasource="AppsEmployee" 	 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
        SELECT   	TOP 1 *
		FROM     	PersonAction
		WHERE       PersonNo  = '#PersonNo#' 
		AND         DateEffective = #START# 	
		AND         ActionCode = '4010'	
	</cfquery>
	
	<cfif overrule.recordcount eq "1">
		<cfset CarryOverMaximum = "">
	</cfif>
	
	<!--- you need to have some sort of credit record defined for a leave type in order to populate --->
				
	<cfif Credit.RecordCount eq 1>
							  
			  <!--- determine if the accrual has to be stopped during the month for some days based
			  on SLWOP received which does no accrue leave balancesaccrual calculation 
			    correction for some leave in a month --->
												
			 <cfif getLeave.leaveAccrual neq "1">	
			 
				 <cfset corr              = 0>
				 <cfset formulacorrection = 0>	
				 
			 <cfelseif getLeave.LeaveBalanceMode eq "relative">	 
			 
			     <!--- added to prevent query 14/1/2019 --->
							 
				<cfset corr              = 0>
				<cfset formulacorrection = 0>	
				
				<cfif itm eq "LeaveType">
				
					<!--- in this portion we make a correction on the balance ---> 
					<!---
					<cfoutput>#leavetype#-#itm#-#Start#-#getLeave.LeaveBalanceMode#-#getPeriod.EntitlementDuration#-#getLeave.leaveAccrual#
					--->
					
					<cfif start gte now()>
					
						<cfset hdate = dateadd("m",getPeriod.EntitlementDuration*-1,start)>
						
						<cfquery name="get" 
						  datasource="AppsEmployee" 	 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
					        SELECT   	*
							FROM     	PersonLeaveBalance
							WHERE       PersonNo  = '#PersonNo#' 
							AND         LeaveType = '#leaveType#'
							AND         Mission   = '#Mission#'
							AND         BalanceStatus = '0'
							AND         DateEffective = #hdate#		
						</cfquery>
						
						<cfif get.taken neq "">
									
							<cfset ADJ = get.taken>
							<cfset Memo = "Time correction">
												
						</cfif>
					
					</cfif>									
				
				</cfif>
				
								 			 
			 <cfelse>		
						  
				  <cfquery name="slwop" 
		           datasource="AppsEmployee" 		   
		           username="#SESSION.login#" 
		           password="#SESSION.dbpw#">
				    SELECT  *
					FROM    PersonLeave L 
					        INNER JOIN Ref_LeaveTypeClass R ON L.LeaveType = R.LeaveType AND  L.LeaveTypeClass = R.Code
							INNER JOIN Ref_LeaveType T ON L.LeaveType = T.LeaveType 
					WHERE   L.PersonNo       = '#PersonNo#'
					<!--- overlaps the period of balance calculation --->
					AND     Status          = '2'  <!--- approved --->					
					AND     DateExpiration  >= #START#
					AND     DateEffective   <= #END#					
					AND     R.StopAccrual    = '1'   <!--- this Leave type class is meant to stop the accrual calculation --->			
			     </cfquery>
				 				 				 
				 <!--- NEW we capture the TOTAL duration of the SLWOP record involved for this balance period
				 into a single array of days covered for comparison to the threshold --->
				 
				 <cfset corr              = 0>
				 <cfset formulacorrection = 0>
				 <cfset ar = ArrayNew(1)>
				 <cfset ds = day(START)>
			     <cfset de = day(END)>		
				 
				 <cfif slwop.recordcount gte "1">
				 				  
					  <!--- we set an empty array --->				 				 
					  <cfloop index="d" from="1" to="366">	
					 	   <cfset ar[d] = "0">
					  </cfloop>	
					 				  
					  <cfloop query="slwop">					 			   					 
						  
						 <cfset dy = DateEffective>  	
					 
					 	 <cfloop condition="#dy# lte #DateExpiration#">
						 
							 <cfset ar[DayOfYear(dy)] = "1">		
							 <cfset dy = dateadd("d","1",dy)>
						 
						 </cfloop>
										 
					 </cfloop>		
					 <cfset totaldays =  arraySum(ar)>						 
					   				 
					 <!--- we compare the total days involved, can be removed 
				 	   <cfset totaldays =  slwop.DateExpiration - slwop.DateEffective + 1>					   
					   --->
					  					   
					   <!--- 8/12 we ONLY deduct the accrual of a SLWOP record as its total duration as-a -ecord 
					   is more than the threshold days  --->
					   
					   <cfif totaldays gte slwop.ThresholdSLWOP>	
					   					 		 
						   <cfif slwop.DateExpiration gt END>
						       <cfset sldte =  END>
						   <cfelse>
						   	   <cfset sldte =  slwop.DateExpiration>    
						   </cfif>
						   
						   <cfif slwop.DateEffective lt START>
						       <cfset sldts =  START>
						   <cfelse>
						   	   <cfset sldts =  slwop.DateEffective>    
						   </cfif>		  						   
						   
						   <cfif Credit.Calculation eq "Formula">	
						   
							   <!--- UN formula, we support effectively only one record  --->
							   
							   <cfset corr = sldte - sldts + 1>	
							  							   							   							   
							   <cfif  sldte eq end and sldts eq start>							    
							   		<cf_LeaveAccrual DS="#day(sldts)#"  DE="#day(sldte)#" End="#End#" Credit="#credit.CreditFull#" Mode="Standard">										
							   <cfelse>							  							  							   							   							   
								   	<cf_LeaveAccrual DS="#day(sldts)#"  DE="#day(sldte)#" End="#End#" Credit="#credit.CreditFull#" Mode="SLWOP">								   
							   </cfif> 		
							   							  
							   <cfset formulacorrection = crd>
							  							   							   													   							    
						   <cfelseif Credit.Calculation eq "Day">		
						   					   
						   		<cfloop query="slwop">
								
									<cfif DateExpiration gt END>
									      <cfset sldte =  END>
								    <cfelse>
									      <cfset sldte =  DateExpiration>    
								    </cfif>
						   
								    <cfif DateEffective lt START>
									       <cfset sldts =  START>
								    <cfelse>
									   	   <cfset sldts =  DateEffective>    
								    </cfif>		
									
									<cfset corr = corr + (sldte - sldts + 1)>								
								
								</cfloop>
															
						   <cfelse>
						   
							   <!--- workdays --->
							   							   
							   <cfloop query="slwop">		
							   								
									<cfif DateExpiration gt END>
									      <cfset sldte =  END>
								    <cfelse>
									      <cfset sldte =  DateExpiration>    
								    </cfif>
						   
								    <cfif DateEffective lt START>
									       <cfset sldts =  START>
								    <cfelse>
									   	   <cfset sldts = DateEffective>    
								    </cfif>		
							   
								   <cfset dim = sldte - sldts>		
							   	   						   												
								   <cfloop index="cnt" from="0" to="#dim#">	
									
										<cfset dte = dateAdd("d",cnt,sldts)>
																																			
										<!--- schedule counter --->
										
										<cfinvoke component = "Service.Process.Employee.Attendance"  
										   method           = "WorkDay" 
										   PersonNo         = "#PersonNo#"
										   CalendarDate     = "#dateformat(dte,client.dateformatshow)#"  		   	  
										   returnvariable   = "work">		
										   
									   <cfset corr = corr + work.hours>									   
									  								   								 						   
									</cfloop>											
																
								</cfloop>						 				
							
						   </cfif>	
					 
				   </cfif>
				   				   				   
				 </cfif>   
				 
			 </cfif>	 
			 			 			 
			 <cfif getLeave.leaveAccrual eq "4" or itm neq "LeaveType">				
			 
			 	 <!--- THRESHOLD records which usually apply to the class within a leave --->
			 		 
			 	<cfquery name="getEntitlement" 
		           datasource="AppsEmployee" 		   
		           username="#SESSION.login#" 
		           password="#SESSION.dbpw#">				  
				 
				  	SELECT    TOP 1 * 
					FROM      Ref_LeaveTypeThreshold P
					WHERE     LeaveType = '#LeaveType#'	
										
					<cfif itm eq "LeaveType">
					AND       LeaveTypeClass is NULL <!--- added to provide support for class balances ---> 
					<cfelse>
					AND       LeaveTypeClass = '#itm#'
					</cfif>	  						
										
					AND       Mission    IN (SELECT Mission
					                         FROM   PersonContract 
											 WHERE  PersonNo        = '#PersonNo#'		
											 AND    DateEffective  <= #END# 				
											 AND    DateExpiration >= #START#													
											 AND    ActionStatus != '9') 
								 
					AND       DateEffective <= #START# 			
					<cfif start neq eod>				
					AND       ThresholdMonth = '#month(start)#'	 
					</cfif>
					ORDER BY  DateEffective DESC												
				</cfquery>		
													
				<cfquery name="check" 
		           datasource="AppsEmployee" 		   
		           username="#SESSION.login#" 
		           password="#SESSION.dbpw#">
				  	SELECT    *
					FROM      PersonLeaveBalance WITH(NOLOCK)
					WHERE     PersonNo             = '#PersonNo#'
					AND       LeaveType            = '#LeaveType#'		
					<cfif itm eq "LeaveType">
					AND       LeaveTypeClass       is NULL <!--- added to provide support for class balances ---> 
					<cfelse>
					AND       LeaveTypeClass       = '#itm#'
					</cfif>	  		
					AND       YEAR(DateEffective)  = '#year(start)#'
					AND       MONTH(DateEffective) = '#month(start)#'																
				</cfquery>		 
			 
			 	<cfif getEntitlement.Threshold gt "0" and check.recordcount eq "0">
					<cfset crd = getEntitlement.Threshold>					
				</cfif>	
				
			 <cfelseif getLeave.leaveAccrual eq "3">		
			 						 
			 	 <!--- ENTITLEMENT records --->
			 		 
			 	<cfquery name="getEntitlement" 
		           datasource="AppsEmployee" 		   
		           username="#SESSION.login#" 
		           password="#SESSION.dbpw#">
				  	SELECT    SUM(DaysEntitlement) AS Days
					FROM      PersonLeaveEntitlement P
					WHERE     PersonNo = '#PersonNo#' 
					AND       ContractId IN (SELECT ContractId 
					                         FROM   PersonContract 
											 WHERE  PersonNo     = '#PersonNo#'
											 AND    ContractId   = P.ContractId
											 AND    ActionStatus != '9') 
					AND       LeaveType = '#LeaveType#'					 
					AND       DateEffective >= #START# 				
					AND       DateEffective <= #END#			
				</cfquery>		 
			 
			 	<cfif getEntitlement.Days gt "0">
					<cfset crd = getEntitlement.days>
				</cfif>	
				
			 <cfelseif getLeave.leaveAccrual eq "2">				 
						 
			 	<cfset crd = 0>	
			 
			 	<cfif Credit.CreditUoM eq "hour">
				
					<cfquery name="getOvertime" 
			           datasource="AppsEmployee" 		   
			           username="#SESSION.login#" 
			           password="#SESSION.dbpw#">		
	
					   SELECT ISNULL(SUM(Hours*Multiplier),0)   as Hours, 
					          ISNULL(SUM(Minutes*Multiplier),0) as minutes
							  
					   FROM (				     
					  			  
							  	SELECT   SalaryTrigger,
								
								 		 ISNULL((SELECT C.SalaryMultiplier
										         FROM   Payroll.dbo.Ref_PayrollTrigger AS R INNER JOIN
						                                Payroll.dbo.Ref_PayrollComponent AS C ON R.SalaryTrigger = C.SalaryTrigger
										         WHERE  R.SalaryTrigger = OTD.SalaryTrigger),1) as Multiplier,
												 
								         SUM(OTD.OvertimeHours)   AS Hours, 
								         SUM(OTD.OvertimeMinutes) AS Minutes
										 
								FROM     Payroll.dbo.PersonOvertimeDetail AS OTD INNER JOIN
		                                 Payroll.dbo.PersonOvertime AS O ON OTD.PersonNo = O.PersonNo AND OTD.OvertimeId = O.OvertimeId					 							
								WHERE    O.PersonNo = '#PersonNo#' 
								AND      O.Mission  = '#mission#'
								AND      O.OvertimePeriodStart >= #START# 
								AND      O.OvertimePeriodStart <= #END# 		
								AND      O.Status IN ('1','2','3','5')		
								AND      OTD.BillingPayment = 0 	
								GROUP BY SalaryTrigger		
													
							) as Base
																						
					</cfquery>
					
					<cfif getOvertime.recordcount gte "1">
					
						<cfif getOvertime.Minutes gt "0">
							<cfset ovt = getOvertime.Hours+(getOvertime.Minutes/60)>
						<cfelse>				
							<cfset ovt = getOvertime.Hours>
						</cfif>
															
						<cfset crd = ovt>
					
					<cfelse>
					
						<cfset crd = 0>
						
					</cfif>					
																			
				<cfelse> 							
				 					
					 <!--- determine the contract 
							and then the payroll schedule of the person for this period 
							and then we can detfine 
					 --->								
							
				 	<cfquery name="getOvertime" 
			           datasource="AppsEmployee" 		   
			           username="#SESSION.login#" 
			           password="#SESSION.dbpw#">		
	
					  SELECT ISNULL(SUM(Hours*Multiplier),0)   as Hours, 
					         ISNULL(SUM(Minutes*Multiplier),0) as minutes
							  
					   FROM (				     
					  			  
							  	SELECT   SalaryTrigger,
								
								 		 ISNULL((SELECT C.SalaryMultiplier
										         FROM   Payroll.dbo.Ref_PayrollTrigger AS R INNER JOIN
						                                Payroll.dbo.Ref_PayrollComponent AS C ON R.SalaryTrigger = C.SalaryTrigger
										         WHERE  R.SalaryTrigger = OTD.SalaryTrigger),1) as Multiplier,
												 
								         SUM(OTD.OvertimeHours)   AS Hours, 
								         SUM(OTD.OvertimeMinutes) AS Minutes
										 
								FROM     Payroll.dbo.PersonOvertimeDetail AS OTD INNER JOIN
		                                 Payroll.dbo.PersonOvertime AS O ON OTD.PersonNo = O.PersonNo AND OTD.OvertimeId = O.OvertimeId					 							
								WHERE    O.PersonNo = '#PersonNo#' 
								AND      O.Mission  = '#mission#'
								AND      O.OvertimePeriodStart >= #START# 
								AND      O.OvertimePeriodStart <= #END# 		
								AND      O.Status IN ('1','2','3','5')		
								AND      O.OvertimePayment = 0		
								GROUP BY SalaryTrigger		
													
							) as Base
								
					</cfquery>
				
					<!--- add minutes to the ovt counting in hours --->
					
					<cfif getOvertime.Minutes gt "0">
						<cfset ovt = getOvertime.Hours+(getOvertime.Minutes/60)>
					<cfelse>				
						<cfset ovt = getOvertime.Hours>
					</cfif>
					
					<cfif ovt gt "0">
						<!--- <cfset crd = ovt/Parameter.HoursWorkDefault> --->
						<cfset crd = ovt/Parameter.HoursInDay>
					</cfif>	
					
				</cfif>	
								
			 <cfelseif getLeave.leaveAccrual eq "1">				
			 			 
			 	  <!--- ANNUAL LEAVE records and part-timers (STL) --->	 
					 				 
				 <cfif Credit.Calculation eq "Formula" or contractTime lt "60">		
				 					 			 			
				 	<cfif leavetype eq "Annual">																								 
					 																	
						<cfif month(START) eq priormonth 
						  and personno eq priorperson 
						  and DS eq DayLast>
						  
						  <cfset DP = dateAdd("D","1",DS)>
						  
						     <cfquery name="check" 
					           datasource="AppsEmployee" 		   
					           username="#SESSION.login#" 
					           password="#SESSION.dbpw#">
							    SELECT  TOP 1 *
								FROM    PersonLeave L 
								        INNER JOIN Ref_LeaveTypeClass R ON L.LeaveType = R.LeaveType AND  L.LeaveTypeClass = R.Code
										INNER JOIN Ref_LeaveType T ON L.LeaveType = T.LeaveType 
								WHERE   L.PersonNo       = '#PersonNo#'
								<!--- overlaps the period of balance calculation --->
								AND     DateExpiration  >= #DP#
								AND     DateEffective   <= #DP#			
								AND     Status = '2'  <!--- approved --->		
								AND     R.StopAccrual    = '1'   <!--- this Leave type class is meant to stop the accrual calculation --->			
						     </cfquery>
							 
							 <cfset totaldays =  slwop.DateExpiration - slwop.DateEffective + 1>

							 <cfif check.recordcount eq "0" or totaldays lt slwop.ThresholdSLWOP>						  											
								<cf_LeaveAccrual DS="#DayFirst#"  DE="#DE#" End="#End#" Credit="#credit.CreditFull#" mode="Standard">									
							 <cfelse>
							 
							 	 <!--- 13/4/2018  we do not apply full period if the person 
							       has a SLWOP in the date prior to the start which means a new contract, not continuation --->								   				   
							 
							 	<cf_LeaveAccrual DS="#DS#"  DE="#DE#" End="#End#" Credit="#credit.CreditFull#" mode="Standard">		
							    <cfset DayFirst = day(START)>							  
							
							 </cfif>
														
						<cfelse>
												
							<!--- we have a break, so we reset this --->
							<cf_LeaveAccrual DS="#DS#"  DE="#DE#" End="#End#" Credit="#credit.CreditFull#" mode="Standard">
							
																
							<cfset DayFirst = day(START)>	
							
						</cfif>		
						
												
						<cfset DaysLast = dateAdd("D","1",DE)>
													
					 							 
					 </cfif>
															 					 
					 <cfset crd  = crd * (contractTime/100)>
					 
					 <cfset full = credit.CreditFull * (contractTime/100)>
					 					 					 
					 <!--- correction in case we have several legs in the same month to prevent over-counting 
					 which is likely with the method of break under line 336 to happen --->
					 
					 <cfquery name="check" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					    SELECT SUM(Credit) as Deduct
						FROM   PersonLeaveBalance 
						WHERE  LeaveType            = '#LeaveType#'
						AND    PersonNo             = '#PersonNo#'
						<cfif itm eq "LeaveType">
						AND    LeaveTypeClass is NULL <!--- added to provide support for class balances ---> 
						<cfelse>
						AND    LeaveTypeClass       = '#itm#'
						</cfif>	  		
						AND    MONTH(DateEffective) = month(#START#) 
						AND    YEAR(DateEffective)  = year(#START#)							
					 </cfquery>					 
										 
					 <cfif Check.deduct neq "">
					 					 
						 <cfset tot = check.deduct+crd>
						 
						 <cfif tot gt full>
							  <cfset crd = full - check.deduct>
						 </cfif> 						
						
					 </cfif>	
										 
					 <cfset crd = crd - formulacorrection>  <!--- slwop --->
					 
					 <cfif crd lt 0>
					 	<cfset crd = 0>
					 </cfif>							 
				 
				 <cfelseif Credit.Calculation eq "day">			
					 			 
				 	 					 
				 	 <cfset mul = ((END - START + 1) - corr)/(daysInMonth(END))>
				     <cfset crd = mul * credit.CreditFull>
												 						 
					 <cfif crd lt 0.25>
					           <cfset crd = 0>						  
					 <cfelseif crd lt 0.75>
					           <cfset crd = 0.5>
					 <cfelseif crd lt 1.25>
					           <cfset crd = 1.0>	 
					 <cfelseif crd lt 1.75>
			    		       <cfset crd = 1.5>
				     <cfelseif crd lt 2.25>
			    		       <cfset crd = 2.0>		  
					 <cfelseif crd lt 2.75>
					           <cfset crd = 2.5>
					  <cfelseif crd lt 3.25>
					           <cfset crd = 3.0>	  
					 <cfelseif crd lt 3.75>
						       <cfset crd = 3.5>						
				     <cfelseif crd lt 4.25>
						       <cfset crd = 4.0>			   	  	  
					 <cfelse>
					      <cfset crd = round(crd)>	  
					 </cfif>
					 
				 <cfelse>
				 				
				 	<!--- define the number of working days between END and START and 
						devide this by the total number of working days in that month  					
					--->	
										
					<cfset BT  = 0>  <!--- Base time --->
					<cfset ST  = 0>  <!--- schedule time --->
					<cfset AT  = 0>  <!--- actual time counter as the record may have portions different from the month --->
					
					<cfset str = createDate(year(end),month(end),1)>
					<cfset dim = daysInMonth(END)-1>
															
					<cfset vDeduct = 0>							
																					
					<cfloop index="cnt" from="0" to="#dim#">	
										
						<cfset dte = dateAdd("d",cnt,str)>
						
						<!--- base counter --->
						
						<cfif dayofweek(dte) neq "1" and dayofweek(dte) neq "7">
							<cfset BT = BT + Credit.CreditFullDayHours>							
						</cfif>	
						
						<!--- schedule counter --->
																		
						<cfinvoke component = "Service.Process.Employee.Attendance"  
						   method           = "WorkDay" 
						   PersonNo         = "#PersonNo#"
						   MissionSchedule  = "#hasMissionSchedule#"
						   SalarySchedule   = "#SalarySchedule#"
						   CalendarDate     = "#dateformat(dte,client.dateformatshow)#"  		   	  
						   returnvariable   = "work">									 				 
						
						<cfset ST = ST + work.hours>		
																										
						<!--- actual time counter as the record may have portions different from the month --->
						
						<cfif dte gte START and dte lte END>										
							<cfset AT = AT + work.hours>							
							<cfset vDeduct = vDeduct + work.deduct>
						</cfif>
																								
					</cfloop>
																								
					 <!--- Schedule Time / Base time * CreditFull = Maximum (M) --->					
					 
			 		<cfset factor = credit.CreditFull>	
														 	
					 <cfset M = (ST/BT) * factor>
					 					
					 <cfif ST eq "0">					
						<cfset crd = 0>
					 <cfelse>						 						
					 	<!--- corr is correction based on SLWOP --->														
						<cfset crd = ((AT-corr)/ST) * M>						
					 </cfif>		
									 
					 <!---
					 <cfoutput>#str#:#AT#--#corr# #crd#-#m#-#factor#<br></cfoutput>									
					 --->					 
																								
					 <cfif ST EQ BT>	
											
						 <cfif crd lt 0.25>
						           <cfset crd = 0>		
						 <cfelseif crd lt 0.75>
						           <cfset crd = 0.5>		   				  
						 <cfelseif crd lt 1.25>
						           <cfset crd = 1>								   
						 <cfelseif crd lt 1.75>
						           <cfset crd = 1.50>		   
						 <cfelseif crd lt 2.25>
						           <cfset crd = 2.00>
						 <cfelseif crd lt 2.75>
						           <cfset crd = 2.50>
						 <cfelseif crd lt 3.25>
						           <cfset crd = 3>
						 <cfelseif crd lt 3.75>
						           <cfset crd = 3.50>
						 <cfelseif crd lt 4.25>
						           <cfset crd = 4.0>
						 <cfelse>
						      <cfset crd = round(crd)>	  
						 </cfif>
						 
					<cfelse>
																									
						  <cfif crd lt 0.25>
						           <cfset crd = 0>		
						 <cfelseif crd lt 0.75>
						           <cfset crd = 0.5>		   				  
						 <cfelseif crd lt 1.25>
						           <cfset crd = 1>								   
						 <cfelseif crd lt 1.75>
						           <cfset crd = 1.50>		   
						 <cfelseif crd lt 2.25>     <!--- Hanno : made a small change driven by Ann Kalledly if the person has a break in contract on June 1st 2018 --->
						           <cfset crd = 2.00>
						 <cfelseif crd lt 2.75>
						           <cfset crd = 2.50>
						 <cfelseif crd lt 3.25>
						           <cfset crd = 3>
						 <cfelseif crd lt 3.75>
						           <cfset crd = 3.50>
						 <cfelseif crd lt 4.25>
						           <cfset crd = 4.0>
						 <cfelse>
						      <cfset crd = round(crd)>	  
						 </cfif>						 	
					
					</cfif>	 
											 					 
				 </cfif>	
				 
				  <cfquery name="check" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					    SELECT  SUM(Credit) as Deduct
						FROM    PersonLeaveBalance WITH(NOLOCK) 
						WHERE   LeaveType            = '#LeaveType#'
						AND     PersonNo             = '#PersonNo#'
						<cfif itm eq "LeaveType">
						AND     LeaveTypeClass is NULL <!--- added to provide support for class balances ---> 
						<cfelse>
						AND     LeaveTypeClass       = '#itm#'
						</cfif>	  		
						AND     MONTH(DateEffective) = month(#START#) 
						AND     YEAR(DateEffective)  = year(#START#)							
					 </cfquery>					 
										 
					 <cfif Check.deduct neq "">
					 					 
						 <cfset tot = check.deduct+crd>
						 
						 <cfif tot gt credit.CreditFull>
							  <cfset crd = credit.CreditFull - check.deduct>
						 </cfif> 						
						
					 </cfif>	
				 				 
			</cfif>	 	 
			 		
		    <!--- 2.define leave taken to be processed---> 		
		   		 
			 <cfquery name="taken" dbtype="query">
				SELECT  *
				FROM    takenbase
			    WHERE   1=1
				<cfif itm neq "LeaveType">					
				<!--- we narrow the taken down to the class only --->
				AND    LeaveTypeClass = '#itm#'
				</cfif>	  						
				AND     (
				 
				 		 (DateEffective   <= #START# AND DateExpiration >= #START#)
						 
						 OR
						 
						 (DateEffective   >  #START# AND DateEffective  <= #END#)
											 
						 )
			  </cfquery>				 						 					 
								 
				 <!--- added provision for leave to be compensated 
				 by another leave like sick leave with annual leave compensation 27/11/2017 --->	
			
						 
			<cfset tkn = "0">

			<cfif leaveid eq "">
				<cfset leaveid = "00000000-0000-0000-0000-000000000000">
			</cfif>	
				 		 
			<cfloop query="Taken">		
																			 										 
			 	<cfquery name="checkdeduct" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">					 
				    SELECT   *					 
					FROM     PersonLeaveDeduct WITH(NOLOCK)
					WHERE    LeaveId       = '#id#'		
					AND      CalendarDate >= #START# 
					AND      CalendarDate <= #END#	 			 
				</cfquery>		
			 				 
			 	<cfif checkdeduct.recordcount gte "1">
				
					<!--- we have the leave deduction table filled and possibly adjusted --->
									
					<cfquery name="takendays" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					    SELECT   SUM(Deduction)	as Total				 
						FROM     PersonLeaveDeduct WITH(NOLOCK)
						WHERE    LeaveId       = '#id#'
						AND      CalendarDate >= #START# 
						AND      CalendarDate <= #END#							 			 			 									 			 			 																	 			 			 
					 </cfquery>		
					 
					 <cfif takendays.total neq "">					 
				 
						 <cfset tkn = tkn + takendays.total>					
					 
					 </cfif>
				
				<cfelse>				
										
					<cfif Mode eq "Regular">	

						<!--- define if the main record count is correct, bypassing it makes it faster --->			
													 	
						<cf_BalanceDays 
						       personno        = "#personNo#" 
					           LeaveType       = "#LeaveType#" 
							   leavetypeclass  = "#Leavetypeclass#" 
							   start           = "#dateformat(DateEffective,client.datesql)#" 
							   startfull       = "#DateEffectiveFull#" 
							   end             = "#dateformat(DateExpiration,client.datesql)#" 
							   endfull         = "#DateExpirationFull#">							
																	   
					   <cfif DaysDeduct neq days>
					 
						    <cfquery name="reset" 
						     datasource="AppsEmployee" 
						     username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
							    UPDATE PersonLeave
								SET    DaysDeduct = '#days#' 
								WHERE  LeaveId    = '#id#'					 			 
							</cfquery>		
						
						</cfif>
					
					</cfif>
									   		 
				 	<CF_DateConvert Value="#dateformat(dateeffective,CLIENT.DateFormatShow)#">
					<cfset eff = datevalue>
					
					<CF_DateConvert Value="#dateformat(dateexpiration,CLIENT.DateFormatShow)#">
					<cfset exp = datevalue>
				 		 		 
				 	<cfif eff lt start>
					
						<cfset startl = start>
						<cfset startfull = "1">
					
					<cfelse>
					
						<cfset startl = eff>	
						<cfset startfull = DateEffectiveFull>
					
					</cfif>
										
					<cfif exp gt end>
					
						<cfset endl = end>
						<cfset endfull = "1">
					
					<cfelse>
					
						<cfset endl = exp>	
						<cfset endfull = DateExpirationFull>		
					
					</cfif>		
										
					<cfif month(DateEffective) neq month(DateExpiration) 
						or dateEffective lt start or dateExpiration gt end>
										
						<!--- there is a need for calculation as the leave splits the month  --->
																						 
						<cf_BalanceDays 
						    personno       = "#personNo#"
						    leavetype      = "#leavetype#"
							leavetypeclass = "#leavetypeclass#"
						    start          = "#STARTL#" 
							startfull      = "#startfull#" 
							end            = "#ENDL#" 
							endfull        = "#endfull#">	
														
					<cfelse>					
										
							<cfset days = daysdeduct>	
													
					</cfif>					
																								 		 
				    <cfset tkn = tkn + days>					
									
				</cfif>					
			 
			</cfloop>	
			
			<!--- -------------------------------------------------------------- --->
			<!--- NEW provision to add taken days for compensation leave granted --->
			<!--- -------------------------------------------------------------- --->			
			
			<cfif itm eq "LeaveType">		
			
				<cfquery name="consumed" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
		    	 password="#SESSION.dbpw#">
				 					 
					 SELECT   P.*, 	
							  CompensationPointer, 				          
					          Leaveid as Id	 
					 FROM     PersonLeave P WITH(NOLOCK)
					          INNER JOIN Ref_LeaveTypeClass C WITH(NOLOCK) ON P.LeaveType = C.LeaveType AND P.LeaveTypeClass = C.Code 
					 WHERE    CompensationLeaveType = '#LeaveType#'		
					  		
					 AND      PersonNo       = '#PersonNo#'
					 <cfif leaveid neq "">
					 AND      LeaveId != '#leaveid#'
					 </cfif>
					 AND      (
					 
					 		  (DateEffective   <= #START# AND DateExpiration >= #START#)
							 
							  OR
							 
							  (DateEffective   >  #START# AND DateEffective  <= #END#)
												 
							  )
							 					 
					 AND      Status IN ('0','1','2')
					 					 
				</cfquery>	
										 		 
				<cfloop query="consumed">
														   		 
				 	<CF_DateConvert Value="#dateformat(dateeffective,CLIENT.DateFormatShow)#">
					<cfset eff = datevalue>
					
					<CF_DateConvert Value="#dateformat(dateexpiration,CLIENT.DateFormatShow)#">
					<cfset exp = datevalue>
				 		 		 
				 	<cfif eff lt start>
					
						<cfset startl = start>
						<cfset startfull = "1">
					
					<cfelse>
					
						<cfset startl = eff>	
						<cfset startfull = DateEffectiveFull>
					
					</cfif>
					
					<cfif exp gt end>
					
						<cfset endl = end>
						<cfset endfull = "1">
					
					<cfelse>
					
						<cfset endl = exp>	
						<cfset endfull = DateExpirationFull>		
					
					</cfif>
															
					<cfif month(consumed.DateEffective) neq month(consumed.DateExpiration) or CompensationPointer neq "100">											
												 
					<cf_BalanceDays 
					    calculationmode = "compensation" 
					    personno        = "#personNo#"
					    leavetype       = "#consumed.LeaveType#"
						leavetypeclass  = "#consumed.leavetypeclass#"
					    start           = "#STARTL#" 
						startfull       = "#startfull#" 
						end             = "#ENDL#" 
						endfull         = "#endfull#">	
						
					<cfelse>
																				
						<cfset days = daysdeduct>	
					
					</cfif>	
							 		 
				    <cfset tkn = tkn + days>					
											 
				</cfloop>	 
				
			</cfif>								
						
			<cfif getLeave.leaveAccrual eq "4" or itm neq "LeaveType">	  	
			
				<!--- threshold (classes) reduction will never go beyond the threshold --->
				
				<cfquery name="getEntitlement" 
		           datasource="AppsEmployee" 		   
		           username="#SESSION.login#" 
		           password="#SESSION.dbpw#">
					  	SELECT    TOP 1 * 
						FROM      Ref_LeaveTypeThreshold P
						WHERE     LeaveType = '#LeaveType#'	
						
						<cfif itm eq "LeaveType">
						AND    LeaveTypeClass is NULL <!--- added to provide support for class balances ---> 
						<cfelse>
						AND    LeaveTypeClass = '#itm#' 
						</cfif>	  						
											
						AND       Mission    IN (SELECT Mission
						                         FROM   PersonContract 
												 WHERE  PersonNo        = '#PersonNo#'		
												 AND    DateEffective  <= #END# 				
												 AND    DateExpiration >= #START#													
												 AND    ActionStatus != '9') 
									 
						AND       DateEffective <= #START# 								
						ORDER BY  DateEffective DESC												
				</cfquery>		
				
				<cfset pBAL = BAL+CRD+Balance>	
				
				<!--- initial balance correction --->
				<cfif ADJ gte CRD>
					<cfset CRD = CRD - ADJ>									
				</cfif>				
																 																		 
				 <cfif pBAL gt getEntitlement.Threshold and getEntitlement.Threshold neq "">												 
				        <cfset ADJ  = ADJ - (pBAL -  getEntitlement.Threshold)>
					    <cfset BAL  =  getEntitlement.Threshold - TKN>
					    <cfset Memo = "Threshold reduction">					 												
				 <cfelse>					 			
					 	<cfset BAL = BAL+ADJ+CRD-TKN+Balance>							
			     </cfif>  			 			 
								 
				 <cfif pBal lt getEntitlement.Threshold and CRD gt "0">				
								 
				 	<cfset ADJ = ADJ + (pBal - getEntitlement.Threshold)>
					<cfset Memo = "Threshold correction">					
					<cfset BAL = BAL - (pBal - getEntitlement.Threshold)>
					
				 </cfif>
				 
			<!--- ------------------------- --->	
		  	<!--- ---BALANCE CORRECTION---- --->
			<!--- ------------------------- --->  		
			   
		    <cfelseif getLeave.leaveAccrual eq "2">	
			
				 <!--- OVERTIME records --->	
			
				 <!--- A. Determine the credits of the last [var] months --->
					
				<cfset date = dateAdd("m",Credit.AccumulationPeriod*-1, start)>
				
				<cfquery name="getOvertime" 
		           datasource="AppsEmployee" 		   
		           username="#SESSION.login#" 
		           password="#SESSION.dbpw#">
				  	SELECT    SUM(OvertimeHours) AS Hours
					FROM      Payroll.dbo.PersonOvertime
					WHERE     PersonNo             = '#PersonNo#' 
					AND       OvertimePeriodStart >= #Date# 
					AND       OvertimePeriodStart <= #END# 		
					AND       Status IN ('2','3','5')			
					AND       OvertimePayment       = 0	
					
				</cfquery>
				
				<!---
				
				<cfif getOvertime.Hours gt "0">
					<cfset max = getOvertime.Hours>
				<cfelse>
				    <cfset max = 0>
				</cfif>	
				
				--->
				
				<!--- hanno to be adjusted --->
				
				<cfset MAX = Credit.MaximumBalance>
				
				<!--- B. determine the balance and lower it accordingly based on A. --->	
				
				<cfif BAL gt MAX>
								
				    <cfset ADJ  = ADJ - (BAL - MAX)>
				    <cfset BAL  = Credit.MaximumBalance>
				    <cfset Memo = "MAX Correction">
				    <cfset BAL = BAL+CRD-TKN+Balance>	
									
			    <cfelse>
								
				 	<cfset BAL = BAL+ADJ+CRD-TKN+Balance>		
					
				</cfif>	  
					
			<cfelse> 	
									
				<!--- ANY OTHER records 	
				<cfoutput>#ADJ#</cfoutput>
				--->
									
				
				<!--- here we apply the bingo correction --->
																
				<cfif Initial.DateEffective eq "">
					<cfset initmth = 0>
				<cfelse>
				    <cfset initmth = Month(Initial.DateEffective)>
				</cfif>				
																								
				<cfif Credit.CarryOverOnMonth eq "0" AND Month(START) eq initmth and Day(START) eq "1"> 	 
										
					 <cfif BAL gt CarryOverMaximum and CarryOverMaximum neq "">
					 
				        <cfset ADJ  = ADJ - (BAL - Credit.CarryOverMaximum)>
					    <cfset BAL  = Credit.CarryOverMaximum>
					    <cfset Memo = "Carry-over reduction">
						<cfset BAL = BAL+CRD-TKN+Balance>		
									
					 <cfelse>
					 
					 	<cfset BAL = BAL+ADJ+CRD-TKN+Balance>		
						
				     </cfif>  
			      
				<cfelseif Credit.CarryOverOnMonth eq Month(START) and Day(START) eq "1">				  	
					
				     <cfif BAL gt CarryOverMaximum and CarryOverMaximum neq "">
					 
				        <cfset ADJ  = ADJ - (BAL - Credit.CarryOverMaximum)>
					    <cfset BAL  = Credit.CarryOverMaximum> <!--- new balance --->
					    <cfset Memo = "Carry-over reduction">
						<cfset BAL = BAL+CRD-TKN+Balance>							
						
					 <cfelse>						 
					 
					 	<cfset BAL = BAL+ADJ+CRD-TKN+Balance>		
						
				     </cfif>  
			  
				<cfelse>
			  
				     <cfif BAL gt Credit.MaximumBalance and Credit.MaximumBalance neq "">
					 
				        <cfset ADJ  = ADJ - (BAL - Credit.MaximumBalance)>
					    <cfset BAL  = Credit.MaximumBalance>
					    <cfset Memo = "MAX Correction">
				        <cfset BAL = BAL+CRD-TKN+Balance>		
									
					 <cfelse>
					 
					 	<cfset BAL = BAL+ADJ+CRD-TKN+Balance>		
						
				     </cfif>  
			  
			    </cfif>	
				
			</cfif>	
				
			<!--- ----------------------- --->	
		  	<!--- ---3.register record--- --->
			<!--- ----------------------- --->	   
			   
		     <cfquery name="check" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT     BalanceId
				 FROM       PersonLeaveBalance
				 WHERE      PersonNo = '#PersonNo#'
				 AND        LeaveType = '#LeaveType#'
				  <cfif itm neq "leavetype">
				 AND        LeaveTypeClass = '#itm#'
				 <cfelse>
				 AND        LeaveTypeClass is NULL
				 </cfif>
				 AND        DateEffective = #START#
			  </cfquery>		  	 
			  			  
			  <cfif check.recordcount eq "0">	 
			  						  
				   <cftry>	  
				   
					   <cfif START gte END>
					       <cfset END = START>
					   </cfif>
					   					   				     
					   <cfquery name="insert" 
					     datasource="AppsEmployee" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						 								    			 			
						    INSERT INTO PersonLeaveBalance (
							       PersonNo,
								   LeaveType, 
								   Mission,
								   <cfif itm neq "leavetype">
								   LeaveTypeClass,
								   </cfif>
								   DateEffective, 
								   DateExpiration, 
								   ContractType, 
						 		   UoM, 
								   Adjustment, 
								   Credit, 
								   Taken, 
								   Balance,
								   Memo)
								 
					        VALUES ('#PersonNo#',
									'#LeaveType#',
									'#Mission#',
									<cfif itm neq "leavetype">
									'#itm#', 
									</cfif>
									#START#,
									#END#,
									'#Contract.ContractType#',
								    'Day',    <!--- better to take the variable --->
									'#ADJ#',
									'#CRD#',
									'#TKN#',
									'#BAL#',
									'#Memo#') 
							
					   </cfquery>  	    
				  
				  	   <cfcatch></cfcatch>
				   
				   </cftry>	   	
			   
			 </cfif>    
			  	   	   
	   </cfif>	
		       	
</cfif>