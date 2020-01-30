
<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM  Program
    WHERE ProgramCode ='#url.programcode#'
</cfquery>

<cfif Program.EnforceAllotmentRequest eq "1">
			
	<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Program
		SET EnforceAllotmentRequest = 0
		WHERE ProgramCode ='#url.programcode#'
	</cfquery>
	
<cfelse>

	<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Program
		SET EnforceAllotmentRequest = 1
		WHERE ProgramCode ='#url.programcode#'
	</cfquery>

</cfif>

<script>
   history.go()
</script>