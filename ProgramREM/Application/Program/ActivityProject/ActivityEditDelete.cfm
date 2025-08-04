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

<cftransaction>
	
	<cfquery name = "DeleteActivity" 
		datasource= "AppsProgram" 
		username  = "#SESSION.login#" 
		password  = "#SESSION.dbpw#">
		UPDATE  ProgramActivity 
	    SET     RecordStatus = '9'
		WHERE   ActivityId = '#URL.ActivityId#'	 
	</cfquery>		
					
	<!--- remove child or parent records --->	
	
	<cfquery name="DeleteDependency" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE ProgramActivityParent
	    WHERE  ActivityId = '#URL.ActivityId#' OR ActivityParent = '#URL.ActivityId#'		 
	</cfquery>	

</cftransaction>

<!--- should also recalculated the dates --->	 

<script>
    
	try { opener.document.getElementById('progressrefresh').click() } catch(e) { }
	window.close()
	    
</script>	