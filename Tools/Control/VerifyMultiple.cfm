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

<cfparam name="SESSION.acc" default="Public">

<cf_getHost host="#cgi.http_host#">

<!--- check session --->
<cfquery name="CheckLogon" 
datasource="AppsSystem">
	SELECT *
	FROM   UserStatus S
	WHERE  Account       = '#SESSION.acc#'
	AND    HostName      = '#host#'  	
	AND    HostSessionId = '#SESSION.Sessionid#'	
</cfquery>

<!--- check session --->
<cfquery name="get" 
datasource="AppsSystem">
	SELECT *
	FROM   UserNames
	WHERE  Account   = '#SESSION.acc#' 
</cfquery>

<cfif CheckLogon.actionExpiration eq "0">

    <!--- perform the check on multiple clients --->

	<cfif SESSION.acc eq "Batch" or SESSION.acc eq "Public">
	
		<!--- exclude --->
	
	<cfelse>
			
		<cfparam name="CLIENT.Timeout" default="30">
		<cfparam name="CLIENT.MultipleLogon" default="1">
				
		<cfif get.AllowMultipleLogon eq "0" and getAdministrator("*") eq "0"> 
					
			<cfset tm = DateAdd("n", "-#CLIENT.Timeout#", "#now()#")>
				
			<!--- verify entry --->
			<cfquery name="CheckLogon" 
			datasource="AppsSystem">
				SELECT *
				FROM   UserStatus S
				WHERE  Account     = '#SESSION.acc#' 
				AND    HostName    = '#host#' 
				AND    HostSessionId  != '#SESSION.Sessionid#'
				AND    ActionExpiration = 0
				AND    ActionTimeStamp > #tm# 
			</cfquery>
			
			<cfif CheckLogon.recordcount gte "1">
			
			   <cfoutput>
					
				   <cfquery name="expire" 
					datasource="AppsSystem">
					    UPDATE UserStatus 
						SET    ActionExpiration = 1
						WHERE  Account       = '#SESSION.acc#' 
						AND    HostName       = '#host#' 
						AND    HostSessionId  != '#SESSION.Sessionid#'
						AND    ActionTimeStamp > #tm# 
				   </cfquery>
				   
				   <cfset CLIENT.multiple = "1">	
														
				   <script language="JavaScript">
				        alert("You were already logged on node: #CheckLogon.NodeIP#. You are not allowed to logon simultaneously, your other session has expired.")
				   </script>
				  			   
			   </cfoutput>   
			
			</cfif>
		
		</cfif>
		
	</cfif>	

</cfif>