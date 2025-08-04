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

<!--- show the transaction --->


<cfoutput>

	<script>

		function processaction(act,des,doc,src) {
		if (confirm("Do you want to " + des + " this transaction ?")) {
		    window.location = "AssignmentActionProcess.cfm?action=1&act=" + act + "&doc=" + doc + "&src=" + src, "right";
	  	}
	}

</script>	
</cfoutput>

<cfquery name="SearchResult" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    	 SELECT * FROM EmployeeAction 		
		 WHERE  ActionDocumentNo = '#url.actionReference#'	
</cfquery>				

<cfset ActionStatus = SearchResult.actionStatus>

<cfinclude template="../Authorization/Staffing/TransactionViewDetail.cfm">

