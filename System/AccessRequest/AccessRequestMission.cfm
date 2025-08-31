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
<cfparam name="url.application" default="">
<cfparam name="url.requestid"   default="00000000-0000-0000-0000-000000000000">

<cfquery name="GetMission" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">

			SELECT DISTINCT Mission 
			FROM   Ref_MissionModule
			WHERE  SystemModule IN	( SELECT SystemModule
									  FROM   System.dbo.Ref_ApplicationModule
									  WHERE  Code = '#url.application#'
									)

</cfquery>

<cfquery name="GetRequest"
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">		 
		 	SELECT *
			FROM   UserRequest
			WHERE  RequestId = '#url.requestid#'
		 
</cfquery>

<select name="Mission" id="Mission" class="regularxl" onChange="updateGroup(this.value,document.getElementById('Workgroup').value);">
    <option value="Global">Global</option>
	<cfoutput query="GetMission">
		<option value="#Mission#" <cfif GetRequest.Mission eq Mission>selected</cfif> >#Mission#</option>
	</cfoutput>
</select>

<cfset AjaxOnLoad("initGroup")>
