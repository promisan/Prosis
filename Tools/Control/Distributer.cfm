
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