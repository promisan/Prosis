<cfparam name="url.action" default="">

<cfif url.action eq "new">

	<cftransaction>
	
		<cfquery name="Check" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     UserRequest
				WHERE    RequestId = '#Form.RequestId#'						
		</cfquery>
		
		<cfif check.recordcount eq "0">
					
		<cfquery name="Last" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   TOP 1 *
				FROM     UserRequest
				WHERE    Owner = '#Form.Owner#'		
				ORDER BY RequestNo DESC
		</cfquery>
		
		<cfif last.recordcount eq "0">
		
			<cfset la = 1>
			<cfset ref = "#Form.Owner#000#la#">
			
		<cfelse>
		
			<cfset la = last.requestno+1>
		
			<cfif len(la) eq "1">
				<cfset ref = "#Form.Owner#000#la#">
			<cfelseif len(la) eq "2">
			    <cfset ref = "#Form.Owner#00#la#">
			<cfelseif len(la) eq "3">
			    <cfset ref = "#Form.Owner#0#la#">
			<cfelse>
			    <cfset ref = "#Form.Owner#0#la#">	
			</cfif>
		
		</CFIF>
		
		<cfquery name="InsertRequest" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			INSERT INTO UserRequest	(	
				   RequestId,
			       Reference,
				   Mission,
			       Owner,
				   RequestNo,
			       Application,
			       RequestName,
				   MailAddress,
			       RequestMemo,
			       ActionStatus, 
			       OfficerUserId, 
			       OfficerLastName, 
			       OfficerFirstName, 
				   Created )
			VALUES(	'#Form.RequestId#',
					'#ref#',
					'#Form.Mission#',
					'#Form.Owner#',
					'#la#',
					'#Form.Workgroup#',
					'#Form.RequestName#',
					'#Form.eMail#',
					'#Form.RequestMemo#',
					0,
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#',
					getdate() )		
				  	
		</cfquery>
		
		<cfloop list="#Form.user#" index="account" delimiters=",">
		
			<cfquery name="InsertRequestNames" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			
					INSERT INTO UserRequestNames(
							RequestId, 
				      		Account, 
				      		OfficerUserId, 
				      		OfficerLastName, 
				      		OfficerFirstName)
					VALUES(	'#Form.RequestId#',
							'#account#',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#')
			
			</cfquery>
		
		</cfloop>
		
		<cfparam name="Form.SystemRole" default="">
		
		<cfloop list="#Form.SystemRole#" index="role" delimiters=",">
		
			<cfquery name="InsertRequestAccess" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				INSERT INTO UserRequestAccess (
				  RequestId,
			      Mission,
 			      <!--- OrgUnit, --->
			      Role,
			      ClassParameter,
			      GroupParameter,
			      AccessLevel,
			      OfficerUserId,
			      OfficerLastName,
			      OfficerFirstName)
				 VALUES (
				 	'#Form.RequestId#',
					'#Form.Mission#',
					<!--- '#Form.OrgUnit#', --->
					'#role#',
					'',
					'',
					'',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#' )
			
			</cfquery>
		
		</cfloop>
		
		<cfparam name="Form.AccountGroup" default="">
		
		<cfloop list="#Form.AccountGroup#" index="group" delimiters=",">
		
			<cfquery name="InsertRequestUserGroup" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					INSERT INTO UserRequestUserGroup(
						 RequestId,
						 AccountGroup,
		      	         OfficerUserId,
			             OfficerLastName, 
			             OfficerFirstName )
					VALUES(
						'#Form.RequestId#',
						'#group#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
					
			</cfquery>
			
		</cfloop>
		
		<cfparam name="Form.Portal" default="">
		
		<cfloop list="#Form.Portal#" index="portal" delimiters=",">
		
				<cfquery name="InsertRequestModule" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			
			 		INSERT INTO UserRequestModule (
						RequestId, 
						SystemFunctionId,
			      		OfficerUserId,
			      		OfficerLastName, 
			      		OfficerFirstName)
					
					VALUES(
						'#Form.RequestId#',
						'#portal#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#') 
			  
				</cfquery>
		
		</cfloop> 
		
		</cfif>
		
	</cftransaction>

<cfelseif url.action eq "edit">	

	<cftransaction>
		
		<cfquery name="CleanAccount" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE 
				FROM   UserRequestNames
				WHERE  RequestId = '#Form.RequestId#'
		</cfquery>
		
		<cfloop list="#Form.user#" index="account" delimiters=",">
		
		    <cftry>
			
			<cfquery name="InsertRequestNames" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			
					INSERT INTO UserRequestNames(
						RequestId, 
			      		Account, 
			      		OfficerUserId, 
			      		OfficerLastName, 
			      		OfficerFirstName
					)
					VALUES(
						'#Form.RequestId#',
						'#account#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
			
			</cfquery>
			
			<cfcatch></cfcatch>
			
			</cftry>
		
		</cfloop>
		
		<cfquery name="update" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE UserRequest
				SET    RequestMemo  = '#Form.RequestMemo#', 
				       MailAddress  = '#Form.eMail#',
					   Application  = '#Form.Workgroup#',
					   Mission		= '#Form.Mission#'
				WHERE  RequestId    = '#Form.RequestId#'
		</cfquery>		
		
		<cfquery name="CleanAccess" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE
				FROM   UserRequestAccess
				WHERE  RequestId = '#Form.RequestId#'
		</cfquery>
		
		<cfloop list="#Form.SystemRole#" index="role" delimiters=",">
		
			<cfquery name="InsertRequestAccess" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			
				INSERT INTO UserRequestAccess (
					  RequestId,
				      Mission,
					  <!---
				      OrgUnit,
					  --->
				      Role,
				      ClassParameter,
				      GroupParameter,
				      AccessLevel,
				      OfficerUserId,
				      OfficerLastName,
				      OfficerFirstName )
				 VALUES(				 
					 	'#Form.RequestId#',
						'#Form.Mission#',
						<!---
						'#Form.OrgUnit#',
						--->
						'#role#',
						'',
						'',
						'',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#' )
			
			</cfquery>
		
		</cfloop>
		
		<cfquery name="CleanGroups" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE	FROM UserRequestUserGroup
				WHERE   RequestId = '#Form.RequestId#'
		</cfquery>
		
		<cfloop list="#Form.AccountGroup#" index="group" delimiters=",">
		
			<cfquery name="InsertRequestUserGroup" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					INSERT INTO UserRequestUserGroup(
						 RequestId,
						 AccountGroup,
		      	         OfficerUserId,
			             OfficerLastName, 
			             OfficerFirstName)
					VALUES(
						'#Form.RequestId#',
						'#group#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
					
			</cfquery>
			
		</cfloop>
		
		<cfquery name="CleanPortal" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE	FROM    UserRequestModule
				WHERE   RequestId = '#Form.RequestId#'
		</cfquery>		
		
		<cfloop list="#Form.Portal#" index="portal" delimiters=",">
		
				<cfquery name="InsertRequestModule" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			
			 		INSERT INTO UserRequestModule (
						RequestId, 
						SystemFunctionId,
			      		OfficerUserId,
			      		OfficerLastName, 
			      		OfficerFirstName)
					
					VALUES(
						'#Form.RequestId#',
						'#portal#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#') 
			  
				</cfquery>
		
		</cfloop> 
		
	</cftransaction>
	
<cfelseif url.action eq "purge">	

	<cfquery name="update" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM UserRequest				
				WHERE  RequestId    = '#Form.RequestId#' 
		</cfquery>		

</cfif>

<!--- establish the workflow object --->

<cfif url.action eq "new">
	
	<cfset link = "System/AccessRequest/DocumentEntry.cfm?drillid=#Form.RequestId#">
		
	<cf_ActionListing 
			EntityCode       = "AuthRequest"
			EntityGroup      = "#Form.Workgroup#"
			EntityClass      = "Standard"<!--- EditAccess --->
			EntityStatus     = "0"		
			PersonEMail      = "#Form.eMail#"
			ObjectReference  = "Authorization Request #Form.Workgroup# under No #Form.Reference#"
			ObjectReference2 = "#SESSION.first# #SESSION.last#"
			ObjectKey4       = "#Form.RequestId#"
			ObjectURL        = "#link#"
			Show             = "No"
			Toolbar          = "No"
			Framecolor       = "ECF5FF"
			CompleteFirst    = "Yes">	
		
</cfif>		

<cfif url.action eq "purge">	
	
	<cfoutput>
		
		<script>		  
		    try {				
				parent.opener.applyfilter('','','#form.requestid#');
				parent.window.close()
			} catch(e) {}    	
	
	    </script>	
		
	</cfoutput>

<cfelse>

<cfoutput>
	
	<script>	
	      
	    try {				
			parent.opener.applyfilter('','','content');			
		} catch(e) {}    	
		parent.window.location = 'DocumentEntry.cfm?drillid=#Form.RequestId#'

    </script>	
	
</cfoutput>

</cfif>