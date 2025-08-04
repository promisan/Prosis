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

<cf_compression>

<cfset dateValue = "">
<cf_DateConvert Value="#url.start#">
<cfset vStart = dateValue>

<cfset dateValue = "">
<cf_DateConvert Value="#url.end#">
<cfset vEnd = dateValue>

<cfif url.status eq "0">
	<cfset vActionStatus = "1">
<cfelseif url.status eq "1">
	<cfset vActionStatus = "0">
</cfif>

<cfquery name="Update" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE	ServiceItemLoadTrigger
		SET		ActionStatus = '#vActionStatus#'
		WHERE	ServiceItem = '#url.serviceitem#'
		AND		SelectionDateStart = #vStart#
		AND		SelectionDateEnd = #vEnd#
		AND		LoadScope = '#url.loadscope#'
</cfquery>

<cfset vId = "#url.ServiceItem##url.start##url.end##url.loadscope#">
<cfset vId = replace(vId," ", "_", "ALL")>
<cfset vId = replace(vId,"/", "_", "ALL")>

<cfoutput>
	<script>
		ColdFusion.navigate('RecordListingActionStatus.cfm?serviceitem=#url.serviceItem#&start=#url.start#&end=#url.end#&loadscope=#url.loadscope#&status=#vActionStatus#','divStatus_#vId#');
	</script>
</cfoutput>