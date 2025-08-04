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

<cftry>
	
	<cfquery name="Delete" 
		datasource="#url.dsn#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
		UPDATE #url.table#
		SET ActionStatus = '9'
		WHERE #url.key# = '#url.val#'	
	</cfquery>	

<cfcatch>
	
	<cfquery name="Delete" 
		datasource="#url.dsn#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
		DELETE FROM #url.table#
		WHERE #url.key# = '#url.val#'	
	</cfquery>	

</cfcatch>

</cftry>

<!--- forces the reload --->
<cfset session.listingdata[url.box]['sqlorig'] = "">

<!---
<script>
  document.getElementById('reloadoption').click()
</script>
--->

	