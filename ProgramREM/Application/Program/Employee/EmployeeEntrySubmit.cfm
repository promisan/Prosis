

<cfif Len(#Form.ProgramDuty#) gt 100>
  <cfset ProgramDuty = left(#Form.ProgramDuty#,100)>
<cfelse>
  <cfset ProgramDuty = #Form.ProgramDuty#>
</cfif>  

<cfif Len(#Form.Remarks#) gt 50>
  <cfset remarks = left(#Form.Remarks#,50)>
<cfelse>
  <cfset remarks = #Form.Remarks#>
</cfif>  

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = #dateValue#>

<cfset dateValue = "">
<cfif #Form.DateExpiration# neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = #dateValue#>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<cfquery name="Check" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   ProgramPeriodOfficer
	WHERE  ProgramCode = '#Form.ProgramCode#'
	AND    Period  = '#Form.Period#'
	AND    PersonNo = '#FORM.PersonNo#'	
</cfquery>		

<cfif check.recordcount gte '1'>

<cfquery name="Update" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE ProgramPeriodOfficer 
	SET    PersonNo       = '#Form.PersonNo#', 
	       ProgramDuty    = '#ProgramDuty#',
		   Remarks        = '#Remarks#',
		   DateEffective  = #STR#,
		   DateExpiration = #END#,
		   RecordStatus   = '1'
	WHERE  ProgramCode = '#Form.ProgramCode#'
	AND    Period  = '#Form.Period#'
	AND    PersonNo = '#FORM.PersonNo#'	
</cfquery>		

<cfelse>

<cfquery name="Insert" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO ProgramPeriodOfficer 
         (ProgramCode, 
		  Period,
		  PersonNo,
		  ProgramDuty,
		  Remarks,
		  DateEffective,
		  DateExpiration,
		  OfficerUserId,
		  OfficerLastName,
		  OfficerFirstName,
		  Created)
  VALUES ('#Form.ProgramCode#', 
  		  '#Form.Period#',
		  '#Form.PersonNo#',
		  '#ProgramDuty#',
		  '#Remarks#',
		  #STR#,
		  #END#,
		  '#SESSION.acc#',
		  '#SESSION.last#',
		  '#SESSION.first#',
		  getDate())
</cfquery>		

</cfif>

<cflocation url="../Employee/EmployeeView.cfm?ProgramCode=#Form.ProgramCode#&Period=#Form.Period#&Layout=#Form.Layout#" addtoken="No">		  


