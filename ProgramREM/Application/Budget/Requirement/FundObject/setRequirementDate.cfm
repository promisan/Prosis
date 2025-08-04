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

<cfif url.show eq 1>

	<cfif url.RequirementDate eq "">
		<cfset vDate = "">
	<cfelse>
		<cfset vDate = url.RequirementDate>
	</cfif>
	<!-- <cfform name="frmFundObject_#url.vCodeId#"> -->
	<cf_intelliCalendarDate8
		FieldName="RequirementDate_#url.vCodeId#"
		Message="Select a valid Requirement Date for #url.code#"
		class="regularxl"
		Default="#vDate#"
		AllowBlank="False">
	<!-- </cfform> -->
	
	<cfset AjaxOnLoad("doCalendar")>

</cfif>