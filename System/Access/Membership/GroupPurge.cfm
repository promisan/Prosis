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
<cfparam name="URL.Id" default="cpd">

<cftry>

	<cf_assignId>

	<cftransaction>
	
	<cfquery name = "Group" 
	  datasource = "AppsOrganization" 
	  username   = "#SESSION.login#" 
	  password   = "#SESSION.dbpw#">
	  DELETE FROM System.dbo.UserNamesGroup
	  WHERE  AccountGroup = '#URL.ID#'
	</cfquery>
	
	<cfquery name = "Account" 
	  datasource = "AppsOrganization" 
	  username   = "#SESSION.login#" 
	  password   = "#SESSION.dbpw#">
	  DELETE FROM System.dbo.UserNames
	  WHERE  Account = '#URL.ID#'
	</cfquery>
	
	<cfquery name = "Access2" 
	  datasource = "AppsOrganization" 
	  username   = "#SESSION.login#" 
	  password   = "#SESSION.dbpw#">
	  DELETE FROM OrganizationAuthorizationDeny
	  WHERE  Source = '#URL.ID#'
	</cfquery>
	
	<cfoutput>
		<cfsavecontent variable="condition">
			 Source = '#URL.ID#' OR UserAccount = '#URL.ID#'
		</cfsavecontent>
	</cfoutput>
	
	<!--- also log the removal of this group --->
	
	<cfinvoke component="Service.Access.AccessLog"  
		  method               = "DeleteAccess"
		  Logging              = "1"
		  ActionId             = "#rowguid#"
		  ActionStep           = "Purge User group"
		  ActionStatus         = "9"
		  UserAccount          = "#url.id#"
		  Condition            = "#condition#"
		  DeleteCondition      = ""
		  AddDeny              = "0"
		  AddDenyCondition     = "">			  
		  			
	</cftransaction>
	
	<cfoutput>
	
		<script LANGUAGE = "JavaScript">		     
		     ptoken.navigate('RecordListingResult.cfm?idmenu=#url.idmenu#&search=#url.search#&mission=#url.mission#&application=#url.application#','result')
		</script>	
	
	</cfoutput>

	 <cfcatch>
	     <cf_message message = "Usergroup could not be removed. Please contact your administrator." return = "back">  
		 
		  <script>
			 Prosis.busy('no')		
		 </script>
	 
	 </cfcatch>
	 
	

</cftry>




