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

<cfset dateValue = "">
<cf_DateConvert Value="#url.start#">
<cfset vStart = dateValue>

<cfset dateValue = "">
<cf_DateConvert Value="#url.end#">
<cfset vEnd = dateValue>

<cfquery name="Delete" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM 	ServiceItemLoadTrigger
		WHERE	ServiceItem = '#url.serviceitem#'
		AND		SelectionDateStart = #vStart#
		AND		SelectionDateEnd = #vEnd#
		AND		LoadScope = '#url.loadscope#'
</cfquery>

<cfinclude template="RecordListingDetail.cfm">