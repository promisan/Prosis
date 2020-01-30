<cfinclude template="check-auth.cfm">
<cfset request.title = "FuseGuard: Log View">
<cfparam name="url.mode" default="graph" type="variablename">
<cfif url.mode IS "graph">
	<!--- need to allow inline CSS for the graphical display --->
	<cfset request.csp = request.urlBuilder.getDefaultContentSecurityPolicy() & "style-src 'self' 'unsafe-inline';">
</cfif>
<cfinclude template="views/header.cfm">
<cftry>
<cfimport prefix="vw" taglib="views/">
<cfset reader = request.firewall.getLogReader()>

<vw:top-filter />
<cfoutput>
<div align="right" class="navtab">
	<br />
	<cfif url.mode IS "graph">
		<a href="#buildLogURL("mode", "table")#" class="btn btn-small"><img src="#request.urlBuilder.createStaticURL("views/images/table.png")#" border="0" class="icon"> Switch to Table View</a>
	<cfelse>
		<a href="#buildLogURL("mode", "graph")#" class="btn btn-small"><img src="#request.urlBuilder.createStaticURL("views/images/chart-pie.png")#" border="0" class="icon"> Switch to Graphical View</a>
	</cfif>
</div>
<h2><img src="#request.urlBuilder.createStaticURL('views/images/line-chart.png')#" alt="line-chart" border="0" class="icon" /> 
<cfif url.day NEQ 0 AND url.month NEQ 0 AND url.year NEQ 0>#DateFormat(CreateDate(url.year, url.month, url.day), "dddd mmmm d, yyyy")#<cfelseif url.month NEQ 0 OR url.year NEQ 0><cfif url.month NEQ 0>#MonthAsString(url.month)#, </cfif><cfif url.year NEQ 0>#Int(url.year)#</cfif><cfelse>Threats over Time</cfif>
<cfif Len(url.blocked) OR Len(url.ip) OR Len(url.threat_category) OR url.threat_level NEQ 0 OR Len(url.script_name)>(
<cfif url.blocked IS "1">Blocked Requests<cfelseif url.blocked IS "0">Not Blocked</cfif>
<cfif Len(url.ip)>With IP=#request.firewall.stringCleaner(url.ip)#</cfif>
<cfif Len(url.threat_category)>Category=#request.firewall.stringCleaner(url.threat_category)#</cfif>
<cfif Len(url.threat_level) AND url.threat_level NEQ 0>Level=#Val(url.threat_level)#</cfif>
<cfif Len(url.script_name)>URI=#request.firewall.stringCleaner(url.script_name)#</cfif>
)</cfif>
</h2>
</cfoutput>

<cfif url.mode IS "graph">
	<vw:time-series reader="#reader#" />
	<div class="pie_left">
	<vw:pie-chart field="threat_category" title="Threats by Category" column_header="Category" reader="#reader#" />
	</div>
	<div class="pie_right">
	<vw:pie-chart field="filter_name" title="Threats by Filter" column_header="Filter Name" reader="#reader#" />
	</div>
	<br class="clear" />
	<div class="pie_left">
	<vw:pie-chart field="ip_address" title="Threats by IP Address" column_header="IP Address" minimum="1" reader="#reader#" />
	</div>
	<div class="pie_right">
	<vw:pie-chart field="threat_level" title="Threats by Severity" column_header="Threat Level" reader="#reader#" />
	</div>
	<br class="clear" />
	
	<div class="pie_full">
	<vw:pie-chart field="script_name" title="Threats by URI" column_header="URI"  reader="#reader#" />
	</div>
	<br class="clear" />
	<vw:pie-chart field="request_host" title="Threats by Host" column_header="Host" minimum_records="2" reader="#reader#" />
	
	
<cfelse>
	<cfparam name="url.page" default="1" type="integer">
	<cfset request.limit = 500>
	
	<cfset logs = reader.getLogEntries(year=url.year, month=url.month, day=url.day, threat_category=url.threat_category, ip=url.ip, script_name=url.script_name, host=url.host, threat_level=url.threat_level, blocked=url.blocked, limit=request.limit, page=url.page)>
	<cfif logs.recordcount GTE request.limit>
		<cfset nextPage = buildLogURL("page", url.page+1)>
	<cfelse>
		<cfset nextPage = "">
	</cfif>
	<cfif url.page GT 1>
		<cfset prevPage = buildLogURL("page", url.page-1)>
	<cfelse>
		<cfset prevPage = "">
	</cfif>
	<vw:log-table logs="#logs#" nextpage="#nextPage#" prevpage="#prevpage#" page="#url.page#" />
</cfif>

<cffunction name="buildLogURL" returntype="string" output="false">
	<cfargument name="field" type="variableName">
	<cfargument name="value" type="string">
	<cfset var qs = "">
	<cfset var fieldList = "year,month,day,mode,threat_category,script_name,ip,host,threat_level,blocked,filter_name,page">
	<cfset var i = "">
	<cfset var val = "">
	<cfloop list="#fieldList#" index="i">
		<cfif LCase(arguments.field) IS i>
			<cfif Len(qs)><cfset qs = qs & "&"></cfif>
			<cfset qs = qs & i & "=" & URLEncodedFormat(arguments.value)>
		<cfelseif StructKeyExists(url, i) AND Len(url[i])>
			<cfif Len(qs)><cfset qs = qs & "&"></cfif>
			<cfif ListFindNoCase("year,month,day,threat_level,blocked,page", i)>
				<cfset val = Int(Val(url[i]))>
			<cfelse>
				<cfset val = ReReplace(url[i], "[^a-zA-Z0-9/._-]", "", "ALL")>
			</cfif>
			<cfset qs = qs & i & "=" & URLEncodedFormat(val)>
		</cfif>
	</cfloop>
	<cfreturn request.urlBuilder.createDynamicURL('log', qs)>
</cffunction>
<cfcatch type="any">
	<cfmodule template="views/catch.cfm" catch="#cfcatch#" /><cfabort>
</cfcatch>
</cftry>
<cfinclude template="views/footer.cfm">