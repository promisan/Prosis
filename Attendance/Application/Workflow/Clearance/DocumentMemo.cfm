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
<cfquery name="get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT  *
			FROM    OrganizationActionPerson
			WHERE   OrgUnitActionId  = '#url.id#' 
			AND     PersonNo         = '#url.personno#'
</cfquery>	

<cfoutput>
<table width="100%" class="labelmedium">
<tr><td style="padding:4px;padding-left:20px;width:100%">
	<textarea type="text" id="memo" totlength="800" name="memo_#url.personno#" onkeyup="return ismaxlength(this)"
	onchange="ptoken.navigate('#session.root#/attendance/application/Workflow/Clearance/DocumentMemoSave.cfm?personno=#url.personno#&id=#url.id#','memo_#url.personno#','','','POST','clearanceform')" 
	style="padding:4px;font-size:14px;height:70px;width:100%">#get.remarks#</textarea>
</td>
<td style="min-width:10px;width;10px" id="memo_#url.personno#"></td>
</tr>
</table>
</cfoutput>
