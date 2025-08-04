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

<cfquery name="SystemFunction" 
datasource="AppsSystem">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  SystemModule   = 'SelfService'
	AND    FunctionClass  IN ('SelfService','Report')
	AND    FunctionName   = '#URL.ID#' 
</cfquery>

<cfquery name="Parameter" 
datasource="AppsSystem">
	SELECT   *
	FROM     Parameter
</cfquery>

<style>

	table.rpthighLight {
		BACKGROUND-COLOR: #f9f9f9;		
		border-top : 1px solid silver;
		border-right : 1px solid silver;
		border-left : 1px solid silver;
		border-bottom : 1px solid silver;
	}
	table.rptnormal {
		BACKGROUND-COLOR: #ffffff;
		border-top : 1px solid white;
		border-right : 1px solid white;
		border-left : 1px solid white;
		border-bottom : 1px solid white;
	}
	
</style>

<cf_LoginTop height="96%" FunctionName = "#URL.ID#">

<cfinclude template="SubmenuReportScript.cfm">

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td valign="top" colspan="2" height="50"><cfinclude template="SelfServiceBanner.cfm"></td></tr>

<tr><td width="200" height="40">
<b><font size="2"><cf_tl id="Select Reporting area">:</b>
</td>
<td width="80%">

<cfquery name="report" 
datasource="AppsSystem">
	SELECT   DISTINCT SystemModule, FunctionClass
	FROM     Ref_ReportControl
	WHERE    Owner = '#url.id#'
	<cfif SystemFunction.FunctionCondition neq "">
	AND      SystemModule = #preservesinglequotes(SystemFunction.FunctionCondition)#
	</cfif>
	AND      Operational = '1'	
	AND      FunctionClass NOT IN ('Application','System')
	ORDER BY SystemModule,FunctionClass
</cfquery>

<select name="functionclass" id="functionclass">
<option value="my"><cf_tl id="Subscribed Report"></option>
<cfoutput query="report">
<option value="'#functionclass#'">#FunctionClass#</option>
</cfoutput>
</select>

</td>
<td></td>
</tr>

<cfset url.portal = 1>
<cfinclude template="../../../System/Modules/Subscription/RecordScript.cfm">

<tr><td colspan="2" height="1" bgcolor="silver"></td></tr>

<cfset module  = replace(SystemFunction.FunctionCondition,"'","|","ALL")>

<tr><td colspan="2" valign="top">
    <cfdiv bind="url:SubmenuReportList.cfm?owner=|#url.id#|&module=#module#&menuclass=|reports|&selection={functionclass}" 
	 bindOnLoad="true" 
	 id="myreport">
</td></tr>
</table>

<cf_LoginBottom FunctionName = "#URL.ID#">