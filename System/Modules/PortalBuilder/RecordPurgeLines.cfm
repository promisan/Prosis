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
<cfparam name="url.isPortal" default="0">

<cfquery name="delete" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 DELETE 
	 FROM 		Ref_ModuleControl	 
	 WHERE		SystemFunctionId 	= '#url.id#'
</cfquery>

<cfif url.isPortal eq 0>

	<cfoutput>
		<script>
			ColdFusion.navigate("RecordListingClass.cfm?name=#url.name#&class=#url.class#&systemmodule=#url.systemmodule#&functionclass=#url.functionclass#","div#url.class#");
		</script>
	</cfoutput>

<cfelse>

	<cfquery name="deleteDetail" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">		 
		 DELETE 
		 FROM 		Ref_ModuleControl	 
		 WHERE		FunctionClass = '#url.name#'
		 AND		SystemModule = '#url.systemmodule#'
	</cfquery>
	
	<script>
		try {			
			opener.document.getElementById('listing_refresh').click();
		} catch(e) {}	
		window.close();
	</script>

</cfif>
