
<cfparam name="url.rule" default="NULL">
<cfparam name="url.owner" default="">
<cfparam name="url.from" default="">
<cfparam name="url.to" default="">
<cfparam name="url.level" default="">

<cftry>

	<cfquery name="Insert" 
			 datasource="AppsSelection"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 
			 UPDATE Ref_StatusCodeProcess
			 
			 SET    RuleCode = <cfif  url.rule neq "NULL"> '#url.rule#' <cfelse> NULL </cfif>
			 WHERE  Owner = '#url.owner#'
			 		AND Status = '#url.from#'
					AND StatusTo = '#url.to#'
					AND AccessLevel = '#url.level#'
				 
	</cfquery>
	
	<font color="0080FF">
		<b>Saved</b>
	</font
	
	<cfoutput>
	<script>
		ColdFusion.navigate('Rule.cfm?level=#url.level#&from=#url.from#&to=#url.to#&owner=#url.owner#&rule=#url.rule#','rule_#url.level#_#url.from#_#url.to#');
	</script>
	</cfoutput>
	
	<cfcatch>
		<font color="FF0000">
				<b>Error</b>
		</font>	
	</cfcatch>
	
</cftry>

<cf_compression>