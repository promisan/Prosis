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
						 '#dateFormat(k,client.dateSQL)#',		
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
					AND           CalendarDate = '#dateFormat(k,client.dateSQL)#'
			</cfquery>
			
			<cfquery name  = "clearPosition" 
		    	datasource= "AppsEmployee" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">    
				DELETE FROM   WorkSchedulePosition
			    WHERE         WorkSchedule = '#url.workschedule#'					  
				AND           CalendarDate = '#dateFormat(k,client.dateSQL)#'
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
						VALUES ('#url.workschedule#','#dateFormat(k,client.dateSQL)#','#hr#',<cfif cls eq "">NULL<cfelse>'#cls#'</cfif>)		
					</cfquery>	
								
				</cfloop>
				
				<!--- adding positions but only if valid --->
				
				<cfif form.selected neq "">
				
					<cfquery name  = "add" 
				    	datasource= "AppsEmployee" 
					    username  = "#SESSION.login#" 
						password  = "#SESSION.dbpw#">    
						INSERT INTO WorkSchedulePosition
							    (WorkSchedule,CalendarDate,PositionNo,OfficerUserId,OfficerLastName,OfficerFirstName)
						SELECT  '#url.workschedule#',
						        '#dateFormat(k,client.dateSQL)#',
								PositionNo,
								'#session.acc#',
								'#session.last#',
								'#session.first#'
						FROM    Position
						WHERE   PositionNo IN (#preserveSingleQuotes(Form.Selected)#)		
						AND		'#dateFormat(k,client.dateSQL)#' BETWEEN DateEffective AND DateExpiration
					</cfquery>	
				
				</cfif>
				
			<cfelse>
			
				<cfquery name  = "clearDate" 
			    	datasource= "AppsEmployee" 
				    username  = "#SESSION.login#" 
					password  = "#SESSION.dbpw#">    
						DELETE FROM  WorkScheduleDate
					    WHERE        WorkSchedule = '#url.workschedule#'					  
						AND          CalendarDate = '#dateFormat(k,client.dateSQL)#'
				</cfquery>
				
				<cfquery name  = "clearPosition" 
		    	datasource= "AppsEmployee" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">    
					DELETE FROM   WorkSchedulePosition
				    WHERE         WorkSchedule = '#url.workschedule#'					  
					AND           CalendarDate = '#dateFormat(k,client.dateSQL)#'  xxxxx
				</cfquery>
						
			</cfif>
			
		</cfif>
		
	</cfloop>	
	
</cfif>

