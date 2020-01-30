
<cf_compression>

<cftry>

	<cfquery name="Last" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT max(serialNo) as last 
			FROM   AttachmentLog
			WHERE 	AttachmentId = '#url.Id#'								
	</cfquery>

	<cfquery name="LogAction" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO AttachmentLog
					(AttachmentId,
					 SerialNo, 
					 FileAction, 			
					 OfficerUserid, 
					 OfficerLastName, 
					 OfficerFirstName)
				VALUES
					('#url.id#',
					 '#last.last+1#',
					 'Open',			
					 '#SESSION.acc#',
					 '#SESSION.last#',
					 '#SESSION.first#')
	</cfquery>	

	<cfcatch></cfcatch>

</cftry>


