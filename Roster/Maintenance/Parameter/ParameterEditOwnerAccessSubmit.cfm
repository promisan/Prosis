<!--
    Copyright © 2025 Promisan B.V.

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
<cfif url.checked eq "true">

	<cftry>
	
		<cfquery name="Insert" 
			 datasource="AppsSelection"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 INSERT INTO Ref_StatusCodeProcess (
						 	Owner,
							Id,
							Status,
							StatusTo,
							Role,
							Process,
							AccessLevel,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName )
				 VALUES   ('#url.owner#',
						   'Fun',
						   '#url.from#',
						   '#url.to#',
						   'RosterClear',
						   'Process',
						   '#url.level#',
						   '#SESSION.acc#',
						   '#SESSION.last#',
						   '#SESSION.first#'
						  )
		</cfquery>
	
		<font color="0080FF">
			<b>Saved</b>
		</font>
	
		<cfcatch>
			<font color="FF0000">
				<b>Error</b>
			</font>	
		</cfcatch>
	</cftry>

<cfelseif url.checked eq "false">

	<cftry>
	
		<cfquery name="delete" 
			 datasource="AppsSelection"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 DELETE
				 FROM 		Ref_StatusCodeProcess
				 WHERE		Owner = '#url.owner#'
				 AND		Id = 'Fun'
				 AND		Role = 'RosterClear'
				 AND		Process = 'Process'
				 AND		AccessLevel = '#url.level#'
				 AND		Status = '#url.from#'
				 AND		StatusTo = '#url.to#'
		</cfquery>
	
		<font color="0080FF">
			<b>Saved</b>
		</font>
	
		<cfcatch>
			<font color="FF0000">
				<b>Error</b>
			</font>	
		</cfcatch>
	</cftry>

</cfif>

<cfparam name="url.owner" default="">

<cfif url.owner neq "">
	
	<cfoutput>
	<script>
	   	 try {
		  opener.authorizationrefresh('#url.owner#')
		  } catch(e) {}		
	</script>
	</cfoutput>		

	<cfsilent>
		<cfoutput>
			<cf_logpoint filename="RosterOwnerAccessLog.txt" mode="append">
				[#session.acc#] owner: #url.owner# - level: #url.level# - from: #url.from# - to: #url.to# - check: #url.checked#
			</cf_logpoint>
		</cfoutput>
	</cfsilent>
	
</cfif>

<cf_compression>