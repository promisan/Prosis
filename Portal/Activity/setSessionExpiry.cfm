
<cfquery name="Drill" 
datasource="AppsSystem">
	UPDATE  UserStatus
	SET     ActionExpiration = 1
	WHERE   Account = '#URL.ID#'
	AND     NodeIP  = '#URL.ID1#'
	AND     HostSessionId = '#url.id2#'
</cfquery>

<cfset tracker = CreateObject("java", "coldfusion.runtime.SessionTracker")>
<cfset sessions = tracker.getSessionCollection(application.applicationName)>

<cftry>

	<cfset targetSession = sessions[ application.applicationName & '_' & URL.ID2]>
	<cfset StructClear(targetSession)>

	<cfcatch></cfcatch>
</cftry>

<font color="FF0000">Expired</font>
