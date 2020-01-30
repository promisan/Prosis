
<!--- set percentage --->

<cfif not LSIsNumeric(url.value)>

	<script>
	    alert('Incorrect percentage')
	</script>	 		
	<cfabort>
	
</cfif>


<cfquery name="ProgramAllotment" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE   ProgramAllotmentRequest
		SET      AmountBasePercentageDue = '#url.value/100#'
		WHERE    RequirementId = '#url.requirementid#'		
	</cfquery>