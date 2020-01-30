
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

	<!--- 1. Revoke group access --->
	<cfloop query="Group">

		<cf_assignId>
		
		<cftransaction action="BEGIN">
		
			<cfquery name="Delete" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     DELETE FROM System.dbo.UserNamesGroup
				 WHERE Account      = '#Account.Account#'
				 AND   AccountGroup = '#Group.AccountGroup#'
				 AND   RequestId    = '#RequestId#'
			</cfquery>
		
			<cfquery name="check" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT *
				 FROM   System.dbo.UserNamesGroupLog 
				 WHERE  Account      = '#Account.Account#'
				 AND    AccountGroup = '#Group.AccountGroup#'
				 AND    DateEffective = '#dateformat(now(),client.dateSQL)#'
			</cfquery>
						
			<cfif check.recordcount eq "1">
			
				<cfquery name="set" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 UPDATE System.dbo.UserNamesGroupLog 
					 SET    ActionStatus = '9'
					 WHERE  Account      = '#Account.Account#'
					 AND    AccountGroup = '#Group.AccountGroup#'
					 AND    DateEffective = '#dateformat(now(),client.dateSQL)#'
			    </cfquery>
			
			<cfelse>
						
				<cfquery name="InsertLog" 
				     datasource="AppsOrganization" 
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
							  '9',
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#')
				</cfquery>		
						
			</cfif>	
		
		<cfoutput>
			<cfsavecontent variable="condition">
				 UserAccount = '#Account.Account#'
				 AND   Source ='#Group.AccountGroup#'
			</cfsavecontent>
		</cfoutput>
		
		<cfinvoke component="Service.Access.AccessLog"  
				  method="DeleteAccess"
				  ActionId             = "#rowguid#"
				  ActionStep           = "1"
				  ActionStatus         = "9"
				  UserAccount          = "#Account.Account#"
				  Condition            = "#condition#"
				  DeleteCondition      = ""
				  AddDeny              = "0"
				  AddDenyCondition     = "">	 
		
		</cftransaction>
		
		<!--- 2. Portal access --->	
		<cfloop query="Portal">
	
			<cfquery name="validate" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 	SELECT	*
					FROM	UserModule
					WHERE	SystemFunctionId = '#Portal.SystemFunctionId#'
					AND		Account          = '#Account.Account#'
					AND     RequestId        = '#RequestId#'
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
								'9'
							)
				</cfquery>
	
			<cfelse>
					
				<cfquery name="update" 
				     datasource="AppsSystem" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 	UPDATE 	UserModule
						SET		Status           = '9'
						WHERE	SystemFunctionId = '#Portal.SystemFunctionId#'
						AND		Account          = '#Account.Account#'
						AND     RequestId        = '#requestId#'
				</cfquery>
			
			</cfif>
		
		</cfloop>
 
 	</cfloop>
 
 </cfloop> 
 
 <!--- 3. Revert Role access --->
 
 <cfinvoke component = "Service.Access.AccessLog"
 		   method    = "RevertAccessRequest"
		   requestId = "#requestId#">
 
 </cfinvoke>