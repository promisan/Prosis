
<cfif url.checked neq "">

	<cfif url.checked eq "true">

		<cfquery name="Update" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">				
	    	INSERT INTO Ref_TopicDomainClass 
			 (Code,ServiceDomain,ServiceDomainClass,OfficerUserId,OfficerLastName,OfficerFirstName)
			VALUES (
				'#url.topic#',
				'#url.servicedomain#',
				'#url.servicedomainclass#',
				'#session.acc#',
				'#session.last#',
				'#session.first#' 
				)						
		</cfquery>
		
	<cfelse>
		
		<cfquery name="Delete" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	DELETE  FROM Ref_TopicDomainClass 
			WHERE   Code               = '#url.topic#'
			AND     ServiceDomain      = '#url.servicedomain#'
			AND     ServiceDomainClass = '#url.serviceDomainClass#'
		</cfquery>
		
	</cfif>
	
</cfif>
