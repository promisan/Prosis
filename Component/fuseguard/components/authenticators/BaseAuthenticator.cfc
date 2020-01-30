<cfcomponent output="false" hint="The base authentication component (abstract)">
	<cfset variables.cookie_name = "fguardat">
	<cfset variables.min_password_length = 5>
	<cfset variables.hash_algorithm = "SHA">
	
	<cffunction name="init" access="public" output="false" hint="Initialize the Authenticator on firewall configure.">
		<cfargument name="firewallInstance">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="authenticate" returntype="boolean" output="false" hint="I authenticate a user credential">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfthrow message="The authenticate() must be implemented in your authenticator implementation." detail="Method not implemented in authenticator component" type="fuseguard">
	</cffunction>
	
	<cffunction name="changePassword" returntype="void" output="false" access="public" hint="Used to change a users password">
		<cfargument name="user_id" type="string" required="true">
		<cfargument name="old_password" type="string" required="true">
		<cfargument name="new_password" type="string" required="true">
		<cfargument name="confirm_password" type="string" required="true">
		<cfthrow message="The changePassword method is not supported by the authenticator you are using." detail="Method not implemented in authenticator component" type="fuseguard">
	</cffunction>
	
	<cffunction name="updateUser" returntype="string" output="false" hint="Updates or creates a user by passing in a struct with keys email, roles, enabled, etc. Performs security checks to make sure the current user may perform this action as well. Returns the user id of the new or existing user.">
		<cfargument name="user_id" type="string">
		<cfargument name="user" type="struct">
		<cfthrow message="The updateUser method is not supported by the authenticator you are using." detail="Method not implemented in authenticator component" type="fuseguard">
	</cffunction>
	
	<cffunction name="getAllUsers" returntype="query" output="false" hint="Returns a query of all users with columns id,username,email,roles,enabled">
		<cfreturn QueryNew("id,username,email,roles,enabled")>
	</cffunction>
	
	<cffunction name="getUserByID" returntype="query" output="false" hint="Returns a query with columns id, username, token, email, password, enabled, roles">
		<cfargument name="user_id">
		<cfreturn QueryNew("id,username,token,email,password,enabled,roles")>
	</cffunction>
	
	<cffunction name="setIsAuthenticated" returntype="void" output="false" access="package">
		<cfargument name="user_id" type="string">
		<cfargument name="username" type="string">
		<cfargument name="email" type="string">
		<cfargument name="password_hash" type="string">
		<cfargument name="token" type="string">
		<cfargument name="roles" type="string" default="">
		<cfset request.fuseguard_auth = StructNew()>
		<cfset request.fuseguard_auth.user_id = arguments.user_id>
		<cfset request.fuseguard_auth.username = arguments.username>
		<cfset request.fuseguard_auth.email = arguments.email>
		<cfset request.fuseguard_auth.auth_token = createAuthenticationToken(arguments.user_id, arguments.password_hash, arguments.token)>
		<cfset request.fuseguard_auth.roles = arguments.roles>
		<cfset setAuthenticationCookie(request.fuseguard_auth.auth_token)>
	</cffunction>
	
	<cffunction name="getAuthenticatedUserID" returntype="string" output="false" access="public" hint="Returns authenticated user id or 0 if not authenticated">
		<cfif StructKeyExists(request, "fuseguard_auth") AND StructKeyExists(request.fuseguard_auth, "user_id")>
			<cfreturn request.fuseguard_auth.user_id>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="getAuthenticatedUserRoles" returntype="string" output="false" access="public" hint="Returns authenticated user roles or empty string if not authenticated">
		<cfif StructKeyExists(request, "fuseguard_auth") AND StructKeyExists(request.fuseguard_auth, "roles")>
			<cfreturn request.fuseguard_auth.roles>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>
	
	<cffunction name="isAuthenticatedUserInRole" returntype="boolean" output="false" access="public" hint="Returns true if the user is authenticated">
		<cfargument name="role" type="variablename" default="admin">
		<cfreturn ListFindNoCase(getAuthenticatedUserRoles(), arguments.role)>
	</cffunction> 
	
	<cffunction name="isAuthenticatedUserAdmin" returntype="boolean" output="false" access="public" hint="Returns true if authenticated user has admin role.">
		<cfreturn isAuthenticatedUserInRole("admin")>
	</cffunction>
	
	<cffunction name="setAuthenticationCookie" returntype="void" output="false" access="package">
		<cfargument name="auth_token" type="string">
		<cfset var cook = "#variables.cookie_name#=#arguments.auth_token#;expires=#GetHttpTimeString(DateAdd("n", 20, now()))#;">
		<cfif StructKeyExists(cookie, variables.cookie_name) AND cookie[variables.cookie_name] IS arguments.auth_token>
			<!--- already set --->
			<cfreturn>
		</cfif>
		<cfif cgi.script_name contains "login.cfm">
			<cfset cook = cook & "path=" & Replace(ReReplaceNoCase(cgi.script_name, "[^0-9a-z/._-]", "", "ALL"), "login.cfm", "") & ";">
		</cfif>
		<cfif LCase(cgi.https) IS "on">
			<cfset cook = cook & "secure;">
		</cfif>
		<cfset cook = cook & "HttpOnly">
		<cfheader name="Set-Cookie" value="#cook#">
	</cffunction>
	
	<cffunction name="getAuthenticationCookieValue" returntype="string" output="false" access="public" hint="I return authentication cookie value">
		<cfif StructKeyExists(cookie, variables.cookie_name)>
			<cfreturn cookie[variables.cookie_name]>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>
	
	<cffunction name="deleteAuthenticationCookie" returntype="void" output="false" access="public" hint="I remove the authenication cookie value.">
		<cfset var cook = "#variables.cookie_name#=logout;expires=#GetHttpTimeString(DateAdd("y", -2, now()))#;">
		<cfif cgi.script_name contains "logout.cfm">
			<cfset cook = cook & "path=" & Replace(ReReplaceNoCase(cgi.script_name, "[^0-9a-z/._-]", "", "ALL"), "logout.cfm", "") & ";">
		</cfif>
		<cfif LCase(cgi.https) IS "on">
			<cfset cook = cook & "secure;">
		</cfif>
		<cfset cook = cook & "HttpOnly">
		<cfheader name="Set-Cookie" value="#cook#">
	</cffunction>
	
	<cffunction name="authenticateByToken" returntype="boolean" output="false" access="public">
		<cfargument name="auth_token" type="string" default="#getAuthenticationCookieValue()#">
		<cfset var user_id = "">
		<cfset var user = "">
		<cfif ListLen(arguments.auth_token, "_") NEQ 3>
			<cfreturn false>
		</cfif>
		<cfset user_id = Val(ListGetAt(arguments.auth_token, 2, "_"))>
		<cfset user = getUserByID(user_id)>
		<cfif NOT user.recordcount>
			<cfreturn false>
		</cfif>
		<cfif NOT user.enabled>
			<cfset auditUserEvent(user_id=user.id, event_type="Disabled User Login Attempt", event_description="The disabled user #user.username# (#user.id#) attempted to login.")>
		</cfif>
		<cfif arguments.auth_token IS createAuthenticationToken(user_id, user.password, user.token)>
			<cfset setIsAuthenticated(user_id, user.username, user.email, user.password, user.token, user.roles)>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="getAuthenticatedUserToken" returntype="string">
		<cfif StructKeyExists(request, "fuseguard_auth") AND StructKeyExists(request.fuseguard_auth, "auth_token")>
			<cfreturn request.fuseguard_auth.auth_token>
		</cfif>
	</cffunction>
	
	<cffunction name="createAuthenticationToken" returntype="string" output="false" access="package">
		<cfargument name="user_id" type="string">
		<cfargument name="password_hash" type="string">
		<cfargument name="token" type="string">
		<cfset var auth_token = DateFormat(now(), "yyyymmdd") & TimeFormat(now(), "HH") & "_" & arguments.user_id & "_">
		<cfset auth_token = auth_token & Hash(auth_token & arguments.token & cgi.http_user_agent & arguments.password_hash, "SHA-512", "utf-8")>
		<cfreturn auth_token>
	</cffunction>
	
	
	<cffunction name="isUserAuthenticated" returntype="boolean" output="false" hint="Returns true if a user is authenticated.">
		<cfreturn authenticateByToken(getAuthenticationCookieValue())>
	</cffunction>
	
	<cffunction name="getTokenType" hint="Returns one of AES,DES,DESEDE,BLOWFISH, or UUID">
		<cfreturn "AES">
	</cffunction>
	
	<cffunction name="generateToken" hint="Returns a token to be stored with the user account.">
		<cfif ListFindNoCase("AES,DES,DESEDE,BLOWFISH", getTokenType())>
			<cfreturn generateSecretKey(getTokenType())>
		<cfelse>
			<cfreturn Hash(CreateUUID(), "SHA-512")>
		</cfif>
	</cffunction>
	
	<cffunction name="isPasswordValid" returntype="boolean" output="false" hint="Used to validate that a password matches required criteria, (eg min length)">
		<cfargument name="password" type="string" required="true">
		<cfif Len(arguments.password) LT getMinimumPasswordLength()>
			<cfreturn false>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setMinimumPasswordLength" returntype="void" output="false" hint="Used to set the minimum password length">
		<cfargument name="length" type="numeric" default="5">
		<cfset variables.min_password_length = variables.length>
	</cffunction>
	
	<cffunction name="getMinimumPasswordLength" returntype="numeric" output="false" hint="Returns the minimum password length">
		<cfreturn variables.min_password_length>
	</cffunction>
	
	<cffunction name="getHashAlgorithm" returntype="variablename" output="false" hint="Returns the hashing algorithm used to hash passwords">
		<cfreturn variables.hash_algorithm>
	</cffunction>
	
	<cffunction name="setHashAlgorithm" returntype="void" output="false" hint="Changes the hashing algorithm used. WARNING if you change this you may not be able to login without updating your data.">
		<cfargument name="algorithm" type="variableName">
		<cfset variables.hash_algorithm = variables.algorithm>
	</cffunction>
	
	<cffunction name="logout" returntype="void" output="false" hint="Removes all authentication cookies">
		<cfset deleteAuthenticationCookie()>
	</cffunction>
	
	<cffunction name="auditUserEvent" returntype="void" access="package" output="false" hint="I log a user action">
		<cfargument name="user_id" type="string" default="0">
		<cfargument name="event_type" type="string" required="true">
		<cfargument name="event_description" type="string" required="true">
		<!--- implement in sub classes --->
	</cffunction>
	
	<cffunction name="canEditUsers" returntype="boolean" output="false" hint="Returns true if this Authenticator supports the methods to edit users and change passwords">
		<cfreturn false>
	</cffunction>
	
	<cffunction name="sendForgotPasswordEmail" returntype="void" output="false">
		<cfargument name="email" type="string" required="true">
		<cfset var q = "">
		<cfset var h = "">
		<cfset var reqUrl = "http">
		<cfset q = getUserByEmail(arguments.email)>
		<cfset h = Hash(q.id & q.password & q.token & DateFormat(Now(),"yyyymmdd"), getHashAlgorithm())>
		<cfif LCase(cgi.https) IS "on">
			<cfset reqUrl = reqUrl & "s">
		</cfif>
		<cfset reqUrl = reqUrl & "://" & ReReplaceNoCase(cgi.server_name, "[^0-9a-z.-]", "", "ALL")>
		<cfif cgi.server_port NEQ 80 AND cgi.server_port NEQ 443>
			<cfset reqUrl = reqUrl & ":" & Val(cgi.server_port)>
		</cfif>
		<cfset reqUrl = reqUrl & ReReplaceNoCase(cgi.script_name, "[^0-9a-z._/-]", "", "ALL")>
		<cfif q.recordcount>
			<cfmail to="#q.email#" from="#q.email#" subject="FuseGuard Manager Forgot Password" type="html">
				<p>Hello,</p>
				<p>Your email was entered into the Password Reset Form for FuseGuard Manager.</p>
				<p>If you wish to reset your password click on the link below (expires at midnight server time), otherwise you may ignore this email.</p>
				<p<a href="#reqUrl#?h=#URLEncodedFormat(h)#">#reqUrl#?h=#URLEncodedFormat(h)#</a></p>
				<p>Thank You,<br />--<br /><a href="http://foundeo.com/">FuseGuard</a>
			</cfmail>
			<cfset auditUserEvent(user_id=q.id, event_type="Forgot Password", event_description="The user #q.email# filled out the forgot password form.")>
		<cfelse>
			<cfif IsValid("email", arguments.email)>
				<cfset auditUserEvent(user_id=0, event_type="Invalid Forgot Password", event_description="Filled out the forgot password form with email that does not correspond to a user: #arguments.email#")>
			<cfelse>
				<cfset auditUserEvent(user_id=0, event_type="Invalid Forgot Password", event_description="Filled out the forgot password form with a value that was not a valid email address.")>
			</cfif>
		</cfif>
		
	</cffunction>
	
	
	<cffunction name="changeForgotPassword" returntype="boolean" output="false">
		<cfargument name="email" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="confirm_password" type="string" required="true">
		<cfargument name="forgot_password_hash" type="string" required="true">
		<cfset var u = getUserByEmail(arguments.email)>
		<cfset var h = Hash(u.id & u.password & u.token & DateFormat(Now(),"yyyymmdd"), getHashAlgorithm())>
		<cfif NOT u.recordcount OR h IS NOT arguments.forgot_password_hash>
			<cfset auditUserEvent(user_id=Val(u.id), event_type="Invalid Password Reset", event_description="Failed attempt to reset password due to either invalid hash token or invalid email.")>
			<cfthrow message="Invalid Token" type="fuseguard">
		</cfif>
		<cfset changePassword(u.id,u.password,arguments.password,arguments.confirm_password)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getUserByEmail" returntype="query" output="false" hint="Returns user info query by email address">
		<cfargument name="email">
		<!--- implement in extending classes --->
		<cfreturn QueryNew("id,email,password,token")>
	</cffunction>
	
	<cffunction name="getDescription" returntype="string" output="false" hint="Returns a description of where the data is stored, eg datasource name.">
		<cfreturn "Unspecified">
	</cffunction>
	
</cfcomponent>