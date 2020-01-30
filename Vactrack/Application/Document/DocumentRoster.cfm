
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
 
<!--- register access to authorised user for step --->

<cfquery name="Bucket" 
datasource="appsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  FunctionOrganization
	WHERE DocumentNo = '#URL.ID#'
</cfquery>

<cfif Bucket.recordcount eq "1">

	<cfquery name="Check" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   RosterAccessAuthorization
		WHERE  FunctionId = '#Bucket.FunctionId#'
		AND    UserAccount = '#SESSION.acc#'
		AND    AccessLevel = '#URL.Status#'
	</cfquery>
	
	<cfif Check.recordcount eq "0">
	
		<cfquery name="Insert" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO RosterAccessAuthorization
				(FunctionId,UserAccount,AccessLevel,Source,Role,OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES
				('#Bucket.FunctionId#','#SESSION.acc#','#URL.Status#','Vactrack','RosterClear','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
		</cfquery>
			
	</cfif>
	
	<cfquery name="Check" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM    RosterAccessAuthorization
		WHERE   FunctionId = '#Bucket.FunctionId#'
		AND     UserAccount = '#SESSION.acc#'
		AND     AccessLevel = '#URL.Status#'
	</cfquery>
	
	<!--- open dialog for initial or technical --->

	<cflocation url="../../../Roster/RosterSpecial/CandidateView/FunctionViewLoop.cfm?IDFunction=#Check.FunctionId#" addtoken="No">
	
<cfelse>

	<cf_message 
	    message="Problem, roster bucket process dialog can not be located.">

</cfif>


