
<cf_compression>

<cfif url.personNo neq "">
		
	<cfquery name="Update" 
	 datasource="appsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     UPDATE  RosterSearchResult 
		 SET     Status = '#URL.status#'
		 WHERE   SearchId = '#URL.SearchId#'
		 AND     PersonNo = '#URL.PersonNo#'	   
	</cfquery>	
	
<cfelse>

	<cfquery name="Update" 
	 datasource="appsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     UPDATE  RosterSearchResult 
		 SET     Status = '#URL.status#'
		 WHERE   SearchId = '#URL.SearchId#'		 
	</cfquery>	

</cfif>	
	
	
		
