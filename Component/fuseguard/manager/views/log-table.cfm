<cfparam name="thisTag.ExecutionMode" default="invalid">
<cfif thisTag.ExecutionMode IS "start">
	<cfparam name="attributes.logs" type="query">
	<cfparam name="attributes.page" type="integer" default="1">
	<cfparam name="attributes.nextpage" type="string" default="false">
	<cfparam name="attributes.prevpage" type="string" default="false">
	
	<cfset logs = attributes.logs>
	
	<cfif logs.recordcount>
		
		<table class="logs" border="0" cellspacing="0" width="100%">
			<tr>
				<th>Level</th>
				<th>Message</th>
				<th>Filter</th>
				<th>Date</th>
			</tr>
			<cfoutput query="logs">
				<cfset odd = logs.currentrow MOD 2>
				<tr class="row#odd#">
					<td class="level"><div class="level level#Int(logs.threat_level)#">#logs.threat_level#</div></td>
					<td class="msg"><a href="#request.urlBuilder.createDynamicURL('log-detail', 'id=#URLEncodedFormat(logs.id)#')#" title="View Details"><cfif Len(logs.message)>#request.firewall.stringCleaner(logs.message)#<cfelse><em>None</em></cfif></a></td>
					<td class="cat">#request.firewall.stringCleaner(logs.filter_name)#</td>
					<td class="request_date">
						<cfif url.day EQ 0>
							#DateFormat(logs.request_date, "mmm dd")# <small>at</small> #TimeFormat(logs.request_date, "h:mm tt")#
						<cfelse>
							#TimeFormat(logs.request_date, "h:mm:ss tt")#
						</cfif>
					</td>
				</tr>
			</cfoutput>
		</table>
		<ul class="pager">
			<cfif Len(attributes.prevPage)>
	  			<li class="previous">
	    			<cfoutput><a href="#attributes.prevPage#">&larr; Previous</a></cfoutput>
	  			</li>
			<cfelse>
				<li class="previous disabled">
    				<a href="#">&larr; Previous</a>
  				</li>
			</cfif>
			<cfif Len(attributes.nextpage)>
	  			<li class="next">
	    			<cfoutput><a href="#attributes.nextPage#">Next &rarr;</a></cfoutput>
	  			</li>
			<cfelse>
				<li class="next disabled">
	    			<a href="#">Next &rarr;</a>
	  			</li>
			</cfif>
		</ul>
		
		
	<cfelse>
		<div class="alert">Sorry, no <cfif attributes.page GT 1>additional</cfif> log entries have been logged matching this criteria.</div>
		<p><a href="#" class="btn backbtn"><i class="icon-chevron-left"></i> Go Back</a></p>
	</cfif>
	
	
	
</cfif>