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
<cfquery name="get"
datasource="AppsSystem">
	SELECT  * 
	FROM    UserStatus	
	WHERE   UserStatusId  = '#URL.ID#'		
</cfquery>

<cfif get.recordcount gte "1">

	<cfquery name="Drill" datasource="AppsSystem">
		UPDATE  UserStatus
		SET     ActionExpiration = 1
		WHERE   UserStatusId  = '#URL.ID#'
	</cfquery>
	
	<cfset tracker = CreateObject("java", "coldfusion.runtime.SessionTracker")>
	<cfset sessions = tracker.getSessionCollection(application.applicationName)>
	
	<cftry>	
	
    	<cfset targetSession = sessions[ application.applicationName & '_' & get.HostSessionId]>
		    
	    <cfset StructClear(targetSession)>	
	
		<cfcatch>
		
			<script>
				alert('Session information was not found on this server and could not be terminated')
			</script>
		
		</cfcatch>
	
	</cftry>
		
	
	<cfoutput>
	
	<script>
	    applyfilter('1','','#url.id#')
		// $('tr[name*=#url.box#_#url.id#]') .each(function() { this.remove(); }); 
		// alert('Session has been terminated')
	</script>
	
	</cfoutput>

</cfif>

