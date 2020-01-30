<cfquery name="deleteTrigger" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE 
		FROM 	Employee.dbo.Ref_LeaveTypeClassTrigger
		WHERE   LeaveType = '#url.LeaveType#'
		AND 	LeaveTypeClass = '#url.LeaveTypeClass#'
		AND 	SalaryTrigger = '#url.salaryTrigger#'
</cfquery>

<cfif url.status eq "true">
	<cfquery name="insertTrigger" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO [dbo].[Ref_LeaveTypeClassTrigger]
		           ([LeaveType]
		           ,[LeaveTypeClass]
		           ,[SalaryTrigger]
		           ,[OfficerUserId]
		           ,[OfficerLastName]
		           ,[OfficerFirstName])
		     VALUES
		           ('#url.LeaveType#'
		           ,'#url.LeaveTypeClass#'
		           ,'#url.salaryTrigger#'
		           ,'#session.acc#'
		           ,'#session.last#'
		           ,'#session.first#')
	</cfquery>
</cfif>