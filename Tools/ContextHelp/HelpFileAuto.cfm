<!--- auto registration --->
	
	<!--- check if the class is registered --->

	<cfquery name="Check" 
	datasource="AppsSystem"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  HelpProjectClass
		WHERE ProjectCode   = '#Attributes.Code#'
		AND   TopicClass    = '#Attributes.Class#' 
	</cfquery>
	
	<cfif check.recordcount eq "0">
	
		<cfquery name="Insert" 
		datasource="AppsSystem"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO HelpProjectClass
			(ProjectCode, 
			 TopicClass, 
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName)
			Values
			('#Attributes.Code#',
			 '#Attributes.Class#',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')
		</cfquery>
	
	</cfif>
	
	<cfquery name="Check" 
	datasource="AppsSystem"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  HelpProjectTopic
		WHERE ProjectCode   = '#Attributes.Code#'
		AND   TopicClass    = '#Attributes.Class#' 
		AND   TopicCode     = '#Attributes.Id#'
		AND   LanguageCode  = '#client.languageId#'
	</cfquery>	
	
	<cfif check.recordcount eq "0">
		
		<!--- autoregister the topic --->
	
		<cfquery name="Insert" 
		datasource="AppsSystem"
		username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			INSERT INTO HelpProjectTopic
			(ProjectCode, 
			 TopicClass, 
			 TopicCode, 
			 LanguageCode, 
			 TopicName,			 
			 TopicPresentation,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
			VALUES
			('#Attributes.Code#',
			 '#Attributes.Class#',
			 '#Attributes.Id#',
			 '#client.languageId#',
			 '#attributes.TopicName#',			
			 '#attributes.mode#',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')
		 </cfquery>
	 
	 <cfelse>
	 
	 <!---
	 
	 <!--- autoregister the topic --->
	 
	    <cfif Attributes.DisplayText neq "">
	
		<cfquery name="update" 
		datasource="AppsSystem"
		username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			UPDATE HelpProjectTopic
			SET   UITextHeader = '#Attributes.DisplayText#'
			WHERE ProjectCode   = '#Attributes.Code#'
			AND   TopicClass    = '#Attributes.Class#' 
			AND   TopicCode     = '#Attributes.Id#'
			AND   LanguageCode  = '#client.languageId#'
		 </cfquery>
		 
		 </cfif>
		 
		 --->
	 
	 
	 </cfif>
	 