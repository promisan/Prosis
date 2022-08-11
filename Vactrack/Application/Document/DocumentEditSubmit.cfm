
    <cfset dateValue = "">
	<CF_DateConvert Value="#Form.DueDate#">
	<cfset Due = dateValue>
			
	<cfif Len(Form.Remarks) gt 250>
	 <script>
	 alert("You entered remarks that exceeded the allowed size of 250 characters.")
	 </script>
	 <cfabort>	
	</cfif>	

	<cfquery name="Owner" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterOwner 
		WHERE Owner IN (SELECT MissionOwner 
		                FROM Organization.dbo.Ref_Mission 
						WHERE Mission = '#Form.Mission#')
	</cfquery>
	
	<cfif Owner.DefaultSubmission eq "">
	
		 <script>
	 		alert("Problem, roster has not been configured.")
	 	</script>	
		<cfabort>	
		
	</cfif>
		
	<cfquery name="UpdateDocumentHeader" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Document
	SET FunctionNo        = '#Form.FunctionNo#',
		FunctionalTitle   = '#Form.FunctionalTitle#', 
		OrganizationUnit  = '#Form.OrganizationUnit#',
		DocumentType      = '#form.DocumentType#',
		Mission           = '#Form.Mission#',
		DueDate           = #Due#,
		PostGrade         = '#Form.PostGrade#',
		Remarks           = '#Form.Remarks#'
	WHERE DocumentNo      = '#Form.DocumentNo#'	
	</cfquery>
	
	<script>
		alert("Header information was saved.")
	</script>