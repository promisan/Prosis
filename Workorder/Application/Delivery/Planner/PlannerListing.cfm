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
<cfparam name = "url.print" default ="no">

<!--- obtain selection data on the left --->
<cfinclude template="../getTreeData.cfm">
<cfset url.dts = url.date>
<cfinclude template="getPlannerData.cfm">


<cfif Deliveries.recordcount eq "0">

	<table align="center"><tr><td style="height:60" align="center" class="labelmedium">No records found to show in this view.</td></tr></table>
	
<cfelse>
		
	<!--- scheduler / planner --->
	
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">	
	<tr><td valign="top"><cfinclude template="PlannerListingContent.cfm"></td></tr>					
	</table>	

</cfif>

<script>
	Prosis.busy('no')
</script>
	