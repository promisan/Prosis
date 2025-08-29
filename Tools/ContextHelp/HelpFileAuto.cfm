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
	 