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
<cfquery name="Parameter"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Parameter	
</cfquery>

<cfquery name="InsertProject"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO HelpProject
	(ProjectCode,ProjectName,SystemModule,OfficerUserId,OfficerLastName,OfficerFirstName)
	SELECT SystemModule,SystemModule,SystemModule,'#SESSION.acc#','#SESSION.last#','#SESSION.first#'
	FROM   Ref_SystemModule
	WHERE  Operational = 1
	AND    SystemModule NOT IN (SELECT ProjectCode FROM HelpProject)
</cfquery>	

<cfquery name="InsertClass"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO HelpProjectClass
	(ProjectCode,TopicClass,OfficerUserId,OfficerLastName,OfficerFirstName)
	SELECT SystemModule,'General','#SESSION.acc#','#SESSION.last#','#SESSION.first#'
	FROM   Ref_SystemModule
	WHERE  Operational = 1
	AND    SystemModule NOT IN (SELECT C.ProjectCode FROM HelpProjectClass C,HelpProject P WHERE C.ProjectCode = P.ProjectCode)
</cfquery>	

<!--- insert entries if helpproject class exists with datasource and table --->

<cfquery name="Select"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   HelpProjectClass
	WHERE  DataSource is not NULL
</cfquery>	

<cfloop query="Select">

    <cfset prj  = "#Select.ProjectCode#">
	<cfset cls  = "#Select.TopicClass#">
	<cfset cde  = "#TopicFieldCode#">
	<cfset des  = "#TopicFieldName#">
	
	<cfquery name="Values"
		datasource="#Select.DataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT #cde#,#des#
		FROM   #TableName#
	</cfquery>	
	
	<cfloop query="Values">
	
		<cfquery name="Check"
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   HelpProjectTopic
			WHERE  ProjectCode  = '#prj#'
			AND    TopicClass   = '#cls#'
			AND    TopicCode    = '#evaluate(cde)#' 
			AND    LanguageCode = '#client.Languageid#'
		</cfquery>	
		
		<cfif check.recordcount eq "0">
		
			<cfquery name="InsertTopic"
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO HelpProjectTopic
			(ProjectCode,TopicClass,TopicCode,TopicName,OfficerUserId,OfficerLastName,OfficerFirstName)
			VALUES ('#prj#','#cls#','#evaluate(cde)#','#evaluate(des)#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
			</cfquery>	
			
		</cfif>
	
	</cfloop>

</cfloop>