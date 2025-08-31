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
<cfparam name="CLIENT.DateFormatShow" default="DD/MM/YY">

<cfquery name="Action" 
	datasource="AppsOrganization">
		SELECT   * 
		FROM     OrganizationObjectAction
		WHERE    ObjectId = '#url.objectid#'
		AND      ActionStatus IN ('2','2Y','2N')
		ORDER BY Created DESC
</cfquery>

<cfoutput>

	<table style="width:230px" align="center">
	
	<tr style="height:20px" class="labelmedium"><td><b><cf_tl id="Last Action"></td></tr>
	<tr style="height:20px" class="labelmedium"><td>#Action.OfficerFirstName# #Action.OfficerLastName#</td></tr>
	<tr style="height:20px" class="labelmedium"><td><cfif Action.ActionStatus eq "2N">
				<span style="color:##FF0000;">Denied</span>
			<cfelse>
				<span style="color:##34AB3A;">Confirmed</span>
			</cfif></td></tr>
	<tr style="height:20px" class="labelmedium"><td>#dateformat(Action.OfficerDate,CLIENT.DateFormatShow)# #timeformat(action.OfficerDate,"HH:MM")#</td></tr>	
	
	</table>

	<!---
	<cf_mobilerow>
		<cf_mobilecell class="col-lg-12">
			<cf_tl id="Last Action performed by">:
		</cf_mobilecell>
	</cf_mobilerow>

	<cf_mobilerow>
		<cf_mobilecell class="col-lg-12">
			#Action.OfficerFirstName# #Action.OfficerLastName#
		</cf_mobilecell>
	</cf_mobilerow>

	<cf_mobilerow>
		<cf_mobilecell class="col-lg-12">
			<cfif Action.ActionStatus eq "2N">
				<span style="color:##FF0000;">Denied</span>
			<cfelse>
				<span style="color:##34AB3A;">Confirmed</span>
			</cfif>
		</cf_mobilecell>
	</cf_mobilerow>

	<cf_mobilerow>
		<cf_mobilecell class="col-lg-12">
			#dateformat(Action.OfficerDate,CLIENT.DateFormatShow)# #timeformat(action.OfficerDate,"HH:MM")#
		</cf_mobilecell>
	</cf_mobilerow>
	--->

</cfoutput>