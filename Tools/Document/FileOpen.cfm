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

<cftry>
	<cfquery name="Last" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT max(serialNo) as last 
			FROM   AttachmentLog
			WHERE 	AttachmentId = '#url.Id#'								
	</cfquery>
	
	<cfif Last.recordcount eq "0">
	
		<cfquery name="LogAction" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO AttachmentLog
						(AttachmentId,
						 SerialNo, 
						 FileAction, 			
						 OfficerUserid, 
						 OfficerLastName, 
						 OfficerFirstName)
					VALUES
						('#url.id#',
						 '0',
						 'Open',			
						 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#')
		</cfquery>	
	
	<cfelse>

		<cfquery name="LogAction" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO AttachmentLog
						(AttachmentId,
						 SerialNo, 
						 FileAction, 			
						 OfficerUserid, 
						 OfficerLastName, 
						 OfficerFirstName)
					VALUES
						('#url.id#',
						 '#last.last+1#',
						 'Open',			
						 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#')
		</cfquery>	
	
	</cfif>
	
<cfcatch></cfcatch>	
</cftry>



