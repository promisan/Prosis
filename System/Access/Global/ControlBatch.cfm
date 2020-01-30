
<cf_screentop html="No" jquery="Yes">

<cfparam name="url.context" default="1">
	
	<cfparam name="Form.Account" default="''">
	
	<!--- positions --->
		
	<cfquery name="User" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
        SELECT * FROM UserNames
		WHERE  Account IN (#PreserveSingleQuotes(FORM.Account)#) 		
	</cfquery>
	
	<cfloop query="User">
	
		<cftransaction>
		
			<cfoutput>
		
			<cfsavecontent variable="condition">
				UserAccount = '#account#' AND Role    = '#URL.ID4#'
			</cfsavecontent>
			
			<cfsavecontent variable="conditiongroup">
				Source = '#account#' AND Role = '#URL.ID4#'
			</cfsavecontent>
			
			</cfoutput>
			
			<cf_assignid>			
						
			<cfinvoke component="Service.Access.AccessLog"  
				  method               = "DeleteAccess"
				  Logging              = "1" 
				  ActionId             = "#rowguid#"
				  ActionStep           = "Batch role removal"
				  ActionStatus         = "9"
				  UserAccount          = "#Account#"
				  Condition            = "#condition#"
				  ConditionGroup       = "#conditionGroup#"
				  DeleteCondition      = ""
				  AddDeny              = "1"
				  AddDenyCondition     = "Source != 'Manual'">	
								 
			<cfif AccountType eq "Group">   
			 
			 	 <!--- ----------------------- --->
				 <!--- sync access to memmbers --->
				 <!--- ----------------------- --->			
		
				 <cfinvoke component="Service.Access.AccessLog"  
					  method       = "SyncGroup"
					  UserGroup    = "#account#"
					  UserAccount  = ""
					  Role         = "#URL.ID4#">	 		   
			
			</cfif>		 
			
		</cftransaction>
		  
	</cfloop>	  
	 
	<cfoutput>	  
	  
	<script language="JavaScript">	    
		ptoken.location("OrganizationListing.cfm?context=#url.context#&ID0=#URL.ID#&ID4=#URL.ID4#")
	</script>
	
	</cfoutput>
 


