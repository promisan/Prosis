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

<cfparam name="client.TimesheetDate"       		default="#now()#">

<cfparam name="Attributes.Label"           		default="Timesheet">
<cfparam name="Attributes.Presentation"    		default="Month">
<cfparam name="Attributes.LabelColor"      		default="ffffff">
<cfparam name="Attributes.TableBorder"     		default="0">
<cfparam name="Attributes.SelectionDate"   		default="#client.TimesheetDate#">
<cfparam name="Attributes.Object"          		default="Unit">
<cfparam name="Attributes.ObjectKeyValue1" 		default="0">
<cfparam name="Attributes.ObjectKeyValue2" 		default="0">
<cfparam name="Attributes.ObjectKeyValue3" 		default="0">
<cfparam name="Attributes.ObjectKeyValue4" 		default="0">

<cfparam name="Attributes.CopyScheduleFunction" default="">
<cfparam name="Attributes.RemoveScheduleFunction" default="">

<cfset border= attributes.tableborder>

<table width="98%" height="100%" align="center">

<cfoutput>

<cfif attributes.label neq "">
<tr><td>

	<table>
	  <tr>
	  	<td bgcolor="#attributes.labelcolor#" class="labelit" style="font-weight:200;font-size:26px;padding-right:20px;border-left:#border#px solid silver;border-top:#border#px solid silver;border-right:#border#px solid silver;height:28px;padding-left:17px">#attributes.Label#</td>
	  </tr>  
	</table>
	</td>
</tr>	
</cfif>

<cfset session.Timesheet["Presentation"] = attributes.Presentation>

<cfset url.selectiondate   			= attributes.selectiondate>
<cfset url.Object          			= attributes.Object>
<cfset url.ObjectKeyValue1 			= attributes.ObjectKeyValue1>
<cfset url.ObjectKeyValue2 			= attributes.ObjectKeyValue2>
<cfset url.ObjectKeyValue3 			= attributes.ObjectKeyValue3>
<cfset url.ObjectKeyValue4 			= attributes.ObjectKeyValue4>
<cfset url.CopyScheduleFunction 	= attributes.CopyScheduleFunction>
<cfset url.RemoveScheduleFunction 	= attributes.RemoveScheduleFunction>

<cfset url.init = "1">

<tr><td height="100%" valign="top" id="timesheetbox" style="border:#border#px solid silver;">
	<cfinclude template="TimeSheetContent.cfm">
</td></tr>

</cfoutput>

</table>		