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
<cfparam name="URL.bex" default="0">

<cfdiv id="iconBatchContainer_#url.id1#_#url.id2#">

<cfset iconSize = 15>
<cfset iconName = "run_button3.gif">
<cfset tooltipText = "Click to execute posting.">
<cfset cursortype = "cursor: pointer;">

<cfif url.bex eq "1">
	<cfset iconName = "success.png">
	<cfset tooltipText = "Posting executed">
	<cfset cursortype = "cursor: default;">
</cfif>

<cfoutput>
	<img src="#SESSION.root#/images/#iconName#" title="#tooltipText#" width="#iconSize#" height="#iconSize#" style="#cursortype#" 
	onclick="javascript: ColdFusion.navigate('batchToggle.cfm?id1=#url.id1#&id2=#url.id2#', 'iconBatchContainer_#url.id1#_#url.id2#');">
</cfoutput>
</cfdiv>