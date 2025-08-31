<!--
    Copyright © 2025 Promisan B.V.

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
