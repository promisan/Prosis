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

<!---
	1. Check if the host is QA 
	2. If it is, make sure that it can see its own code
	3. Check if there are other servers to where the master can deploy
--->

<cfoutput>

<cftry>
           
	<cfset master = 0>
	
	<cfset vHost = CGI.HTTP_HOST>
	
	<cfquery name="Site" datasource="AppsControl">
		SELECT * 
		FROM   ParameterSite R
		WHERE  ServerRole = 'QA'
		AND    Operational = 1
		AND    ApplicationServer = '#vHost#'
	</cfquery>
	
	
	<cfif Site.recordcount eq 1>
		
		<!--- Check if master can see its own code --->
		<cfif Site.ReplicaPath neq "" and DirectoryExists(Site.ReplicaPath)>
		
			<!--- check if there are other servers to where the master can deploy --->
			<cfquery name="qServer" datasource="AppsControl">
				SELECT * 
				FROM   ParameterSite R
				WHERE  ServerRole != 'QA'
				AND    Operational = 1    
			</cfquery>
			
			<cfloop query="qServer">   
				<cfif ReplicaPath neq "" and  DirectoryExists(ReplicaPath)>                                                               
					<cfset master = 1>                                                                                                                         
					<cfbreak>
				</cfif>                  
			</cfloop>
		
		</cfif>
		
	</cfif>

	<cfset Caller.Master = master>

<cfcatch>

	<cfset Caller.master = 0>
                
</cfcatch>

</cftry> 

</cfoutput>