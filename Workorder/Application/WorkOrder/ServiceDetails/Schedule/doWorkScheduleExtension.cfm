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
<cfparam name="url.name"        default="schedule">
<cfparam name="url.workorderid" default="00000000-0000-0000-0000-000000000000">

<CF_DateConvert Value="#url.ExtensionDate#">
<cfset expiry = dateValue>

<!--- 

1.  Select the schedules that are valid (for todays days) and associate these to the last schema 
2.  Determine the last planning date 

loop by scheduleid master table

4.	If day

	Determine the planning hour(s) on the last date.

	Loop until the planning to date 
	
		Create records with source = "Extend"
		

5.  If month

	Loop until the planning to date
	
		Create records with 

--->

<cfquery name="getSchedules" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	    SELECT   WL.DateExpiration,
		         WLS.ScheduleId, 
		         WLS.ScheduleName, 
				 WLS.ActionClass, 
				 WLS.WorkSchedule, 
				 WLS.WorkSchedulePriority, 
				 WLS.ScheduleClass, 
				 WLS.ScheduleEffective,
                 (SELECT  MAX(ScheduleDate) AS Expr1
                  FROM    WorkOrderLineScheduleDate
                  WHERE   ScheduleId = WLS.ScheduleId) AS LastScheduleDate
				  
		FROM     WorkOrderLine AS WL INNER JOIN
                 WorkOrderLineSchedule AS WLS ON WL.WorkOrderId = WLS.WorkOrderId AND WL.WorkOrderLine = WLS.WorkOrderLine
				 
		WHERE    WL.WorkOrderId    = '#url.workorderid#'
		
		AND     (WL.DateExpiration IS NULL OR WL.DateExpiration >= GETDATE()) 
		
		AND      WL.Operational    = 1 
		
		AND      WLS.ActionStatus  = '1'
					
</cfquery>	


<cfoutput query="getSchedules">

	<!--- set the start date of the schedule to be extended --->
		
	<CF_DateConvert Value="#dateformat(LastScheduleDate,client.dateformatshow)#">
	<cfset date = dateValue>
	

	<cfif DateExpiration eq "">
	
		<cfset lineexpiry = expiry>
	
	<cfelse>

		<CF_DateConvert Value="#dateformat(DateExpiration,client.dateformatshow)#">
		<cfset lineexpiry = dateValue>
		
	</cfif>	
	
	
	
	<!--- define the moment until we want to calculate new lines --->
		
	<cfif lineexpiry lt expiry>
		<cfset expiration = ParseDateTime(DateExpiration)>
	<cfelse>	
		<cfset expiration = Expiry>
	</cfif>
	
	<cfset last = "">

	<!---
	<cftransaction>
	--->
	
	<!--- last schema --->
	
	<cfquery name="getSchema" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   TOP 1 ScheduleId, SchemaSerialNo, SchemaName, 
		         DateEffective, DateExpiration, 
				 Periodicity, PeriodicityInterval, ApplyDaysOfWeek, ApplyDaysOfMonth, 
	    	     OfficerUserId, OfficerLastName, OfficerFirstName, Created
		FROM     WorkOrderLineScheduleSchema
		WHERE    ScheduleId = '#scheduleid#'
		ORDER BY SchemaSerialNo DESC
	</cfquery>
	
	<cfquery name="getScheduleDates" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   DISTINCT CalendarDate 
			FROM     Employee.dbo.WorkScheduleDateHour
			WHERE    WorkSchedule = '#workschedule#'
			AND      CalendarDate >= #date#		
			AND      CalendarDate <= #expiration# 
	</cfquery>
	
	<cfset workscheduledatelist = quotedvalueList(getScheduleDates.CalendarDate)> 
	
	<!--- check if the schedule is valid --->
					
	<cfif getSchema.Periodicity eq "day">
			
		<cfset sqlquery = "">		
					
		<cfloop condition="#date# lte #expiration#">		
		
		    <!--- first date into the schedule --->
		    <cfset date = dateAdd("D",getSchema.PeriodicityInterval,date)>
			
			<cfset datesel = dateformat(date,"YYYY-MM-DD")>
						
			<cfif findNoCase(datesel,workscheduledatelist)>
							
				<!--- define the day of week of the date --->
				
				<cfset day = dayofweek(date)>
				
				<cfif findNoCase(day,getSchema.ApplyDaysOfWeek)>			
			
					<!--- generate records --->
					
					<cfif LastScheduleDate neq date>
					
						<cfsavecontent variable="sql">
						INSERT INTO WorkOrderLineScheduleDate 
							       (ScheduleId,ScheduleDate,ScheduleHour,Memo,Source,OfficerUserId,OfficerLastName,OfficerFirstName)
						SELECT ScheduleId,#date#,ScheduleHour,Memo,'Extend','#session.acc#','#session.last#','#session.first#'
						FROM   WorkOrderLineScheduleDate
						WHERE  ScheduleId   = '#scheduleid#' AND ScheduleDate = '#LastScheduleDate#'			
						</cfsavecontent>
												
						<cfset sqlquery = "#sqlquery#  #sql#">
					
					</cfif>
				
				</cfif>
						
			</cfif>
			
			<cfset last = date>	
	
		</cfloop>	
		
		<!--- perform insert in one shot --->
		
		<cfif sqlquery neq "">
		
			<cfquery name="addSchedule" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				#preservesinglequotes(sqlquery)#		
			</cfquery>
		
		</cfif>		
			
	<cfelseif getSchema.Periodicity eq "month">
	
		<cfloop condition="#date# lte #expiration#">
					
		    <cfset date = dateAdd("M",getSchema.PeriodicityInterval,date)>
			
			<!--- define the day of week of the date --->
			
			<cfset yr = year(date)>
			<cfset mt = month(date)>
			<cfset datenew = createDate(yr,mt,1)>
			
			<cfif mt gte "1" and mt lte "12">
			
				<cfloop index="dy" list="#getSchema.ApplyDaysOfMonth#">
				
					<!--- generate records --->
					
					<cftry>
					
						<cfset datenew = createDate(yr,mt,dy)>
						
						<!--- check if the schedule is valid --->
						
						<cfset datesel = dateformat(date,"YYYY-MM-DD")>
												
						<cfif findNoCase(datesel,workscheduledatelist)>
												
							<cfquery name="addSchedule" 
								datasource="AppsWorkOrder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								
								INSERT INTO WorkOrderLineScheduleDate 
								
								       (ScheduleId,
									    ScheduleDate,
										ScheduleHour,
										Memo,
										Source,
										OfficerUserId,
										OfficerLastName,
										OfficerFirstName)
										
								SELECT  ScheduleId, 
								        #datenew#, 
								        ScheduleHour,
										Memo,
										'Extend',
										'#session.acc#',
										'#session.last#',
										'#session.first#'
								FROM    WorkOrderLineScheduleDate
								WHERE   ScheduleId   = '#scheduleid#'
								AND     ScheduleDate = '#LastScheduleDate#'		
								
							</cfquery>
						
						</cfif>
						
				 <cfcatch></cfcatch>
				 
				 </cftry>
								
				</cfloop>
			
			</cfif>
			
			<cfset last = datenew>
	
		</cfloop>				
	
	</cfif>
	
	<cfif last neq "">
	
		<cfquery name="updateSchema" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE   WorkOrderLineScheduleSchema
			SET      DateExpiration = #last# 
			WHERE    ScheduleId     = '#scheduleid#'
			AND      SchemaSerialNo = '#getSchema.SchemaSerialNo#'		
		</cfquery>		
		
	</cfif>		
	
	<cfset SESSION["Count_#url.name#"] = currentrow>
	<cfset SESSION["Base_#url.name#"]  = recordcount>
		
	<!---
	</cftransaction>
	--->
	
</cfoutput>

<script>
 Prosis.busy('no') 
</script>
