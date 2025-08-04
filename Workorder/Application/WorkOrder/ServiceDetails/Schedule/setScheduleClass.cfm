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
<cfquery name="getClass" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ScheduleClass
		ORDER BY ListingOrder ASC
</cfquery>

<cfset vScheduleClass = url.selectedScheduleClass>

<cfif url.ScheduleId eq "">

	<cfquery name="getDefaultClass" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM   	WorkSchedule
			WHERE	Code = '#url.workSchedule#' 
	</cfquery>
	<cfset vScheduleClass = getDefaultClass.ScheduleClass>
	
</cfif>

<!-- <cfform name="dummy"> -->


<cfselect 
	name="ScheduleClass" 
	id="ScheduleClass" 
	query="getClass" 
	display="Description" 
	value="Code" 
	selected="#vScheduleClass#" 
	class="regularxl" 
	queryposition="below">
	<option value="">
</cfselect>

<!-- </cfform> -->