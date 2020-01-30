
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

