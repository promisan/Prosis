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
<cfquery name="delete" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE	Publication
		SET		ActionStatus = '9'
		WHERE	PublicationId = '#url.publicationId#'
</cfquery>

<cfoutput>
	<script>
		window.close();
		window.opener.ColdFusion.navigate('#session.root#/WorkOrder/Application/Activity/Publication/PublicationListing.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#url.workorderid#','contentbox2');
	</script>
</cfoutput>