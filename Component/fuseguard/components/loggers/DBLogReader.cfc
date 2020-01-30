<cfcomponent extends="BaseLogReader" hint="I read from the log database and return results">
	<cfset variables.ds = "fuseguard">
	<cfset variables.ds_user = "">
	<cfset variables.ds_pass = "">
	<cfset variables.ds_type = "">
	
	
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
	
	
	
	<cffunction name="getAllThreatCategories" returntype="query" output="false" hint="Returns a query with column threat_category">
		<cfset var q = "">
		<cfquery name="q" datasource="#variables.ds#" username="#variables.ds_user#" password="#variables.ds_pass#">
			SELECT DISTINCT threat_category FROM fuseguard_log
		</cfquery>
		<cfreturn q>
	</cffunction>
	
	<cffunction name="getAllHostNames" returntype="query" output="false" hint="Returns a query with column request_host">
		<cfset var q = "">
		<cfquery name="q" datasource="#variables.ds#" username="#variables.ds_user#" password="#variables.ds_pass#">
			SELECT DISTINCT request_host FROM fuseguard_log
			ORDER BY request_host
		</cfquery>
		<cfreturn q>
	</cffunction>
	
	<cffunction name="getLogEntries" returntype="query" output="false" hint="Returns a query with several columns, the detail column is not returned.">
		<cfargument name="year" type="numeric" default="0" hint="Pass in a year to filter by year, or 0 for any year">
		<cfargument name="month" type="numeric" default="0" hint="Pass in a month to filter by month, or 0 for any month">
		<cfargument name="day" type="numeric" default="0" hint="Pass in a day or 0 to filter by any day">
		<cfargument name="threat_category" type="string" default="" hint="Pass in a threat category to filter by, or an empty string for any category.">
		<cfargument name="script_name" type="string" default="" hint="Pass in a URI to filter by, supports wildcards eg /admin/* will match anything under the admin uri.">
		<cfargument name="ip" type="string" default="" hint="Pass in an IP address to filter by.">
		<cfargument name="host" type="string" default="" hint="Pass in a hostname to filter by.">
		<cfargument name="threat_level" type="numeric" default="0" hint="Threat Level from 1-10">
		<cfargument name="blocked" type="string" default="" hint="Pass boolean to filter by blocked or not blocked">
		<cfargument name="limit" type="numeric" default="0" hint="Limit the number of records returned to this many">
		<cfargument name="page" type="numeric" default="1" hint="Page number when used with limit">
		<cfset var q = "">
		<cfset var loc = "">
		<cfquery name="q" datasource="#variables.ds#" username="#variables.ds_user#" password="#variables.ds_pass#">
			SELECT <cfif arguments.limit GT 0 AND variables.ds_type IS "sqlserver">TOP #Int(arguments.limit*arguments.page)#</cfif> id,threat_level, filter_name, message, request_method, script_name, ip_address, blocked, request_date, request_host, request_port, request_https, filter_component, threat_category, filter_instance
			FROM fuseguard_log
			WHERE 1=1
				<cfif arguments.year GT 0>
					AND Year(request_date) = <cfqueryparam value="#arguments.year#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif arguments.month GT 0>
					AND Month(request_date) = <cfqueryparam value="#arguments.month#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif arguments.day GT 0>
					AND Day(request_date) = <cfqueryparam value="#arguments.day#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif Len(arguments.threat_category)>
					AND threat_category = <cfqueryparam value="#arguments.threat_category#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif Len(arguments.script_name)>
					AND script_name LIKE <cfqueryparam value="#Replace(arguments.script_name, "*", "%" , "ALL")#">
				</cfif>
				<cfif Len(arguments.ip)>
					AND ip_address = <cfqueryparam value="#Replace(arguments.ip, "*", "%" , "ALL")#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif Len(arguments.ip)>
					AND ip_address = <cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif Len(arguments.host)>
					AND request_host = <cfqueryparam value="#arguments.host#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.threat_level NEQ 0>
					AND threat_level = <cfqueryparam value="#Int(arguments.threat_level)#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif IsBoolean(arguments.blocked)>
					AND blocked = <cfif arguments.blocked>1<cfelse>0</cfif>
				</cfif>
			ORDER BY request_date DESC
			<cfif arguments.limit GT 0 AND ListFindNoCase("mysql,postgresql", variables.ds_type)>
				LIMIT #Int(arguments.limit)# <cfif arguments.page GT 1>OFFSET #Int((arguments.limit*arguments.page)-arguments.limit)#</cfif>
			</cfif>
		</cfquery>
		<cfif q.recordcount AND arguments.limit GT 0 AND ListFindNoCase("sqlserver,derby", variables.ds_type)>
			<!--- because derby and sqlserver dont have limit/offset we have to extract records manually --->
			<cfset loc = StructNew()>
			<cfif arguments.page EQ 1>
				<cfset loc.startRow = 1>
			<cfelse>
				<cfset loc.startRow = (arguments.limit * arguments.page) - arguments.limit + 1>
			</cfif>
			<cfset loc.keep = "">
			<cfoutput query="q" startrow="#loc.startRow#" maxrows="#arguments.limit#">
				<cfset loc.keep = listAppend(loc.keep, q.id)>
			</cfoutput>
			<cfquery dbtype="query" name="q">
				SELECT * FROM q
				WHERE id <cfif Len(loc.keep)>IN (<cfqueryparam value="#loc.keep#" cfsqltype="cf_sql_integer" list="true">)<cfelse> = -1</cfif>
			</cfquery>
		</cfif>
		<cfreturn q>
	</cffunction>
	
	<cffunction name="getLogDetail" returntype="query" output="false" hint="Returns all information about a particular log entry.">
		<cfargument name="id" type="string" default="0">
		<cfset var q = "">
		<cfquery name="q" datasource="#variables.ds#" username="#variables.ds_user#" password="#variables.ds_pass#">
			SELECT id,threat_level, filter_name, message, detail, request_method, script_name, user_agent, ip_address, blocked, request_date, request_host, request_port, request_https, filter_component, threat_category, filter_instance, query_string, http_referer
			FROM fuseguard_log
			WHERE id = <cfqueryparam value="#Int(Val(arguments.id))#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfreturn q>
	</cffunction>

	<cffunction name="getCountFor" returntype="query" output="false" hint="Returns a query with the num column and column passed into the field argument.">
		<cfargument name="field" type="variablename" required="true" hint="One of: ip_address,script_name,threat_level,threat_category,filter_component,filter_name,request_date,request_host">
		<cfargument name="minimum" type="numeric" default="0">
		<cfargument name="year" type="numeric" default="0" hint="Pass in a year to filter by year, or 0 for any year">
		<cfargument name="month" type="numeric" default="0" hint="Pass in a month to filter by month, or 0 for any month">
		<cfargument name="day" type="numeric" default="0" hint="Pass in a day or 0 to filter by any day">
		<cfargument name="threat_category" type="string" default="" hint="Pass in a threat category to filter by, or an empty string for any category.">
		<cfargument name="script_name" type="string" default="" hint="Pass in a URI to filter by, supports wildcards eg /admin/* will match anything under the admin uri.">
		<cfargument name="ip" type="string" default="" hint="Pass in an IP address to filter by.">
		<cfargument name="host" type="string" default="" hint="Pass in a hostname to filter by.">
		<cfargument name="threat_level" type="numeric" default="0" hint="Threat Level from 1-10">
		<cfargument name="blocked" type="string" default="" hint="Pass boolean to filter by blocked or not blocked">
		<cfargument name="maxrows" type="numeric" default="0">
		<cfargument name="filter_name" type="string" default="" hint="Pass in a filter_name to filter by.">
		<cfset var q = "">
		<cfset var a = "">
		
		<cfif NOT ListFindNoCase("ip_address,script_name,threat_level,threat_category,filter_component,filter_name,request_date,request_host", arguments.field)>
			<cfthrow message="Invalid Field Name">
		</cfif>
		<cfif arguments.maxrows LT 1>
			<cfset arguments.maxrows = -1>
		</cfif>
		<cfquery name="q" datasource="#variables.ds#" maxrows="#arguments.maxrows#" username="#variables.ds_user#" password="#variables.ds_pass#">
			SELECT <cfif arguments.maxrows GT 0 AND variables.ds_type IS "sqlserver">TOP #Int(Val(arguments.maxrows))#</cfif> COUNT(*) as num, <cfif arguments.field IS "request_date">Year(request_date) AS y, Month(request_date) AS m, Day(request_date) AS d <cfif arguments.day NEQ 0>,<cfif variables.ds_type IS "sqlserver">DATEPART(hour, request_date)<cfelse>Hour(request_date)</cfif> AS h, <cfif variables.ds_type IS "sqlserver">DATEPART(minute, request_date)<cfelse>Minute(request_date)</cfif> AS mn</cfif><cfelse>#XmlFormat(arguments.field)#</cfif>
			FROM fuseguard_log
			WHERE 1=1
				<cfif arguments.year GT 0>
					AND Year(request_date) = <cfqueryparam value="#Int(arguments.year)#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif arguments.month GT 0>
					AND Month(request_date) = <cfqueryparam value="#Int(arguments.month)#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif arguments.day GT 0>
					AND Day(request_date) = <cfqueryparam value="#Int(arguments.day)#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif Len(arguments.threat_category)>
					AND threat_category = <cfqueryparam value="#arguments.threat_category#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif Len(arguments.script_name)>
					AND script_name LIKE <cfqueryparam value="#Replace(arguments.script_name, "*", "%" , "ALL")#">
				</cfif>
				<cfif Len(arguments.ip)>
					AND ip_address = <cfqueryparam value="#Replace(arguments.ip, "*", "%" , "ALL")#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif Len(arguments.host)>
					AND request_host = <cfqueryparam value="#arguments.host#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif Len(arguments.filter_name)>
					AND filter_name = <cfqueryparam value="#arguments.filter_name#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.threat_level NEQ 0>
					AND threat_level = <cfqueryparam value="#Int(arguments.threat_level)#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif IsBoolean(arguments.blocked)>
					AND blocked = <cfif arguments.blocked>1<cfelse>0</cfif>
				</cfif>
			GROUP BY <cfif arguments.field IS "request_date">Year(request_date), Month(request_date), Day(request_date)<cfif arguments.day NEQ 0>,<cfif variables.ds_type IS "sqlserver">DATEPART(hour, request_date), DATEPART(minute, request_date)<cfelse>Hour(request_date), Minute(request_date)</cfif></cfif><cfelse>#XmlFormat(arguments.field)#</cfif>
			<cfif arguments.minimum GT 0>HAVING COUNT(*) > <cfqueryparam value="#arguments.minimum#" cfsqltype="cf_sql_integer"></cfif>
			ORDER BY <cfif arguments.field IS "request_date">Year(request_date), Month(request_date), Day(request_date)<cfif arguments.day NEQ 0>,<cfif variables.ds_type IS "sqlserver">DATEPART(hour, request_date), DATEPART(minute, request_date)<cfelse>Hour(request_date), Minute(request_date)</cfif></cfif><cfelse>COUNT(*) DESC</cfif>
			<cfif arguments.maxrows GT 0 AND ListFindNoCase("mysql,postgresql", variables.ds_type)>LIMIT #arguments.maxrows#</cfif>
		</cfquery>
		<cfif arguments.field IS "request_date">
			<!--- add a request date column --->
			<cfset a = ArrayNew(1)>
			<cfoutput query="q">
				<cfif arguments.day NEQ 0>
					<cfset ArrayAppend(a, CreateDateTime(q.y, q.m, q.d, q.h, q.mn, 0))>
				<cfelse>
					<cfset ArrayAppend(a, CreateDate(q.y, q.m, q.d))>
				</cfif>
			</cfoutput>
			<!--- adding datatype to QueryAddColumn is required for OpenBD but will break CF6 --->
			<cfset QueryAddColumn(q, "request_date", "Date", a)>
		</cfif>
		<cfreturn q>
		
	</cffunction>
	
	
	<cffunction name="getAverageThreatLevel" returntype="numeric" output="false" hint="returns the average threat level on a given day, month, or year">
		<cfargument name="year" type="numeric" default="0" hint="Pass in a year to filter by year, or 0 for any year">
		<cfargument name="month" type="numeric" default="0" hint="Pass in a month to filter by month, or 0 for any month">
		<cfargument name="day" type="numeric" default="0" hint="Pass in a day or 0 to filter by any day">
		<cfset var q = "">
		<cfquery datasource="#variables.ds#" username="#variables.ds_user#" password="#variables.ds_pass#">
			SELECT AVG(threat_level) AS threat_level FROM fuseguard_log
			WHERE 1=1
			<cfif arguments.year GT 0>
				AND Year(request_date) = <cfqueryparam value="#Int(arguments.year)#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif arguments.month GT 0>
				AND Month(request_date) = <cfqueryparam value="#Int(arguments.month)#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif arguments.day GT 0>
				AND Day(request_date) = <cfqueryparam value="#Int(arguments.day)#" cfsqltype="cf_sql_integer">
			</cfif>
		</cfquery>
	</cffunction>
	
	
</cfcomponent>