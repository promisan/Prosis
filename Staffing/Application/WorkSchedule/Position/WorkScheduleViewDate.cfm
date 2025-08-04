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

<cfquery name="Position" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Position
		WHERE  PositionNo = '#URL.PositionNo#'
</cfquery>

<cfif Position.dateEffective lte url.calendardate and Position.DateExpiration gte url.calendardate>

	<cfquery name="PositionSchedule" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT   DISTINCT WS.*
		   FROM     WorkSchedulePosition WSP INNER JOIN
	                WorkSchedule WS ON WSP.WorkSchedule = WS.Code
		  WHERE     WSP.PositionNo  = '#url.positionNo#' 
		  AND       WSP.CalendarDate = #url.calendardate#
		  AND		EXISTS
		  			(
						SELECT 'X'
					    FROM   WorkScheduleDateHour
						WHERE  WorkSchedule = WSP.WorkSchedule
						AND    CalendarDate = WSP.CalendarDate
					)
	</cfquery>
		
	<cfif PositionSchedule.recordcount gt "1">
	
		<cfquery name="Overlap" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT    ROUND(CalendarHour,0)
		    FROM      WorkScheduleDateHour 
			WHERE     WorkSchedule IN (#quotedValueList(PositionSchedule.Code)#) 
			AND       CalendarDate = #url.calendardate#
			GROUP BY  ROUND(CalendarHour,0)	
			HAVING count(*) > 1
		</cfquery>		
				
		<cfif overlap.recordcount gte "1">
			<cfset cl = "red">	
			<cfset ft = "white">
		<cfelse>
			<cfset cl = "white">
			<cfset ft = "black">	
		</cfif>	
		
	<cfelse>
	
		<cfset cl = "white">	
		<cfset ft = "black">	
	
	</cfif>	
	
					
	<table width="96%" bgcolor="<cfoutput>#cl#</cfoutput>" border="0" cellspacing="0" cellpadding="0" align="right">
	
		<cfoutput query="PositionSchedule">
	
			<tr><td class="labelit" style="color:#ft#;padding-left:3px">#Description#:</td>
			
			<td class="labelit" style="color:#ft#;padding-left:3px">
		
			<cfquery name="ScheduleHours" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    SELECT *, (SELECT count(*) 
				              FROM   WorkSchedulePosition 
							  WHERE  WorkSchedule = D.WorkSchedule 
							  AND    CalendarDate = D.CalendarDate) as Positions
				    FROM   WorkScheduleDateHour D
					WHERE  WorkSchedule = '#code#' 
					AND    CalendarDate = #url.calendardate#
			</cfquery>		
			
				<cfset pointer = "">	
				<cfset mode = "start">
		
				<cfloop query="ScheduleHours">
										
						<cfif pointer lt CalendarHour or currentrow eq recordcount>
																	
							<cfif mode eq "End">
							
								<cfset hr = pointer>				
																
							<cfelse>
							
								<cfset hr = calendarhour>	
																						
							</cfif>
										
							<!--- put in the right portion --->
								
							<cfset row = 0>						
								
							<cfloop index="part" list="#hr#" delimiters=".">
										
								<cfset row = row+1>	
																
								<cfif row eq "1">	
																		
									<cfset hr = "#part#">	
									<cfif len(hr) eq "1">								
								    	 <cfset hr = "0#hr#">							
									</cfif>		
														
								<cfelseif row eq "2">	
																	
									<cfif part eq "50" or part eq "5">
										<cfset hr = "#hr#:30">
									<cfelseif part eq "25">
										<cfset hr = "#hr#:15">
									<cfelse>
										<cfset hr = "#hr#:00">			
									</cfif>	
																																    
								</cfif>					
								
							</cfloop>		
								
							<cfif row eq "1">
								  <cfset hr = "#hr#:00">	
							</cfif>		
													
							<cfif mode eq "start">		
							
								<cfset hours = "#hr#h">					
								<cfset mode = "end">	
									
							<cfelse>	
									
								<cfset hours   = "#hours# - #hr#h">															
												
								<!--- ----------- --->
								<!--- outputtting --->
								#hours#
								<!--- ----------- --->
																
								<cfset pointer = "">
								
								<cfset hr = CalendarHour>
													
								<!--- check if there is more records --->
								
								<cfif currentrow lt recordcount>	
								
									<cfset row = 0>						
								
									<cfloop index="part" list="#hr#" delimiters=".">
												
										<cfset row = row+1>	
																														
										<cfif row eq "1">																
											<cfset hr = "#part#">	
											<cfif len(hr) eq "1">								
											     <cfset hr = "0#hr#">							
											</cfif>														
										<cfelseif row eq "2">							   													
											<cfif part eq "50" or part eq "5">
												<cfset hr = "#hr#:30">
											<cfelseif part eq "25">
												<cfset hr = "#hr#:15">
											<cfelse>
												<cfset hr = "#hr#:00">			
											</cfif>																															    
										</cfif>					
										
									</cfloop>	
									
									<cfif row eq "1">
								  	  <cfset hr = "#hr#:00">	
									</cfif>		
									<br>				
				
									<cfset hours   = "#hr#h">		
									
								</cfif>	
								
							</cfif>	
								
						</cfif>
									
						<!--- we define the logical next number --->
						
						<cfif PositionSchedule.HourMode eq "60">		
								<cfset pointer = CalendarHour+1.00>
						<cfelseif PositionSchedule.HourMode eq "30"> 
								<cfset pointer = CalendarHour+0.50>
						<cfelseif PositionSchedule.HourMode eq "20">
								<cfset pointer = CalendarHour+0.333333333333333>
						<cfelseif PositionSchedule.HourMode eq "15">
								<cfset pointer = CalendarHour+0.25>
						</cfif>			
												
					</cfloop>
		
				</tr>
			
		</cfoutput>	
		
	</table>
	
<cfelse>

	<table width="100%" height="100%"><tr><td bgcolor="f4f4f4" class="labelit" align="center">Position not valid</td></tr></table>
	
</cfif>

