<cfparam name="thisTag.ExecutionMode" default="invalid">
<cfif thisTag.ExecutionMode IS "start">
	<cfif NOT StructKeyExists(request, "firewall")>
		<cfabort>
	</cfif>
	<cfparam name="url.year" type="integer" default="#year(now())#">
	<cfparam name="url.month" type="range" default="0" min="0" max="12">
	<cfparam name="url.day" type="range" default="0" min="0" max="31">
	<cfparam name="url.threat_category" type="string" default="">
	<cfparam name="url.script_name" type="string" default="">
	<cfparam name="url.ip" type="string" default="">
	<cfparam name="url.host" type="string" default="">
	<cfparam name="url.threat_level" type="numeric" default="0">
	<cfparam name="url.mode" default="graph" type="variablename">
	<cfparam name="url.blocked" default="">
	<cfif url.mode IS NOT "graph">
		<cfset url.mode = "table">
	</cfif>
	
	<cfset reader = request.firewall.getLogReader()>
	<div id="topFilter">
	<cfoutput>
		<form action="#request.urlBuilder.createDynamicURL('log')#" method="get" class="filter form-inline">
			
			<input type="hidden" name="mode" value="#request.firewall.stringCleaner(url.mode, "remove")#" />
			<label for="year">Year:</label>
			<select name="year" id="year" class="input-mini">
				<option value="0"<cfif url.year EQ 0> selected="selected"</cfif>>Any</option>
				<cfloop from="2008" to="#Year(Now())#" index="y">
					<option value="#y#"<cfif y IS url.year> selected="selected"</cfif>>#y#</option>
				</cfloop>
			</select> 
			<label for="month">Month:</label>
			<select name="month" id="month" class="input-mini">
				<option value="0"<cfif url.month EQ 0> selected="selected"</cfif>>Any</option>
				<cfloop from="1" to="12" index="m">
					<option value="#m#"<cfif m IS url.month> selected="selected"</cfif>>#Left(MonthAsString(m), 3)#</option>
				</cfloop>
			</select>
			<label for="day">Day:</label>
			<select name="day" id="day" class="input-mini">
				<option value="0"<cfif url.day EQ 0> selected="selected"</cfif>>Any</option>
				<cfloop from="1" to="31" index="d">
					<option value="#d#"<cfif d IS url.day> selected="selected"</cfif>>#d#</option>
				</cfloop>
			</select> 
			<label  for="blocked">Blocked:</label>
			<select name="blocked" id="blocked" class="input-mini">
				<option value=""<cfif url.blocked IS ""> selected="selected"</cfif>>Any</option>
				<option value="1"<cfif url.blocked IS "1"> selected="selected"</cfif>>Yes</option>
				<option value="0"<cfif url.blocked IS "0"> selected="selected"</cfif>>No</option>
			</select>
			<label for="threat_level">Threat Level:</label>
			<select name="threat_level" id="threat_level" class="input-mini">
				<option value="0"<cfif url.threat_level EQ 0> selected="selected"</cfif>>Any</option>
				<cfloop from="1" to="10" index="l">
					<option value="#l#"<cfif l IS url.threat_level> selected="selected"</cfif>>#l#</option>
				</cfloop>
			</select> 
			<div class="break-narrow"></div>
			<label for="threat_category">Category:</label>
			<select name="threat_category" id="threat_category" class="input-mini">
				<option value=""<cfif url.threat_category IS ""> selected="selected"</cfif>>Any</option>
				<cfset threatCategories = reader.getAllThreatCategories()>
				<cfloop query="threatCategories">
					<option value="#threatCategories.threat_category#"<cfif url.threat_category IS threatCategories.threat_category> selected="selected"</cfif>>#threatCategories.threat_category#</option>
				</cfloop>
			</select>
			<cfset hostNames = reader.getAllHostNames()>
			<cfif hostNames.recordcount GT 1>
				<label for="host">Host:</label>
				<select name="host" id="host" class="input-mini">
					<option value=""<cfif url.host IS ""> selected="selected"</cfif>>Any</option>
					<cfloop query="hostNames"><option value="#request.firewall.stringCleaner(hostNames.request_host)#"<cfif hostNames.request_host IS url.host> selected="selected"</cfif>>#XmlFormat(Left(hostNames.request_host, 30))#</option></cfloop>
				</select>
			</cfif>
			<label for="ip">IP:</label>
			<input type="text" name="ip" id="ip" class="input-mini" value="#ReReplace(url.ip, "[^0-9a-zA-Z:.]", "", "ALL")#" />
	
			<label for="script_name">URI:</label>
			<input type="text" name="script_name" class="input-mini" id="script_name" value="#request.firewall.stringCleaner(url.script_name)#" />
			
			<input type="submit" class="btn btn-small" value="Filter Logs" />
		</form> 
	</cfoutput>
	</div>
	<br />
</cfif>