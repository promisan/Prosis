
<cf_systemscript>

<cfparam name="Form.Account" default="''">

<cfif Form.Operation eq "Remove"> 

    <cfquery name="Select" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   UserNames
		WHERE  Account     IN (#PreserveSingleQuotes(FORM.Account)#) 
	</cfquery>		
	
	<cfquery name="ClearGroup" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM UserNamesGroup
		WHERE  Account     IN (#PreserveSingleQuotes(FORM.Account)#) 
		OR     AccountGroup IN (#PreserveSingleQuotes(FORM.Account)#) 
	</cfquery>		
	
	<cfloop query="Select">
	
		<cfinvoke component="Service.Access.AccessLog"  
				  method="DeleteAccessAll"
				  UserAccount = "#Account#">	
				  
		<!--- sync the group as well --->
		
		<cfif AccountType eq "Group">
		
			<cfquery name="ClearGroup" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM OrganizationAuthorizationDeny
					WHERE  UserAccount = '#Account#' OR Source = '#Account#' 
			</cfquery>		
				 
		   	<cfinvoke component="Service.Access.AccessLog" method="SyncGroup"
				  UserGroup    = "#Account#"
				  UserAccount  = ""
				  Role         = "">	
		  
		</cfif>  
		
		<cfif SESSION.isAdministrator eq "Yes">
					
			<cfquery name="Get" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   UserNames
				WHERE  Account = '#Account#' 
			</cfquery>		
			
			<cftransaction>
			
				<cfquery name="Insert" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO Log_UserNames
					(Account,PersonNo,LastName,FirstName,OfficerAction,OfficerUserId,OfficerLastName,OfficerFirstName)
					VALUES 
					('#Account#','#get.PersonNo#','#get.LastName#','#get.FirstName#','Deleted','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
				</cfquery>				
				
				<cfquery name="DeleteUser" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE    UserNames
					WHERE     Account = '#Account#' 
				</cfquery>	
			
			</cftransaction>	
				
		<cfelse>
		
			<cfif disabled eq "0">
		
				<cfquery name="DeleteUser" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE    UserNames
					SET       Disabled = 1, 
					          DisabledModified = getDate()
					WHERE     Account = '#Account#' 
				</cfquery>	
				
				<cfquery name="Log" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				INSERT INTO UserNamesLog						
					  (Account,
					   ActionField,
					   FieldValueFrom,
					   FieldValueTo,
					   OfficerUserId,
					   OfficerLastName,
					   OfficerFirstName)				   
				VALUES (
					 '#Account#',
					 'Disabled',
					 '1',
					 '0',				
					 '#SESSION.acc#',
					 '#SESSION.last#',
					 '#SESSION.first#')					 
				</cfquery>		
				 	 
			</cfif>		  
		
		</cfif>
				  
	</cfloop>			 
 
</cfif>   

<cfoutput>
	<script language="JavaScript">
	   ptoken.location("UserResult.cfm?idmenu=#URL.IDMenu#&IDSorting=#Form.Group#&Page=#Form.page#")
	 </script>
</cfoutput>



