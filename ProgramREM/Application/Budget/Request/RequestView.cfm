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
<cfparam name="url.activityid" default="">
<cfparam name="url.requirementid" default="">
<cfparam name="url.editionid" default="">
<cfparam name="url.mode" default="view">
<cfparam name="url.cell" default="">
<cfparam name="url.objectcode" default="">

<cfoutput>
<table width="100%" height="100%">

<tr><td style="height:100%;width:100%">
	<iframe src="#SESSION.root#/programrem/Application/Budget/Request/RequestDialog.cfm?mode=#url.mode#&requirementid=#url.requirementid#&programcode=#url.programcode#&period=#url.period#&activityid=#url.activityid#&editionid=#url.editionid#&objectcode=#url.objectcode#&cell=#url.cell#" width="100%" height="99%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>