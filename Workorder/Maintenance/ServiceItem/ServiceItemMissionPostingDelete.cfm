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

<cfset vyear = mid(url.id3, 1, 4)>
<cfset vmonth = mid(url.id3, 6, 2)>
<cfset vday = mid(url.id3, 9, 2)>

<cfset vSelectionDate = createDate(vyear, vmonth, vday)>

<cfquery name="getMissionPosting" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM   ServiceItemMissionPosting
		WHERE  ServiceItem = '#url.id1#'		
		AND    Mission = '#url.id2#'
		AND	   SelectionDateExpiration = #vSelectionDate#
</cfquery>

<cfoutput>
	<script>
		window.location.reload();
	</script>
</cfoutput>