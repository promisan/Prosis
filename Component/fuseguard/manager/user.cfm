<cfinclude template="check-auth.cfm">
<cfset request.title = "User">

<cfparam name="url.mode" default="list">
<cfswitch expression="#url.mode#">
	<cfcase value="new">
		<cfset request.title = "FuseGuard: New User">
	</cfcase>
	<cfcase value="edit">
		<cfset request.title = "FuseGuard: Edit User">
	</cfcase>
	
	<cfcase value="list">
		<cfset request.title = "FuseGuard: Users">
	</cfcase>
	<cfdefaultcase>
		<cfset url.mode = "me">
		<cfset request.title = "FuseGuard: My Account">
	</cfdefaultcase>
</cfswitch>
<cfimport prefix="vw" taglib="views/">
<cfinclude template="views/header.cfm">
<cftry>
	<cfset auth = request.firewall.getAuthenticator()>
	<cfparam name="url.user_id" default="#auth.getAuthenticatedUserID()#" type="integer">
	
	<cfif auth.getAuthenticatedUserID() IS NOT url.user_id AND NOT auth.isAuthenticatedUserAdmin()>
		<cfset url.user_id = auth.getAuthenticatedUserID()>
	</cfif>
	
	<cfset isCurrentUser = auth.getAuthenticatedUserID() IS url.user_id>
	
	<h1>
		<cfoutput><img src="#request.urlBuilder.createStaticURL('views/images/user.png')#" class="icon" alt="user" border="0" /></cfoutput> 
		<cfif url.mode IS "list">User Accounts<cfelseif url.mode IS "new">Create New User Account<cfelse><cfif isCurrentUser>My</cfif> Account</cfif>
	</h1>
	<br />
	
	<cfif auth.canEditUsers()>
		
		<cfif url.mode IS "edit" OR url.mode IS "me">
			<cfset user = auth.getUserByID(url.user_id)>
			<cfif not user.recordcount>
				No Such User.
			<cfelse>
				<!--- email / roles / username --->
				<vw:user-form user_id="#url.user_id#" email="#user.email#" username="#user.username#" enabled="#user.enabled#" roles="#user.roles#" />
			
				<cfif isCurrentUser>
					<!--- change password --->
					<vw:change-password user_id="#url.user_id#" />
				</cfif>
			
			</cfif>
		<cfelseif url.mode IS "list">
			<cfif auth.isAuthenticatedUserAdmin()>
				<cfset users = auth.getAllUsers()>
				<vw:list-users users="#users#" />
			</cfif>
			<br /><br />
		<cfelseif url.mode IS "new">
			<vw:user-form user_id="0" formTitle="Create New User" />
		</cfif>	
		
		
	
	<cfelse>
		
		<p>Sorry the authenticator you are using does not support modifying user profiles.</p>
	
	</cfif>
	<cfcatch type="any">
		<cfmodule template="views/catch.cfm" catch="#cfcatch#" /><cfabort>
	</cfcatch>
</cftry>
<cfinclude template="views/footer.cfm">