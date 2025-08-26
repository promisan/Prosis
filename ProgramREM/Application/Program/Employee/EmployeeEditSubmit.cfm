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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->
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
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE ProgramPeriodOfficer 
	SET   PersonNo    = '#Form.PersonNo#', 
	      ProgramDuty = '#ProgramDuty#',
		  Remarks     = '#Remarks#',
		  DateEffective = #STR#,
		  DateExpiration = #END#
	WHERE ProgramOfficerNo = '#FORM.ProgramOfficerNo#'	
	</cfquery>		

<cfelse>

	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE ProgramPeriodOfficer 
	SET RecordStatus  = '9'
	WHERE ProgramOfficerNo = '#FORM.ProgramOfficerNo#'	
	</cfquery>		

</cfif>

<cflocation url="../Employee/EmployeeView.cfm?ProgramCode=#Form.ProgramCode#&Period=#Form.Period#&Layout=#Form.Layout#" addtoken="No">		  


