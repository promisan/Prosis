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
<cfparam name="attributes.autoRedirect" default="true">
<cfparam name="url.autoRedirect" default="#attributes.autoRedirect#">

<cfif NOT isDefined("Session.isAdministrator")>
	<cfset SESSION.isAdministrator = "No">
</cfif>

<!---
<cfif SESSION.isAdministrator eq "No">
--->

	<cf_getHost host="#cgi.http_host#">
	
	<cfquery name="get" 
	 datasource="AppsSystem">
		SELECT *
		FROM   UserNames
		WHERE  Account       = '#SESSION.acc#' 		
	</cfquery>
					
	<cfquery name="delete" 
	 datasource="AppsSystem">
		DELETE UserStatus 
		WHERE  Account       = '#SESSION.acc#' 
		AND    HostName      = '#host#' 				
		<cfif get.AllowMultipleLogon eq "1">
			<!--- before we logged out all but this was not always a good idea if the user has multiple sessions enabled --->
			AND    HostSessionId = '#SESSION.SessionId#' 
		</cfif>
	</cfquery>
	
	<!--- removing all client variables --->
	
	<cfloop list="#getClientVariablesList()#" index="var">
	
		<cfif var neq "indexno" and 
			  var neq "nodeip" and 
			  var neq "sessionno" and 			  
			  var neq "logoncredential" and
			  var neq "root" and 
			  var neq "LanPrefix" and
			  var neq "LanguageId" and
			  var neq "style">
		    <cfset deleteClientVariable(var)>
		</cfif>
		
	</cfloop>

<!---
</cfif>
--->

<cfset SESSION.authent= "0">

<cfset SESSION.sessionTimeout = createTimeSpan( 0, 0, 0, 1 ) />

<!--- Revised logout routine by dev on 7/30/2014 --->
<cflock scope="Session" type="Readonly" timeout="20">
    <cfset variables.sessionItems = "#StructKeyList(Session)#">
</cflock>

<cfloop index="ListElement" list="#variables.sessionItems#">
    <cfif listFindNoCase("CFID,CFToken,URLToken,SessionID,SessionTimeOut", "#ListElement#") is 0 >
	    <cflock scope="Session" type="Exclusive" timeout="20">
    		<cfset StructDelete(Session, "#ListElement#")>
	    </cflock>
    </cfif>
</cfloop>

<cfquery name="Parameter" 
datasource="AppsSystem">
	SELECT *
	FROM Parameter
</cfquery>

<cfparam name="CLIENT.context" default="main">

<cfif CGI.HTTPS eq "off">
	<cfset tpe = "http">
<cfelse>	
	<cfset tpe = "https">
</cfif>

<cfif url.autoRedirect eq "true">

	<cfoutput>
	   <script language="JavaScript1.2">
	       parent.window.location = "#tpe#://#CGI.HTTP_HOST#/#Parameter.VirtualDirectory#/Default.cfm?ID=#CLIENT.context#"
	  </script>
	</cfoutput>

</cfif>

