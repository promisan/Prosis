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
<cfset dateValue = "">
<cf_DateConvert Value="#url.upToDate#">
<cfset vDateExpiration = dateValue>

<cfquery name  = "getMan" 
   	datasource= "AppsEmployee" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">    
		SELECT	*
		FROM	Organization.dbo.Ref_Mandate
		WHERE	Mission   = '#url.mission#'
		AND		MandateNo = '#url.mandate#'
</cfquery>

<cfif getMan.DateExpiration lt vDateExpiration>
	<cfset vDateExpiration = getMan.DateExpiration>
</cfif>

<cfquery name  = "getMandate" 
   	datasource= "AppsEmployee" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">    
		SELECT	*
		FROM	Organization.dbo.Ref_Mandate
		WHERE	Mission     = '#url.mission#'
		AND		MandateNo   = '#url.mandate#'
		AND		#url.selectedDate# BETWEEN DateEffective AND DateExpiration
</cfquery>

<cfif getMandate.recordCount gt 0>

	<cfloop index="k" from="#url.selectedDate#" to="#vDateExpiration#" step="#url.everyNDays#">
	
		<cfif evaluate("url.day_" & DayOfWeek(k)) eq "true">
			
			<!--- add day --->		
			<cfquery name  = "getDateM" 
		    	datasource= "AppsEmployee" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">    
				SELECT 	* 
				FROM   	WorkScheduleDate
			    WHERE   WorkSchedule = '#url.workschedule#'					  
				AND     CalendarDate = '#dateFormat(k,"yyyy-mm-dd")#'
			</cfquery>
	
			<cfif getDateM.recordcount eq "0">
			
				<cfquery name  = "add" 
			    	datasource = "AppsEmployee" 
				    username   = "#SESSION.login#" 
					password   = "#SESSION.dbpw#">    					
					INSERT INTO WorkScheduleDate
						(WorkSchedule,
						 CalendarDate,		
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)						 
					VALUES('#url.workschedule#',
						 '#dateFormat(k,"yyyy-mm-dd")#',		
						 '#session.acc#',
						 '#session.last#',
						 '#session.first#')			
				</cfquery>
			</cfif>			
			
			<!--- add hours --->	
			<cfquery name  = "clearHours" 
		    	datasource= "AppsEmployee" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">    
					DELETE FROM   WorkScheduleDateHour
				    WHERE         WorkSchedule = '#url.workschedule#'					  
					AND           CalendarDate = '#dateFormat(k,"yyyy-mm-dd")#'
			</cfquery>
			
			<cfquery name  = "clearPosition" 
		    	datasource= "AppsEmployee" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">    
				DELETE FROM   WorkSchedulePosition
			    WHERE         WorkSchedule = '#url.workschedule#'					  
				AND           CalendarDate = '#dateFormat(k,"yyyy-mm-dd")#'
			</cfquery>
				
			<cfif form.hours neq "">
				
				<cfloop index="hr" list="#form.hours#">
				
					<cfset fieldid = round(hr * 4)>
					<cfparam name="form.ActionClass_#fieldid#" default="">
					<cfset cls = evaluate("form.ActionClass_#fieldid#")>	
															
					<cfquery name  = "add" 
				    	datasource= "AppsEmployee" 
					    username  = "#SESSION.login#" 
						password  = "#SESSION.dbpw#">    
						INSERT INTO WorkScheduleDateHour (WorkSchedule,CalendarDate,CalendarHour,ActionClass)
						VALUES ('#url.workschedule#','#dateFormat(k,"yyyy-mm-dd")#','#hr#',<cfif cls eq "">NULL<cfelse>'#cls#'</cfif>)		
					</cfquery>	
								
				</cfloop>
				
				<!--- adding positions --->
				
				<cfif form.selected neq "">
				
					<cfset vPosList = replace(Form.Selected,"'","","ALL")>
					<cfloop index="pos" list="#vPosList#">
		
						<cfset vPointerBreak = 0>
						<cfif isDefined("Form.pointerBreak_#pos#")>
							<cfif evaluate("Form.pointerBreak_#pos#") neq "-">
								<cfset vPBreakList = replace(evaluate("Form.pointerBreak_#pos#"),"'","","ALL")>
								<cfset cnt = 1>
								<cfloop index="pbreak" list="#vPBreakList#">
									<cfif cnt eq 1>
										<cfif pbreak neq "-">
											<cfset vPointerBreak = pbreak>
										</cfif>
									</cfif>
									<cfset cnt = cnt + 1>
								</cfloop>
							</cfif>
						</cfif>
						
						<cfquery name  = "validate" 
					    	datasource= "AppsEmployee" 
						    username  = "#SESSION.login#" 
							password  = "#SESSION.dbpw#">
							
								SELECT 	*
								FROM	WorkSchedulePosition
								WHERE	WorkSchedule = '#url.workschedule#'
								AND		CalendarDate = '#dateFormat(k,"yyyy-mm-dd")#'
								AND		PositionNo = #pos#
						</cfquery>
						
						<cfif validate.recordCount eq 0>
						
							<cfquery name  = "validatePos" 
					    		datasource= "AppsEmployee" 
							    username  = "#SESSION.login#" 
								password  = "#SESSION.dbpw#">
									SELECT 	*
									FROM	Position
									WHERE	PositionNo = '#pos#'
									AND		'#dateFormat(k,"yyyy-mm-dd")#' BETWEEN DateEffective AND DateExpiration
							</cfquery>
							
							<cfif validatePos.recordCount gt 0>
								<cfquery name  = "add" 
							    	datasource= "AppsEmployee" 
								    username  = "#SESSION.login#" 
									password  = "#SESSION.dbpw#">    
									INSERT  INTO WorkSchedulePosition
										    (WorkSchedule,CalendarDate,PositionNo,<cfif vPointerBreak neq 0>PointerBreak,</cfif>OfficerUserId,OfficerLastName,OfficerFirstName)
									VALUES  ('#url.workschedule#','#dateFormat(k,"yyyy-mm-dd")#',#pos#,<cfif vPointerBreak neq 0>'#vPointerBreak#',</cfif>'#session.acc#','#session.last#','#session.first#')
								</cfquery>	
							</cfif>
							
						</cfif>
						
					</cfloop>	
				
				</cfif>
				
			<cfelse>
			
				<cfquery name  = "clearDate" 
			    	datasource= "AppsEmployee" 
				    username  = "#SESSION.login#" 
					password  = "#SESSION.dbpw#">    
						DELETE FROM   WorkScheduleDate
					    WHERE         WorkSchedule = '#url.workschedule#'					  
						AND           CalendarDate = '#dateFormat(k,"yyyy-mm-dd")#'
				</cfquery>
						
			</cfif>
			
		</cfif>
		
	</cfloop>	
	
</cfif>

