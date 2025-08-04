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

<cfparam name="url.scope" default="Backoffice">
<cfparam name="url.src" default="Manual">

<cfif url.scope neq "Backoffice">
	 <cfset url.id = CLIENT.personno>
	 <cfset url.src = "Selfservice">
	 <cfset url.webapp = "portal">
</cfif>

<cf_screentop html="no" scroll="VerticalShow" jQuery="yes">
	
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">

<tr><td>
	<cfset client.stafftoggle = "close">
    <cfset openmode = "close">
	<cfinclude template="../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">
</td>

</tr>
<cfset ctr = "1">
<tr>		
	<td colspan="14" id="contentdependent" style="padding-bottom:10px">		
		<cfinclude template="Request1.cfm">		
	</td>
</tr>
</table>	



