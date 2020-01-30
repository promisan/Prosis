
	<cfquery name="EventServerUserCheck" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   SystemEventServerUser
		WHERE  EventId = '#url.eventid#'
		AND    HostName  = '#CGI.HTTP_HOST#'
		AND    Account   = '#SESSION.acc#'
	</cfquery>
	
	<cfif EventServerUserCheck.recordcount eq "0">
	
		<cfquery name="EventServerUserInsert" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			INSERT INTO SystemEventServerUser
				(EventId
				,Hostname
				,Account)				
			VALUES (
				'#url.eventid#',
				'#CGI.HTTP_HOST#',
				'#SESSION.acc#')
		</cfquery>
		
	</cfif>
	

