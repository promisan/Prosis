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
<cfparam name="url.scope" default="">

<cfif url.scope eq "Portal">

	<cfquery name="delete" 
	 datasource="AppsSystem">
		DELETE UserStatus 
		WHERE  Account   = '#SESSION.acc#' 
		AND    HostName  = '#url.host#' 
		AND    NodeIP    = '#CGI.Remote_Addr#' 
	</cfquery>
		
	<!--- removing all client variables --->
	
	<cfloop list="#getClientVariablesList()#" index="var">
	
		<cfif var neq "acc" and var neq "logon" and var neq "indexno" and var neq "mission" and var neq "languageid" and var neq "lanPrefix">
		 <cfset deleteClientVariable(var)>
		</cfif>
		
	</cfloop>
	
	<cfset SESSION.authent = "0">
	<cfset vLogOut = StructClear(SESSION)>	
	
	<script language="JavaScript1.2">
		window.location.reload();
	</script>
	
<cfelse>

	<cfset host = "#SESSION.root#/Portal/SelfService/LogonAjax.cfm?link=#url.link#">
	
	<cfquery name="delete" 
	 datasource="AppsSystem">
		DELETE UserStatus 
		WHERE  Account   = '#SESSION.acc#' 
		AND    HostName  = '#host#' 
		AND    NodeIP    = '#CGI.Remote_Addr#' 
	</cfquery>	
	
	<!--- removing all client variables --->
	
	<cfloop list="#getClientVariablesList()#" index="var">
	
		<cfif var neq "acc" and var neq "logon"  and var neq "indexno">
		 <cfset deleteClientVariable(var)>
		</cfif>
		
	</cfloop>
	
	<cfset SESSION.authent = "0">
	<cfset vLogOut = StructClear(SESSION)>	
	
	<cfoutput>
	   <script language="JavaScript1.2">
		   ColdFusion.navigate('#host#','detailcontent')
	  </script>
	</cfoutput>

</cfif>

