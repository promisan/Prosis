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

<cfajaximport tags="cfchart,cfwindow">

<cf_dialogREMProgram>

<cf_tl id="ProjectActivityChart" var="1">

<cfset Heading = " #Lt_text#">
<cfparam name="url.html" default="No">

<cf_screenTop height="100%" 
    label="#heading#" 	
	layout="webapp"
	scroll="Yes"
	horisontal="Yes"
	banner="red"
	jQuery="yes"	
	html="#url.html#">	
	
	<!--- blockevent = "rightclick" --->

<cfparam name="URL.Refresh" default="0">
<cfset url.output = "0">

<cfset ProgramFilter = "ProgramCode = '#URL.ProgramCode#'">		

<cfparam name="URL.ProgramCode" default="">
<cfparam name="URL.Period"      default="">

<cfset row = 0>

<!--- Query returning program parameters --->
	<cfquery name="Parameter" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
</cfquery>

<table width="99%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0">

<tr><td colspan="2" valign="top" style="border:0px solid silver" height="30">
	<cfset url.attach = "0">
	<cfinclude template="../../Program/Header/ViewHeader.cfm">
</td></tr>
  
<cfif Program.Status eq "0" and CheckMission.workflowEnabled eq "1" and Program.ProgramClass neq "Program">

	<tr><td style="padding-top:10px;border:0px solid silver;height:100%" colspan="2" class="labellarge" width="100%" valign="top" align="center">
	 <font color="FF0000"><cf_tl id="Your new project record has not been cleared. Please contact your administrator"></td></tr>

<cfelse>
	
	<tr>
	
	<cfinclude template="ActivityViewScript.cfm">
	
	<td colspan="2" valign="top" height="100%" width="100%" align="right">
	  
		<cfinclude template="ActivityViewContent.cfm">
	
	</td>
	</tr>
	
</cfif>	

</table>

<cf_screenbottom html="#url.html#" layout="webapp">