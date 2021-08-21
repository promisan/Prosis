
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




