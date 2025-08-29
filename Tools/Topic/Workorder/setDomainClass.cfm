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
<cfif url.checked neq "">

	<cfif url.checked eq "true">

		<cfquery name="Update" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">				
	    	INSERT INTO Ref_TopicDomainClass 
			 (Code,ServiceDomain,ServiceDomainClass,OfficerUserId,OfficerLastName,OfficerFirstName)
			VALUES (
				'#url.topic#',
				'#url.servicedomain#',
				'#url.servicedomainclass#',
				'#session.acc#',
				'#session.last#',
				'#session.first#' 
				)						
		</cfquery>
		
	<cfelse>
		
		<cfquery name="Delete" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	DELETE  FROM Ref_TopicDomainClass 
			WHERE   Code               = '#url.topic#'
			AND     ServiceDomain      = '#url.servicedomain#'
			AND     ServiceDomainClass = '#url.serviceDomainClass#'
		</cfquery>
		
	</cfif>
	
</cfif>
