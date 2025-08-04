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

<!--- ---------------------------------------------------------------------------- --->
<!--- component to set the prerequirements for any session in terms of client vars --->
<!--- ---------------------------------------------------------------------------- --->

<cftry>

	<cfapplication name="Prosis"
   	clientmanagement  = "Yes" 
   	sessionmanagement = "yes" 
   	sessiontimeout    = "#CreateTimeSpan(0,0,180,0)#">
	
	<cfcatch></cfcatch>

</cftry>

<cfparam name="SESSION.authent" default="0">
<cfparam name="CLIENT.lanPrefix" default="">

<cfif SESSION.authent neq "1">
	<cfset SESSION.acc = "">
</cfif>	

<cfparam name="CLIENT.sessionNo" default="0">

<cfif IsDefined("Session.SessionTimeOut") is "False">

	 <cfquery name="qServer" datasource="AppsSystem">
	 	SELECT TOP 1 SessionExpiration
		FROM Parameter
	 </cfquery>

	 <cfif qServer.SessionExpiration eq "">
	     <cfset  Session.SessionTimeOut = "60">	
	 <cfelse>
	     <cfset  Session.SessionTimeOut = qServer.SessionExpiration>	
	 </cfif>

</cfif>

<!--- code to allow template to call if a user is an administrator for a function --->

<cfset structAppend(url,createObject("component","Service.Authorization.Broker"))/>

<!--- -------------------------- --->
<!--- --backward compatibility-- --->
<!--- -------------------------- --->

<cfif IsDefined("Session.SafeMode") is "False">

	<cfquery name="Parameter" 
		datasource="AppsInit">
		SELECT SessionSafeMode 
		FROM   Parameter
		WHERE  HostName = '#CGI.HTTP_HOST#'  
	</cfquery>
	 
	<cfset Session.SafeMode = Parameter.SessionSafeMode>

</cfif>


<cfif Session.SafeMode eq "1">

    <!--- database --->
	<cfset CLIENT.login 		    = SESSION.login>
	<cfset CLIENT.dbpw  		    = SESSION.dbpw>
	<!--- document and application pather --->
	<cfset CLIENT.root 			    = SESSION.root>
	<cfset CLIENT.rootdocument 	    = SESSION.rootdocument>
	<cfset CLIENT.rootdocumentpath 	= SESSION.rootdocumentpath>
	<cfset CLIENT.rootpath 			= SESSION.rootpath>
	<cfset CLIENT.rootreport 		= SESSION.rootreport>
	<cfset CLIENT.rootreportpath 	= SESSION.rootreportpath>

</cfif>

<!--- -------------------------- --->
<!--- end backward compatibility --->
<!--- -------------------------- --->

<cfif IsDefined("APPLICATION.DateFormat") is "False">
	<cfquery name="Parameter" 
	   datasource="AppsSystem">
	    SELECT * 
		FROM Parameter
	</cfquery>

	<cfset APPLICATION.DateFormat 		= "#Parameter.DateFormat#">	
	<cfset APPLICATION.DateFormatSQL    = "#Parameter.DateFormatSQL#">
	<cfset APPLICATION.BaseCurrency     = "#Parameter.BaseCurrency#">	
		
</cfif>	

