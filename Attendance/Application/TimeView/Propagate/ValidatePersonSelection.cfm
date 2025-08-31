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
<cfset vColor = "##008BE8">
<cfset vValidateScript = "$('.clsTSRemove, .clsTSCopyFrom, .clsTSCopyTo').css('background-color','');">

<cfquery name="getPersonTo" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		if exists (select * from sysobjects where name='CopySchedulePersonTo_#session.acc#' and xtype='U')
			SELECT 	*
			FROM 	CopySchedulePersonTo_#session.acc#
		else
			SELECT '1' WHERE 1=0
</cfquery>

<cfoutput query="getPersonTo">
	<cfset vValidateScript = "#vValidateScript# $('.clsTSCopyTo_#personno#').css('background-color','#vColor#');">
</cfoutput>

<cfquery name="getPersonFrom" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		if exists (select * from sysobjects where name='CopySchedulePerson_#session.acc#' and xtype='U')
			SELECT 	*
			FROM 	CopySchedulePerson_#session.acc#
		else
			SELECT '1' WHERE 1=0
</cfquery>

<cfoutput query="getPersonFrom">
	<cfset vValidateScript = "#vValidateScript# $('.clsTSCopyFrom_#personno#').css('background-color','#vColor#');">
</cfoutput>

<cfquery name="getPersonRemove" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		if exists (select * from sysobjects where name='RemoveSchedulePerson_#session.acc#' and xtype='U')
			SELECT 	*
			FROM 	RemoveSchedulePerson_#session.acc#
		else
			SELECT '1' WHERE 1=0
</cfquery>

<cfoutput query="getPersonRemove">
	<cfset vValidateScript = "#vValidateScript# $('.clsTSRemove_#personno#').css('background-color','#vColor#');">
</cfoutput>

<cfset AjaxOnLoad("function(){ #vValidateScript# }")>
