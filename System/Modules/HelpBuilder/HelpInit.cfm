
<!--- self registration --->

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