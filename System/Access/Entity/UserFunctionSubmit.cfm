

<cfparam name="form.clean"        default="0">
<cfparam name="form.grouponly"    default="0">
<cfparam name="form.accountgroup" default="">
<cfparam name="form.mission"      default="">
<cfparam name="form.profileid"    default="">

<!--- apply profile : 

1. clean existing (usergroup) access of this user : remove membership and remove userAuthorization of the user through users
2. apply usergroup and sync access for usergroup

--->

<!--- save the functions --->

<cftransaction>

<cfquery name="clean" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		DELETE FROM MissionProfileUser
		WHERE  UserAccount = '#url.id#'
		AND    ProfileId IN (SELECT ProfileId 
		                     FROM   MissionProfile 
							 WHERE  Mission = '#Form.Mission#')		
</cfquery>	

<cfloop index="itm" list="#form.profileid#">
	
	<cfquery name="insert" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
				INSERT INTO MissionProfileUser
				(ProfileId, UserAccount, OfficerUserId, OfficerLastName, OfficerFirstName)
				VALUES
				('#itm#','#url.id#','#session.acc#','#session.last#','#session.first#')
	</cfquery>

</cfloop>

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
	
		<cfloop query="Membership">
		
		     <!--- remove usergroup memebership --->
			 
			 
			 <!--- clean access --->
		
			<cfoutput>
				<cfsavecontent variable="condition">Source = '#source#'</cfsavecontent>
			</cfoutput>
		
			<!--- also log the removal of this group --->
		
			<cfinvoke component="Service.Access.AccessLog"  
				  method             = "DeleteAccess"
				  Logging            = "1"				  
				  ActionStep         = "Purge User group"
				  ActionStatus       = "9"
				  UserAccount        = "#url.id#"
				  Condition          = "#condition#"
				  DeleteCondition    = ""
				  AddDeny            = "0"
				  AddDenyCondition   = "">		
			  
		 </cfloop> 
	
	<cfelse>
	
		<!--- define all manually granted access and remove this for this person --->
	
	</cfif>

</cfif>

<cfloop index="itm" list="#form.AccountGroup#">

	<!--- add usergroup access --->
	
	<cfquery name="Check" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT *
		 FROM   System.dbo.UserNamesGroup
		 WHERE  Account      = '#url.id#'
		 AND    AccountGroup = '#itm#'
	</cfquery>
	
	<cfif check.recordcount eq "0">
	
		<cfquery name="Insert" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO  System.dbo.UserNamesGroup 
			         (Account,
					 AccountGroup,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
		      VALUES ('#URL.id#',
			      	  '#itm#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
		</cfquery>	
		
		<!--- history --->
		
		<cfquery name="check" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				 SELECT *
				 FROM   System.dbo.UserNamesGroupLog 
				 WHERE  Account       = '#url.id#'
				 AND    AccountGroup  = '#itm#' 
				 AND    DateEffective = '#dateformat(now(),client.dateSQL)#'
		</cfquery>
				
		<cfif check.recordcount eq "0">
		
			<cfquery name="InsertLog" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				     INSERT INTO  System.dbo.UserNamesGroupLog 						 
				         (   Account,
							 AccountGroup,
							 DateEffective,
							 ActionStatus,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName
						 ) VALUES 
						 ( '#URL.id#',
				      	   '#itm#',
						   '#dateformat(now(),client.dateSQL)#',
						   '1',
						   '#SESSION.acc#',
				    	   '#SESSION.last#',		  
					  	   '#SESSION.first#' )
			</cfquery>		
		
		</cfif>				
	
		<cfinvoke component= "Service.Access.AccessLog"  
		  method       = "SyncGroup"
		  UserGroup    = "#itm#"
		  UserAccount  = "#URL.id#">	
		  
	  </cfif>	  
					  
</cfloop>		

</cftransaction>	

<script>
	Prosis.busy('no')
</script>		  



