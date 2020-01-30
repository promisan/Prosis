<cfcomponent extends="BaseAuthenticator" hint="Authenticates against the fuseguard database tables fuseguard_users">
	<cfset variables.ds = "fuseguard">
	<cfset variables.ds_user = "">
	<cfset variables.ds_pass = "">
	<cfset varibales.ds_type = "">
	<cfset variables.firewallInstance = "">
	
	<cffunction name="init" access="public" output="false" hint="Initialize the Authenticator on firewall configure.">
		<cfargument name="firewallInstance">
		<cfset variables.firewallInstance = arguments.firewallInstance>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setDatasource" returntype="void" output="false" hint="Sets the datasource name.">
		<cfargument name="datasource" required="true" hint="The name of a valid datasource">
		<cfargument name="username" required="false" default="" hint="Optional, the datasource username">
		<cfargument name="password" required="false" default="" hint="Optional, the datasource password">
		<cfargument name="dbtype" required="false" default="" hint="mysql, sqlserver, or derby">
		<cfset variables.ds = arguments.datasource>
		<cfset variables.ds_user = arguments.username>
		<cfset variables.ds_pass = arguments.password>
		<cfset variables.ds_type = LCase(arguments.dbtype)>
	</cffunction>
	
	
	<cffunction name="authenticate" returntype="boolean" output="false" hint="I authenticate a user credential">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfset var u = "">
		<cfset var h = "">		
		<cfset var auth = "">
		<cfquery datasource="#variables.ds#" name="u" username="#variables.ds_user#" password="#variables.ds_pass#">
			SELECT id, username, token, enabled
			FROM fuseguard_users
			WHERE username = <cfqueryparam value="#Left(arguments.username, 50)#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif IsBoolean(u.enabled) AND NOT u.enabled>
			<cfset auditUserEvent(user_id=u.id, event_type="Disabled User Login Attempt", event_description="The disabled user #u.username# (#u.id#) attempted to login.")>
		</cfif>
		<cfset h = Hash(arguments.password & u.token, getHashAlgorithm(), "utf-8")>
		<cfquery datasource="#variables.ds#" name="auth" username="#variables.ds_user#" password="#variables.ds_pass#">
			SELECT id, username, token, email, roles
			FROM fuseguard_users
			WHERE username = <cfqueryparam value="#Left(arguments.username, 50)#" cfsqltype="cf_sql_varchar">
			AND password = <cfqueryparam value="#h#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif u.recordcount EQ 1>
			<cfif auth.recordcount EQ 1>
				<cfset auditUserEvent(user_id=auth.id, event_type="Successful Login", event_description="The user #auth.username# (#auth.id#) authenticated successfully.")>
				<cfset setIsAuthenticated(auth.id, auth.username, auth.email, h, auth.token, auth.roles)>
				<cfreturn true>
			<cfelse>
				<cfset auditUserEvent(user_id=u.id, event_type="Failed Login Attempt", event_description="The user #u.username# (#u.id#) attempted to login using an incorrect password.")>
			</cfif>
		<cfelse>
			<cfset auditUserEvent(user_id=0, event_type="Unknown Username Login Attempt", event_description="Someone attempted logging in using an invalid username.")>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="changePassword" returntype="void" output="false" access="public" hint="Used to change a users password">
		<cfargument name="user_id" type="string" required="true">
		<cfargument name="old_password" type="string" required="true">
		<cfargument name="new_password" type="string" required="true">
		<cfargument name="confirm_password" type="string" required="true">
		<cfset var q = "">
		<cfset var tok = "">
		<cfif arguments.new_password IS NOT arguments.confirm_password>
			<cfthrow message="Passwords do not match" type="fuseguard">
		</cfif>
		<cfif NOT isPasswordValid(arguments.new_password)>
			<cfthrow message="Password does not meet the requirements. Minimum length is #getMinimumPasswordLength()#" type="fuseguard">
		</cfif>
		<cfquery name="q" datasource="#variables.ds#" username="#variables.ds_user#" password="#variables.ds_pass#">
			SELECT token, password, username
			FROM fuseguard_users
			WHERE id = <cfqueryparam value="#Int(Val(arguments.user_id))#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif q.password IS NOT arguments.old_password>
			<!--- old password will be hashed db value if using forgot password feature --->
			<cfif arguments.user_id IS NOT getAuthenticatedUserID() AND NOT isAuthenticatedUserAdmin()>
				<cfthrow message="Nice try, but sorry you cant change this users password." type="fuseguard">
			</cfif>
			<cfif NOT q.recordcount OR UCASE(Hash(arguments.old_password & q.token, getHashAlgorithm(), "utf-8")) IS NOT UCASE(q.password)>
				<cfthrow message="Old Password is incorrect." type="fuseguard">
			</cfif>
		</cfif>
		
		
		<!--- setup a new token --->
		<cfset tok = generateToken()>
		<cfquery datasource="#variables.ds#" username="#variables.ds_user#" password="#variables.ds_pass#">
			UPDATE fuseguard_users
			SET password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Hash(arguments.new_password&tok, getHashAlgorithm(), "utf-8")#">,
			token = <cfqueryparam value="#tok#" cfsqltype="cf_sql_varchar">
			WHERE id = <cfqueryparam value="#Int(Val(arguments.user_id))#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset auditUserEvent(user_id=arguments.user_id, event_type="Changed Password", event_description="The user #q.username# (#Val(arguments.user_id)#) changed their password.")>
	</cffunction>
	
	
	
	<cffunction name="updateUser" returntype="string" output="false" hint="Updates or creates a user by passing in a struct with keys email, roles, enabled, etc. Performs security checks to make sure the current user may perform this action as well. Returns the user id of the new or existing user.">
		<cfargument name="user_id" type="string">
		<cfargument name="user" type="struct">
		<cfset u = arguments.user>
		<cfset uid = Int(Val(arguments.user_id))>
		<cfset oldUser = getUserByID(uid)>
		<cfset tok = "">
		<cfif NOT oldUser.recordcount AND uid IS NOT "0">
			<cfthrow message="Invalid User" type="fuseguard">
		</cfif>
		<cfif Val(getAuthenticatedUserID()) NEQ 0 AND uid IS NOT getAuthenticatedUserID() AND NOT isAuthenticatedUserAdmin()>
			<cfset auditUserEvent(user_id=Val(getAuthenticatedUserID()), event_type="Access Denied Modify Users", event_description="Attempted to add/edit user: #uid#")>
			<cfthrow message="Sorry you cant modify this user." type="fuseguard">
		</cfif>
		<cfif NOT StructKeyExists(u, "roles")>
			<cfset u.roles = "viewer">
		</cfif>
		
		<cfif uid IS "0">
			<!--- new user --->
			<cfset tok = generateToken()>
			<cftransaction>
				<cfquery datasource="#variables.ds#" username="#variables.ds_user#" password="#variables.ds_pass#">
					INSERT INTO fuseguard_users (username, email, password, token, enabled, roles)
					VALUES (
						<cfqueryparam value="#Left(u.username, 50)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Left(u.email, 128)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Hash(u.password & tok, getHashAlgorithm(), "utf-8")#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Left(tok, 128)#" cfsqltype="cf_sql_varchar">,
						<cfif u.enabled>1<cfelse>0</cfif>,
						<cfqueryparam value="#Left(u.roles, 128)#" cfsqltype="cf_sql_varchar">
					)
				</cfquery>
				<cfquery name="u" datasource="#variables.ds#" username="#variables.ds_user#" password="#variables.ds_pass#">
					SELECT Max(id) AS user_id FROM fuseguard_users
				</cfquery>
			</cftransaction>
			<cfreturn u.user_id>
		<cfelse>
			<cfquery datasource="#variables.ds#" username="#variables.ds_user#" password="#variables.ds_pass#">
				UPDATE fuseguard_users
				SET 
					email = <cfqueryparam value="#Left(u.email, 128)#" cfsqltype="cf_sql_varchar">,
					<cfif isAuthenticatedUserAdmin()>
						<cfif StructKeyExists(u, "enabled")>
							enabled = <cfif u.enabled>1<cfelse>0</cfif>,
						</cfif>
						<cfif StructKeyExists(u, "roles")>
							roles = <cfqueryparam value="#Left(u.roles, 128)#" cfsqltype="cf_sql_varchar">,
						</cfif>
					</cfif>
					username = <cfqueryparam value="#Left(u.username, 50)#" cfsqltype="cf_sql_varchar">
				WHERE id = <cfqueryparam value="#Int(Val(arguments.user_id))#" cfsqltype="cf_sql_integer">
			</cfquery>
			
		</cfif>
			
		<cfreturn Int(Val(arguments.user_id))>
	</cffunction>
	
	<cffunction name="getAllUsers" returntype="query" output="false" hint="Returns a list of all users">
		<cfset var q = "">
		<cfif NOT isAuthenticatedUserAdmin()>
			<cfthrow message="Sorry you must be an admin to list all users." type="fuseguard">
		</cfif>
		<cfquery name="q" datasource="#variables.ds#" username="#variables.ds_user#" password="#variables.ds_pass#">
			SELECT id, email, username, enabled, roles FROM fuseguard_users
		</cfquery>
		<cfreturn q>
	</cffunction>
	
	<cffunction name="auditUserEvent" returntype="void" access="package" output="false" hint="I log a user action">
		<cfargument name="user_id" type="string" default="0">
		<cfargument name="event_type" type="string" required="true">
		<cfargument name="event_description" type="string" required="true">
		<cfquery datasource="#variables.ds#" username="#variables.ds_user#" password="#variables.ds_pass#">
			INSERT INTO fuseguard_audit (user_id, ip_address, event_date, event_type, event_description)
			VALUES (
				<cfqueryparam value="#Int(Val(arguments.user_id))#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#Left(variables.firewallInstance.getRequestIPAddress(), 40)#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam value="#Left(arguments.event_type, 20)#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Left(arguments.event_description, 255)#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="getUserByID" returntype="query" output="false">
		<cfargument name="user_id">
		<cfset var q = "">
		<cfquery name="q" datasource="#variables.ds#" username="#variables.ds_user#" password="#variables.ds_pass#">
			SELECT id, username, token, email, password, enabled, roles
			FROM fuseguard_users
			WHERE id = <cfqueryparam value="#Int(Val(arguments.user_id))#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfreturn q>
	</cffunction>
	
	<cffunction name="getUserByEmail" returntype="query" output="false" hint="Returns user info query by email address">
		<cfargument name="email">
		<cfset var q = "">
		<cfquery name="q" datasource="#variables.ds#" username="#variables.ds_user#" password="#variables.ds_pass#">
			SELECT id, username, token, email, password, enabled, roles
			FROM fuseguard_users
			WHERE email = <cfqueryparam value="#Left(arguments.email,128)#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn q>
	</cffunction>
	
	<cffunction name="canEditUsers" returntype="boolean" output="false" hint="Returns true if this Authenticator supports the methods to edit users and change passwords">
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getDescription" returntype="string" output="false" hint="Returns a description of where the data is stored, eg datasource name.">
		<cfreturn "datasource=" & variables.ds & ", type=" & variables.ds_type>
	</cffunction>
	
</cfcomponent>