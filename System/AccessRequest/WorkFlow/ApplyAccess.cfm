
<cfparam     name= "Object.ObjectKeyValue4"        default="">

<cfset requestId =  Object.ObjectKeyValue4>

<cfquery name="Account" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT * 
	FROM   UserRequestNames 
    WHERE  RequestId = '#requestId#'

</cfquery>

<cfquery name="Group" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT * 
	FROM   UserRequestUserGroup
	WHERE  RequestId = '#requestId#'

</cfquery>

<cfquery name="Portal" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT * 
	FROM   UserRequestModule
	WHERE  RequestId = '#requestId#'

</cfquery>


<cfloop query="Account">

	<!--- 0. Make sure account is enabled --->
	<cfquery name="EnableAccount" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		UPDATE UserNames
		SET    Disabled = 0
		WHERE  Account = '#Account.Account#'
		
	</cfquery>

	<!--- 1. UserGroup access --->

	<cfloop query="Group">
				
		<cfquery name="Check" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			     SELECT *
				 FROM UserNamesGroup
				 WHERE Account    = '#Account.Account#'
				 AND AccountGroup = '#Group.AccountGroup#'
		</cfquery>
		
		<cfif Check.recordCount eq "0">
								
			<cfquery name="Insert" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO UserNamesGroup 
			         (Account,
					 AccountGroup,
					 RequestId,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
					 
			      VALUES ('#Account.Account#',
			      	  '#Group.AccountGroup#',
					  '#requestId#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
			</cfquery>				
			
			<cfquery name="check" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT *
				 FROM   UserNamesGroupLog 
				 WHERE  Account       = '#Account.Account#'
				 AND    AccountGroup  = '#Group.AccountGroup#' 
				 AND    DateEffective = '#dateformat(now(),client.dateSQL)#'
			</cfquery>
			
			<cfif check.recordcount eq "0">
			
				<cfquery name="InsertLog" 
				     datasource="AppsSystem" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     INSERT INTO UserNamesGroupLog 
						 
					         (   Account,
								 AccountGroup,
								 DateEffective,
								 ActionStatus,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName
							 )
							 
					      VALUES 
						  
						     ('#Account.Account#',
					      	  '#Group.AccountGroup#',
							  '#dateformat(now(),client.dateSQL)#',
							  '1',
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#')
				</cfquery>		
			
			</cfif>	
									
			<cfinvoke component= "Service.Access.AccessLog"  
				  method       = "SyncGroup"
				  UserGroup    = "#Group.AccountGroup#"
				  UserAccount  = "#Account.Account#"
				  Role         = "">	
			 				
		</cfif>	 
										 			  				
	</cfloop>

	<!--- 2. Portal access --->	
	<cfloop query="Portal">

		<cfquery name="validate" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 	SELECT	*
				FROM	UserModule
				WHERE	SystemFunctionId = '#Portal.SystemFunctionId#'
				AND		Account = '#Account.Account#'
		</cfquery>
		
		<cfif validate.recordcount eq 0>
		
			<cfquery name="insert" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 	INSERT INTO UserModule
						(
							Account,
							SystemFunctionId,
							RequestId,
							OrderListing,
							Status
						)
					VALUES
						(
							'#Account.Account#',
							'#Portal.SystemFunctionId#',
							'#requestId#',
							0,
							'1'
						)
			</cfquery>

		<cfelse>
				
			<cfquery name="update" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 	UPDATE 	UserModule
					SET		Status = '1', 
							RequestId = '#requestId#'
					WHERE	SystemFunctionId = '#Portal.SystemFunctionId#'
					AND		Account = '#Account.Account#'
			</cfquery>
		
		</cfif>
	
	</cfloop>
	
</cfloop>
