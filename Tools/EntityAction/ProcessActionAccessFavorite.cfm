
<cfparam name="URL.Action" default="">

<cfquery name="User" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * FROM UserNames
	WHERE Account  = '#URL.Account#'	
</cfquery>

<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * FROM OrganizationObject
	WHERE ObjectId  = '#URL.Objectid#'	
</cfquery>

<cfoutput>

<cfif url.action eq "reset">
	
	<cfquery name="Delete" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM   Ref_EntityClassActionAccess
		WHERE  EntityCode         = '#Object.EntityCode#'
		AND    EntityClass        = '#Object.EntityClass#'
		AND    ActionCode         = '#url.ActionCode#'
		AND    Mission            = '#Object.Mission#'
		AND    UserAccount        = '#SESSION.acc#'		
		AND    UserAccountGranted = '#url.account#'
	</cfquery>
	
	<img src="#SESSION.root#/Images/favoriteadd.png" 
		   alt="Remember delegation for #User.LastName#, #User.FirstName#" 
		   width="13" 
		   height="13" 
		   border="0" 
		   style="cursor: pointer;" 
		   onClick="ptoken.navigate('#SESSION.root#/tools/entityAction/ProcessActionAccessFavorite.cfm?ObjectId=#url.ObjectId#&ActionCode=#url.ActionCode#&action=grant&account=#url.Account#&accesslevel=#url.accesslevel#','b#account#_favorite')">
						

<cfelseif url.action eq "grant"> 

	<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM Ref_Mission
		WHERE Mission = '#Object.Mission#'		
	</cfquery>
 
    <cfif check.recordcount eq "1">

		<cfquery name="Insert" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_EntityClassActionAccess
				( EntityCode, 
				  EntityClass, 
				  ActionCode, 
				  UserAccount, 
				  Mission, 
				  UserAccountGranted, 
				  AccessLevel, 
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName)
			VALUES
				('#Object.EntityCode#',
				 '#Object.EntityClass#',
				 '#url.ActionCode#',
				 '#SESSION.acc#',
				 '#Object.Mission#',
				 '#url.account#',
				 '#url.accesslevel#',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')		
		</cfquery>
		
		<img src="#SESSION.root#/Images/favorite.png" 
		   alt="Account was delegated for future actions for this entity (#User.LastName#, #User.FirstName#)" 
		   width="13" 
		   height="13" 
		   border="0" 
		   style="cursor: pointer;" 
		   onClick="ptoken.navigate('#SESSION.root#/tools/entityAction/ProcessActionAccessFavorite.cfm?ObjectId=#url.ObjectId#&ActionCode=#url.ActionCode#&action=reset&account=#url.Account#&accesslevel=#url.accesslevel#','b#account#_favorite')">
		   
	</cfif>   
	
	
</cfif>

</cfoutput>
