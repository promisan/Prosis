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
<cfquery name="delete" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM 	WorkOrderImplementer
		WHERE 	WorkOrderId = '#url.workOrderId#'
		AND		OrgUnit = '#url.orgUnit#'
</cfquery>

<cfoutput>
	<script>	 
		ptoken.navigate('#SESSION.root#/Workorder/Application/WorkOrder/Implementer/ImplementerList.cfm?workOrderId=#url.workOrderId#&mission=#url.mission#&mandateno=#url.mandateno#','divImplementerList');
	</script>
</cfoutput>