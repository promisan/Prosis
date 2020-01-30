<cfparam name="thisTag.ExecutionMode" default="invalid">
<cfif thisTag.ExecutionMode IS "start">
	<cfparam name="attributes.user_id" default="0">
	<cfparam name="attributes.email" default="" type="string">
	<cfparam name="attributes.username" default="" type="string">
	<cfparam name="attributes.roles" default="" type="string">
	<cfparam name="attributes.enabled" default="true" type="boolean">
	<cfparam name="attributes.formTitle" default="Profile">
	<cfset xss = request.firewall.stringCleaner>
	<cfif NOT IsValid("email", attributes.email)>
		<cfset attributes.email = "">
	</cfif>
	<!--- clean vars --->
	<cfset attributes.email = ReReplace(attributes.email, "[^a-zA-Z0-9@+._-]", "", "ALL")>
	<cfset attributes.username = ReReplace(attributes.username, "[^a-zA-Z0-9_-]", "", "ALL")>
	
	<cfoutput>
	
	<form action="#request.urlBuilder.createDynamicURL('user-action')#" method="post" class="labled">
		<input type="hidden" name="user_id" value="#xss(attributes.user_id)#" />
		<label for="email">Email:</label>
		<input type="text" name="email" id="email" value="#xss(attributes.email)#" />
		<br />
		
		<label for="username">Username:</label>
		<input type="text" name="username" id="username" value="#xss(attributes.username)#" />
		<br />
		
		<cfif request.firewall.getAuthenticator().isAuthenticatedUserAdmin()>
			<cfif attributes.user_id IS "0">
				<label for="password">Password:</label>
				<input type="password" name="password" id="password" value="" />
				<br />
			</cfif>
			
			<label for="username">Roles:</label>
			<select name="roles" id="roles">
				<option value="admin"<cfif attributes.roles IS "admin"> selected="selected"</cfif>>admin</option>
				<option value="viewer"<cfif attributes.roles IS "viewer"> selected="selected"</cfif>>viewer</option>
			</select>
			<br />
			<label for="enabled">Enabled:</label>
			<select name="enabled" id="enabled">
				<option value="1"<cfif attributes.enabled IS "1"> selected="selected"</cfif>>Yes</option>
				<option value="0"<cfif attributes.enabled IS "0"> selected="selected"</cfif>>No</option>
			</select>
			<br />
			
			
		</cfif>
		<input type="submit" class="btn" value="Save" />
	</form>
	</cfoutput>
</cfif>