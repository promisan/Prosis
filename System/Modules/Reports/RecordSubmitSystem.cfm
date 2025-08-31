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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

	<cfquery name="Update" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Ref_ReportControl
		SET   TemplateBoxes     = '#Form.TemplateBoxes#'
		WHERE ControlId = '#URL.ID#'
		</cfquery>
	
		
	<cfif ParameterExists(Form.Update)>
	
		<script language="JavaScript">
		 opener.history.go() 
	     window.location = "RecordEdit.cfm?Id=<cfoutput>#URL.ID#</cfoutput>"
		 <cfif ParameterExists(Form.Update)>
		 alert("Global parameters have been saved.")
		 </cfif>
		</script>  
	
	<cfelse>
	
		<script language="JavaScript">
		
		 opener.history.go() 		
		 window.close()
		
		</script>
	
	</cfif>
	
		

	
