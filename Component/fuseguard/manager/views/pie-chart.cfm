<cfparam name="thisTag.ExecutionMode" default="error">
<cfif thisTag.ExecutionMode IS "start">

	<cfparam name="attributes.field" type="variablename" default="ip_address">
	<cfparam name="attributes.title" type="string" default="">
	<cfparam name="attributes.column_header" type="string" default="#attributes.title#">
	<cfparam name="attributes.colors" type="string" default="red,##FF9900,##1E90FF,green,##9900CC,pink,brown,orange,yellow,##F0F8FF,##7FFFD4,##FFD700,black">
	<cfparam name="attributes.maxrows" type="range" default="12" min="1" max="#ListLen(attributes.colors)#">
	<cfparam name="attributes.minimum" type="integer" default="0">
	<cfparam name="attributes.minimum_records" type="integer" default="1">
	<cfparam name="attributes.reader">
	<cfparam name="url.year" type="integer" default="#year(now())#">
	<cfparam name="url.month" type="range" default="0" min="0" max="12">
	<cfparam name="url.day" type="range" default="0" min="0" max="31">
	<cfparam name="url.threat_category" type="string" default="">
	<cfparam name="url.threat_level" type="numeric" default="0">
	<cfparam name="url.script_name" type="string" default="">
	<cfparam name="url.ip" type="string" default="">
	<cfparam name="url.host" type="string" default="">
	<cfparam name="url.filter_name" type="string" default="">
	
	<cfset data = attributes.reader.getCountFor(field=attributes.field, minimum=attributes.minimum, year=url.year, month=url.month, day=url.day, threat_category=url.threat_category, ip=url.ip, script_name=url.script_name, host=url.host, threat_level=url.threat_level, maxrows=attributes.maxrows,filter_name=url.filter_name)>
	<cfif data.recordcount GTE attributes.minimum_records>
		
		<cfoutput>
			<h2>#request.firewall.stringCleaner(attributes.title)#</h2>
			<div class="pieChart" id="#attributes.field#_chart">#ValueList(data.num)#</div>
			<table class="data" cellspacing="0" id="dataTable_#attributes.field#">
					<tr>
						<th><cfoutput>#request.firewall.stringCleaner(attributes.column_header)#</cfoutput></th>			
						<th>Threats</th>
					</tr>
				<cfset filterData = Duplicate(url)>
				<cfset pieColorIndex = 0>
				<cfloop query="data">
					<cfif attributes.field IS "ip_address">
						<cfset filterData["ip"] = data[attributes.field][data.currentrow]>
					<cfelse>
						<cfset filterData[attributes.field] = data[attributes.field][data.currentrow]>		
					</cfif>
					<tr>
						<td class="item">
							<cfset pieColorIndex = pieColorIndex +  1>
							<cfif pieColorIndex GT ListLen(attributes.colors)>
								<cfset pieColorIndex = 1>
							</cfif>
							<div class="pieColor pieColor#pieColorIndex#">&nbsp;</div>
							<a href="#request.urlBuilder.createDynamicURL('log', 'year=#URLEncodedFormat(url.year)#&month=#URLEncodedFormat(url.month)#&day=#URLEncodedFormat(url.day)#&threat_category=#URLEncodedFormat(filterData.threat_category)#&ip=#URLEncodedFormat(filterData.ip)#&script_name=#URLEncodedFormat(filterData.script_name)#&host=#URLEncodedFormat(filterData.host)#&threat_level=#URLEncodedFormat(filterData.threat_level)#&filter_name=#URLEncodedFormat(filterData.filter_name)#')#">#request.firewall.stringCleaner(data[attributes.field][data.currentrow])#
						</td>
						<td class="val">#data.num#</td>
					</tr>
				</cfloop>
			</table>
			
		</cfoutput>
	</cfif>
</cfif>