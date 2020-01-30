
	<cftry>
		<cfdirectory action="CREATE" directory="#SESSION.rootDocumentPath#\EmployeeFiles\#account#">
		<cfcatch></cfcatch>
	</cftry>
	
	
	<cftry>
		
		<cfif ParameterExists(Form.tanotepadcontent)>
	
			<cffile action = "write" 
		    	file = "#SESSION.rootDocumentPath#\EmployeeFiles\#account#\#account#_notes.txt" 
		    	output = "#Form.tanotepadcontent#" nameconflict="OVERWRITE">
	
		</cfif>
	
	<cfcatch>
	
		<cfoutput>
			<script>
				alert("No account to Associate notes")
			</script>
		</cfoutput>
		
	</cfcatch>	
	
	</cftry>
