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
<cfif URL.searchid neq "">

	<cfif URL.Line neq "">
		<cfquery name="qDelete" datasource = "AppsSystem">		
			DELETE FROM CollectionLogCriteria
			WHERE  SearchId = '#URL.searchid#'
			AND    SearchLine = '#URL.line#' 
		</cfquery>
		
	<cfelse>
	
		<cfquery name="qDelete" datasource = "AppsSystem">
			DELETE FROM CollectionLogCriteria
			WHERE  SearchId = '#URL.Searchid#'
		</cfquery>
		
	</cfif>

	<cfoutput>
	
		<script>
			ColdFusion.navigate ('CaseFile/AdvancedSearchCriteria.cfm?searchid=#URL.searchid#&class=#url.class#&mode=new&ds=AppsCaseFile&db=CaseFile&Table=Ref_TopicElementClass&layout=1&where= and elementClass = |#url.class#|','dcriteria_#url.class#');
		</script>
	
	</cfoutput>		
	
</cfif>

