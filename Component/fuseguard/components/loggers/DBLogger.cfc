<cfcomponent name="CFLogLogger" extends="BaseLogger" hint="Logs to a database using the cfquery tag.">
	<cfset variables.ds = "fuseguard">
	<cfset variables.ds_user = "">
	<cfset variables.ds_pass = "">
	<cfset varibales.ds_type = "">
	<cfset variables.log_reader = "">
	<cfset variables.firewallInstance = "">
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="firewallInstance">
		<cfset variables.firewallInstance = arguments.firewallInstance>
		<cfset setEscapeMessage(false)>
		<!--- use cfinvoke for shared host support --->
		<cfinvoke component="DBLogReader" method="init" returnvariable="variables.log_reader">
			<cfinvokeargument name="firewall" value="#arguments.firewallInstance#">
			<cfinvokeargument name="logger" value="#this#">
		</cfinvoke>
		<cfreturn super.init(arguments.firewallInstance)>
	</cffunction>
	
	<cffunction name="logRequest" returntype="void" access="public">
		<cfargument name="level" type="numeric" required="true">
		<cfargument name="filter" type="any" hint="a Filter object">
		<cfargument name="type" default="inspectRequest" type="variablename">
		<cfargument name="message" type="string" default="">
		<cfargument name="detail" type="string" default="">
		<cfset var blocked = 0>
		<cfset var insertResult = "">
		<cfif filter.blockEnabled() AND arguments.level GTE filter.getBlockLevel()>
			<cfset blocked = 1>
		</cfif>
		
		<cfquery datasource="#variables.ds#" username="#variables.ds_user#" password="#variables.ds_pass#" result="insertResult">
			INSERT INTO fuseguard_log (threat_level, filter_name, message, detail, request_method, script_name, user_agent,ip_address, blocked, request_date, request_host, request_port, request_https, filter_component, threat_category, filter_instance, query_string, http_referer)
			VALUES (
				<cfqueryparam value="#arguments.level#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#Left(arguments.filter.getName(), 50)#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Left(arguments.message, 255)#" cfsqltype="cf_sql_varchar">,
				<cfif isVerbose()>
					<cfqueryparam value="#arguments.detail#" cfsqltype="cf_sql_varchar">,
				<cfelse>
					<cfqueryparam null="true" cfsqltype="cf_sql_varchar">,
				</cfif>
				<cfqueryparam value="#Left(cgi.request_method, 10)#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Left(cgi.script_name, 255)#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Left(cgi.http_user_agent, 255)#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.filter.getFirewall().getRequestIPAddress()#" cfsqltype="cf_sql_varchar">,
				<cfif blocked>1<cfelse>0</cfif>,
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam value="#Left(cgi.server_name, 128)#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#cgi.server_port#">,
				<cfif cgi.server_port_secure>1<cfelse>0</cfif>,
				<cfqueryparam value="#Left(arguments.filter.getFilterComponent(), 128)#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Left(arguments.filter.getThreatCategory(), 16)#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Left(arguments.filter.getFilterInstanceName(), 50)#">,
				<cfif isVerbose()>
					<cfqueryparam value="#cgi.query_string#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#cgi.http_referer#" cfsqltype="cf_sql_varchar">
				<cfelse>
					<cfqueryparam null="true" cfsqltype="cf_sql_varchar">,
					<cfqueryparam null="true" cfsqltype="cf_sql_varchar">
				</cfif>
			)
		</cfquery>
		<cfif IsStruct(insertResult)>
			<cfif StructKeyExists(insertResult, "generatedKey") AND Len(insertResult.generatedKey)>
				<cfset request.fuseguard_log_id = insertResult.generatedKey>
			<cfelseif StructKeyExists(insertResult, "IDENTITYCOL") AND Len(insertResult.IDENTITYCOL)>
				<cfset request.fuseguard_log_id = insertResult.identityCol>
			<cfelseif StructKeyExists(insertResult, "GENERATED_KEY") AND Len(insertResult.GENERATED_KEY)>
				<cfset request.fuseguard_log_id = insertResult.GENERATED_KEY>
			</cfif>
		</cfif>
		
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
	
	<cffunction name="getDatasourceName" returntype="string" output="false" hint="Returns the name of the datasource passed into setDatasource">
		<cfreturn variables.ds>
	</cffunction>
	
	<cffunction name="getDatasourceType" returntype="string" output="false" hint="Returns the database type passed into setDatasource">
		<cfreturn variables.ds_type>
	</cffunction>
	
	<cffunction name="isViewable" returntype="boolean" hint="If the log is viewable such as a file or DB return true, if not (email, or IM) return false.">
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getLogReader" returntype="BaseLogReader" output="false" hint="I return the log reader">
		<!--- use cfinvoke for shared host support --->
		<cfinvoke component="#variables.log_reader#" method="setDatasource">
			<cfinvokeargument name="datasource" value="#variables.ds#">
			<cfinvokeargument name="username" value="#variables.ds_user#">
			<cfinvokeargument name="password" value="#variables.ds_pass#">
			<cfinvokeargument name="dbtype" value="#variables.ds_type#">
		</cfinvoke>
		<cfreturn variables.log_reader>
	</cffunction>
	
	<cffunction name="hasLogReader" returntype="boolean" output="false" hint="If this logger has an associated log reader, return true">
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getStorageDescription" returntype="string" output="false" hint="Returns a description of where the data is stored, eg datasource name.">
		<cfreturn "datasource=" & variables.ds & ", type=" & variables.ds_type>
	</cffunction>
	
</cfcomponent>