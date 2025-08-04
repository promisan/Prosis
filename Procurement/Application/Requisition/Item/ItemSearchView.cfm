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

<cfparam name="url.id" default="">
<cfparam name="url.mission"       default="">
<cfparam name="url.flditemmaster" default="">
<cfparam name="url.period"        default="">

<cfoutput>
<table width="100%" height="100%">
<tr><td style="height:100%;width:100%" valign="top">
<cfif flditemmaster neq "">
	<iframe src="#SESSION.root#/Procurement/Application/Requisition/Item/ItemSearchMaster.cfm?id=#url.id#&mission=#url.mission#&period=#url.period#&flditemmaster=#url.flditemmaster#" width="100%" height="99%" frameborder="0"></iframe>
<cfelse>
	<iframe src="#SESSION.root#/Procurement/Application/Requisition/Item/ItemSearch.cfm?access=#url.access#&mission=#url.mission#&itemmaster=#url.itemmaster#&field=#url.field#&script=#url.script#&scope=#url.scope#" width="100%" height="99%" frameborder="0"></iframe></cfif>	
</td></tr>
</table>
</cfoutput>