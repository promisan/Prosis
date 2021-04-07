
<cfparam name="form.clean"     default="0">
<cfparam name="form.grouponly" default="0">

<cfoutput>#now()#</cfoutput>

<!--- apply profile : 

1. clean existing (usergroup) access of this user : remove membership and remove userAuthorization of the user through users
2. apply usergroup and sync access for usergroup

--->

<!--- save the functions --->

<!--- save the selected accountgroups --->

<cfif form.clean eq "1">

	<cfquery name="Membership" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			SELECT DISTINCT Source
			FROM   OrganizationAuthorization
			WHERE  UserAccount = '#url.id#'
	</cfquery>	

	<!--- define all groups this person has access to and remove access from those groups --->
	
	<cfif form.grouponly eq "1">
	
		<cfloop query="Member">
		
			<cfoutput>
				<cfsavecontent variable="condition">Source = '#source#'</cfsavecontent>
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
			  
		 </cfloop> 
	
	<cfelse>
	
		<!--- define all manually granted access and remove this for this person --->
	
	</cfif>

</cfif>

<cfloop index="group" list="#form.AccountGroup#">

	<cfinvoke component= "Service.Access.AccessLog"  
		  method       = "SyncGroup"
		  UserGroup    = "#group#"
		  UserAccount  = "#URL.id#">	
					  
</cfloop>					  



