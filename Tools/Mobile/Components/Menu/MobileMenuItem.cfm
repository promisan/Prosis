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
<cfparam name="attributes.active"				default="0">
<cfparam name="attributes.parent"				default="0">
<cfparam name="attributes.reference"			default="##">
<cfparam name="attributes.description"			default="--">
<cfparam name="attributes.badge"				default="">
<cfparam name="attributes.style"				default="">
<cfparam name="attributes.systemfunctionid"		default="">
<cfparam name="attributes.badgeColor"			default="label-success">


<cfset vActive = "">
<cfif trim(lcase(attributes.active)) eq "1" or trim(lcase(attributes.active)) eq "yes">
	<cfset vActive = "active">
</cfif>

<cfif thisTag.ExecutionMode is "start">

	<cfoutput>
	
		<li class="#vActive#" style="#attributes.style#">
		
		<cfset vLogFunction = "">
		<cfif attributes.systemfunctionid neq "">
			<cfset vLogFunction = "ptoken.navigate('#session.root#/tools/mobile/components/menu/mobileMenuItemLog.cfm?systemfunctionId=#attributes.systemfunctionid#', 'divLogTarget')">
		</cfif>
		<div id="divLogTarget" name="divLogTarget" style="display:none;"></div>

		<a href="#attributes.reference#" onclick="#vLogFunction#">
			<cfif trim(lcase(attributes.Parent)) eq "1" or trim(lcase(attributes.Parent)) eq "yes">
				<span class="nav-label">#attributes.description#</span><span class="fa arrow"></span>
			<cfelse>
				#attributes.description# 
				<cfif trim(attributes.badge) neq "">
					<span class="label #attributes.badgeColor# pull-right">#attributes.badge#</span>
				</cfif>
			</cfif>
		</a>
  
	</cfoutput>

<cfelse>
	</li>
</cfif>	