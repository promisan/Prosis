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
<cfparam name="Attributes.To"          default="">
<cfparam name="Attributes.AccessLevel" default="1">
<cfparam name="Attributes.ActionCode"  default="">
<cfparam name="Attributes.ObjectId"    default="">
<cfparam name="Attributes.Text"        default="">

<cfquery name="Parameter" 
	datasource="AppsOrganization"  
	username="#SESSION.login#" 
	password ="#SESSION.dbpw#">
		SELECT * 
		FROM   Parameter.dbo.Parameter
		WHERE  HostName = '#CGI.HTTP_HOST#' 
</cfquery>

<cfif Attributes.to neq "">

	<cfquery name="qObject" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   O.* , R.EntityDescription, R.DocumentPathName
			 FROM     OrganizationObject O, Ref_Entity R
			 WHERE    ObjectId = '#Attributes.ObjectId#'
			 AND      O.EntityCode = R.EntityCode
			 AND      O.Operational  = 1
	</cfquery>
	
	<cfquery name="Last" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password ="#SESSION.dbpw#">
			 SELECT    TOP 1 *
			 FROM OrganizationObjectAction
			 WHERE ObjectId = '#Attributes.ObjectId#'
			 ORDER BY OfficerDate DESC
	</cfquery>
	
	<cfquery name="Mail" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT   *
			FROM     System.dbo.UserNames
			WHERE    Account = '#Last.OfficerUserId#'
	</cfquery>		
	
	<cfquery name="Action" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 	SELECT       *
			FROM            Ref_EntityActionPublish
			WHERE ActionPublishNo = '#qObject.ActionPublishNo#' and ActionCode = '#Attributes.ActionCode#'
				 
	</cfquery>

<cfset headercolor = "ffffff">

<cfquery name="System" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT     *
		 FROM   System.dbo.Parameter			 
</cfquery>

<cfif System.MailSendMode eq "1">

    <cfset sendto = attributes.to>
	<cfinclude template="ProcessMailTextContent.cfm">
	
<cfelse>

	<cfloop index="sendto" list="#attributes.to#">
		<cfinclude template="ProcessMailTextContent.cfm">
	</cfloop>	

</cfif>	

</cfif>