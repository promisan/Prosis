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

<cfparam name="url.mission"       default="">
<cfparam name="url.mid"           default="">
<cfparam name="url.mandate"       default="">
<cfparam name="url.period"        default="">
<cfparam name="url.role"          default="">
<cfparam name="url.singleMission" default="0">

<cfif url.scope eq "undefined">
	<cfset url.scope = "">
</cfif>

<cfoutput>
<table width="100%" height="99%">
<tr><td style="height:100%;width:100%" valign="top">
<iframe src="#session.root#/System/Organization/Application/OrganizationSearch.cfm?singlemission=#url.singlemission#&mode=#url.mode#&script=#url.script#&mission=#url.mission#&mandate=#url.mandate#&period=#url.period#&role=#url.role#&orgtype=#url.orgtype#&fldorgunit=#url.fldorgunit#&scope=#url.scope#&mid=#url.mid#" 
   width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>