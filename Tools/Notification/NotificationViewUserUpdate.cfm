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

	<cfquery name="EventServerUserCheck" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   SystemEventServerUser
		WHERE  EventId = '#url.eventid#'
		AND    HostName  = '#CGI.HTTP_HOST#'
		AND    Account   = '#SESSION.acc#'
	</cfquery>
	
	<cfif EventServerUserCheck.recordcount eq "0">
	
		<cfquery name="EventServerUserInsert" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			INSERT INTO SystemEventServerUser
				(EventId
				,Hostname
				,Account)				
			VALUES (
				'#url.eventid#',
				'#CGI.HTTP_HOST#',
				'#SESSION.acc#')
		</cfquery>
		
	</cfif>
	

