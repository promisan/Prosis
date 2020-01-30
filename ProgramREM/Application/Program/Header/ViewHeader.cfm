
<cf_dialogREMProgram>

<cfquery name="getProgram" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Program
	WHERE   ProgramCode    = '#URL.ProgramCode#'
</cfquery>

<cfif getProgram.mission neq "">
	<cfset url.mission = getProgram.mission>
</cfif>

<table width="100%" align="center" class="formpadding">
	<tr>
		<td class="clsPrintContent">
			<cfif getProgram.ProgramClass eq "Program">			
				<cfinclude template="ProgramViewHeader.cfm">
			<cfelse>			
				<cfinclude template="ComponentViewHeader.cfm">
			</cfif>
		</td>
	</tr>
</table>

