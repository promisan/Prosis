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
<CF_DateConvert Value="#url.date#">
<cfset dateob = dateValue>

<cfif url.type eq "prior">
	<cfset from = 1>
	<cfset to = month(dateob)-1>
	<cfset vMes = "Prior Months">
</cfif>

<cfif url.type eq "next">
	<cfset from = month(dateob)+1>
	<cfset to = 12>
	<cfset vMes = "Next Months">
</cfif>

<cfoutput>
	<cfif to gt 0 and from lt 13>
	
		<select name="#url.name#" id="#url.name#" class="regularxl" style="width:150px;" onchange="calendarDoJumpTo(this.value);">
			<option value=""> - <cf_tl id="#vMes#"> -
			<cfloop index="i" from="#from#" to="#to#">
			
				<cfset vValue = createDate(year(dateob),i,1)>
				
				<cfswitch expression="#i#">
					<cfcase value="1">		
						<cf_tl id="January" var="1">
					</cfcase>
					<cfcase value="2">
						<cf_tl id="February" var="1">
					</cfcase>
					<cfcase value="3">
						<cf_tl id="March" var="1">
					</cfcase>
					<cfcase value="4">
						<cf_tl id="April" var="1">
					</cfcase>
					<cfcase value="5">
						<cf_tl id="May" var="1">
					</cfcase>
					<cfcase value="6">
						<cf_tl id="June" var="1">
					</cfcase>
					<cfcase value="7">
						<cf_tl id="July" var="1">
					</cfcase>
					<cfcase value="8">
						<cf_tl id="August" var="1">
					</cfcase>
					<cfcase value="9">
						<cf_tl id="September" var="1">
					</cfcase>
					<cfcase value="10">
						<cf_tl id="October" var="1">
					</cfcase>
					<cfcase value="11">
						<cf_tl id="November" var="1">
					</cfcase>
					<cfcase value="12">
						<cf_tl id="December" var="1">
					</cfcase>
				</cfswitch>
				
				<option value="#dateFormat(vValue, '#client.dateFormatShow#')#">#lt_text#
			</cfloop>
		</select>
	</cfif>
</cfoutput>