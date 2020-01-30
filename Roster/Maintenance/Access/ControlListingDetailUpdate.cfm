
<cfquery name="Clean" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM RosterAccessAuthorization
		WHERE     FunctionId  = '#URL.FunctionId#'
		AND       UserAccount = '#URL.Account#' 
		AND       AccessLevel = '9'
</cfquery>		

<cfif URL.AccessCondition eq "Full">
	
	<cfquery name="Save" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
			INSERT INTO RosterAccessAuthorization
			(FunctionId, UserAccount, AccessLevel, Source, Role, OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES
			('#URL.FunctionId#','#URL.Account#','9','Manual','RosterClear','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
	</cfquery>		

</cfif>
