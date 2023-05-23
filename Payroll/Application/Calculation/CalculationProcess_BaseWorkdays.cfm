
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

<cfif Schedule.SalaryBasePeriodDays eq "30fix" and daysInMonth(SALSTR) eq "31">

		<cfquery name="Remove" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE 
				FROM userTransaction.dbo.sal#SESSION.thisprocess#Dates
				WHERE CalendarDate = #date#				
		</cfquery>	

</cfif>

