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
