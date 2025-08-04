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

<!--- calculate the days --->

<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#Dates">	

<cfquery name="Schedule" 
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		CREATE TABLE dbo.sal#SESSION.thisprocess#Dates (
		[CalendarDate] [datetime] NOT NULL ,
		[Workday] [int] NOT NULL ,
		CONSTRAINT [PK_sal#SESSION.thisprocess#] PRIMARY KEY  CLUSTERED 
		(  [CalendarDate]
		)  ON [PRIMARY] 
		) ON [PRIMARY]
		
</cfquery>	

<cfquery name="Schedule" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   SalarySchedule 
		WHERE  SalarySchedule = '#Form.Schedule#'
	</cfquery>

<cfloop index="day" from="0" to="#daysInMonth(SALSTR)-1#" step="1">

	<cfset date = DateAdd("d", "#day#", #salstr#)>
	<cfset dow =  DayOfWeek(date)>
		
	<cfif Schedule.SalaryBasePeriodDays eq "30">
	
			<cfquery name="Insert" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO userTransaction.dbo.sal#SESSION.thisprocess#Dates
			VALUES (#date#,'1') 
			</cfquery>	
		
	<cfelse>		
		
		<cfquery name="WorkSchedule" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   SalaryScheduleWork
			WHERE  SalarySchedule = '#Form.Schedule#'
			AND    Weekday        = '#Dow#'
			
		</cfquery>	
			
		<cfif WorkSchedule.WorkHours gt "0">
			
			<cfquery name="Insert" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO userTransaction.dbo.sal#SESSION.thisprocess#Dates
				VALUES (#date#,'1')
			</cfquery>	
			
		<cfelse>
			
			<cfquery name="Insert" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO userTransaction.dbo.sal#SESSION.thisprocess#Dates
				VALUES (#date#,'0')
			</cfquery>	
					
		</cfif>
		
	</cfif>	

</cfloop>

