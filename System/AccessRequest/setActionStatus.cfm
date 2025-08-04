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

<!--- set status to cancelled --->

<cfquery name="get" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * FROM  UserRequest			
			WHERE    RequestId = '#url.requestid#'		
	</cfquery>	

<cfif url.value eq "false">
			
	<cfquery name="Last" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE   UserRequest
			SET      ActionStatus = '9'
			WHERE    RequestId = '#url.requestid#'		
	</cfquery>
	
	<cfset link = "System/AccessRequest/DocumentEntry.cfm?drillid=#url.requestid#">
			
	<cf_ActionListing 
		EntityCode       = "AuthRequest"		
		EntityClass      = "Standard"
		EntityStatus     = "0"					
		ObjectReference  = "Authorization Request #get.Application# under No #get.Reference#"
		ObjectReference2 = "#get.OfficerFirstName# #get.OfficerLastName#"
		ObjectKey4       = "#url.RequestId#"
		ObjectURL        = "#link#"
		Show             = "No"		
		CompleteCurrent  = "Yes">	
		
<cfelse>

	<cfquery name="Last" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE   UserRequest
			SET      ActionStatus = '0'
			WHERE    RequestId = '#url.requestid#'		
	</cfquery>
	
	<cfset link = "System/AccessRequest/DocumentEntry.cfm?drillid=#url.requestid#">
		
	<cf_ActionListing 
		EntityCode       = "AuthRequest"		
		EntityClass      = "Standard"
		EntityStatus     = "0"					
		ObjectReference  = "Authorization Request #get.Application# under No #get.Reference#"
		ObjectReference2 = "#get.OfficerFirstName# #get.OfficerLastName#"
		ObjectKey4       = "#url.RequestId#"
		ObjectURL        = "#link#"
		CompleteFirst    = "Yes"
		HideCurrent      = "Enforce"   <!--- closed and creates a new one --->
		Show             = "No">	
		
</cfif>

