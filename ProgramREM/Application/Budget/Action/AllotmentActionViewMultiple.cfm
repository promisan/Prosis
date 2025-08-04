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

<!--- allotment view multiple --->


<table width="100%" align="center" style="padding:15px">

<tr>
	
	<td valign="top" style="padding-left:4px;width:170;border-right:1px solid silver" height="100%">
	
	   <table cellspacing="0" cellpadding="0" class="formpadding">
	   
	   <cfset row = 0>
	   
	   <cfloop index="action" list="#url.actions#" delimiters=":">
	   
	   	<cfset row = row+1>
	   
	   <cfquery name="getAction"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM       ProgramAllotmentAction 
			WHERE      ActionId = '#action#'
		</cfquery>	
		
		<cfoutput query="getAction">
		<tr>
			<td>#row#.</td>
			<td style="padding-left:4px" class="labelit">
			<a href="javascript:ColdFusion.navigate('#session.root#/ProgramREM/Application/Budget/Action/AllotmentActionViewContent.cfm?ID=#action#','submain')">
			<font color="0080C0">#Reference#</font>
			</a>
			</td>
		</tr>
		</cfoutput>
	      
	   </cfloop>
	   
	   </table>
		
	</td>
	
	<td style="width:80%" id="submain" valign="top">
		<cfdiv bind="url:#session.root#/ProgramREM/Application/Budget/Action/AllotmentActionViewContent.cfm?ID=#url.id#">
	</td>

</tr>

</table>