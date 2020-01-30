<cfcomponent name="CFLogLogger" extends="BaseLogger" hint="Logs to filesystem using the cflog tag.">
	<cfset variables.log_file = "foundeo_firewall">
	
	<cffunction name="logRequest" returntype="void" access="public">
		<cfargument name="level" type="numeric" required="true">
		<cfargument name="filter" type="any" hint="a Filter object">
		<cfargument name="type" default="inspectRequest" type="variablename">
		<cfargument name="message" type="string" default="">
		<cfargument name="detail" type="string" default="">
		<cfset var logtype = "Information">
		<cfset var text = "[#arguments.level#] " & cgi.REMOTE_ADDR & " " & filter.getName() & " (filterID:#arguments.filter.getFilterID()#) - ">
		<cfif filter.blockEnabled() AND arguments.level GTE filter.getBlockLevel()>
			<cfset logtype = "fatal">
			<cfset text = text & "Blocked ">
		<cfelseif filter.filterEnabled() AND arguments.level GTE filter.getFilterLevel()>
			<cfset logtype = "warning">
			<cfset text = text & "Filtered ">
		<cfelseif arguments.type IS "error">
			<cfset logtype = "error">
		<cfelse>
			<cfset logtype = "Information">
		</cfif>
		<cfset text = text & arguments.type &  " - " & cgi.request_method & " " & cgi.script_name>
		<cfif Len(cgi.query_string)>
			<cfset text = text & "?" & cgi.query_string>
		</cfif>
		<cfset text = text & " : " & filter.getRequestLogMessage()>
		<cfif isVerbose()>
			<cfset text = text & " : " & filter.getRequestLogMessageDetail()>
		</cfif>
		<cfset text = Replace(text, Chr(10), "\n", "ALL")>
		<cfset text = Replace(text, Chr(13), "\r", "ALL")>
		<cflog application="true" file="#variables.log_file#" text="#text#" type="#logtype#">
	</cffunction>
	
	<cffunction name="setLogFileName" returntype="void" output="false" hint="Sets the log file name. Default value is foundeo_firewall, which will log to the CF server logs/foundeo_firewall.log">
		<cfargument name="file_name" required="true" hint="No file extension is required.">
		<cfset variables.log_file = arguments.file_name>
	</cffunction>
	
	<cffunction name="isViewable" returntype="boolean" hint="If the log is viewable such as a file or DB return true, if not (email, or IM) return false.">
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getStorageDescription" returntype="string" output="false" hint="Returns a description of where the data is stored, eg datasource name.">
		<cfreturn variables.log_file & ".log">
	</cffunction>
	
</cfcomponent>