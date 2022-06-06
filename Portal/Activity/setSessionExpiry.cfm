<cfquery name="get"
datasource="AppsSystem">
	SELECT  * 
	FROM    UserStatus	
	WHERE   UserStatusId  = '#URL.ID#'		
</cfquery>

<cfif get.recordcount gte "1">

	<cfquery name="Drill" datasource="AppsSystem">
		UPDATE  UserStatus
		SET     ActionExpiration = 1
		WHERE   UserStatusId  = '#URL.ID#'
	</cfquery>
	
	<cfset tracker = CreateObject("java", "coldfusion.runtime.SessionTracker")>
	<cfset sessions = tracker.getSessionCollection(application.applicationName)>
	
	<cftry>	
	
    	<cfset targetSession = sessions[ application.applicationName & '_' & get.HostSessionId]>
	
		<cfcatch>
		
			<script>
				alert('Session information was not found on this server and could not be terminated')
			</script>
		
		</cfcatch>
	
	</cftry>
	
	<cfset StructClear(targetSession)>		
	
	<cfoutput>
	
	<script>
	    applyfilter('1','','#url.id#')
		// $('tr[name*=#url.box#_#url.id#]') .each(function() { this.remove(); }); 
		// alert('Session has been terminated')
	</script>
	
	</cfoutput>

</cfif>

