
<cfquery name="parameter" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Parameter 
	  WHERE  Identifier = 'A'				  
</cfquery>	
	
<cfquery name="schedule" 
  	datasource="AppsEmployee" 
  	username="#SESSION.login#" 
  	password="#SESSION.dbpw#">
	  SELECT    TOP 1 *
	  FROM      PersonWorkSchedule S 
	  WHERE     PersonNo         = '#form.PersonNo#'
	  AND       Mission          = '#form.Mission#'	 
	  AND       DateEffective    <= #STR#	 
	  ORDER BY  DateEffective DESC
</cfquery>
				
<cfquery name="check" 
  	datasource="AppsEmployee" 
  	username="#SESSION.login#" 
  	password="#SESSION.dbpw#">
      SELECT    TOP 1 *
	  FROM      PersonWork 
	  WHERE     PersonNo        = '#Form.PersonNo#' 
	  AND       CalendarDate    = #STR#
	  AND       TransactionType = '1'
</cfquery>
	
<cfif check.recordcount eq "0">

	<cfquery name="addheader" 
	  	datasource="AppsEmployee" 
	  	username="#SESSION.login#" 
	  	password="#SESSION.dbpw#">
	      INSERT INTO PersonWork
		      (PersonNo,
			   CalendarDate,
			   OrgUnit,
			   OfficerUserId,
			   OfficerLastName,
			   OfficerFirstName)
		  VALUES
			  ('#form.PersonNo#',
			   #STR#,
			   '#orgunit#',
			   '#session.acc#',
			   '#session.last#',
			   '#session.first#')				  
    </cfquery>

</cfif>

<cfquery name="Modality" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    * 
	FROM      Payroll.dbo.Ref_PayrollTrigger
	WHERE     TriggerGroup = 'Overtime'
	and       Description NOT LIKE '%Differential%'
	ORDER BY  TriggerSort
</cfquery>

<!--- read into an array to apply --->

<cfloop query="Modality">
	<cfset mde[currentrow] = SalaryTrigger>
</cfloop>

<cfset cnt = "0">

<cfloop index="hr" from="#parameter.hourstart#" to="#parameter.hourend#" step="1">

    <cfif hr gte "6">

		<cfloop index="slot" from="1" to="#schedule.hourslots#">					
		
			<cfparam name = "Form.BillingMode_#hr#_#slot#"    default="">
			<cfparam name = "Form.BillingPayment_#hr#_#slot#" default="0">
			
			<cfset mode = evaluate("Form.BillingMode_#hr#_#slot#")>
			<cfset paym = evaluate("Form.BillingPayment_#hr#_#slot#")>					
												
			<cfif mode eq "covered">
						
				<!--- no action we leave it but maybe we can enable this as it won't undertwrite edits --->					
				
			<cfelseif mode eq "">
			
				<!--- not sure this is a good idea as this will be overwritten when you press update in the schedule --->
			
				<cfquery name="get" 
				  	datasource="AppsEmployee" 
				  	username="#SESSION.login#" 
				  	password="#SESSION.dbpw#">
				      DELETE FROM PersonWorkDetail 
					  WHERE  PersonNo         = '#Form.PersonNo#' 
					  AND    CalendarDate     = #str#
					  AND    TransactionType  = '1'
					  AND    CalendarDateHour = '#hr#'
					  AND    HourSlot         = '#slot#'
			    </cfquery>			
			
			<cfelseif findNoCase("overtime",mode)>
						
				<cfset cnt = cnt+1>
			
				<cfquery name="getbalance" 
				  	datasource="AppsEmployee" 
				  	username="#SESSION.login#" 
				  	password="#SESSION.dbpw#">
					SELECT   TOP 1  Balance
					FROM     PersonLeaveBalance
					WHERE    LeaveType IN (SELECT LeaveType 
					                       FROM   Ref_LeaveType
                                           WHERE  LeaveAccrual = '2') 
					AND      PersonNo = '#Form.PersonNo#' 
					AND      Mission  = '#Form.Mission#'	
					AND      DateEffective <= #str#
					ORDER BY DateExpiration DESC	
										
				</cfquery>	
				
				<cfquery name="getthreshold" 
				  	datasource="AppsEmployee" 
				  	username="#SESSION.login#" 
				  	password="#SESSION.dbpw#">
					SELECT    MaximumBalance
					FROM      Ref_LeaveTypeCredit
					WHERE     LeaveType IN (SELECT LeaveType 
					                        FROM   Ref_LeaveType
                                            WHERE  LeaveAccrual = '2') 
											
				</cfquery>
				
				<cfif getBalance.Balance gte getthreshold.maximumBalance>				
					<cfset paym = "1">								
				<cfelse>				
					<cfset paym = "0">					
				</cfif>
							
				<cfquery name="get" 
				  	datasource="AppsEmployee" 
				  	username="#SESSION.login#" 
				  	password="#SESSION.dbpw#">
				      SELECT  TOP 1 *
					  FROM    PersonWorkDetail 
					  WHERE   PersonNo         = '#Form.PersonNo#' 
					  AND     CalendarDate     = #str#
					  AND     TransactionType  = '1'
					  AND     CalendarDateHour = '#hr#'
					  AND     HourSlot         = '#slot#' 
				</cfquery>
					
				<cfif get.recordcount eq "1">
								
					<!---- update --->
				
					<cfquery name="update" 
					  	datasource="AppsEmployee" 
					  	username="#SESSION.login#" 
					  	password="#SESSION.dbpw#">
					      UPDATE  PersonWorkDetail 
						  SET     BillingMode      = '#mode#', 
						          BillingPayment   = '#paym#', 
								  Source           = 'Overtime',
								  SourceId         = '#url.overtimeid#'							       
						  WHERE   PersonNo         = '#Form.PersonNo#' 
						  AND     CalendarDate     = #str#
						  AND     TransactionType  = '1'
						  AND     CalendarDateHour = '#hr#'
						  AND     HourSlot         = '#slot#'							  							       
					</cfquery>
												
				<cfelse>
				
					<!--- we set the business rule for type of overtime as it applies for STL --->
					
					<cfinvoke component = "Service.Process.Employee.PersonnelAction"
						    Method          = "getGrade"
						    PersonNo        = "#Form.PersonNo#"
							Mission         = "#Form.mission#"
							Mode            = "force"	
							Seldate         = "#dateformat(str, client.dateformatshow)#"
						    ReturnVariable  = "PersonGrade">								
							
					  <!--- we check generically how many days this person has been working continuously prior to the date --->																			
					 					  
					  <cfset days = 0>
					  
					  <cfloop index="day" from="1" to="6">
					  
					 	   <cfset pri = dateAdd("d", day*-1, str)>
					  
						   <cfquery name="getofficial" 
						  	datasource="AppsEmployee" 
						  	username="#SESSION.login#" 
						  	password="#SESSION.dbpw#">
						      SELECT  *
							  FROM    PersonWorkDetail
							  WHERE   PersonNo     = '#Form.PersonNo#' 
							  AND     CalendarDate = #pri# 
							  AND     ActionClass is not NULL <!--- something officially covered on that date --->						  
						  </cfquery>						 						 
						  
						  <cfquery name="gettime" 
						  	datasource="AppsEmployee" 
						  	username="#SESSION.login#" 
						  	password="#SESSION.dbpw#">
						      SELECT  *
							  FROM    PersonWorkDetail
							  WHERE   PersonNo     = '#Form.PersonNo#' 
							  AND     CalendarDate = #pri# 							  					  
						  </cfquery>
					  
						  <cfif getofficial.recordcount gte "1">
					  
							  	<cfset days = days + 1>														
								
						  <cfelseif gettime.recordcount eq "0">	<!--- there is noting recorded for this date --->	
						  
						  	<!--- check weekly workschedule if the person was supposed to work because this info is not recorded yet in the time sheet time --->
							
							<cfquery name="getwork" 
						  	datasource="AppsEmployee" 
						  	username="#SESSION.login#" 
						  	password="#SESSION.dbpw#">
							      SELECT *
								  FROM   PersonWorkSchedule
								  WHERE  PersonNo  = '#Form.PersonNo#' 
								  AND    Weekday   = #dayofweek(pri)# 							  					  
								  AND    Mission   = '#Form.mission#'
								  <!--- of the active schedule --->
								  AND    DateEffective = (SELECT MAX(DateEffective) 
								                          FROM   PersonWorkSchedule
														  WHERE  PersonNo    = '#Form.PersonNo#'
														  AND    Mission     = '#Form.Mission#'
														  AND    DateEffective <= #pri#)
						  	</cfquery>
													  
						  	<cfif getWork.recordcount gte "1">							
								<cfset days = days + 1>						  
							</cfif>
														
						   <cfelse>					 
					  
						  </cfif>						  		  
					  
					</cfloop>
					
					<cfquery name="getholiday" 
					  	datasource="AppsEmployee" 
					  	username="#SESSION.login#" 
					  	password="#SESSION.dbpw#">
							SELECT *
							FROM   PersonWorkDetail
						 	WHERE  PersonNo     = '#Form.PersonNo#' 
							AND    CalendarDate = #pri# 
							AND    ActionClass  = 'break'						  
					</cfquery>	
										
									
					<cfif left(PersonGrade,1) eq "P">	
						<cfset mode = mde[1]>	<!--- always the same  --->							
					<!--- <cfelseif days eq "6" or getHoliday.recordcount eq "1" or dayofweek(str) eq "1">	--->										
					<cfelseif getHoliday.recordcount eq "1" or dayofweek(str) eq "1">	
						<cfset mode = mde[3]>	<!--- 200%             --->
					<cfelseif days eq "5" or dayofweek(str) eq "7">	
					    <cfset mode = mde[2]>   <!--- always 150%      ---> 
					<cfelseif cnt eq "1" and days lte "4">				
						<cfset mode = mde[1]>	<!--- first half hour  --->									
					<cfelse>			
						<cfset mode = mde[2]>	<!--- 150%    		   --->
					</cfif>
				
					<cfquery name="addline" 
					  	datasource="AppsEmployee" 
					  	username="#SESSION.login#" 
					  	password="#SESSION.dbpw#">
						
					      INSERT INTO PersonWorkDetail
						      (PersonNo,
							   CalendarDate,
							   CalendarDateHour,
							   Hourslot,
							   HourSlots,
							   HourSlotMinutes,
							   ActionClass,
							   BillingMode,
							   BillingPayment,
							   Source,
							   SourceId,
							   OfficerUserId,
							   OfficerLastName,
							   OfficerFirstName)
						  VALUES
							  ('#form.PersonNo#',
							   #STR#,
							   '#hr#',
							   '#slot#',
							   '#schedule.hourslots#',
							   '#60/schedule.hourslots#',
							   'Indirect',
							   '#mode#',
							   '#paym#',	
							   'Overtime',
							   '#url.overtimeid#',							  
							   '#session.acc#',
							   '#session.last#',
							   '#session.first#')				  
				    </cfquery>
					
					<!--- we check if the overtime is exceeded the threshold, if it does then we set as payment  --->
					
					<cfquery name="checkovertime" 
					  	datasource="AppsEmployee" 
					  	username="#SESSION.login#" 
					  	password="#SESSION.dbpw#">
							SELECT    SUM(HourSlotMinutes) AS Minutes
							FROM      PersonWorkDetail 
							WHERE     PersonNo        = '#form.PersonNo#' 
							AND       CalendarDate    = #str# 
							AND       TransactionType = '1'
							AND       BillingMode    != 'Contract'
							AND       Source          = 'Overtime'
							AND       SourceId        = '#url.overtimeid#'											
					</cfquery>
						
					<cfset vHour = int(checkovertime.minutes/60)>
					<cfif getBalance.Balance eq "">
						<cfset bal = 0>
					<cfelse>
						<cfset bal = getBalance.Balance>	
					</cfif>
				     
															
					<cfif (bal + vHour) gt getthreshold.maximumBalance>		
					
						<cfquery name="checkovertime" 
					  	datasource="AppsEmployee" 
					  	username="#SESSION.login#" 
					  	password="#SESSION.dbpw#">
							UPDATE    PersonWorkDetail 
							SET       BillingPayment   = '1'
							WHERE     PersonNo         = '#form.PersonNo#' 
							AND       CalendarDate     = #str# 
							AND       TransactionType  = '1'
							AND       CalendarDateHour = '#hr#'
							AND       Hourslot         = '#slot#'			
					   </cfquery>	
															
					</cfif>
																			
				</cfif>
			
			</cfif>
						
		</cfloop>	
	
	</cfif>		

</cfloop>

