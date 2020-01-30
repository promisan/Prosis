<cfparam name="thisTag.ExecutionMode" default="invalid">
<cfif thisTag.ExecutionMode IS "start">
	<cfparam name="attributes.log" type="query">
	<cfparam name="attributes.priors" type="integer" default="0">
	<cfset log = attributes.log>
	<cfset xss = request.firewall.stringCleaner>
	<cfif log.recordcount>
		<cfoutput>
		<table class="logDetail" border="0" cellspacing="0">
			<tr>
				<td class="prop">Request Date:</td>
				<td class="val">#DateFormat(log.request_date, "dddd mmmm d, yyyy")# <small>at</small> #TimeFormat(log.request_date, "h:mm:ss tt")#</td>
			</tr>
			<tr>
				<td class="prop">IP Address:</td>
				<td class="val"><a href="#request.urlBuilder.createDynamicURL('log', 'ip=#URLEncodedFormat(log.ip_address)#')#" title="Click to view Log">#xss(log.ip_address)#</a> <cfif attributes.priors GT 1>(<em>This IP has been logged #attributes.priors# times</em>)</cfif></td>
			</tr>
			<tr>
				<td class="prop">Threat Level:</td>
				<td class="val"><div class="level level#Val(log.threat_level)#">#Val(log.threat_level)#</div></td>
			</tr>
			<tr>
				<td class="prop">Blocked:</td>
				<td class="val"><cfif IsBoolean(log.blocked) AND log.blocked>Yes<cfelse>No</cfif></td>
			</tr>
			<tr>
				<td class="prop">Log Message:</td>
				<td class="val">#xss(log.message)#</td>
			</tr>
			<tr>
				<td class="prop">Log Detail: </td>
				<td class="val">#xss(log.detail)#&nbsp;</td>
			</tr>
			<tr>
				<td class="prop">User Agent:</td>
				<td class="val">#xss(log.user_agent)#</td>
			</tr>
			<tr>
				<td class="prop">Host:</td>
				<td class="val">#xss(log.request_host)#<cfif log.request_port NEQ 80>:#Val(log.request_port)#</cfif></td>
			</tr>
			<tr>
				<td class="prop">Script Name:</td>
				<td class="val"><a href="#request.urlBuilder.createDynamicURL('log', 'script_name=#URLEncodedFormat(log.script_name)#')#">#xss(log.script_name)#</a></td>
			</tr>
			<tr>
				<td class="prop">Query String:</td>
				<td class="val">#xss(log.query_string)#</td>
			</tr>
			<tr>
				<td class="prop">HTTPS:</td>
				<td class="val">#YesNoFormat(IsBoolean(log.request_https) AND log.request_https)#</td>
			</tr>
			<tr>
				<td class="prop">HTTP Referer:</td>
				<td class="val">#xss(log.http_referer)#</td>
			</tr>
			<tr>
				<td class="prop">Filter:</td>
				<td class="val">#xss(log.filter_name)# (#log.filter_component#)</td>
			</tr>
			<tr>
				<td class="prop">Filter Instance:</td>
				<td class="val">#xss(log.filter_instance)#</td>
			</tr>
			<tr>
				<td class="prop">Threat Category:</td>
				<td class="val">#xss(log.threat_category)#</td>
			</tr>
		</table>
		</cfoutput>
	<cfelse>
		<p>Sorry you passed an inavlid or incomplete id.
	</cfif>
</cfif>