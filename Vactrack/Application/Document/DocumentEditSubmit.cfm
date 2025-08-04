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