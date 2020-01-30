
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

<cfloop index="day" from="0" to="#daysInMonth(SALSTR)-1#" step="1">

	<cfset date = DateAdd("d", "#day#", #salstr#)>
	<cfset dow =  DayOfWeek(date)>
	
	<cfquery name="Schedule" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   SalarySchedule 
		WHERE  SalarySchedule = '#Form.Schedule#'
	</cfquery>
	
	<cfif Schedule.SalaryBasePeriodDays eq "30">
	
			<cfquery name="Insert" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO userTransaction.dbo.sal#SESSION.thisprocess#Dates
			VALUES (#date#,'1') 
			</cfquery>	
		
	<cfelse>		
		
		<cfquery name="Schedule" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   SalaryScheduleWork
			WHERE  SalarySchedule = '#Form.Schedule#'
			AND    Weekday        = '#Dow#'
			
		</cfquery>	
			
		<cfif Schedule.WorkHours gt "0">
			
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

