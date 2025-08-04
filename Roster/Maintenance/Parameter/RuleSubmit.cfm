<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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
		ptoken.navigate('Rule.cfm?level=#url.level#&from=#url.from#&to=#url.to#&owner=#url.owner#&rule=#url.rule#','rule_#url.level#_#url.from#_#url.to#');
	</script>
	</cfoutput>
	
	<cfcatch>
		<font color="FF0000">
				<b>Error</b>
		</font>	
	</cfcatch>
	
</cftry>

