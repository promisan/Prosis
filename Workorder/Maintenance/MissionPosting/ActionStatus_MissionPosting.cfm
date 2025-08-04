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
<cfdiv id="iconStatusContainer_#url.id1#_#url.id2#">

<cfset iconSize = 15>
<cfset iconName = "icon_stop.gif">
<cfset tooltipText = "Closed. Click to reopen.">
<cfset confirmText = "reopen">

<cfif url.actionStatus eq 0>
	<cfset iconName = "icon_confirm.gif">
	<cfset tooltipText = "Open. Click to close.">
	<cfset confirmText = "lock">
</cfif>

<cfoutput>
	<img src="#SESSION.root#/images/#iconName#" title="#tooltipText#" width="#iconSize#" height="#iconSize#" style="cursor: pointer;"
			onclick="javascript: if (confirm('Do you want to #confirmText# this financial period ?')) { ColdFusion.navigate('ToggleActionStatus_MissionPosting.cfm?id1=#url.id1#&id2=#url.id2#&id3=#url.id3#&actionStatus=#url.actionStatus#', 'iconStatusContainer_#url.id1#_#url.id2#'); }">
</cfoutput>

</cfdiv>