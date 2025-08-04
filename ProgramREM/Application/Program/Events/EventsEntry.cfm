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

<cfparam name="url.portal" default="0">
<cfparam name="url.mode"   default="edit">

<cfif url.portal eq "0">
	
	<cfajaximport tags="cfform">
	
	<cf_screenTop height="100%" html="No" scroll="yes" flush="Yes">
		
		<cfset url.attach = "0">
		<table width="99%" align="center" border="0" frame="hsides" bordercolor="silver">
		<tr><td><cfinclude template="../Header/ViewHeader.cfm"></tr>
		
		<tr><td id="eventdetail">
		<cfif url.mode eq "edit">
			<cfinclude template="EventsEntryDetail.cfm">
		<cfelse>
			<cfinclude template="EventsEntryDetail.cfm">
		</cfif>
		</td>
		</tr>   
		
		</table>
	
	<cf_screenbottom html="No">

<cfelse>

	<table width="99%" align="center" border="0" frame="hsides" bordercolor="silver">				
		<tr><td id="eventdetail"><cfinclude template="EventsEntryDetail.cfm"></td></tr>   		
	</table>

</cfif>
