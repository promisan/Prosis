<!--
    Copyright © 2025 Promisan B.V.

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
	<cfquery name="SetBaseDays" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE SalarySchedulePeriod
		SET    CalculationBaseDays = '#Form.SalaryDays#'
		WHERE  SalarySchedule      = '#Form.Schedule#'
		AND    Mission             = '#Form.Mission#'
		AND    PayrollStart        = #SALSTR#
	</cfquery>		
	
	<cfset CalculationBaseDays = DATEDIFF("d",PayrollStart,PayrollEnd)+1>

	<cfquery name="FirstLast" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     MIN(CalendarDate) AS FirstDate, 
		           MAX(CalendarDate) as LastDate
		FROM       userTransaction.dbo.sal#SESSION.thisprocess#Dates
		WHERE      Workday = 1
	</cfquery>
	
	<cfquery name="Days" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT sum(workday) as total
		FROM   userTransaction.dbo.sal#SESSION.thisprocess#Dates		
    </cfquery>	
	
	<!--- 
	
	2. now focus on the execptions for on the people which have broken recorded  calculation of payroll days 
		
	1. if a person starts later than the first of the month, he is paid for the days he work to a maximum of 21.75
	2. if a person ends before the last of the month, he is paid balance - days. --->
	
	<!--- A. update people that start on the firstday BUT end during the month --->
	
	<!--- 4/12/2017 provision to adjust the sal start comparisn in case the salstr is on a weekend day 
		
	--->
	  
	<cfquery name="FullMonth" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Payroll
		SET   PayrollDays = '#Form.SalaryDays#', 
		      WorkDays    = '#days.Total#'
		WHERE DateEffective  <= '#dateformat(FirstLast.FirstDate,client.dateSQL)#' 
		AND   DateExpiration >= '#dateformat(FirstLast.LastDate,client.dateSQL)#' 
	</cfquery>	
	
	<!--- 29/8/2018 adjusted to sort by EODMission in order not to mix distinct periods --->
			
	<cfquery name="SelectList" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM    userTransaction.dbo.sal#SESSION.thisprocess#Payroll
		<!--- we consider the first real working day here not just 1 and 31 --->
		WHERE   DateEffective  > '#dateformat(FirstLast.FirstDate,client.dateSQL)#' 
		   OR   DateExpiration < '#dateformat(FirstLast.LastDate,client.dateSQL)#' 
		   
		<!--- 29/8/2018 adjusted to sort by EODMission in order not to mix distinct periods after a new initial contract --->   
		<cfif daymode eq "0">
		ORDER BY PersonNo,EODDateMission,DateEffective ASC					
		<cfelse>
		ORDER BY PersonNo,EODDateMission, DateEffective DESC
		</cfif>		
		

	</cfquery>		
		
	<cfoutput query="selectlist" group="personno">
	
	<cfoutput>
	
		<cfif daymode eq "0">
						
			<!--- only records that have something irregular with start or end --->
						
				<cfif DateEffective eq SALSTR>
						
				    <!--- person starts at the beginning but leaves earlier --->
				
					<cfquery name="Days" 
					datasource="AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT sum(workday) as total
						FROM   userTransaction.dbo.sal#SESSION.thisprocess#Dates
						WHERE  CalendarDate <= '#DateExpiration#'
				    </cfquery>	
					
					<cfif Days.total gte Form.SalaryDays>
						<cfset t = Form.SalaryDays>
					<cfelse>
						<cfset t = Days.total>
					</cfif>			
					
				<cfelseif DateExpiration lte SALEND>
							
					<cfquery name="Days" 
						datasource="AppsQuery" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   SUM(workday) as total 
						FROM     userTransaction.dbo.sal#SESSION.thisprocess#Dates 
						WHERE    CalendarDate >= '#dateEffective#' 
						AND      CalendarDate <= '#dateExpiration#'
				    </cfquery>	
							
					<cfquery name="Prior" 
						datasource="AppsQuery" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   SUM(PayrollDays) as total
							FROM     userTransaction.dbo.sal#SESSION.thisprocess#Payroll
							WHERE    PersonNo = '#PersonNo#'
					</cfquery>	
								
					<cfif prior.total gte "1">
				
				        <!--- this scenario applies if a person has a change of contract 
						 such as a grade/step or schedule change or sepearation during a month --->		
						 
						 						
						<!--- check if there is a third period after the current portion --->
						
						<cfquery name="hasNextLeg" dbtype="query">
							SELECT   *
							FROM	 SelectList
							WHERE    PersonNo = '#personNo#'
							AND      DateExpiration > '#dateformat(DateExpiration,client.dateSQL)#'
						</cfquery>						
												
						<cfif DateEffective gt SALSTR and hasNextLeg.recordcount neq 0>
										
							<cfquery name="Days" 
							datasource="AppsQuery" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT sum(workday) as total 
								FROM   userTransaction.dbo.sal#SESSION.thisprocess#Dates 
								WHERE  CalendarDate >= '#dateEffective#'
								AND    CalendarDate <= '#dateExpiration#'
					        </cfquery>					
							
							<cfset t = days.total>
							
						<cfelse>
						
							<cfif DateExpiration lt SALEND>
							
								<cfquery name="Days" 
								datasource="AppsQuery" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT sum(workday) as total 
									FROM   userTransaction.dbo.sal#SESSION.thisprocess#Dates 
									WHERE  CalendarDate >= '#dateEffective#'
									AND    CalendarDate <= '#dateExpiration#'
						        </cfquery>	
							
								<cfset t = days.total>	
								<cfif (Form.SalaryDays-Prior.total-days.total) lt 0>
									<cfset t = 0>
								</cfif>
													
							<cfelse>
							
								<cfquery name="Days" 
								datasource="AppsQuery" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT SUM(workday) as total 
									FROM   userTransaction.dbo.sal#SESSION.thisprocess#Dates 
									WHERE  CalendarDate > '#dateExpiration#'
						        </cfquery>	
										
								<cfif days.total eq "">				
									<cfset t = Form.SalaryDays-Prior.total>
								<cfelse>
								    <!--- if for one reason the record has 3 instances we also correct for this --->
								    <cfset t = Form.SalaryDays-Prior.total-days.total>						
									<!--- revision, it is better to set this scenario to 0 for Cas this is for closure --->
									<cfset t = 0>
								</cfif>	
							
							</cfif>
							
						</cfif>
		
					<cfelse>
					
					    <!--- ------------------------------------------------------------------ --->
						<!--- person is arriving during the month and ends by the end or earlier --->
						<!--- ------------------------------------------------------------------ --->
					
						<cfif form.Mission eq "C">
						
							<!--- 16/4/2011 In case of Ca correction was requested by German that in case the person is leaving. He/she to be paid the
							working days during that month and NOT the complement to be consistent --->
						
							<cfquery name="Days" 
								datasource="AppsQuery" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT sum(workday) as total 
									FROM   userTransaction.dbo.sal#SESSION.thisprocess#Dates 
									WHERE  CalendarDate >= '#DateEffective#' AND CalendarDate <= '#DateExpiration#'													
							 </cfquery>		
							 
							 <cfif Days.total gte Form.SalaryDays>
								<cfset t = Form.SalaryDays>
							 <cfelseif Days.total eq "">
							    <cfset t = 0>
							 <cfelse>
								<cfset t = Days.total>
							 </cfif>	
					
						<cfelse>
															
							<cfquery name="Days" 
							datasource="AppsQuery" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT SUM(workday) as total 
								FROM   userTransaction.dbo.sal#SESSION.thisprocess#Dates  
								WHERE  CalendarDate < '#DateEffective#' OR CalendarDate > '#DateExpiration#'																
						    </cfquery>					
											
							<cfif Days.total gte Form.SalaryDays or Days.total eq "">
								<cfset t = Form.SalaryDays>
							<cfelse>
								<cfset t = Form.SalaryDays-Days.total>
							</cfif>							
							
						</cfif>			
					
					</cfif>	
								
				</cfif>	
				
				<cfquery name="Update" 
					datasource="AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Payroll
					SET    Workdays = '#days.total#',
					       PayrollDays   = '#t#'
					WHERE  PersonNo      = '#PersonNo#'		
					AND    DateEffective = '#DateEffective#' 
				</cfquery>					
							
		<cfelse>
		
			<!--- STL added mode to give priority to the last leg first for the counting ,
			
			   - we look always for the days towards the end of the contract, and complement with the beginning portion
			   - if we can pay days, we always do pay day and not consistent on 21.75 basis --->			
															
				<cfif DateExpiration eq SALEND>
						
				    <!--- person ends at the end of the month 
					and might come last than the beginning --->
				
					<cfquery name="Days" 
					datasource="AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT sum(workday) as total
						FROM   userTransaction.dbo.sal#SESSION.thisprocess#Dates
						WHERE  CalendarDate >= '#DateEffective#'
				    </cfquery>	
					
					<cfif Days.total gte Form.SalaryDays>
						<cfset t = Form.SalaryDays>
					<cfelse>
						<cfset t = Days.total>
					</cfif>			
					
				<cfelseif DateEffective gte SALSTR>
							
					<cfquery name="Days" 
						datasource="AppsQuery" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   SUM(workday) as total 
						FROM     userTransaction.dbo.sal#SESSION.thisprocess#Dates 
						WHERE    CalendarDate >= '#dateEffective#' 
						AND      CalendarDate <= '#dateExpiration#'
						
				    </cfquery>	
							
					<cfquery name="Prior" 
						datasource="AppsQuery" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   SUM(PayrollDays) as total
							FROM     userTransaction.dbo.sal#SESSION.thisprocess#Payroll
							WHERE    PersonNo = '#PersonNo#'
					</cfquery>					
													
					<cfif prior.total gte "1">
									
				        <!--- this scenario applies if a person has a change of contract 
						 such as a grade/step change
						      schedule change / SPA 
							  or sepearation during a month --->																
												
						<!--- check if there is a third period BEFORE the current portion ????? --->
						
						<cfquery name="hasPriorLeg" dbtype="query">
							SELECT   *
							FROM	 SelectList
							WHERE    PersonNo = '#personNo#'
							AND      DateEffective < '#dateformat(DateEffective,client.dateSQL)#'
						</cfquery>						
																														
						<cfif DateEffective gt SALSTR and hasPriorLeg.recordcount gte 1>
																										
							<cfquery name="Days" 
							datasource="AppsQuery" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT sum(workday) as total 
								FROM   userTransaction.dbo.sal#SESSION.thisprocess#Dates 
								WHERE  CalendarDate >= '#dateEffective#'
								AND    CalendarDate <= '#dateExpiration#'								
					        </cfquery>										
							
							<cfset t = days.total>
							
						<cfelse>
						
							<cfif DateEffective gt SALSTR>
							
								<cfquery name="Days" 
								datasource="AppsQuery" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT sum(workday) as total 
									FROM   userTransaction.dbo.sal#SESSION.thisprocess#Dates 
									WHERE  CalendarDate >= '#dateEffective#'
									AND    CalendarDate <= '#dateExpiration#' 									
						        </cfquery>	
							
								<cfset t = days.total>	
								<cfif (Form.SalaryDays-Prior.total-days.total) lt 0>
									<cfset t = Form.SalaryDays-Prior.total>	
								</cfif>								
																					
							<cfelse>
							
								<!--- the start date = payroll start date --->
								
								<cfquery name="checkFullPeriod" dbtype="query">
									SELECT   MIN(DateEffective) as DateEffective, 
									         MAX(DateExpiration) as DateExpiration
									FROM	 SelectList
									WHERE    PersonNo = '#personNo#'									
								</cfquery>
												
								<cfquery name="Days" 
								datasource="AppsQuery" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT SUM(workday) as total 
									FROM   userTransaction.dbo.sal#SESSION.thisprocess#Dates 
									WHERE  CalendarDate <= '#dateExpiration#'									
						        </cfquery>	
																		
								<cfif days.total eq "">		
									
									<cfset t = 0>
									
								<cfelse>
																   									
								    <cfset t = days.total>	
																			
									<cfif (Form.SalaryDays-Prior.total-days.total) lt 0>									
									    <!--- make it the remainder instead --->
										<cfset t = Form.SalaryDays-Prior.total>																		
									<cfelseif checkFullperiod.DateEffective eq SALSTR and checkFullperiod.DateExpiration eq SALEND>
										<cfset t = Form.SalaryDays-Prior.total>											
									</cfif>
																		
									<!---				
									<cfoutput>#t#:#Form.SalaryDays#-#Prior.total#-#days.total#</cfoutput>
									<cfabort>
									--->
									
								</cfif>	
															
							</cfif>
							
						</cfif>
								
					<cfelse>
					
						<!--- ------------------------------------------------------------------ --->
						<!--- person is departing during the month ----------------------------- --->
						<!--- ------------------------------------------------------------------ --->
						
						<cfquery name="Days" 
							datasource="AppsQuery" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT sum(workday) as total 
								FROM   userTransaction.dbo.sal#SESSION.thisprocess#Dates 
								WHERE  CalendarDate >= '#DateEffective#' AND CalendarDate <= '#DateExpiration#'		
																		
						 </cfquery>		
							 
						 <cfif Days.total gte Form.SalaryDays>
							<cfset t = Form.SalaryDays>
						 <cfelseif Days.total eq "">
						    <cfset t = 0>
						 <cfelse>
							<cfset t = Days.total>
						 </cfif>						
					
					</cfif>	
								
				</cfif>	
				
				<cfquery name="Update" 
					datasource="AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Payroll
					SET    PayrollDays   = '#t#', Workdays = '#days.total#'
					WHERE  PersonNo      = '#PersonNo#'		
					AND    DateEffective = '#DateEffective#' 
				</cfquery>		
										
		</cfif>
		
	</cfoutput>
	
	<!--- check the total on the level of the person only relevant in case of a contining inirtial appointment --->
	
	<cfquery name="getTotal" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT sum(PayrollDays) as Days
		FROM   userTransaction.dbo.sal#SESSION.thisprocess#Payroll		
		WHERE  PersonNo      = '#PersonNo#'				
	</cfquery>		
			
	<cfif getTotal.days gt Form.SalaryDays>
	
		<cfset diff = getTotal.days - Form.SalaryDays> 
	
		<cfquery name="getTotal" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Payroll		
			SET    PayrollDays   = PayrollDays - #diff#
			WHERE  PersonNo      = '#PersonNo#'						
			AND    Line = 1
			
		</cfquery>				
			
	</cfif>			
				
	</cfoutput>		
	