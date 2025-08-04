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
<cf_compression>

<cfif url.status eq "1">
	<cfset iconName = "icon_stop.gif">
	<cfset vText = "Click to enable">
<cfelseif url.status eq "0">
	<cfset iconName = "icon_confirm.gif">
	<cfset vText = "Click to disable">
</cfif>

<cfset vId = "#url.ServiceItem##url.start##url.end##url.loadscope#">
<cfset vId = replace(vId," ", "_", "ALL")>
<cfset vId = replace(vId,"/", "_", "ALL")>

<cfoutput>
<img src="#SESSION.root#/Images/#iconName#"  
	style="cursor: pointer;" title="#vText#" width="14" height="14" border="0" align="middle" 
	onClick="javascript: if (confirm('This action may incur in non desired loads or quit loading desired data. \nDo you want to continue ?')) { ColdFusion.navigate('ToggleActionStatus.cfm?serviceitem=#url.serviceItem#&start=#url.start#&end=#url.end#&status=#url.status#&loadscope=#url.loadscope#','divStatus_#vId#'); }">
</cfoutput>