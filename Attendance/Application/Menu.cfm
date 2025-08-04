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

<cf_screentop  height="100%" scroll="vertical" html="no" ValidateSession="No">

<cf_submenuLogo module="Attendance" selection="Application">

<cfset heading = "General">
<cfset module = "'Attendance'">
<cfset selection = "'Application'">
<cfset class = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm"> 

 <cfquery name="SystemModule" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ModuleControl
		WHERE FunctionPath = 'TimeView/View.cfm'
	</cfquery>
	
<!--- specific menu--->
<cfset verifysource     = "'TimeKeeper'">
<cfset verifytable      = "">
<cfset menutemplate     = "TimeView/View.cfm">
<cfset module           = "'Attendance'">
<cfset class            = "'Time'">

<cfinclude template="../../Tools/SubmenuMission.cfm">
