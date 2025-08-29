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
<cfquery name="Delete"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    DELETE 
	FROM   Ref_PostTypeMission
	WHERE  PostType = '#Url.PostType#'
	AND	   Mission = '#url.mission#' 
</cfquery>

<cfoutput>
	<script>
		window.location = 'RecordListing.cfm?posttype=#url.posttype#&idmenu=#url.idmenu#';
	</script>
</cfoutput>