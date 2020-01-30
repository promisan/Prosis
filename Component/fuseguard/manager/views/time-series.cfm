<cfparam name="thisTag.ExecutionMode" default="invalid">
<cfif thisTag.ExecutionMode IS "start">
	<cfparam name="attributes.reader">
	<cfset byDay = attributes.reader.getCountFor(field="request_date", year=url.year, month=url.month, day=url.day, threat_category=url.threat_category, ip=url.ip, script_name=url.script_name, host=url.host, threat_level=url.threat_level)>
	
	<cfif byDay.recordcount>
	<div id="byDayChart"></div>
	<div id="byDayData">
		<cfoutput query="byDay">
			<div class="p" data-x="#NumberFormat(DateDiff("s", CreateDate(1970,1,1), DateConvert("local2Utc",byDay.request_date))*1000, "_____________")#" data-y="<cfif IsDefined("byDay.num")>#byDay.num#<cfelse>1</cfif>"></div>
		</cfoutput>
	</div>
	<cfelse>
		<div class="alert">Sorry, no log entries have been logged matching this criteria.</div>
		<p><a href="#" class="btn backbtn"><i class="icon-chevron-left"></i> Go Back</a></p>
	</cfif>
</cfif>