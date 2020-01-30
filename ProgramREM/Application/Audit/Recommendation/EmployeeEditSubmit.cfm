
<cfif parameterexists(Form.Update)>

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

<cfquery name="Update" 
datasource="AppsProgram" 
username=#SESSION.login# 
password=#SESSION.dbpw#>
UPDATE ProgramPeriodOfficer 
SET PersonNo    = '#Form.PersonNo#', 
    ProgramDuty = '#ProgramDuty#',
	Remarks     = '#Remarks#',
	DateEffective = #STR#,
	DateExpiration = #END#
WHERE ProgramOfficerNo = '#FORM.ProgramOfficerNo#'	
</cfquery>		

<cfelse>

<cfquery name="Update" 
datasource="AppsProgram" 
username=#SESSION.login# 
password=#SESSION.dbpw#>
UPDATE ProgramPeriodOfficer 
SET RecordStatus  = '9'
WHERE ProgramOfficerNo = '#FORM.ProgramOfficerNo#'	
</cfquery>		


</cfif>

<cflocation url="../Employee/EmployeeView.cfm?ProgramCode=#Form.ProgramCode#&Period=#Form.Period#&Layout=#Form.Layout#" addtoken="No">		  


