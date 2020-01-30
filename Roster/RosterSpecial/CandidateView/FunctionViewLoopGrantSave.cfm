
<!--- enable the user profile --->

<cfquery name="Update" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  UserNames
	SET     Disabled = '0', 
	        DisabledModified = getDate()
	WHERE   Account = '#URL.ACC#' 
</cfquery>


<cfif url.mode eq "Roster" or url.Mode eq "Delete">
		
	<cfquery name="Check" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM RosterAccessAuthorization 
		WHERE       UserAccount = '#URL.ACC#'
		 AND        FunctionId  = '#URL.ID#'
		 AND        AccessLevel = '#URL.Status#' 
	</cfquery>

</cfif>

<cfif url.mode eq "Roster">

	<cftry>
		
		<cfquery name="Insert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO RosterAccessAuthorization  
		         (UserAccount,
				  FunctionId,
				  AccessLevel,						
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)
			  VALUES ('#URL.ACC#',
					  '#URL.ID#',
			          '#URL.Status#', 					  
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
		</cfquery>	
	
		<cfcatch>	</cfcatch>
		
	</cftry>	
	
</cfif>

<cfif url.mode eq "update">
	
	<cfquery name="Clean" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM RosterAccessAuthorization
			WHERE     FunctionId = '#URL.Id#'
			AND       UserAccount = '#URL.Acc#' 
			AND       AccessLevel = '#url.status#'
	</cfquery>		

	<cfparam name="URL.AccessCondition" default="">

	<cfquery name="Save" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
			INSERT INTO RosterAccessAuthorization
			(FunctionId, UserAccount, AccessLevel, 
			<cfif URL.AccessCondition eq "Limited">
				  AccessCondition,
				</cfif>
			Source, Role, OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES
			('#URL.ID#','#URL.Acc#','#url.status#',
			<cfif URL.AccessCondition eq "Limited">
				  '#URL.AccessCondition#',
			</cfif>
			'Manual',
			'RosterClear',
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#')
	</cfquery>		

</cfif>


<cfset url.mode = "Roster">
<cfinclude template="FunctionViewLoopGrantUser.cfm">
