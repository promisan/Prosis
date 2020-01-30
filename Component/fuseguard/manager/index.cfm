<cfinclude template="check-auth.cfm">
<cfset request.title = "FuseGuard: Dashboard">
<cfinclude template="views/header.cfm">
<cftry>
	<cfset reader = request.firewall.getLogReader()>
	<cfoutput>
		<h2><img src="#request.urlBuilder.createStaticURL('views/images/dashboard.png')#" border="0" class="icon" alt="dashboard" /> Dashboard</h2>
	</cfoutput>
	<table border="0" cellspacing="0" cellpadding="8" class="dashboard" align="right" width="100%">
		<tr>
			<th>&nbsp;</th>
			<th>Blocked</th>
			<th>&nbsp;</th>
			<th>Logged</th>
			<th>&nbsp;</th>
		</tr>
		<!--- TODAY --->
		<cfset today = reader.getLogEntries(year=Year(now()), month=Month(Now()), day=Day(now()))>
		<cfset block_count = 0>
		<cfset logged = today.recordcount>
		<cfloop query="today">
			<cfif today.blocked><cfset block_count = block_count + 1></cfif>
		</cfloop>
		<cfset blocked_sparklines = ArrayNew(1)>
		<cfset logged_sparklines = ArrayNew(1)>
		<cfloop from="1" to="24" index="h">
			<cfset b = 0>
			<cfset l = 0>
			<cfloop query="today">
				<cfif Hour(today.request_date) EQ h><cfif today.blocked><cfset b=b+1></cfif><cfset l=l+1></cfif>
			</cfloop>
			<cfset ArrayAppend(blocked_sparklines, b)>
			<cfset ArrayAppend(logged_sparklines, l)>
		</cfloop>
		<cfoutput>
		<tr>
			<td class="period"><h2>Today</h2></td>
			<td class="blocked"><a href="#request.urlBuilder.createDynamicURL('log', 'year=#Year(now())#&month=#Month(now())#&day=#Day(now())#&blocked=1')#">#block_count#</a></td>
			<td class="spark"><div id="today_blocked">#ArrayToList(blocked_sparklines)#</div></td>
			<td class="logged"><a href="#request.urlBuilder.createDynamicURL('log', 'year=#Year(now())#&month=#Month(now())#&day=#Day(now())#')#">#logged#</a></td>
			<td class="spark"><div id="today_logged">#ArrayToList(logged_sparklines)#</div></td>
		</tr>
		</cfoutput>
		
		<!--- YESTERDAY --->
		<cfset yday = DateAdd("d", -1, now())>
		<cfset yesterday = reader.getLogEntries(year=Year(yday), month=Month(yday), day=Day(yday))>
		<cfset block_count = 0>
		<cfset logged = yesterday.recordcount>
		<cfloop query="yesterday">
			<cfif yesterday.blocked><cfset block_count = block_count + 1></cfif>
		</cfloop>
		<cfset blocked_sparklines = ArrayNew(1)>
		<cfset logged_sparklines = ArrayNew(1)>
		<cfloop from="1" to="24" index="h">
			<cfset b = 0>
			<cfset l = 0>
			<cfloop query="yesterday">
				<cfif Hour(yesterday.request_date) EQ h><cfif yesterday.blocked><cfset b=b+1></cfif><cfset l=l+1></cfif>
			</cfloop>
			<cfset ArrayAppend(blocked_sparklines, b)>
			<cfset ArrayAppend(logged_sparklines, l)>
		</cfloop>
		<cfoutput>
		<tr>
			<td class="period"><h2>Yesterday</h2></td>
			<td class="blocked"><a href="#request.urlBuilder.createDynamicURL('log', 'year=#Year(yday)#&month=#Month(yday)#&day=#Day(yday)#&blocked=1')#">#block_count#</a></td>
			<td class="spark"><div id="yesterday_blocked">#ArrayToList(blocked_sparklines)#</div></td>
			<td class="logged"><a href="#request.urlBuilder.createDynamicURL('log', 'year=#Year(yday)#&month=#Month(yday)#&day=#Day(yday)#')#">#logged#</a></td>
			<td class="spark"><div id="yesterday_logged">#ArrayToList(logged_sparklines)#</div></td>
		</tr>
		</cfoutput>
		
		<!--- MONTH --->
		<cfset month_logged = reader.getCountFor(field="request_date", year=Year(now()), month=Month(now()))>
		<cfset month_blocked = reader.getCountFor(field="request_date", year=Year(now()), month=Month(now()), blocked=1)>
		<cfset blocked_sparklines = ArrayNew(1)>
		<cfset logged_sparklines = ArrayNew(1)>
		<cfset block_count = 0>
		<cfset logged = 0>
		<cfloop from="1" to="#DaysInMonth(now())#" index="i">
			<cfset b = 0>
			<cfset l = 0>
			<cfloop query="month_logged">
				<cfif month_logged.d EQ i>
					<cfset logged = logged+month_logged.num>
					<cfset l = l + month_logged.num>
				</cfif>
			</cfloop>
			<cfloop query="month_blocked">
				<cfif month_blocked.d EQ i>
					<cfset block_count = block_count+month_blocked.num>
					<cfset b = b + month_blocked.num>
				</cfif>
			</cfloop>
			<cfset ArrayAppend(logged_sparklines, l)>
			<cfset ArrayAppend(blocked_sparklines, b)>
		</cfloop>
		<cfoutput>
		<tr>
			<td class="period"><h2>This Month</h2></td>
			<td class="blocked"><a href="#request.urlBuilder.createDynamicURL('log', 'year=#Year(now())#&month=#Month(now())#&blocked=1')#">#block_count#</a></td>
			<td class="spark"><div id="month_blocked">#ArrayToList(blocked_sparklines)#</div></td>
			<td class="logged"><a href="#request.urlBuilder.createDynamicURL('log', 'year=#Year(now())#&month=#Month(now())#')#">#logged#</a></td>
			<td class="spark"><div id="month_logged">#ArrayToList(logged_sparklines)#</div></td>
		</tr>
		</cfoutput>
		
		<!--- YEAR --->
		<cfset year_logged = reader.getCountFor(field="request_date", year=Year(now()))>
		<cfset year_blocked = reader.getCountFor(field="request_date", year=Year(now()), blocked=1)>
		<cfset blocked_sparklines = ArrayNew(1)>
		<cfset logged_sparklines = ArrayNew(1)>
		<cfset block_count = 0>
		<cfset logged = 0>
		<cfloop from="1" to="12" index="i">
			<cfset b = 0>
			<cfset l = 0>
			<cfloop query="year_logged">
				<cfif year_logged.m EQ i>
					<cfset logged = logged+year_logged.num>
					<cfset l = l + year_logged.num>
				</cfif>
			</cfloop>
			<cfloop query="year_blocked">
				<cfif year_blocked.m EQ i>
					<cfset block_count = block_count+year_blocked.num>
					<cfset b = b + year_blocked.num>
				</cfif>
			</cfloop>
			<cfset ArrayAppend(logged_sparklines, l)>
			<cfset ArrayAppend(blocked_sparklines, b)>
		</cfloop>
		<cfoutput>
		<tr>
			<td class="period"><h2>This Year</h2></td>
			<td class="blocked"><a href="#request.urlBuilder.createDynamicURL('log', 'year=#Year(now())#&blocked=1')#">#block_count#</a></td>
			<td class="spark"><div id="year_blocked">#ArrayToList(blocked_sparklines)#</div></td>
			<td class="logged"><a href="#request.urlBuilder.createDynamicURL('log', 'year=#Year(Now())#')#">#logged#</a></td>
			<td class="spark"><div id="year_logged">#ArrayToList(logged_sparklines)#</div></td>
		</tr>
		</cfoutput>
	</table>
	<br />
	
	
	<cfcatch type="any">
		<cfmodule template="views/catch.cfm" catch="#cfcatch#" /><cfabort>
	</cfcatch>
</cftry>
<cfinclude template="views/footer.cfm">