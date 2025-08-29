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
<cfparam name="url.licenseid" default="">
<cfparam name="url.licenseidall" default="">
<cfparam name="url.module" default="xxxx">
<cfparam name="url.mission" default="'ALL'">
<cfparam name="url.mode" default="descriptive">

<cfif url.licenseid eq "" and url.licenseidall eq "">

    <cfoutput>
	<table cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td class="labelmedium2">
    <img src="#SESSION.root#/Images/alert_caution.gif" alt="" border="0" align="absmiddle">
	</td>
	<cfif url.mode eq "descriptive">
	<td class="labelmedium2">
	<font color="gray">---</font>
	</td>
	</cfif>
	</tr>
	</table>
	</cfoutput>

<cfelse>
	 
	<cftry>	
	
		<cfset License = 0>
		<cfset vYear = 0>		
		<cfset vQuarter = 0>		
		
		<cf_licenseCheck module="'#preserveSingleQuotes(Module)#'" mission="#url.mission#" message="No" LicenseId ="#url.licenseId#">
		
		<cfif License eq 0 and url.licenseidAll neq "">
			<!--- trying now for all --->
			<cf_licenseCheck module="'#preserveSingleQuotes(Module)#'" mission="'ALL'" message="No" LicenseId ="#url.licenseIdAll#">
		</cfif>
							
		<cfinclude template="ShowLicenseExpiration.cfm">		
		
		<cfcatch>
		     <cfoutput>
			  <table class="formpadding"><tr class="labelmedium2"><td>
			 <img src="#SESSION.root#/Images/alert_stop.gif" alt="" border="0" align="absmiddle">	
			 </td><td>
			 <font color="FF0000">Error2</font>
			  </td></tr></table>
			 </cfoutput>
		</cfcatch>
		
		
	</cftry>

</cfif>
				