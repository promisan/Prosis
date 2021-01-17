
<!--- 
   Name : /Component/Employee/Attendance.cfc
   Description : Execution procedures
   
   1.1.  Define balance lines
   1.2	Calculate the line    
      
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Attendance Action">
	
	<cffunction name="SlotAudit"
             access="public"
             returntype="any"
             displayname="Audit log of the slot">
			 
			 <cfargument name="HourSlotId"  type="string"  required="true"   default="">
			 <cfargument name="Mode"        type="string"  required="true"   default="Edit">
			 
			 <cfquery name="get" 
	         datasource="AppsEmployee" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
		         SELECT  *
		         FROM    PersonWorkDetail
				 WHERE   HourSlotId = '#HourSlotId#'				
		    </cfquery>
			
			<cfquery name="last" 
	         datasource="AppsEmployee" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
			 	 SELECT  TOP 1 SerialNo
		         FROM    PersonWorkLog
				 WHERE   PersonNo     = '#get.PersonNo#'
				 AND     CalendarDate = '#get.CalendarDate#'	
				 ORDER BY SerialNo DESC
			</cfquery>
			
			<cfif last.recordcount eq "0">
				<cfset next = 1>
			<cfelse>
				<cfset next = last.serialNo + 1>
			</cfif> 
			
			<cfquery name="insert" 
	         datasource="AppsEmployee" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">				 
		         INSERT INTO PersonWorkLog
						 (PersonNo, 
						  CalendarDate, 
						  SerialNo, 
						  TransactionType, 
						  CalendarDateHour, 
						  HourSlot, 
						  Action, 
						  ActionValue, 
						  OfficerUserId, 
						  OfficerLastName, 
                          OfficerFirstName)
				 VALUES  ('#get.PersonNo#',
						  '#get.CalendarDate#',
						  '#next#',
						  '#get.TransactionType#',
						  '#get.CalendarDateHour#',
						  '#get.HourSlot#',
						  'Amendment',
						  '',
						  '#session.acc#',
						  '#session.last#',
						  '#session.first#')						
		    </cfquery>	
			 
	</cffunction>		 
	
	<cffunction name="WorkDay"
             access="public"
             returntype="any"
             displayname="Determine if a date/day portion is considered as a workday for a person for leave deduction">
			 
    	<!--- dates are passed in SQL value or universal format --->
				
		<cfargument name="PersonNo"         type="string"  required="true"   default="">
		<cfargument name="Mission"          type="string"  required="false"  default="">	
		<cfargument name="SalarySchedule"   type="string"  required="true"   default="">
		<cfargument name="MissionSchedule"  type="string"  required="true"   default="1">  <!--- just a way to complete didable it, no longer used --->
		<cfargument name="CalendarDate"     type="date"    required="true">  <!--- euro format --->			
		<cfargument name="DayMode"          type="string"  required="true"   default="">  <!--- AM | PM | [blank] --->	
				
		<cfsetting requesttimeout="5000">
				
		<!--- in order to determine if a workday has to be counted for leave deduction there are 3 levels in the below order 
		
		- Level 1 : NEW !
				first we check if for a person there is a concrete timeschedule set
				 in the table PersonWork.TransactionType = '2' for this date. This indicates the person indeed is supposed to work
				 on that date.
				 
		- Level 2 :
				we check if the person has a fixed schedule set in the table PersonWorkSchedule and if it applies for today	
				
		- Level 3 :
				we fall back to a default schema as it was set up for the salaryschedule Payroll.dbo.SalaryScheduleWork  schema which applies for the main stream --->			 
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#CalendarDate#">
		<cfset DTE = dateValue>
		
		<cfset dow = dayOfWeek(dte)>
		
		<!--- default schedule, mon - friday --->
		
		<cfset schedulemode = "3">
								
		<cfif MissionSchedule eq "1">
		
			<!--- check if there is a specific workplan for this person in this month --->
		
			<cfquery name="hasSchedule" 
	         datasource="AppsEmployee" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
		         SELECT  TOP 1 *
		         FROM    PersonWork
		         WHERE   PersonNo = '#PersonNo#'
				 AND     TransactionType     = '2'
				 AND     YEAR(CalendarDate)  = #year(dte)#
				 AND     MONTH(CalendarDate) = #month(dte)#				
		    </cfquery>
			
			<cfif hasSchedule.recordcount gte "1">		
			
				<cfset schedulemode = "1">		
							
			<cfelse>
			
				<!--- mostly for part-timers 
				    or irregular workers in the default schedule --->
							
				<cfquery name="hasSchedule" 
		         datasource="AppsEmployee" 
		         username="#SESSION.login#" 
		         password="#SESSION.dbpw#">
			         SELECT   TOP 1 *
			         FROM     PersonWorkSchedule 
			         WHERE    PersonNo = '#PersonNo#'
					 AND      DateEffective <= #dte#
					 <cfif mission neq "">
					 AND      Mission = '#mission#'
					 </cfif>
					 ORDER BY DateEffective DESC
			    </cfquery>
				
				<cfif hasSchedule.recordcount gte "1">
									
					<cfset schedulemode = "2">			
				
				</cfif>
							
			</cfif>	
									
		</cfif>
		
		<cfset work.deduct = "0">
		<cfset work.hours  = "0">		
								
		<cfif schedulemode eq "3">
						
		   <!--- we are going into the default mode --->
		  
		   <!--- no schedule defined, then we take the default PAYROLL schedule --->		   
		    			 
			 <cfquery name="PaySchedule" 
		         datasource="AppsEmployee" 
		         username="#SESSION.login#" 
		         password="#SESSION.dbpw#">
		         SELECT   *
		         FROM     Payroll.dbo.SalaryScheduleWork 
		         WHERE    SalarySchedule = '#SalarySchedule#'
			     AND      WeekDay = '#dow#'				 
		     </cfquery>								
			 			 
			 <cfif PaySchedule.recordcount eq "1">
			 
				 <cfif PaySchedule.WorkHours gte "4">
				 				 
				 	 <cfset work.deduct = "1">
					 <cfset work.hours  = PaySchedule.WorkHours>
				 
				 <cfelse>
				 				 
				 	 <cfset work.deduct = "0">
					 <cfset work.hours  = PaySchedule.WorkHours>
				 	
				 </cfif>
				
			 <cfelse>
			 
			  	   <!--- if no payroll schedule then a pure default 
				       based on mon-fri 7.5 hours --->
	   
			        <cfif dow gt "1" and dow lt "7">
					
						 <cfset work.deduct = "1">
					 	 <cfset work.hours  = "7.5">
					
					<cfelse>
					
						 <cfset work.deduct = "0">
					 	 <cfset work.hours  = "7.5">
					 
					</cfif>	
			 
			 </cfif>	
			 	
			 <cfif daymode neq "">
			 	<cfset work.deduct = 0.5*work.deduct>
			 </cfif>
		  		
		<cfelseif schedulemode eq "1">
			
				<!--- detailed schedule mode we first detect how the workschedule is organised --->
				
				<cfquery name="getPlanStart" 
		         datasource="AppsEmployee" 
		         username="#SESSION.login#" 
		         password="#SESSION.dbpw#">
			         SELECT   MIN(CalendarDateHour) as WorkStart
			         FROM     PersonWorkDetail 
			         WHERE    PersonNo      = '#PersonNo#'
					 AND      CalendarDate  = #dte#
					 AND      TransactionType = '2'	<!--- work is scheduled --->							 					 
			    </cfquery>
				
				<cfif getPlanStart.Workstart eq "">
				    <cfset cutoff = "12">
				<cfelse> 
					<cfset cutoff = getPlanStart.Workstart+4>
				</cfif>	
			
				<cfquery name="getSchedule" 
		         datasource="AppsEmployee" 
		         username="#SESSION.login#" 
		         password="#SESSION.dbpw#">
			         SELECT   SUM(HourSlotMinutes)/60 as Hours
			         FROM     PersonWorkDetail 
			         WHERE    PersonNo      = '#PersonNo#'
					 AND      CalendarDate  = #dte#
					 AND      TransactionType = '2'	<!--- workscheduled --->							 
					 <cfif DayMode eq "">
					 <cfelseif DayMode eq "AM">
					 AND      CalendarDateHour < #cutoff#
					 <cfelseif DayMode eq "PM">
					 AND      CalendarDateHour >= #cutoff#				 
					 </cfif>		 
			    </cfquery>				
															
				<cfif DayMode eq "">
								
					<cfif getSchedule.Hours gte "10">					
						<cfset work.deduct = "1.5">
						<cfset work.hours  = getSchedule.Hours>									
					<cfelseif getSchedule.Hours gte "6">
						<cfset work.deduct = "1">
						<cfset work.hours  = getSchedule.Hours>					
					<cfelseif getSchedule.Hours gte "3">
					    <cfset work.deduct = "0.5">
						<cfset work.hours  = getSchedule.Hours>					
					</cfif>	
					
				<cfelseif DayMode eq "AM">
												
					<cfif getSchedule.Hours gte "5">					
						<cfset work.deduct = "0.75">
						<cfset work.hours  = getSchedule.Hours>		
					<cfelseif getSchedule.Hours gte "3">
						<cfset work.deduct = "0.5">
						<cfset work.hours  = getSchedule.Hours>
					</cfif>	
				
				<cfelse>
					<cfif getSchedule.Hours gte "5">					
						<cfset work.deduct = "0.75">
						<cfset work.hours  = getSchedule.Hours>		
					<cfelseif getSchedule.Hours gte "3">
						<cfset work.deduct = "0.5">
						<cfset work.hours  = getSchedule.Hours>
					</cfif>				
				
				</cfif>
			
			<cfelseif schedulemode eq "2">	
								
				<!--- weekly schedule defined --->		
						
				<cfquery name="getSchedule" 
		         datasource="AppsEmployee" 
		         username="#SESSION.login#" 
		         password="#SESSION.dbpw#">
			         SELECT   COUNT(CalendarDateHour) as Hours, MAX(HourSlots) as Slots 
			         FROM     PersonWorkSchedule 
			         WHERE    PersonNo      = '#PersonNo#'
					 AND      DateEffective = '#hasSchedule.DateEffective#'
					 AND      Mission       = '#hasSchedule.Mission#'
					 AND      WeekDay       = '#dow#'				 
					 <cfif DayMode eq "">
					 <cfelseif DayMode eq "AM">
					 AND      CalendarDateHour <= 12
					 <cfelseif DayMode eq "PM">
					 AND      CalendarDateHour > 12				 
					 </cfif>		 
			    </cfquery>
																												
				<cfif getSchedule.Hours gte "1">
				
					<cfset timeworked = getSchedule.Hours / getSchedule.Slots>
													
					<cfif DayMode eq "">
												
						<cfif timeworked gte "6">
							<cfset work.deduct = "1">
							<cfset work.hours  = timeworked>					
						<cfelseif timeworked gte "3">
						    <cfset work.deduct = "0.5">
							<cfset work.hours  = timeworked>					
						</cfif>	
						
					<cfelseif DayMode eq "AM">
					
						<cfif timeworked gte "3">
							<cfset work.deduct = "0.5">							
							<cfset work.hours  = round(timeworked)>
						</cfif>	
					
					<cfelse>
					
						<cfif timeworked gte "3">
							<cfset work.deduct = "0.5">							
							<cfset work.hours  = round(timeworked)>
						</cfif>				
					
					</cfif>
					
				<cfelse>
				
					<cfset work.deduct = "0.0">
					<cfset work.hours  = "0">
								
				</cfif>							
									
		</cfif>
						 
		<cfreturn work>		 
			 
	</cffunction>
	
	<cffunction name="LeaveConflict" access="public" returntype="struct" displayname="Verify if there is a overlap conflict">
			 
			 <cfargument name="PersonNo"            type="string"  required="true"    default="">	
			 <cfargument name="Mission"             type="string"  required="false"   default="">
			 <cfargument name="LeaveType"           type="string"  required="true"    default="">
			 <cfargument name="CurrentLeaveId"      type="string"  required="false"   default="">
			 <cfargument name="DateEffective"       type="string"  required="true"    default="#dateformat(now(),client.dateformatshow)#">		
			 <cfargument name="DateEffectiveFull"   type="string"  required="true"    default="1">				 
			 <cfargument name="DateEffectiveHour"   type="string"  required="true"    default="0">
			 <cfargument name="DateExpiration"      type="string"  required="true"    default="#dateformat(now(),client.dateformatshow)#">	
			 <cfargument name="DateExpirationFull"  type="string"  required="true"    default="1">
			 <cfargument name="DateExpirationHour"  type="string"  required="true"    default="0">	
			 
			 <cfset conflict.overlap = "0">
			 
			 <!--- we loop through the date and see if we can find a conflict record --->
			 
			 <cfset dateValue = "">
			 <CF_DateConvert Value="#DateEffective#">
			 <cfset EFF = dateValue>	
		
			 <cfset dateValue = "">
			 <CF_DateConvert Value="#DateExpiration#">
			 <cfset EXP = dateValue>	
			 
			 <cfset days = dateDiff("d",  EFF,  EXP)>
			 
			 <cfloop index="itm" from="0" to="#days#">
			 			 			 
			 	<cfset dte = dateAdd("d",itm,eff)>
				
				<cfif conflict.overlap eq "0">
												
					<!--- check if there is a leave request on this date 
							if there is a leave request we dig deeper						
					--->
					
					<cfquery name="getRecord" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
		    	    password="#SESSION.dbpw#">
					
			    	    SELECT *
			        	FROM   PersonLeave
			    		WHERE  PersonNo  = '#PersonNo#'
						<cfif mission neq "">
						AND    Mission   = '#Mission#'
						</cfif>
						AND    LeaveType IN (SELECT LeaveType 
						                     FROM   Ref_LeaveType R INNER JOIN Ref_TimeClass T ON R.LeaveParent = T.TimeClass
											 AND    TimeParent = 'Absent')
											 					
						AND    DateEffective  <= #DTE# 
						AND    DateExpiration >= #DTE#		
						AND    Status IN ('0','1','2','3')	
						<cfif currentleaveId neq "">
						AND    LeaveId != '#currentLeaveId#'			
						</cfif>												
					
		     		</cfquery> 
															
					<cfif getRecord.recordcount gte "1">
					
						<cfif dte eq eff>
						
							<cfif DateEffectiveHour eq "6">
								<cfset reqpart = "AM">
							<cfelseif DateEffectiveHour eq "12">	
							    <cfset reqpart = "PM">
							<cfelseif DateEffectiveFull eq "0">
								<cfset reqpart = "PM">	
							<cfelse>
								<cfset reqpart = "FL">	
							</cfif>
												
						<cfelseif dte eq exp>
						
							<cfif DateExpirationHour eq "6">
								<cfset reqpart = "AM">  <!--- not used yet --->
							<cfelseif DateExpirationHour eq "12">	
							    <cfset reqpart = "PM">  <!--- not used yet --->
							<cfelseif DateExpirationFull eq "0">
								<cfset reqpart = "AM">	
							<cfelse>
								<cfset reqpart = "FL">		
							</cfif>
						
						<cfelse>
						
							<cfset reqpart = "FL">	
										
						</cfif>
						
						<cfloop query="getRecord">
						
							<cfif conflict.overlap eq "0">
						
								<cfif dte eq getRecord.DateEffective>
														
									<cfif getRecord.DateEffectiveHour eq "6">
										<cfset actpart = "AM">
									<cfelseif getRecord.DateEffectiveHour eq "12">	
									    <cfset actpart = "PM">
									<cfelseif getRecord.DateEffectiveFull eq "0">
										<cfset actpart = "PM">	
									<cfelse>
										<cfset actpart = "FL">	
									</cfif>
								
									<cfif actpart eq "FL" or reqpart eq "FL" or reqpart eq actpart>
										<cfset conflict.overlap = "1">	
										<cfset conflict.record  = leaveid>						
									</cfif>
														
								<cfelseif dte eq getRecord.dateExpiration>
								
									<cfif getRecord.DateExpirationHour eq "6">
										<cfset actpart = "AM">  <!--- not used yet --->
									<cfelseif getRecord.DateExpirationHour eq "12">	
									    <cfset actpart = "PM">  <!--- not used yet --->
									<cfelseif getRecord.DateExpirationFull eq "0">
										<cfset actpart = "AM">	
									<cfelse>
										<cfset actpart = "FL">		
									</cfif>
									
									<cfif actpart eq "FL" or reqpart eq "FL" or reqpart eq actpart>
										<cfset conflict.overlap = "1">		
										<cfset conflict.record  = leaveid>					
									</cfif>
								
								<cfelse>
								
									<cfset conflict.overlap = "1">	
									<cfset conflict.record  = leaveid>	
																				
								</cfif>		
							
							</cfif>			
						
						</cfloop>				
					
					</cfif>		
					
				</cfif>	 
			 				 				
				<!--- check if there is a leave request on this date --->
			  			 
			 </cfloop>
			 
			 <cfif conflict.overlap eq "1">
			 
				 <cf_tl id="Problem, you are trying to submit a leave request that overlaps with an existing request" var="vOverlap">
				 
				 <cfset conflict.message = voverlap>
			  
				 <cfquery name="getOverlap" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
			        password="#SESSION.dbpw#">
			    	    SELECT *
			        	FROM   PersonLeave L INNER JOIN Ref_LeaveType R ON L.LeaveType = R.LeaveType
						WHERE  Leaveid = '#conflict.record#'	    						
			     </cfquery> 
			 							 
				 <cfif getOverlap.dateEffective neq getOverlap.dateExpiration>
				 
					 <cfif getOverlap.DateEffectiveFull eq "0">
					     <cfset stm = "PM">
					 <cfelse>
					     <cfset stm = "FULL">
					 </cfif> 
					 
					 <cfif getOverlap.DateExpirationFull eq "0">
					 	<cfset ptm = "AM">
					 <cfelse>
						<cfset ptm = "FULL">
					 </cfif> 
				 
					 <cfset detail = "#getOverlap.Description# : #dateformat(getOverlap.dateeffective,client.dateformatshow)# #stm# - #dateformat(getOverlap.dateexpiration,client.dateformatshow)# #ptm#">
					 
				 <cfelse>
				 
				 	 <cfif getOverlap.DateEffectiveHour eq "6">
					     <cfset stm = "AM">
					 <cfelseif getOverlap.DateEffectiveHour eq "12">
					     <cfset stm = "PM">
					 <cfelse>	
					     <cfset stm = "FULL"> 
					 </cfif>	 
					 
					 <cfset detail = "#getOverlap.Description# : #dateformat(getOverlap.dateeffective,client.dateformatshow)# #stm#">	
					 
				 </cfif>	
				 
				  <cfset conflict.content = detail> 
				  
			 </cfif>	  
			 			 			 
			 <cfreturn conflict>				 
			 
	</cffunction>		 
	
	<cffunction name="LeaveAttendance"
             access="public"
             returntype="any"
             displayname="Merges leave records into the attendance structure">
			 
		<cfargument name="PersonNo"         type="string"  required="true"    default="">		
		<cfargument name="Mission"          type="string"  required="false"   default="">	 <!--- mission of where leave is used --->	
		<cfargument name="MissionSchedule"  type="string"  required="true"    default="1">   <!--- no longer used 29/9/2018 --->
		<cfargument name="StartDate"        type="date"    required="true"    default="#dateformat(now(),client.dateformatshow)#">		
		<cfargument name="EndDate"          type="date"    required="true"    default="#dateformat(now(),client.dateformatshow)#">	
		<cfargument name="From"             type="numeric" default="0"        required="yes">		
		<cfargument name="Days"             type="numeric" default="0"        required="yes">		
		<cfargument name="Mode"             type="string"  default="regular"  required="yes">		
		<cfargument name="LeaveList"        type="query"   required="no">	
		
		<!--- META code --->
		<!---
		
		1. Define the attendance schedule mode
		
		- 3. standard mon - fri schedule + 8 hours : as set in the defaults 
		- 2. alternate schedule, used for part-time 
		- 1. granular schedule as set for security staff on a per person basis (NOT on the position)) based on activities that may vary
						
		2. Obtain the leave records of this person 
		
		3. Loop through the days for each person which is passed
		
			3.1  reset the workday
			3.2  check if indeed working on this date as assignment
			3.3  define how many hours this person is supposed to work based on the schedulemode (3,2,1) 
			3.4  if the person has work and he/she has more than 1 hour then we start
				3.4.1   Person has some leave on this date recorded (not cancelled)
				3.4.2.  Official Holiday
				3.4.3.  Normal day tp be considered for work 
				
		--->
				
		<cfset dateValue = "">
		<CF_DateConvert Value="#StartDate#">
		<cfset DTE = dateValue>	
				
		<!--- default mon-fri corporate schedule --->
		<cfset schedulemode = "3">	
							
		<cfif MissionSchedule eq "1">
				
			<!--- check if there is a workplan for this person this month --->
		
			<cfquery name="hasPersonalSchedule" 
	         datasource="AppsEmployee" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
		         SELECT  TOP 1 *
		         FROM    PersonWork
		         WHERE   PersonNo            = '#PersonNo#'
				 AND     TransactionType     = '2'
				 AND     YEAR(CalendarDate)  = #year(dte)#
				 AND     MONTH(CalendarDate) = #month(dte)#				
		    </cfquery>
			
			<cfif hasPersonalSchedule.recordcount gte "1">		
			
				<cfset schedulemode = "1">				
			
			<cfelse>
										
				<cfquery name="hasSchedule" 
		         datasource="AppsEmployee" 
		         username="#SESSION.login#" 
		         password="#SESSION.dbpw#">
			         SELECT   TOP 1 *
			         FROM     PersonWorkSchedule 
			         WHERE    PersonNo = '#PersonNo#'
					 AND      DateEffective <= #dte#					
					 <cfif mission neq "">
					 AND      Mission = '#mission#'
					 </cfif>
					 ORDER BY DateEffective DESC
			    </cfquery>
				
				<cfif hasSchedule.recordcount gte "1">			
													
					<cfset schedulemode = "2">
				
				</cfif>
							
			</cfif>	
									
		</cfif>					
		
		<CF_DateConvert Value="#StartDate#">		
		<cfset start = dateValue>
				
		<cfif Days eq "0">			
		
			<CF_DateConvert Value="#EndDate#">		
			<cfset end  = dateValue>		
			
			<cfif mode eq "Reset">
			
				<!--- A. we are going to reset all actual transactiontype = 1 data if there is underlying
				attendance data found which will overwrite its content for TransactionType = '1' ---> 
									
				<!--- B. we are going to reset all actual transactiontype = 1 data if there is underlying
				leave data found which will overwrite its content for TransactionType = '1' ---> 
			
				<cfquery name="Delete" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#">					
				    DELETE PersonWork
					FROM   PersonWork P
					WHERE  PersonNo      = '#PersonNo#' 
					AND    CalendarDate >= #start#
					AND    CalendarDate <= #end#										
					AND    TransactionType = '1'  
					<!--- we only recalculate if there is or was a leave record --->
					AND    EXISTS (SELECT 'X'
					               FROM    PersonLeave
								   WHERE   PersonNo = P.PersonNo
								   AND     Status NOT IN ('8','9')  <!--- restored by hanno and included 8 --->
								   AND     DateEffective <= P.CalendarDate 
								   AND     DateExpiration >= P.CalendarDate)		
								   
								   				
					   								
			   </cfquery>
			   		   
		    </cfif>
			
					
													
			<cfset days = dateDiff("d",start,end)>	
											
			<cfquery name="LeaveList" 
			datasource="AppsEmployee" 		
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
		        SELECT  L.LeaveId, 
				        L.Mission, 
						L.OrgUnit, 
						L.PersonNo, L.LeaveType, L.LeaveTypeClass, 
						L.DateEffective, L.DateEffectiveHour, L.DateEffectiveFull, 
						L.DateExpiration, L.DateExpirationHour, L.DateExpirationFull, 
						T.CompensationLeaveType, T.CompensationPointer, T.PointerLeave,
						R.LeaveParent
						
			    FROM    PersonLeave L 
				        INNER JOIN Ref_LeaveType R ON L.LeaveType   = R.LeaveType
						INNER JOIN Ref_TimeClass C ON R.LeaveParent = C.TimeClass
						INNER JOIN Ref_LeaveTypeClass AS T ON L.LeaveType = T.LeaveType AND L.LeaveTypeClass = T.Code
						
				WHERE   PersonNo = '#PersonNo#'
				AND     Mission  = '#Mission#'			   		
				AND     L.Status IN ('0','1','2')
				AND     L.TransactionType IN ('Request','Manual','External')
				AND     L.DateEffective   <= #end#
				AND     L.DateExpiration  >= #start#	
							
			</cfquery>
			
		<cfelse>
		
		 <cfif mode eq "Reset">
									
				<!--- we are going to reset all actual transactiontype = 1 data of work and leave  --->
			
				<cfquery name="Delete" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#">					
				    DELETE FROM PersonWork
					WHERE  PersonNo            = '#PersonNo#'
					AND    YEAR(CalendarDate)  = #year(dte)#
				    AND    MONTH(CalendarDate) = #month(dte)#								
					AND    TransactionType = '1'  					
			   </cfquery>
		   
		   </cfif>	
		
		</cfif>
								
		<cfquery name="param"
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_ParameterMission
				WHERE   Mission = '#mission#'	
		</cfquery>
		
		<cfquery name="Parameter" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   	SELECT   *  
				FROM     Parameter 
		</cfquery>
		
		<!---
		<cftransaction isolation="READ_UNCOMMITTED">			 
		--->
		   		   
		   <!--- check if person has an assignment on that date in the mission  --->
		   
		   <cfquery name="Assignments"
		     datasource="AppsEmployee" 
			 username="#SESSION.login#" 
		     password="#SESSION.dbpw#">				  
			    SELECT 	P.Mission        as PositionMission,
						P.LocationCode   as PositionLocation,						
						O.Mission        as AssignmentMission,		
						O.OrgUnitName    as AssignmentOrgUnitName, 		
						O.WorkSchema     as WorkSchema,								
						A.LocationCode   as AssignmentLocation,						
						A.*						
			   	FROM 	PersonAssignment A 
				        INNER JOIN Position P ON A.PositionNo = P.PositionNo 
						INNER JOIN Organization.dbo.Organization O ON A.OrgUnit = O.OrgUnit
				WHERE	A.PersonNo         = '#PersonNo#'
				AND     A.DateEffective   <= #end#
				AND     A.DateExpiration  >= #start#					
				AND     O.Mission           = '#mission#'  <!--- entity/unit were person is attending --->		
				-- AND     A.Incumbency       > '0'
				AND     A.AssignmentStatus IN ('0','1')   <!--- planned and approved --->
			    -- AND     A.AssignmentClass  = 'Regular'
			    AND     A.AssignmentType   = 'Actual'		  	
		   </cfquery>		
		   
		
	   <!---	   
	   </cftransaction>	  
	   --->
	   									
		<cfloop index="count" from="#From#" to="#days#" step="1">	
						     
			<cfset datesel = dateAdd("d",count,start)>		   
		   
		    <!--- check if work of person already exists --->
					   
			<cfquery name="hasWork" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				    SELECT  PersonNo
					FROM 	PersonWork
					WHERE   PersonNo           = '#PersonNo#'	
					AND     CalendarDate       = #DateSel#     
					AND     TransactionType    = '1'  			
			   </cfquery>				   
			  			   
		   <cfquery name="hasAssignment" dbtype="query">
		   		SELECT 	*
			   	FROM 	Assignments
				WHERE	DateEffective    <= #DateSel# 
				AND     DateExpiration   >= #DateSel#		
			</cfquery>				   
		   
		   <!--- tune this to make it faster 
		   <cfoutput>#cfquery.executiontime#</cfoutput>
		   --->
		   
		   <!--- --------------------------------------------------------------------------------- --->
		   <!--- we obtain the available workschedule hours of the person for this day of the week --->
		   <!--- --------------------------------------------------------------------------------- --->
		   
		   <cfif schedulemode eq "1">
		   
		   		<!--- obtain from the personal schedule the hours --->
				
				<cfquery name="hasPersonalSchedule" 
		         datasource="AppsEmployee" 
		         username="#SESSION.login#" 
		         password="#SESSION.dbpw#">
			         SELECT  SUM(HourSlotMinutes)/60 as Hours
			         FROM    PersonWorkDetail
			         WHERE   PersonNo          = '#PersonNo#'
					 AND     TransactionType   = '2'
					 AND     CalendarDate      = #DateSel#								
			    </cfquery>
		   
		   	    <cfif hasPersonalSchedule.Hours eq "">
				    <!--- to ensure that if a person is on leave it is reflected --->
				    <cfset dayhours = Parameter.HoursInDay>
				<cfelse>
			   		<cfset dayhours = hasPersonalSchedule.Hours>
				</cfif>	
				
	       <cfelseif schedulemode eq "2">
		   
		   				   
			   	<cfquery name="getValidSchedule" 
					datasource="AppsEmployee" 		
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT    TOP 1 *
						FROM 	  PersonWorkSchedule PWS
						WHERE     PersonNo      = '#PersonNo#'	
						AND       Mission       = '#mission#' 
						AND       DateEffective <= #DateSel#
						<!--- get the last enabled schedule to validly see if we have day --->
						AND       DateEffective >= (SELECT   MAX(DateEffective)
													FROM     PersonWorkSchedule S 
													WHERE    PersonNo         = PWS.PersonNo
													AND      Mission          = PWS.Mission
													AND      DateEffective   <= #DateSel#)
						AND       WeekDay        = #DayOfWeek(DateSel)#		
						ORDER BY  DateEffective DESC	
				</cfquery>	
				
				<cfif getValidSchedule.recordcount gte "1">
				
					<cfquery name="getPersonSchedule" 
						datasource="AppsEmployee" 		
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">				
						   SELECT    *
						   FROM      PersonWorkSchedule
						   WHERE     PersonNo      = '#getValidSchedule.PersonNo#'
						   AND       Mission       = '#getValidSchedule.Mission#'
						   AND       Weekday       = #DayOfWeek(DateSel)#
						   AND       DateEffective = '#getValidSchedule.DateEffective#'					   
			         </cfquery>
					 
					 <cfquery name="getPersonTotal" dbtype="query">				
						   SELECT    COUNT(CalendarDateHour) as Hours,
						             MAX(CalendarDateSlot) as Slots
						   FROM      getPersonSchedule					  			 
					 </cfquery>
					 
					 <cfif getPersonTotal.Hours gte "1">
				 
						 <cfset dayhours = getPersonTotal.Hours/getPersonTotal.Slots>			   
					 
					 <cfelse>
					 
						 <cfset dayhours = "0">
					 
					 </cfif>
				 
				 <cfelse>
				 
				 	 <cfset dayhours = "0">
				 
				 </cfif>
		   
		   <cfelse>
		   
			   	<cfset dayhours = Parameter.HoursInDay>
		   
		   </cfif>		
		   		 
		   
		   <!--- if the person has 1. an assignnment, 2. no work recorded and 3. indeed hours to work THEN we start populating --->				 		   		    							
							         
		   <cfif hasAssignment.recordcount eq "1"
		         and hasWork.recordcount eq "0"		         
				 and dayhours gt "0">									 
									   	 
				<!--- verify if this person has leave recorded for this calendar date --->
				  
			    <cfquery name="Leave" dbtype="query">
					   SELECT   *
					   FROM     LeaveList
					   WHERE    PersonNo        = '#PersonNo#'			   
					   AND      DateEffective  <= #DateSel#
					   AND      DateExpiration >= #DateSel#
					   ORDER BY LeaveParent, DateEffective					   
			   </cfquery>				  
						   		   						  
			   <cfif Leave.recordcount gte "1">				
			   
			   		<!--- we create a parent work record --->
										
					<cfquery name="Insert" 
		               datasource="AppsEmployee" 
		               username="#SESSION.login#" 
		               password="#SESSION.dbpw#">				   
		       		   INSERT INTO	PersonWork
			    		      (PersonNo, 	    		  
			    			   CalendarDate, 
							   TransactionType,
							   OrgUnit,		
			    			   OfficerUserId, 
			    			   OfficerLastName, 
			    			   OfficerFirstName) 
		        	   VALUES ('#PersonNo#',		            
							    #DateSel#,
							   '1',
								#hasAssignment.OrgUnit#,<!--- unit of attendance --->							  
							   '#SESSION.acc#',
							   '#SESSION.last#',
							   '#SESSION.first#')							  
			  		</cfquery>				   
															
					<cfset prior = "">
					
					<cfquery name="clear" 
	                datasource="AppsEmployee" 
	                username="#SESSION.login#" 
	                password="#SESSION.dbpw#">				   
			       		   DELETE FROM PersonWorkClass
						   WHERE  PersonNo        = '#PersonNo#' 	    		  
				    	   AND    CalendarDate    = #DateSel# 
						   AND    TransactionType = '1'														  
		  		    </cfquery>		
					
					<cfset total = 0>
									
					<cfloop query="Leave">
											
						<!--- attention we could have 2 leave records on the SAME day, morning Annual, afternoon SL --->	
										
						<cfif prior neq LeaveParent>
						
							 <!--- we capture the calculated hours for this leaveparent 
							                if there are several for the same date  --->								
						
							 <cfif prior neq "" and HoursLve gt 0>								
																
								<cfquery name="Insert" 
				                datasource="AppsEmployee" 
				                username="#SESSION.login#" 
				                password="#SESSION.dbpw#">				   
					       		   INSERT INTO	PersonWorkClass
						    		      (PersonNo, 	    		  
						    			   CalendarDate, 
										   TransactionType,
										   TimeClass,		
										   TimeMinutes) 
					        	   VALUES ('#PersonNo#',		            
										    #DateSel#,
										   '1',
										   '#prior#',									  
										   '#hourslve*60#')							  
					  		    </cfquery>				
							
							</cfif>
						
							<cfset HoursLve = 0>														
							<cfset prior = LeaveParent>							
																							
						</cfif>
													
						<!--- 23/7 this counting will be adjusted more I am sure --->		
							        											
						<cfif Leave.DateEffectiveFull eq "0"  and Leave.DateEffective eq DateSel>
						      <cfset HoursLve    = HoursLve + dayhours/2>	
							  <cfset Total       = total    + dayhours/2>	
							  	              							 
						<cfelseif Leave.DateExpirationFull eq "0" and Leave.DateExpiration eq DateSel>
				    		  <cfset HoursLve    = HoursLve + dayhours/2>	
							  <cfset Total       = total    + dayhours/2>						  
						<cfelse>
							  <cfset HoursLve    = HoursLve + dayhours>
							  <cfset Total       = total   +  dayhours>	 						  
					   	</cfif>												
												
						<!--- record details for the hours in the sheet --->
																		
					</cfloop>
					
					<cfif prior neq "" and HoursLve gt 0>
							
						<!--- we capture the calculated hours for this leaveparent --->
														
						<cfquery name="Insert" 
		                datasource="AppsEmployee" 
		                username="#SESSION.login#" 
		                password="#SESSION.dbpw#">				   
			       		   INSERT INTO	PersonWorkClass
				    		      (PersonNo, 	    		  
				    			   CalendarDate, 
								   TransactionType,
								   TimeClass,		
								   TimeMinutes) 
			        	   VALUES ('#PersonNo#',		            
								    #DateSel#,
								   '1',
								   '#prior#',									  
								   '#hourslve*60#')							  
			  		    </cfquery>				
					
					</cfif>
					
					<!--- COMPLEMENT remaining work to the timesheet in case the leave is not full time
					the issue is the hours --->
					
					<cfset hourswork = dayhours - Total>
					
					<!--- we populate the remainder for presentational purpose so that you can see it is part-time --->
					
					<cfif hourswork gt "0">
					
						<cfquery name="Insert" 
			                datasource="AppsEmployee" 
			                username="#SESSION.login#" 
			                password="#SESSION.dbpw#">				   
				       		   INSERT INTO	PersonWorkClass
					    		      (PersonNo, 	    		  
					    			   CalendarDate, 
									   TransactionType,
									   TimeClass,		
									   TimeMinutes) 
				        	   VALUES ('#PersonNo#',		            
									   #DateSel#,
									   '1',
									   'Worked',									  
									   '#hourswork*60#')							  
				  		    </cfquery>				
					
					</cfif>		
					
					<!--- populate hours if for this organization UNIT the option is enabled 
					    to do timesheet management --->															  			  					
										
					   <cfif schedulemode eq "1">
					   
				   	       <!--- we check today's schedule = 2for this person in order to determine --->
	
						   <cfquery name="getPersonalSchedule" 
					         datasource="AppsEmployee" 
					         username="#SESSION.login#" 
					         password="#SESSION.dbpw#">
						         SELECT  *
						         FROM    PersonWorkDetail
						         WHERE   PersonNo            = '#PersonNo#'
								 AND     CalendarDate        = #DateSel#
								 AND     TransactionType     = '2'		
						   </cfquery>
						   
						   <!--- we now check if the leave for that day is to be counted full or parttime --->
						   
						   <cfset applyLeaveStr = "1">
						   <cfset applyLeaveEnd = getPersonalSchedule.recordcount>
							   
						   <cfquery name="checkLeaveStart" 
					         datasource="AppsEmployee" 
					         username="#SESSION.login#" 
					         password="#SESSION.dbpw#">
						         SELECT  *
						         FROM    PersonLeave
						         WHERE   LeaveId  = '#Leave.LeaveId#'
								 AND     DateEffective = #DateSel#									 									 
						   </cfquery>		  						   
						  						  						   						   
						   <cfif checkLeaveStart.recordcount eq "1">
								
						   	   <cfif checkLeaveStart.DateEffectiveFull eq "0">
							   
							   		<cfset applyLeaveStr = getPersonalSchedule.recordcount/2+1>
									<cfset applyLeaveEnd = getPersonalSchedule.recordcount> 
							   							       									
								    <cfif checkLeaveStart.DateEffectiveHour eq "12" or checkLeaveStart.DateExpiration neq checkLeaveStart.DateEffective>
									
										<cfset applyLeaveStr = "1">
								    	<cfset applyLeaveEnd = getPersonalSchedule.recordcount/2> 
																			
									</cfif>	
									
							   </cfif>	
							   
						   <cfelse>
						   
							   <cfquery name="checkLeaveEnd" 
						         datasource="AppsEmployee" 
						         username="#SESSION.login#" 
						         password="#SESSION.dbpw#">
							         SELECT  *
							         FROM    PersonLeave
							         WHERE   LeaveId  = '#Leave.LeaveId#'
									 AND     DateExpiration = #DateSel#									 									 
							   </cfquery>	
							   
							   <!-- the period of leave is always in the morning as it will be a consequitive period --->
							   
							   <cfif checkLeaveEnd.DateExpirationFull eq "0">
							   
							        <cfset applyLeaveStr = "1">
								    <cfset applyLeaveEnd = getPersonalSchedule.recordcount/2> 													  
									
							   </cfif>	
						   	   		
						   
						   </cfif>			
						   
						   <!---
						   <cfoutput>
						   <cfif personNo eq "10461">
						   <script>
						   alert('#dateformat(DateSel,client.dateformatshow)# #applyLeaveStr# #applyLeaveEnd#')
						   </script>					
						   </cfif>   
						   </cfoutput>
						   --->						  
						  						   				   
						   <cfloop query="getPersonalSchedule">			
						   
						   	   <cfif currentrow gte applyLeaveStr 
							       and currentrow lte applyLeaveEnd>   
							   
								   <!--- we apply as leave --->					   				   						   						   
								   						   	
								   <cfquery name="getClass" 
						               datasource="AppsEmployee" 
						               username="#SESSION.login#" 
						               password="#SESSION.dbpw#">	
									    SELECT  *
										FROM    Ref_WorkAction
										WHERE   ActionParent = '#Leave.LeaveParent#'
									</cfquery>
																								
								     <cfquery name="InsertMain" 
						               datasource="AppsEmployee" 
						               username="#SESSION.login#" 
						               password="#SESSION.dbpw#">
									   
						       		   INSERT INTO	PersonWorkDetail
								    		      (PersonNo, 	    		  
								    			   CalendarDate, 
												   CalendarDateHour,
												   HourSlot,
												   HourSlots,	
												   HourSlotMinutes,	
												   ActionClass,			
												   LeaveId,				  
								    			   OfficerUserId, 
								    			   OfficerLastName, 
								    			   OfficerFirstName) 
												   
						        	   VALUES    ('#PersonNo#',		            
												   #DateSel#,
												  '#CalendarDateHour#',
												  '#hourslot#',
												  '#hourSlots#',
												  '#hourSlotMinutes#',
												  '#getClass.ActionClass#',			
												  '#Leave.LeaveId#',				
											      '#SESSION.acc#',
											      '#SESSION.last#',
											      '#SESSION.first#')							 											 
												 
						      		  </cfquery>	
								  
								  <cfelse>
								  
								  	<!--- we apply as WORK from schema --->					   				   						   						   
								   						   	
								   <cfquery name="getClass" 
						               datasource="AppsEmployee" 
						               username="#SESSION.login#" 
						               password="#SESSION.dbpw#">	
									    SELECT  *
										FROM    Ref_WorkAction
										WHERE   ActionParent = '#Leave.LeaveParent#'
									</cfquery>
																								
								     <cfquery name="InsertMain" 
						               datasource="AppsEmployee" 
						               username="#SESSION.login#" 
						               password="#SESSION.dbpw#">
									   
						       		   INSERT INTO	PersonWorkDetail
								    		      (PersonNo, 	    		  
								    			   CalendarDate, 
												   CalendarDateHour,
												   HourSlot,
												   HourSlots,	
												   HourSlotMinutes,	
												   ActionClass,		
												   ActionCode,		
												   BillingMode,		
												   BillingPayment,
												   ActivityPayment,		
												   LocationCode,							   		  
								    			   OfficerUserId, 
								    			   OfficerLastName, 
								    			   OfficerFirstName,
												   Created) 
												   
						        	   VALUES    ('#PersonNo#',		            
												   #DateSel#,
												  '#CalendarDateHour#',
												  '#hourslot#',
												  '#hourSlots#',
												  '#hourSlotMinutes#',
												  '#ActionClass#',	
												  '#ActionCode#',	
												  '#BillingMode#',		
												  '#BillingPayment#',
												  '#ActivityPayment#',	
												  '#LocationCode#',										  				
											      '#OfficerUserid#',
											      '#OfficerLastName#',
											      '#OfficerFirstName#',
												  '#Created#')							 											 
												 
						      		  </cfquery>	
								  
								  </cfif>
												   
						   </cfloop>
					   
					   <cfelseif schedulemode eq "2">
					  									   	   	   						  
						   <cfloop query="getPersonSchedule">
						  									
							   <cfset hourSlotMinutes = 60/HourSlots>

							   <cfquery name="getWork" 
				               datasource="AppsEmployee" 
				               username="#SESSION.login#" 
				               password="#SESSION.dbpw#">	
								    SELECT  *
									FROM    Ref_WorkAction
									WHERE   ActionParent = '#Leave.LeaveParent#'
								</cfquery>						
							
							     <cfquery name="InsertMain" 
					               datasource="AppsEmployee" 
					               username="#SESSION.login#" 
					               password="#SESSION.dbpw#">
								   
					       		   INSERT INTO	PersonWorkDetail
							    		      (PersonNo, 	    		  
							    			   CalendarDate, 
											   CalendarDateHour,
											   HourSlot,
											   HourSlots,	
											   HourSlotMinutes,	
											   ActionClass,			
											   Leaveid,				  
							    			   OfficerUserId, 
							    			   OfficerLastName, 
							    			   OfficerFirstName) 
					        	   VALUES  ('#PersonNo#',		            
											 #DateSel#,
											 '#CalendarDateHour#',
											 '#CalendarDateSlot#',
											 '#hourSlots#',
											 '#hourSlotMinutes#',
											 '#getWork.ActionClass#',			
											 '#Leave.LeaveId#',				
										     '#SESSION.acc#',
										     '#SESSION.last#',
										     '#SESSION.first#')
					      		  </cfquery>	
													  
						  </cfloop>		
						  
						 </cfif> 					 					  
														  		  
				<cfelse>
				  
				     <!--- no leave record, now we first check if this is an OFFICIAL HOLIDAY : insert if possible  --->
							
					 <cfset hourswork = dayhours>
													   
				      <cfquery name="Holiday" 
				     	  datasource="AppsEmployee" 
				     	  username="#SESSION.login#" 
				          password="#SESSION.dbpw#">
						      SELECT   HoursHoliday, (SELECT  count(*) 
								                      FROM    Ref_HolidayLocation 
									                  WHERE   CalendarDate = #DateSel#
												      AND     Mission      = '#Mission#') as hasEnabledLocations	
							  FROM     Ref_Holiday
							  WHERE    CalendarDate = #DateSel#
							  AND      Mission      = '#mission#' 
				      </cfquery>
						  
					  <cfif Holiday.hasEnabledLocations gte "1">
					  
						  <cfif hasAssignment.AssignmentLocation neq "">
						
									<cfquery name="getHolidayLocation" 
									datasource="AppsEmployee" 
									username="#SESSION.login#" 
								    password="#SESSION.dbpw#">
									    SELECT  *
										FROM 	Ref_HolidayLocation
										WHERE   CalendarDate = #DateSel#
										AND     Mission      = '#hasAssignment.PositionMission#' 	<!--- maybe this has to be changed --->	
										AND     LocationCode = '#hasAssignment.AssignmentLocation#' 
								    </cfquery>
											
						  <cfelse>
								
								    <cfquery name="getHolidayLocation" 
									datasource="AppsEmployee" 
									username="#SESSION.login#" 
								    password="#SESSION.dbpw#">
									    SELECT  *
										FROM 	Ref_HolidayLocation
										WHERE   CalendarDate = #Date#
										AND     Mission      = '#hasAssignment.PositionMission#' 		
										AND     LocationCode = '#hasAssignment.PositionLocation#' 
								    </cfquery>		
											
						  </cfif>
						  						 							
						  <cfif getHolidayLocation.recordcount eq "1">
							<cfset isHoliday = "1">	
						  <cfelse>
							<cfset isHoliday = "0">		
						  </cfif>						
										  
					  <cfelseif Holiday.recordcount gte "1">							  							
					  	<cfset isHoliday = "1">																
					  <cfelse>			  					  
					  	<cfset isHoliday = "0">				  						
				      </cfif>
					  				  										  
					  <!--- if no leave day, it has to be a holiday or normal working days --->
				   
					  <cfif isHoliday eq "1">
					 						  		  
				    	  <cfquery name="InsertWork" 
				           datasource="AppsEmployee" 
				           username="#SESSION.login#" 
				           password="#SESSION.dbpw#">
						   	   INSERT INTO	PersonWork
									      (PersonNo, 						  
										   CalendarDate, 
										   TransactionType,
										   OrgUnit,											   			   
										   OfficerUserId, 
										   OfficerLastName, 
										   OfficerFirstName) 
					 		   VALUES    ('#PersonNo#',
							              #DateSel#,
										  '1',
										  #hasAssignment.OrgUnit#,												
										  '#SESSION.acc#',
										  '#SESSION.last#',
										  '#SESSION.first#')
						  </cfquery>	
						  
						  <cfquery name="InsertClass" 
				             datasource="AppsEmployee" 
				             username="#SESSION.login#" 
				             password="#SESSION.dbpw#">				   
					       		INSERT INTO	PersonWorkClass
						    		   (PersonNo, 	    		  
						    			CalendarDate, 
										TransactionType,
										TimeClass,		
										TimeMinutes) 
					        	VALUES ('#PersonNo#',#DateSel#,'1','Holiday','#hourswork*60#')							  
					  	  </cfquery>	
						  						  						  
						  <cfif schedulemode eq "1">
						  
						 						  						  
						  <!--- this is a personal workschedule, 
						  which means the person is supposed to be working on this official date and in that case
						  we report this as working time (which its recovery amount 						  
						  --->
						  
						  <cfelseif schedulemode eq "2">
						  
						  	<!--- this is the persons workschedule --->
					  					 			  
							<cfloop query="getPersonSchedule">
								 								  
						  	   <cfset hourSlotMinutes = 60/HourSlots>
							  						  
							   <cfquery name="InsertMain" 
					               datasource="AppsEmployee" 
					               username="#SESSION.login#" 
					               password="#SESSION.dbpw#">
								   
					       		   INSERT INTO	PersonWorkDetail
						    		      (PersonNo, 	    		  
						    			   CalendarDate, 
										   CalendarDateHour,
										   HourSlot,
										   HourSlots,	
										   HourSlotMinutes,	
										   ActionClass,							  
						    			   OfficerUserId, 
						    			   OfficerLastName, 
						    			   OfficerFirstName) 
					        	   VALUES ('#PersonNo#',		            
										   #DateSel#,
										   '#CalendarDateHour#',
										   '#CalendarDateSlot#',
										   '#hourSlots#',
										   '#hourSlotMinutes#',
										   'Break',							
									       '#SESSION.acc#',
									       '#SESSION.last#',
									       '#SESSION.first#')
					      	   </cfquery>									
																  
							</cfloop>		
							  
							</cfif> 		  
						  		  	  	  
				      <cfelse>	
					  
					  					  
						  <!--- A day which is not covered by leave or by an official holiday --->		
																																								  	  
						      <cfif dayhours gte "0">
							  
							  	<cfquery name="checkrecord" 
					               datasource="AppsEmployee" 
					               username="#SESSION.login#" 
					               password="#SESSION.dbpw#">
						       		   SELECT * 
									   FROM   PersonWork
									   WHERE  PersonNo        = '#PersonNo#'
									   AND    CalendarDate    = #DateSel# 
									   AND    TransactionType = '1'
								</cfquery>   
								
								<cfif checkrecord.recordcount eq "0">
														  
						    		  <cfquery name="InsertMain" 
						               datasource="AppsEmployee" 
						               username="#SESSION.login#" 
						               password="#SESSION.dbpw#">
						       		   INSERT INTO	PersonWork
							    		      (PersonNo, 	    		  
							    			   CalendarDate, 
											   TransactionType,
											   OrgUnit,	  		  
							    			   OfficerUserId, 
							    			   OfficerLastName, 
							    			   OfficerFirstName) 
						        	   VALUES ('#PersonNo#',		            
											   #DateSel#,
											   '1',
											   #hasAssignment.OrgUnit#,
										       '#SESSION.acc#',
										       '#SESSION.last#',
										       '#SESSION.first#') 
						      		  </cfquery>
								  
								  </cfif>
							  					    		 								  
								  <!--- if the person has a personal schedule in this month we apply this --->
								  
								  <cfif schedulemode eq "1">
		   
		   								<!--- obtain from the personal schedule the hours --->
		   						   								   
									   <cfquery name="InsertScheduled" 
								               datasource="AppsEmployee" 
								               username="#SESSION.login#" 
								               password="#SESSION.dbpw#">
										  
												  INSERT INTO PersonWorkDetail 
															( PersonNo, 
															  CalendarDate, 
															  TransactionType, 
															  CalendarDateHour, 
															  HourSlot, 
															  HourSlots, 
															  HourSlotMinutes, 
															  ActionClass, 									  
															  ActionCode, 
															  ActionMemo, 
										                      BillingMode, 
															  BillingPayment,
															  ActivityPayment, 
															  LocationCode, 
															  ParentHour, 
															  OfficerUserId, 
															  OfficerLastName, 
															  OfficerFirstName )
					
													SELECT   PersonNo, 
													         CalendarDate, 
															 '1', 
															 CalendarDateHour, 
															 HourSlot, 
															 HourSlots, 
															 HourSlotMinutes, 
															 ActionClass, 
															 ActionCode, 
															 ActionMemo, 
					                        				 BillingMode, 
															 BillingPayment,
															 ActivityPayment, 
															 LocationCode, 
															 ParentHour, 
															 OfficerUserId, 
															 OfficerLastName, 
															 OfficerFirstName
															 
													FROM     PersonWorkDetail AS D
													WHERE    PersonNo     = '#PersonNo#' 
													AND      CalendarDate = #DateSel#
													AND      TransactionType = '2' 
													<!--- we exclude time already taken by leave --->
													AND      NOT EXISTS ( SELECT 'X' AS Expr1
								            			                  FROM   PersonWorkDetail
					            			            			      WHERE  PersonNo     = D.PersonNo 
																		  AND    CalendarDate = D.CalendarDate 																		  
																		  AND    TransactionType = '1')
																		  
																		  
										  </cfquery>	
									  
										  <!--- populate the class table --->
										  
										   <cfquery name="InsertClass" 
								             datasource="AppsEmployee" 
								             username="#SESSION.login#" 
								             password="#SESSION.dbpw#">		
											 
											    INSERT INTO PersonWorkClass
												            (PersonNo, CalendarDate, TransactionType, TimeClass, ActionCode, TimeMinutes)
															
												SELECT      P.PersonNo, 
												            P.CalendarDate, 
															P.TransactionType, 
															R.ActionParent AS TimeClass, P.ActionCode, 
															SUM(P.HourSlotMinutes) AS Total
															
												FROM        PersonWorkDetail AS P INNER JOIN
												            Ref_WorkAction AS R ON P.ActionClass = R.ActionClass
												WHERE       P.PersonNo = '#PersonNo#' 
												AND         P.CalendarDate = #DateSel#												
												AND         P.TransactionType = '1' 
												AND         R.ActionParent IN ( SELECT       TimeClass
												                                FROM         Ref_TimeClass
												                                WHERE        TimeParent = 'Work') 
											    AND         NOT EXISTS (SELECT  'X' 
												                        FROM    PersonWorkClass 
												                        WHERE   PersonNo = P.PersonNo 
																		AND     CalendarDate = P.CalendarDate 
																		AND     TransactionType = '1')
																		
												GROUP BY P.PersonNo, P.CalendarDate, P.TransactionType, R.ActionParent, P.ActionCode
											 					  
									  	  </cfquery>	
																	  		   				
							       <cfelseif schedulemode eq "2">	
								   
								        <cfif mode eq "force">								   					   
								 								   
										   	<cfloop query="getPersonSchedule">																			  
												 											  										  									  
										  		   <cfset hourSlotMinutes = 60/HourSlots>
										  
												   <cfquery name="InsertMain" 
										               datasource="AppsEmployee" 
										               username="#SESSION.login#" 
										               password="#SESSION.dbpw#">
										       		   INSERT INTO	PersonWorkDetail
												    		      (PersonNo, 	    		  
												    			   CalendarDate, 
																   CalendarDateHour,
																   HourSlot,
																   HourSlots,	
																   HourSlotMinutes,		
																   ActionClass,							  
												    			   OfficerUserId, 
												    			   OfficerLastName, 
												    			   OfficerFirstName) 
										        	   VALUES    ('#PersonNo#',		            
															       #DateSel#,
															      '#CalendarDateHour#',
															      '#CalendarDateSlot#',
															      '#hourSlots#',
															      '#hourSlotMinutes#',
															      'Indirect',							
														          '#SESSION.acc#',
														          '#SESSION.last#',
														          '#SESSION.first#')
										      		  </cfquery>													
																								  
											</cfloop>	
										
										<cfelse>
										
										 <cfquery name="delete" 
									         datasource="AppsEmployee" 
									         username="#SESSION.login#" 
									         password="#SESSION.dbpw#">
									       		DELETE FROM PersonWork
												WHERE PersonNo = '#PersonNo#' 
												AND   CalendarDate = #DateSel#
										  </cfquery>	
										
										</cfif>
																				
										<!--- populate the class table --->
										  
										   <cfquery name="InsertClass" 
								             datasource="AppsEmployee" 
								             username="#SESSION.login#" 
								             password="#SESSION.dbpw#">		
											 
											    INSERT INTO PersonWorkClass
												            (PersonNo, CalendarDate, TransactionType, TimeClass, ActionCode, TimeMinutes)
															
												SELECT      P.PersonNo, 
												            P.CalendarDate, 
															P.TransactionType, 
															R.ActionParent AS TimeClass, P.ActionCode, 
															SUM(P.HourSlotMinutes) AS Total
															
												FROM        PersonWorkDetail AS P INNER JOIN
												            Ref_WorkAction AS R ON P.ActionClass = R.ActionClass
												WHERE       P.PersonNo = '#PersonNo#' 
												AND         P.CalendarDate = #DateSel#												
												AND         P.TransactionType = '1' 
												AND         R.ActionParent IN ( SELECT       TimeClass
												                                FROM         Ref_TimeClass
												                                WHERE        TimeParent = 'Work') 
											    AND         NOT EXISTS (SELECT  'X' 
												                        FROM    PersonWorkClass 
												                        WHERE   PersonNo = P.PersonNo 
																		AND     CalendarDate = P.CalendarDate 
																		AND     TransactionType = '1')
																		
												GROUP BY P.PersonNo, P.CalendarDate, P.TransactionType, R.ActionParent, P.ActionCode
											 					  
									  	  </cfquery>	
										  
								   
								   </cfif>															
															  
							</cfif>
					  
					   </cfif>  
								  	  
				  </cfif> 
			  
			  </cfif>  
			     
		</cfloop>								
			 
	</cffunction>		 
	
	<cffunction name="LeaveBalance"
             access="public"
             returntype="any"
             displayname="Record Position Extension based on the funding">
		 
		<!--- dates are passed in SQL value or universal format --->
				
		<cfargument name="PersonNo"       type="string"  required="true"   default="">
		<cfargument name="LeaveType"      type="string"  required="true"   default="Annual">
		<cfargument name="Mode"           type="string"  required="false"  default="Regular">	
		<cfargument name="Mission"        type="string"  required="false"  default="">		
		<cfargument name="StartDate"      type="date"    required="true"   default="#now()#">		
		<cfargument name="EndDate"        type="date"    required="true"   default="#now()#">		
		<cfargument name="BalanceStatus"  type="string"  required="true"   default="0">		
		<cfargument name="Leaveid"        type="string"  required="false"  default=""> 	
		
		<cfif BalanceStatus eq "0">
		
			<cfset cutoffdate = ""> <!--- the last one --->
			
		<cfelse>
		
			<!--- obtain last EOD --->
			
			<cfinvoke component = "Service.Process.Employee.PersonnelAction"
				    Method          = "getEOD"
				    PersonNo        = "#PersonNo#"
					Mission         = "#mission#"													
				    ReturnVariable  = "EOD">				
		
			<cfset cutoffdate = "#dateformat(EOD,client.dateformatshow)#">	
			
			<cfif cutoffdate neq "">
				<cfset dateValue = "">
				<CF_DateConvert Value="#cutoffdate#">
				<cfset cutoff = dateValue>
			</cfif>
			
		</cfif>			
						
		<cftry>

			<cfquery name="Test"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT TOP 1 * 
			FROM   lvePersonContract
			</cfquery>
			
			<cfcatch>
				
				<CF_DropTable dbName="AppsTransaction" 
				              tblName="lvePersonContract"> 													     
				
				<cfquery name="CreateTable"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					CREATE TABLE dbo.lvePersonContract (
						[ContractId]           [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [lvePersonContract01] DEFAULT (newid()),
						[PersonNo]             [varchar] (20) NOT NULL ,	
						[Mission]              [varchar] (30) NULL ,						
						[ContractType]         [varchar] (20) NULL ,
						[SalarySchedule]       [varchar] (20) NULL ,
						[ContractTime]         [int] NULL DEFAULT 100 ,
						[DateEffective]        [datetime] NOT NULL,
						[DateExpiration]       [datetime] NULL)
						
				</cfquery>
				
				<cfquery name="Index1" 
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					CREATE UNIQUE INDEX [ContractId] ON dbo.lvePersonContract([ContractId]) 
					 ON [PRIMARY]
				</cfquery>	
				
				<cfquery name="Index2" 
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					CREATE CLUSTERED INDEX [PersonInd] ON dbo.lvePersonContract([PersonNo],[Mission])
					 ON [PRIMARY]		  
				</cfquery>				
				
			</cfcatch>

		</cftry>			
				
		<cfquery name="getLeave" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			    SELECT *
				FROM   Ref_LeaveType 
		        WHERE  LeaveType      = '#LeaveType#' 
		</cfquery>
		
		<!--- a view to limit using the direct table --->
		
		<cfquery name="takenbase" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			    SELECT  L.LeaveId as Id, 
				        L.PersonNo, 
						L.Mission, 
						L.OrgUnit,
						L.LeaveType, 
						L.LeaveTypeClass, 
						L.GroupListCode,
						L.DateEffective, 
						L.DateEffectiveHour,	
						L.DateEffectiveFull,
						L.DateExpiration,
						L.DateExpirationHour,
						L.DateExpirationFull,
						L.DaysLeave,
						L.DaysDeduct,
						L.HoursDeduct,
						L.Status				 
				FROM    PersonLeave L INNER JOIN Ref_LeaveTypeClass R ON L.LeaveType = R.LeaveType AND L.LeaveTypeClass = R.Code			
				WHERE   PersonNo         = '#PersonNo#'
				AND     L.LeaveType      = '#LeaveType#'	
									   
				<cfif leaveid neq "">
				AND     LeaveId != '#leaveid#'
				</cfif>										 					 
				AND     Status IN ('0','1','2')							
		</cfquery>	
		
		<cfif leaveid neq "">		
						
			<cfquery name="thisLeave" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			    SELECT  *			 
				FROM    PersonLeave L
				WHERE   PersonNo         = '#PersonNo#'
				AND     LeaveId          = '#LeaveId#'		
			</cfquery>	
								
			<cfset mission = thisleave.mission>		
										
		</cfif>	
		
		<cfset process = "1">		
				
		<cfif getleave.LeaveAccrual eq "2"> <!--- overtime / CTO --->
		
			<!--- only if we find something to speed up the process --->
		
			<cfquery name="checkProcess" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				    SELECT TOP 1 *
					FROM   PersonLeaveBalanceInit
			        WHERE  PersonNo   = '#PersonNo#'							 
					AND    LeaveType = '#LeaveType#'					
			</cfquery>
			
			<cfif checkProcess.recordcount eq "0">
									
				<cfset process = "0">
												
			 </cfif>	
			 		
		</cfif>
															
		<cfif process eq "1">
		
			<!--- addded we check if the leave is a relative leave and then we update the initial balances --->
									
			<cfinvoke component = "Service.Process.Employee.PersonnelAction"
				    Method          = "getEOD"
				    PersonNo        = "#PersonNo#"
					Mission         = "#mission#"	
					SelDate         = "#cutoffdate#" <!--- to obtain the valid EOD date to apply --->												
				    ReturnVariable  = "mEOD">	
									 				  
			<cfset EOD = mEOD>							
																
			<!--- leave entitlement defined for the set duration of the contract, applies to sickleave unlike annual leave
			which accrues  --->	
																						
			<cfif getLeave.LeaveBalanceMode eq "relative" and mission neq "" and mode eq "batch">
						
				<!--- obtain the relative period for balance application for leave --->
						
				<cfquery name="getPeriod" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM  Ref_LeaveTypeMission
					WHERE LeaveType = '#leavetype#'
					AND   Mission   = '#Mission#'												
				</cfquery>			
				
				<cfquery name="getContract" 
				      datasource="AppsEmployee" 		  
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					   SELECT    TOP 1 *
					   FROM      PersonContract
					   WHERE     PersonNo = '#PersonNo#'
					   AND       Mission  = '#Mission#'
					   AND       ActionStatus IN ('0','1')
					   <cfif cutoffdate neq "">
					   AND       DateExpiration < #cutoff#					   
					   </cfif>					   
					   ORDER BY  DateEffective DESC							   					   
				</cfquery>		
				
				<cfif getContract.dateExpiration gt now()>														
					<cfset balancestartdate = dateadd("M","#getPeriod.EntitlementDuration*-1#",now())>					
				<cfelse>
				    <cfset balancestartdate = dateadd("M","#getPeriod.EntitlementDuration*-1#",getContract.dateExpiration)>								
				</cfif>	
																				
				<!--- correct the balance start continuous start date for the current mission --->
					
				<cfinvoke component = "Service.Process.Employee.PersonnelAction"
						    Method          = "getEOD"
						    PersonNo        = "#PersonNo#"
							Mission         = "#mission#"		
							SelDate         = "#cutoffdate#"					
						    ReturnVariable  = "mEOD">	
															 				  
				<cfset EOD = mEOD>						
				
				<cfif  EOD gt balancestartdate>							  
					   <!--- the continuous period is later than the scoped date --->
					   <cfset balancestartdate = EOD>								
				</cfif> 														
											
				<cfif getContract.dateExpiration gt now()>				
					<cfset mth = dateDiff("M",balancestartdate,getContract.dateExpiration)>																	
				<cfelse>
					<cfset mth = dateDiff("M",balancestartdate,now())>									
				</cfif>								
																
				<!--- obtain entitlement based on the contract type --->
												  
				<cfquery name="getEntitlement" 
				      datasource="AppsEmployee" 		  
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					   SELECT   TOP 1 *
					   FROM     Ref_LeaveTypeCreditEntitlement
					   WHERE    LeaveType    = '#leavetype#'
					   AND      ContractType = '#getContract.contractType#'
					   AND      ContractDuration <= #mth#
					   ORDER BY ContractDuration DESC
					   -- AND      DateEffective <= getdate()	
					   					  				   							   
				</cfquery>	
								  
				<cfif getEntitlement.recordcount gte "1">
				
					  <cfset days = getEntitlement.Credit>
					 
				<cfelse>
				
				  	  <cfset days = "0">	
					 
				</cfif>		
							
															  
				<cfif EOD neq "" and days neq "0">
															  
					   <!--- use this date to set the entitlement record in table PersonLeaveBalanceInit --->
					  
					  <cfquery name="reset" 
					      datasource="AppsEmployee" 		  
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
							  DELETE FROM PersonLeaveBalanceInit
							  WHERE  Personno = '#PersonNo#'
							  AND    LeaveType = '#leavetype#'
					  </cfquery>
					  
					   <cfquery name="resetbalances" 
					      datasource="AppsEmployee" 		  
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
							  DELETE FROM PersonLeaveBalance
							  WHERE  Personno      = '#PersonNo#'
							  AND    LeaveType     = '#leavetype#'									  
							  AND    BalanceStatus = '#BalanceStatus#' <!--- we remove only from the same status --->
					  </cfquery>
						
					  <cfquery name="insert" 
					      datasource="AppsEmployee" 		  
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						  						  
						  INSERT INTO PersonLeaveBalanceInit
								  (PersonNo, 
								   LeaveType, 
								   DateEffective, 
								   BalanceDays, 
								   Memo,
								   OfficerUserId, OfficerLastName, OfficerFirstName)
						   
						   VALUES  ('#PersonNo#',
								    '#leavetype#',
									'#dateformat(balancestartDate,client.dateSQL)#',
									'#days#',
									'Calculated entitlement',
									'#session.acc#',
									'#session.last#',
									'#session.first#')									
										
					  </cfquery>  
				  
				  </cfif>
				  
				  <!--- we reset the start date now as well --->
				  <cfset startdate = balancestartdate>
				  				  					
			</cfif>
												
			<!--- we always define the calculation for a complete month --->
			
			<!--- start of the calculation --->	
			<cfset seldate=CreateDate(Year(StartDate),Month(StartDate),1)>	
			<!--- end of the calculation --->	
			<cfset dateob=CreateDate(Year(EndDate),Month(EndDate),DaysInMonth(EndDate))>	
			
			<cfquery name="getLeave" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				    SELECT *
					FROM   Ref_LeaveType 
			        WHERE  LeaveType      = '#LeaveType#' 
			</cfquery>		
						
			<!--- detemrine if we have thresholds potentially defined for classes --->
					 
	 		<cfquery name="getLeaveClass" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT       T.*
					FROM        Ref_LeaveTypeClass AS T
					WHERE       LeaveType = '#leaveType#' 
					AND         Code IN (SELECT  LeaveTypeClass
			                             FROM    Ref_LeaveTypeThreshold
			                             WHERE   LeaveType = T.LeaveType)
			</cfquery>	
				
			<cfif getLeaveClass.recordcount gte "1">						
				<cfset class = "LeaveType,#valueList(getLeaveClass.Code)#">								
			<cfelse>			
				<cfset class = "LeaveType">			
			</cfif>	
					
			<cfloop index="itm" list="#class#">						
			
				<cfset BAL = "0">
					
				<cfquery name="lastbalance" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					    SELECT MAX(DateExpiration)+100 as DateExpiration
						FROM   PersonLeaveBalance 
				        WHERE  PersonNo       = '#PersonNo#'
						AND    LeaveType      = '#LeaveType#' 
						AND    BalanceStatus  = '#BalanceStatus#'  
						<cfif itm eq "LeaveType">
						AND    LeaveTypeClass is NULL <!--- added to provide support for class balances ---> 
						<cfelse>
						AND    LeaveTypeClass = '#itm#'
						</cfif>
				</cfquery>
				
				<cfif dateob lt lastBalance.DateExpiration>
				   <cfset dateob=CreateDate(Year(lastBalance.DateExpiration),Month(lastBalance.DateExpiration),DaysInMonth(lastBalance.DateExpiration))>
				</cfif>
				
				<cfif dateob lt now()>
				   <cfset dateob=CreateDate(Year(now()),Month(now()),DaysInMonth(now()))>
				</cfif>
																				
				<!--- what if a person changes from contract contract --->
				<!--- 
				
					monthly only
					
					0. Remove balance records
					1. define the last date and as such the next date for processing.
					2. define initial transaction for days + date start
					3. define contract start date and select the highest of initial or contract start => START
					4. Define end of month and calculate credit for START and END based on the contract type at the end of the month
					5. Write a credit record PERSON, START, END, CREDIT and INITIAL.
				--->
				
				<!--- 0. remove balance records --->
				
				<cftransaction>
												
				<cfquery name="init" 
				   datasource="AppsEmployee" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				    DELETE FROM PersonLeaveBalance 
			        WHERE  PersonNo       = '#PersonNo#'
					AND    LeaveType      = '#LeaveType#' 
					AND    BalanceStatus  = '#BalanceStatus#'		
					AND    DateEffective  >= #seldate#			 	
					<cfif itm eq "LeaveType">
					AND    LeaveTypeClass is NULL <!--- added to provide support for class balances ---> 
					<cfelse>
					AND    LeaveTypeClass = '#itm#'
					</cfif>	  					
				</cfquery>
							
				<cfquery name="Parameter" 
				    datasource="AppsEmployee" 
				    username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   *
					FROM     Parameter 
				</cfquery>
				
				<cfset HoursInDay = Parameter.HoursInDay>
				
				<!--- 1. now check the last balance start date in the table --->
				
				<cfquery name="check" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					    SELECT MAX(DateExpiration) as DateExpiration
						FROM   PersonLeaveBalance WITH(NOLOCK)
				        WHERE  PersonNo       = '#PersonNo#'
						AND    LeaveType      = '#LeaveType#'
						AND    BalanceStatus  = '#BalanceStatus#'
						<cfif itm eq "LeaveType">
						AND    LeaveTypeClass is NULL <!--- added to provide support for class balances ---> 
						<cfelse>
						AND    LeaveTypeClass = '#itm#'
						</cfif>	 
				</cfquery>
				
				<cfquery name="lastbalance" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					    SELECT Balance
						FROM   PersonLeaveBalance WITH(NOLOCK)
				        WHERE  PersonNo       = '#PersonNo#'
						AND    LeaveType      = '#LeaveType#'				  
						AND    BalanceStatus  = '#BalanceStatus#'
						AND    DateExpiration = '#DateFormat(Check.DateExpiration,client.dateSQL)#' 
					    <cfif itm eq "LeaveType">
						AND    LeaveTypeClass is NULL <!--- added to provide support for class balances ---> 
						<cfelse>
						AND    LeaveTypeClass = '#itm#'
						</cfif>	 
				</cfquery>
									
				<cfif LastBalance.balance neq "">
				    <cfset balance  = LastBalance.balance>
				<cfelse>
				    <cfset balance  = 0>
				</cfif>	
			
				<cfif check.dateExpiration neq "">
						
					 <!--- go to the next month for the 1st day --->
					 <cfset date = dateAdd("d",1,Check.DateExpiration)>	 	 
				    
				<cfelse> 
						
				     <!--- check contract start date --->
					 
					 <cfquery name="contr" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					    SELECT MIN(DateEffective) as DateEffective
						FROM   PersonContract
				        WHERE  PersonNo      = '#PersonNo#' 
						AND    ActionStatus != '9' 
				     </cfquery>
					  
					 <cfif contr.DateEffective eq "">
					 
						 <cf_message message="Problem, no contract was been recorded for this employee.">
						 <cfabort>
					 
					 </cfif>
					 
					  <!--- go to the next month, this was remove as it was not calculating correctly for a brandne contract and was taking the incorrect month	  	  
					  		<cfset dtm = dateAdd("d",31,Contr.DateEffective)>			
					  --->	 
					 	  			  
					  <cfset dtm   = dateAdd("d",0,Contr.DateEffective)>	   	  	  	 
					  <!--- reset to the first date --->
					  <cfset date  = CreateDate(year(dtm),month(dtm),1)>	
					 					  	  	 	     
				</cfif> 
				
				<cfquery name="CLEAR" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					    DELETE FROM userTransaction.dbo.lvePersonContract						
				        WHERE    PersonNo      = '#PersonNo#'						
						<cfif mission neq "">
						AND      Mission = '#mission#'
						</cfif>						
				</cfquery>
							
				<!--- select only valid contract records for this person --->
						
				<cfquery name="ExtractContract" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				    INSERT INTO userTransaction.dbo.lvePersonContract (						
					         ContractType, 
							 SalarySchedule,
							 PersonNo,
							 Mission,
							 ContractTime,
						     DateEffective, 
						     DateExpiration, 
						     ContractId)
					SELECT   ContractType, 
							 SalarySchedule,
							 PersonNo,
							 Mission,
							 ContractTime,
						     DateEffective, 
						     DateExpiration, 
						     ContractId
					FROM     PersonContract
			        WHERE    PersonNo      = '#PersonNo#'
					<cfif mission neq "">
					AND      Mission = '#mission#'
					</cfif>
					AND      ActionStatus IN ('0','1')
					
					AND      (DateExpiration >= #date# OR (DateExpiration is NULL OR DateExpiration = ''))	
					
					<cfif cutoffdate neq "">					
					AND      DateEffective < #cutoff#
					</cfif>	
					
					AND      ContractId NOT IN (SELECT Contractid 
					                            FROM   userTransaction.dbo.lvePersonContract)												
															
				</cfquery>				
		
				<!--- create a usefull set of contract dates within the select period and today (last day of month) --->
				
				<!--- update contract start to date if smaller than date --->				
				<cfquery name="update" 
				     datasource="AppsTransaction" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					    UPDATE lvePersonContract
						SET    DateEffective = #date#  
				        WHERE  PersonNo = '#PersonNo#'
						<cfif mission neq "">
						AND    Mission = '#mission#'
						</cfif>
						AND    DateEffective < #date#  
				</cfquery>
				
				<!--- update contract end period to today if blank or bigger than today --->	
							
				<cfquery name="update" 
				     datasource="AppsTransaction" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					    UPDATE  lvePersonContract
						SET     DateExpiration = #dateob# 
				        WHERE   PersonNo = '#PersonNo#'
						<cfif mission neq "">
						AND     Mission = '#mission#'
						</cfif>
						AND    ( DateExpiration > #dateob# OR DateExpiration is NULL OR DateExpiration = '' )		  
				</cfquery>
								
				<!--- loop through the contract for proper continuous periods --->				
				<cfquery name="select" 
				   datasource="AppsTransaction" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					    SELECT   *
						FROM     lvePersonContract
						WHERE    PersonNo = '#PersonNo#'
						<cfif mission neq "">
						AND      Mission = '#mission#'
						</cfif>
						ORDER BY DateExpiration
				</cfquery>
			   
				<cfset tpe = select.ContractType>
				<cfset dts = select.DateEffective>		
				
				<cfif dts neq "">
							
					<cfset dts = dateAdd("d","0",dts)>				
					
					<cfset no  = '{00000000-0000-0000-0000-000000000000}'>
				        
					<!--- correction in proper periods --->
					   
					<cfloop query="select">
					
						<!--- <cfoutput>#dateeffective#<br></cfoutput> --->
						          
					      <cfif tpe eq select.ContractType>
						  	  
						     <cfif dts gt DateEffective>		 			 	
								   
								    <cfquery name="update" 
						            datasource="AppsTransaction" 
						            username="#SESSION.login#" 
						            password="#SESSION.dbpw#">
								        UPDATE lvePersonContract
									    SET    DateEffective = #dts#
									    WHERE  ContractId    = '#contractId#'  
						           </cfquery>
							   
							 </cfif>
							 
							 <cfset dts = dateAdd("d","1",dts)>
							 		
					      </cfif>
						    
						  <cfset no  = contractId>	 
						  <cfset tpe = ContractType>
						  					      
					</cfloop>
								    
					<!--- now create a final process table --->
					
										
					<cfquery name="resetleave" 
					  datasource="AppsEmployee"   
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					        SELECT    TOP 1 *
							FROM      PersonLeaveBalanceInit
					        WHERE     PersonNo        = '#PersonNo#'
					   		AND       LeaveType       = '#LeaveType#'
							<cfif itm eq "LeaveType">
							AND       LeaveTypeClass is NULL <!--- added to provide support for class balances ---> 
							<cfelse>
							AND       LeaveTypeClass = '#itm#'
							</cfif>	 	
							ORDER BY  DateEffective DESC		
					</cfquery>
															
					<!--- ------------------------------------------------------ --->
					<!--- class threshold support -which may start at any moment --->
					
					<cfif resetleave.recordcount eq "0" and itm neq "LeaveType">
										
						<cfquery name="resetleave" 
						  datasource="AppsEmployee"   
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						        SELECT    TOP 1 *, Threshold as BalanceDays
								FROM      Ref_LeaveTypeThreshold
						        WHERE     LeaveType      = '#LeaveType#'						
								AND       LeaveTypeClass = '#itm#'		
								AND       Mission = '#select.mission#'				
								ORDER BY  DateEffective 	
						</cfquery>		
																		
					</cfif>
				  
					<cfquery name="clearFutureRecords" 
					     datasource="AppsTransaction" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						    DELETE   lvePersonContract		
							WHERE    PersonNo = '#PersonNo#'
							<cfif mission neq "">
							AND      Mission = '#mission#'
							</cfif>						
							AND      DateEffective > DateExpiration				
					</cfquery>					
																						 				  
					<cfquery name="contract" 
					     datasource="AppsTransaction" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						    SELECT   DISTINCT ContractType, 
							         SalarySchedule,
									 ContractTime,									 
							         DateEffective, 
									 DateExpiration
							FROM     lvePersonContract	
							WHERE    PersonNo = '#PersonNo#'
							<cfif mission neq "">
							AND      Mission = '#mission#'
							</cfif>
							<cfif resetleave.recordcount eq "1">
								<cfif mEOD gt resetleave.dateeffective>
									AND      DateExpiration > '#mEOD#'									
								<cfelse>
									AND      DateExpiration >= '#resetleave.dateeffective#'									
								</cfif>	
							<cfelse>		
								AND      DateExpiration > '#mEOD#'								
							</cfif>							 	
							ORDER BY DateExpiration,DateEffective	
															
					</cfquery>					
									
														
					<!--- ready for complete calculation, define possible overruling initialization records --->
									
					<cftransaction>
						
						<cfset ctr = "">			
																		
						<cfloop query="Contract"> 
						
																		
							<cfquery name="hasSchedule" 
					         datasource="AppsEmployee" 
					         username="#SESSION.login#" 
					         password="#SESSION.dbpw#">
						         SELECT   TOP 1 *
						         FROM     PersonWorkSchedule 
						         WHERE    PersonNo = '#PersonNo#'							 							
								 AND      Mission = '#mission#'							
						    </cfquery>
							
							<cfif hasSchedule.recordcount gte "1">
								<cfset hasMissionSchedule = "1">
							<cfelse>
							    <cfset hasMissionSchedule = "0">	
							</cfif>
						
							<!--- we loop through the contract instances first --->
							
							  <cfquery name="check" 
							     datasource="AppsEmployee" 
							     username="#SESSION.login#" 
							     password="#SESSION.dbpw#">
								    SELECT *
									FROM   PersonLeaveBalance WITH(NOLOCK)
									WHERE  PersonNo        = '#PersonNo#'
							   	    AND    LeaveType       = '#LeaveType#'
									AND    BalanceStatus   = '#balancestatus#'
									AND    DateExpiration  = '#dateexpiration#'  	
									<cfif itm eq "LeaveType">
									AND    LeaveTypeClass is NULL <!--- added to provide support for class balances ---> 
									<cfelse>
									AND    LeaveTypeClass = '#itm#'
									</cfif>	 	
							  </cfquery>
							  
							  <cfquery name="Accrual" 
							     datasource="AppsEmployee" 
							     username="#SESSION.login#" 
							     password="#SESSION.dbpw#">
								    SELECT   TOP 1 *
									FROM     Ref_LeaveTypeCredit
									WHERE    LeaveType       = '#LeaveType#'
									AND      ContractType    = '#ContractType#'
									AND      DateEffective   <= '#dateexpiration#'  		
									ORDER BY DateEffective DESC
							  </cfquery>
							  
							  <!--- added 2/12/2012 --->
							  
							  <cfif Accrual.recordcount gte "1">	  
								  <cfset caller.AllowedOverdrawInMonth  = Accrual.AdvanceInCredit>
							  <cfelse>	       
								  <cfset caller.AllowedOverdrawInMonth  = "0">  <!--- was 7/11/2017 : 4, reverted to 0 by Hanno --->
							  </cfif>
							
							  <cfif check.recordcount eq "0">
							  	    
							  <!--- ------------------------- --->
							  <!--- loop through the contract --->
							  <!--- ------------------------- 
							       
					 		  Hanno 05/12/2017    
							  
							  There was an old rule which would reset the balance the moment a different contract type is detected
							  but this is disabled as for this we have maximum and carry-ver rules 
							  	   	
							  <cfif contractType neq ctr>
								     <cfset BAL = 0>
							  </cfif>
							  
							  --->
							  
							  <cfset ctr = contractType>
							  	
							  <cfset Memo = ""> 						 					 					  
							  							         
							  <cfif DateEffective lte ResetLeave.DateEffective>
							 							 							    				
								 <cfset BAL = 0>	 
							     <cfset START = ResetLeave.DateEffective>
								 <cfset ADJ   = ResetLeave.BalanceDays>	 
								 <cfset MEMO  = "Init Balance">
								 <cfset date  = CreateDate(Year(START),Month(START),DaysInMonth(START))>								
													  	 	 
							  <cfelse>	 
							  
							     <cfset START = DateEffective>
								 <cfset ADJ   = 0>
								 <cfset MEMO = "">
							     <cfset date  = CreateDate(Year(START),Month(START),DaysInMonth(START))>
										  
							  </cfif>

							  							  						    							  	   				   	
							  <cfif date gt DateExpiration>  							  
								  <cfset END = DateExpiration>	 
							  <cfelse>      							  
								  <cfset END = date>   	 	 
							  </cfif>  
							  
							  <!--- added to prevent incorrect date above --->
							  <cfset END = date> 
							   
							  <cfset START  = CreateDate(Year(START),Month(START),Day(START))>
							  <cfset END    = CreateDate(Year(END),Month(END),Day(END))>
							 							 							  
							  <cfif end gt CONTRACT.DateExpiration>
							     <cfset END    = CreateDate(Year(CONTRACT.DateExpiration),Month(CONTRACT.DateExpiration),Day(CONTRACT.DateExpiration))>
							  </cfif> 	
							  
							  							  						  
							  <!--- ------------------------------------ --->
							  <!--- ------ RECORD THE BALANCES---------- --->
							  <!--- ------------------------------------ ---> 									 
							  
							  <cfinvoke component  = "Service.Process.Employee.Attendance"
							    Method             = "InsertBalanceRecord"
								returnvariable     = "BAL"
								Mode               = "#mode#"
								Balance            = "#Balance#"
								BAL                = "#BAL#"
								ADJ                = "#ADJ#"
								MEMO               = "#MEMO#"
								HasMissionSchedule = "#hasmissionschedule#"
								LeaveId            = "#leaveid#"
							    PersonNo           = "#PersonNo#"
								EOD                = "#EOD#"
								Takenbase          = "#takenbase#"
								ContractType       = "#Contract.ContractType#"
								ContractTime       = "#ContractTime#"
								SalarySchedule     = "#SalarySchedule#"
								Mission            = "#mission#"	
								LeaveType          = "#LeaveType#"		
								Itm                = "#itm#"
								Start              = "#START#"
								End                = "#End#">	
																				  						 							  					  
							  <!--- ------------------------------------ --->  	
							   
							  <cfset END  = CreateDate(Year(END),Month(END),DaysInMonth(END))>
							  <cfset DTE  = CreateDate(Year(END+1),Month(END+1),1)>
							  <cfset balance = 0>  
							  							  							      
							  <!--- looping through the successive dates of the contract period per complete month --->
	
							  <!--- added saveguard to no endlessly count --->
							  <cfset count = 0>
																			  					  					                
							  <cfloop condition="#DTE# lte #CONTRACT.DateExpiration# and #count# lt 70">
							  
							  	<cfset count = count+1>
							  								
								<!--- Hanno do obtain the correct accrual rate as it might change in the successive period of the contract--->
								 
								<cfquery name="Accrual" 
								     datasource="AppsEmployee" 
								     username="#SESSION.login#" 
							    	 password="#SESSION.dbpw#">
									    SELECT   TOP 1 *
										FROM     Ref_LeaveTypeCredit
										WHERE    LeaveType       = '#LeaveType#'
										AND      ContractType    = '#ContractType#'
										AND      DateEffective   <= #DTE#  		
										ORDER BY DateEffective DESC
							    </cfquery>	
								  					            
							    <cfset START = CreateDate(Year(DTE),Month(DTE),Day(DTE))>						
														 	 
								<cfset date  = CreateDate(Year(DTE),Month(DTE),DaysInMonth(DTE))>
								 
								<!--- define the end date to the last date unless the contract demands different --->
								<cfif date gt DateExpiration>
								   <cfset END = DateExpiration>
								<cfelse>
								   <cfset END = date>   
							    </cfif>
								 	 	 
								 <cfset END  = CreateDate(Year(END),Month(END),Day(END))>		
																 
								 <!--- record the monthly leave record --->								 
								  <cfinvoke component  = "Service.Process.Employee.Attendance"
								    Method             = "InsertBalanceRecord"
									Mode               = "#mode#"
									returnvariable     = "BAL"
									Balance            = "0"
									BAL                = "#BAL#"
									ADJ                = "0"									
									HasMissionSchedule = "#hasmissionschedule#"
									LeaveId            = "#leaveid#"
								    PersonNo           = "#PersonNo#"
									EOD                = "#EOD#"
									Takenbase          = "#takenbase#"
									ContractType       = "#Contract.ContractType#"
									ContractTime       = "#ContractTime#"
									SalarySchedule     = "#SalarySchedule#"
									Mission            = "#mission#"	
									LeaveType          = "#LeaveType#"		
									Itm                = "#itm#"
									Start              = "#START#"
									End                = "#END#">																		
																																		 
								 <!--- go to next month --->
							   
							     <cfset END  = CreateDate(Year(END),Month(END),DaysInMonth(END))>
							     <cfset DTE  = CreateDate(Year(END+1),Month(END+1),1)>						 
								 	  
							  </cfloop>
							  					    
							  </cfif>
							    
						  </cfloop>  						
					
						  <cfparam name="caller.crd" default="0">
					
						</cftransaction>
				
					</cfif>
												
										
			</cfloop>
						
			</cfif>
			
			<cfparam name="caller.crd" default="0">
										
	</cffunction>
	
	<cffunction name="InsertBalanceRecord"
             access="public"            
             displayname="Record balance record">
			 
			<cfargument name="Datasource"   type="string"  required="true"   default="AppsEmployee">
			<cfargument name="Mode"         type="string"  required="true"   default="">
			<cfargument name="Balance"      type="string"  required="true"   default="0">
			<cfargument name="BAL"          type="string"  required="true"   default="0">
			<cfargument name="MEMO"         type="string"  required="true"   default="">
		    <cfargument name="PersonNo"     type="string"  required="true"   default="">
			<cfargument name="ContractType" type="string"  required="true"   default="">
			<cfargument name="ContractTime" type="string"  required="true"   default="">
		    <cfargument name="Mission"      type="string"  required="true"   default=""> 
			<cfargument name="LeaveType"    type="string"  required="true"   default="">  
			<cfargument name="Itm"          type="string"  required="true"   default="">  
			<cfargument name="START"        type="string"  required="true"   default="">  
			<cfargument name="END"          type="string"  required="true"   default=""> 
											
											 						
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
					AND      	ContractType   = '#ContractType#'
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
								
									<cfquery name="getPeriod" 
									datasource="AppsEmployee" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT * 
										FROM  Ref_LeaveTypeMission
										WHERE LeaveType = '#leavetype#'
										AND   Mission   = '#Mission#'												
									</cfquery>		
									
									<cfif getPeriod.EntitlementDuration neq "">
								
									<cfset hdate = dateadd("m",getPeriod.EntitlementDuration*-1,start)>
									
										<cfquery name="get" 
										  datasource="AppsEmployee" 	 
										  username="#SESSION.login#" 
										  password="#SESSION.dbpw#">
									        SELECT   	*
											FROM     	PersonLeaveBalance
											WHERE       PersonNo      = '#PersonNo#' 
											AND         LeaveType     = '#leaveType#'
											AND         Mission       = '#Mission#'
											AND         BalanceStatus = '0'
											AND         DateEffective = CONVERT("date", #hdate#)
										</cfquery>
										
										<cfif get.taken neq "">
													
											<cfset ADJ = get.taken>
											<cfset Memo = "Balance revival">
																
										</cfif>
									
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
								AND     Status          in ('0','1','2')  <!--- approved --->					
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
											AND     Status in ('0','1','2') <!--- approved or not --Muserref Aki --->		
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
										<!---<cfoutput>Testing... CRD=#CRD# DS=#DS#  DE=#DE# End=#End#" Credit=#credit.CreditFull#<br></cfoutput>--->										
										<!--- we have a break, so we reset this --->
										<cf_LeaveAccrual DS="#DS#"  DE="#DE#" End="#End#" Credit="#credit.CreditFull#" mode="Standard">
										<!---<cfoutput>Testing... CRD=#CRD# DS=#DS#  DE=#DE# End=#End#" Credit=#credit.CreditFull#<br></cfoutput>--->										
																			
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
															 						 
								 <cfif crd lt 0.24>
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
									
																			
									<!---<cfoutput>
										Testing... #END#  crd=#CRD#<br>
									</cfoutput>	--->
												 
								 <!---
								 <cfoutput>#str#:#AT#--#corr# #crd#-#m#-#factor#<br></cfoutput>									
								 --->					 
																											
								 <cfif ST EQ BT>	
														
									 <cfif crd lt 0.24>
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
																												
									  <cfif crd lt 0.24>
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
						
						<!---
						
						<cfoutput>#start# #CRD# #TKN#<br></cfoutput>
						
						--->
							
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
												'#ContractType#',
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
			
			<cfreturn BAL>
			 
	</cffunction>			 

	<cffunction name="RemovePersonWork"
             access="public"
             returntype="numeric"
             displayname="Record on PersonWork and PersonWorkDetail">
				
		<cfargument name="Datasource"   type="string"  required="true"   default="">
		<cfargument name="PersonNo"   type="string"  required="true"   default="">
		<cfargument name="WorkDate"   type="date"  	 required="true"   default="">

		<cfquery name="removePersonWorkScheduled" 
			datasource="#Datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE
				FROM 	Employee.dbo.PersonWork
				WHERE	PersonNo = '#PersonNo#'
				AND 	CalendarDate = #WorkDate#
				AND 	TransactionType = '2'
		</cfquery>

		<cfquery name="removePersonWorkActualDetail" 
			datasource="#Datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE
				FROM 	Employee.dbo.PersonWorkDetail
				WHERE	PersonNo = '#PersonNo#'
				AND 	CalendarDate = #WorkDate#
				AND 	TransactionType = '1'
				AND 	ActionClass IN (SELECT ActionClass FROM Employee.dbo.Ref_WorkAction WHERE ActionParent IN ('Worked','Travel'))
		</cfquery>

		<cfquery name="removePersonWorkActualEmptyParent" 
			datasource="#Datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE 	PW
				FROM 	Employee.dbo.PersonWork PW
				WHERE	PersonNo = '#PersonNo#'
				AND 	CalendarDate = #WorkDate#
				AND 	TransactionType = '1'
				AND 	NOT EXISTS (SELECT 'X' FROM Employee.dbo.PersonWorkDetail PWD WHERE PWD.PersonNo = PW.PersonNo AND PWD.CalendarDate = PW.CalendarDate AND PWD.TransactionType = PW.TransactionType)
		</cfquery>

		<cfreturn 0>
	
	</cffunction>

	<cffunction name="InsertPersonWork"
             access="public"
             returntype="numeric"
             displayname="Record on PersonWork and PersonWorkDetail">
				
		<cfargument name="PersonNoFrom"   type="string"  required="true"   default="">
		<cfargument name="WorkDateFrom"   type="date"  	 required="true"   default="">
		<cfargument name="PersonNoTo"     type="string"  required="true"   default="">
		<cfargument name="WorkDateTo"     type="date"  	 required="true"   default="">

		<cfset vCountInserts = 0>

		<!--- ****************** GET ASSIGNMENT FOR THE DAY THAT WILL BE COPIED *********************** --->
		<cfquery name="assign" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		  	    SELECT 	P.*, O.OrgUnitName, O.Mission
		      	FROM 	PersonAssignment P, 
				       	Organization.dbo.Organization O
		  		WHERE	P.DateEffective <= #WorkDateTo# 
				AND   	P.DateExpiration   >= #WorkDateTo#
				AND   	P.Incumbency       > 0
				AND   	P.AssignmentStatus IN ('0','1')
		        AND   	P.AssignmentClass = 'Regular'
		        AND  	P.AssignmentType  = 'Actual'
		       	AND   	P.OrgUnit         = O.OrgUnit
		  		AND   	P.PersonNo        = '#PersonNoTo#'
		</cfquery>

		<!--- ****************** INSERT ONLY IF A VALID ASSIGNMENT FOR THE DATE IS FOUND *********************** --->
		<cfif assign.recordCount gt 0>

			<!--- ****************** INSERT PERSONWORK AND PERSONWORKDETAIL *********************** --->
			<cftransaction>

				<!--- ****************** CLEAN ALL SCHEDULED ON THE TARGET DATE *********************** --->
				<cfinvoke component = "Service.Process.Employee.Attendance"  
					method = "RemovePersonWork"
					Datasource = "AppsEmployee"
				   	PersonNo = "#PersonNoTo#"
					WorkDate = "#WorkDateTo#">	

				<cfloop index="tratpe" list="1,2">
					<cfset vThisInsert = 1>

					<!--- ****************** VALIDATE IF EXISTS ACTUAL PLANNING ON THE TARGET DATE *********************** --->
					<cfif tratpe eq 1>
						<cfquery name="validateActual" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT 	*
								FROM 	[dbo].[PersonWork]
								WHERE	PersonNo = '#PersonNoTo#'
								AND 	CalendarDate = #WorkDateTo#
								AND 	TransactionType = '1'
						</cfquery>

						<!--- ****************** IF EXISTS THEN DO NOT INSERT *********************** --->
						<cfif validateActual.recordCount gt 0>
							<cfset vThisInsert = 0>
						</cfif>

					</cfif>

					<cfif vThisInsert eq 1>
						
						<!--- ****************** INSERT PERSONWORK *********************** --->
						<cfquery name="insertHeader" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								INSERT INTO	PersonWork
									(PersonNo, 
									CalendarDate,
									TransactionType,
									OrgUnit,
									Memo,
									OfficerUserId,
									OfficerLastName, 
							    	OfficerFirstName)
								SELECT 	'#PersonNoTo#'
										,#WorkDateTo#
										,[TransactionType]
										,'#assign.OrgUnit#'
										,'Copied from  #PersonNoFrom# - #dateFormat(WorkDateFrom, client.dateformatshow)#'
										,'#SESSION.acc#'
						    		    ,'#SESSION.last#'
										,'#SESSION.first#'
								FROM 	[dbo].[PersonWork]
								WHERE	PersonNo = '#PersonNoFrom#'
								AND 	CalendarDate = #WorkDateFrom#
								AND 	TransactionType = '#tratpe#'
						</cfquery>
						
						<!--- ****************** INSERT PERSONWORKDETAIL *********************** --->
						<cfquery name="insertLines" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								INSERT INTO PersonWorkDetail
										   (PersonNo, 
										    CalendarDate, 
											TransactionType,
											CalendarDateHour,
											HourSlot,
											Hourslots,
											HourSlotMinutes,
											ActionClass,
											ActionCode,
											ActionMemo,
											LocationCode,
											BillingMode,
											ActivityPayment,
											ParentHour,
											OfficerUserId,
										    OfficerLastName, 
									        OfficerFirstName)
								SELECT     '#PersonNoTo#', 
								           #WorkDateTo#,
										   '#tratpe#',
										   CalendarDateHour,				   
										   HourSlot,
										   Hourslots,
										   HourSlotMinutes,
										   ActionClass,
										   ActionCode,
										   ActionMemo,
										   LocationCode,
										   BillingMode,
										   ActivityPayment,
										   ParentHour,
										   '#SESSION.acc#',	
										   '#SESSION.last#', 
										   '#SESSION.first#'
								FROM       PersonWorkDetail
								WHERE	   CalendarDate    = #WorkDateFrom#
								AND        PersonNo        = '#PersonNoFrom#' 
								AND        TransactionType = '#tratpe#'
						</cfquery>

						<!--- ****************** INSERT SUMMARY *********************** --->
						<cf_summaryCalculation
							personNo = "#PersonNoTo#"
							date="#WorkDateTo#">

						<cfset vCountInserts = vCountInserts + 1>

					</cfif>
					
				</cfloop>	

			</cftransaction> 	

		</cfif>

		<cfreturn vCountInserts>
	
	</cffunction>

</cfcomponent>	

