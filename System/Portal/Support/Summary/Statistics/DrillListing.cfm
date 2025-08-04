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
<cf_screentop html="no" jquery="yes">

<cf_ListingScript>

<table width="100%" height="100%">
	<tr><td height="10"></td></tr>
	<tr>
		<td class="labellarge" style="padding-left:15px; font-size:22px; ">
			<cfoutput>
					<cfif url.item neq "">
						#ucase(url.item)# 
					<cfelse>
						<cf_tl id="All" var="1">
						#ucase(lt_text)#
					</cfif>
					 - #ucase(url.series)#: #url.val# 
					<cfif url.val eq 1>
						<cfif url.by eq "average leading days">
							<cf_tl id="hour">
						<cfelse>
							<cf_tl id="ticket">
						</cfif>
					<cfelse>
						<cfif url.by eq "average leading days">
							<cf_tl id="hours">
						<cfelse>
							<cf_tl id="tickets">
						</cfif>
					</cfif>
			</cfoutput>   
		</td>
		<td align="right">
			<cfoutput>
				<a style="cursor:pointer; color:##3494F3;" onclick="parent.collapseArea('ticketSummaryPanelLayout', 'bottom');">[<cf_tl id="Close">]</a>
			</cfoutput>
		</td>
	</tr>
	<tr>
		<td valign="top" colspan="2">
			<cfinclude template="DrillListingContent.cfm">
		</td>
	</tr>
</table>	