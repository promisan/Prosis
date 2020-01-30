
						
<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT * FROM Program
	WHERE ProgramCode = '#URL.Programcode#'
</cfquery>	

<cfif Program.ProgramDescription eq "">

	<cfoutput>
	<table><tr><td width="200" align="center">No additional information available</td></tr></table>
	</cfoutput>

<cfelse>

	<cfoutput>
	<table><tr><td>#Program.ProgramDescription#</td></tr></table>
	</cfoutput>
	
</cfif>	
