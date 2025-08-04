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
<cfparam name="url.owner" default="">
<cfparam name="url.rule" default="">

<cfquery name="Rules"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Rule 
	WHERE  TriggerGroup = 'Process' AND Owner ='#url.owner#' AND Operational = 1
	ORDER  BY Owner, TriggerGroup
</cfquery>

<cf_screentop height="100%"
			  title="Select Business Rule" 
			  scroll="Yes" 
			  html="No"
			  jquery="Yes"
			  layout="webapp" 
			  close = "ColdFusion.Window.hide('RuleWindow');"
			  banner="gray"
			  label="Select Business Rule">

<table width="100%">
	<tr>
		<td width="100%" style="padding-top:8px" align="center" class="labellarge">
			Rule:&nbsp;&nbsp;
			<select name="rule" id="rule" class="regularxl" onchachange="ptoken.navigate(,'ruleDetail')">
				<option value=""></option>
				<cfoutput query="Rules">
					<option value="#Code#" <cfif Rules.Code eq url.rule>selected</cfif> ><cfif Description neq "">#Description#<cfelse>#Code#</cfif></option>
				</cfoutput>
			</select>
			
		</td>
	</tr>
	<tr>
		<td id="ruleDetail">			
			<cf_securediv bind="url:RuleDetail.cfm?owner=#url.owner#&level=#url.level#&rule={rule}&from=#url.from#&to=#url.to#" bindOnLoad="Yes">			
		</td>
	</tr>
</table>

