<cfcomponent>

	<cffunction  
		access      = "public"
		name        = "Authenticate"
		returntype  = "any" 
		displayname = "Authenticate">
			
			<cfargument name = "Account"	type = "string" default = "" required = "Yes">
			<cfargument name = "Pwd" 		type = "string" default = "" required = "Yes">
			<cfargument name = "DeviceId" 	type = "string" default = "" required = "Yes">	
						
			<cfquery name="System" 
				datasource="AppsSystem">
				SELECT  *	
				FROM    Parameter 
			</cfquery>	
			
			<cfquery name="get" 
			    datasource="AppsSystem">
			     SELECT  *
			     FROM    UserNames
			     WHERE   Account     = '#Account#' 	
				 AND     AccountType = 'Individual'
			</cfquery>  
			
			<cfif get.recordcount eq "0">
			
				<cfquery name="get" 
				    datasource="AppsSystem">
				     SELECT *
				     FROM   UserNames
				     WHERE (Account = '#Account#' 		 
						   <cfif System.LogonIndexNo eq "1">					 
						 	   <cfif findNoCase("@",enteredAccount)>		 
							   OR eMailAddress = '#Account#'			   
							   <cfelse>			   
							   OR IndexNo      = '#Account#'			   			   
							   </cfif>						   		 				 
					       </cfif>
						   )						   
					 <cfif System.UserGroupLogon eq "1">
					 <cfelse>
					 AND    AccountType = 'Individual'
					 </cfif>	   		 
			    </cfquery>  	   	
			
			</cfif>		
			
			<cfif get.recordcount eq "1">
			
			     <cfset account = get.Account>	
	
				<cfinvoke component="Service.Authorization.Password"  
					Method       		= "Prosis"
					Account      		= "#Account#"
					Pwd			   		= "#Pwd#"
					returnvariable   	= "searchresult">	
			  
					<cfif SearchResult.recordCount eq 1>
					
						<cfif len(CGI.HTTP_USER_AGENT) gt "200">
							<cfset version = "#left(CGI.HTTP_USER_AGENT,200)#">
						<cfelse>
							<cfset version = "#CGI.HTTP_USER_AGENT#">
						</cfif>		  	  
					
						<cfset host = cgi.http_host>
						
						<cfquery name="Init" 
							datasource="AppsInit">
								SELECT * 
								FROM   Parameter
								WHERE  HostName = '#CGI.HTTP_HOST#'		
						</cfquery>	
						
						<cfquery name="getUserStatus" 
							datasource="AppsSystem">
							
								SELECT 	*
								FROM	UserStatus
								WHERE	Account = '#Account#'
								AND		HostName = '#host#'
								AND		NodeIp = '#CGI.Remote_Addr#'
							
						</cfquery>		
						
						<cfquery name="getUser" 
							datasource="AppsSystem">
								
								SELECT 	*
								FROM	UserNames
								WHERE	Account = '#Account#'
							
						</cfquery>  
						
						<cfif getUserStatus.recordCount eq 0>
						
							<cf_AssignId>
							<cfset SessionId = rowguid>
							
							<cfquery name="insert" 
								datasource="AppsSystem">
									INSERT INTO UserStatus 
									(Account, 
									HostName, 
									NodeIP, 
									ApplicationServer,
									NodeVersion, 		
									HostSessionNo,
									HostSessionId,
									DeviceId,		 
									TemplateGroup,
									ActionTimeStamp, 
									ActionTemplate)
									VALUES 
									('#Account#',
									'#host#', 
									'#CGI.Remote_Addr#', 
									'#init.applicationserver#',
									'#version#', 	
									0,			 
									'#SessionId#',
									'#DeviceId#',
									'Mobile',
									getDate(), 
									'#CGI.SCRIPT_NAME#')
							</cfquery>
						
						<cfelse>
						
							<cfquery name="update" 
								datasource="AppsSystem">
								
								UPDATE	UserStatus
								SET		DeviceId        = '#DeviceId#',
										ActionTimeStamp = getDate(),
										TemplateGroup   = 'Mobile',
										ActionTemplate  = '#CGI.SCRIPT_NAME#'
								WHERE	Account         = '#Account#'
								AND		HostName        = '#host#'
								AND		NodeIp          = '#CGI.Remote_Addr#'
								
							</cfquery>
							
							<cfset SessionId = getUserStatus.HostSessionId>
						
						</cfif>
						
						<cfset vSessionId = SessionId>
						<cfset vAccount = getUser.Account>
						<cfset vName = getUser.FirstName & " " & getUser.LastName>
					
					<cfelse>	  
					
						<cfset vSessionId = "">
						<cfset vAccount   = "">
						<cfset vName      = "">
					
					</cfif> 
					
			<cfelse>
			
					<cfset vSessionId     = "">
					<cfset vAccount       = "">
					<cfset vName          = "">			
			
			</cfif>		
			
			<cfquery name="get"
				datasource="AppsWorkOrder">
					SELECT	'#vSessionId#' AS HostSessionId,
							'#vAccount#'   AS Account,
							'#vName#'      AS Name
			</cfquery>
			
			<cfset data = serializeJSON(get,true)>
			
			<cfreturn data>
			  
	</cffunction>			
	
	<cffunction  
		access      = "public"
		name        = "Verify"
		returntype  = "string" 
		displayname = "Verify">
		
			<cfargument name = "HostSessionId" 		type = "string" default = "" required = "Yes">
			
			<!--- validate license --->
			<cfset License = 0>	
			<cf_licenseCheck mode="Server">
			
			<cfif License eq 1>
				<cfquery name="check" 
					datasource="AppsSystem">
						SELECT TOP 1
								U.*
						FROM    UserNames U
								INNER JOIN UserStatus S
									ON U.Account = S.Account
						WHERE   S.HostSessionId = '#hostSessionId#'	
						AND 	S.ActionExpiration = 0
						
				</cfquery>
				
				<cfif check.recordcount eq 1>
					
					<cfset vReturn = 1>
					<cfset vAccount = check.Account>
					<cfset vName = check.FirstName & " " & check.LastName>
					
					<!--- log activity --->
					<cfquery name="logActivity" 
						datasource="AppsSystem">
							UPDATE	UserStatus
							SET		ActionTimeStamp = getDate(),
									TemplateGroup = 'Mobile',
									ActionTemplate = '#CGI.SCRIPT_NAME#'
							WHERE	HostSessionId = '#hostSessionId#'
					</cfquery>
					
				<cfelse>
					<cfset vReturn = 0>	
					<cfset vAccount = "">
					<cfset vName = "">
				</cfif>
				
			<cfelse>
				<cfset vReturn = -1> <!--- not valid licensing --->
				<cfset vAccount = "">
				<cfset vName = "">			
			</cfif>
						
			<cfquery name="get"
				datasource="AppsWorkOrder">
					SELECT	'#vReturn#' AS Result,
							'#vAccount#' AS Account,
							'#vName#' AS Name
			</cfquery>
			
			<cfset data = serializeJSON(get,true)>
			
			<cfreturn data>	
						
	</cffunction>			
				
				
	<cffunction  
		access      = "public"
		name        = "LogOut"
		returntype  = "string" 
		displayname = "LogOut">
		
		<cfargument name = "HostSessionId" 		type = "string" default = "" required = "Yes">
		
		<cfquery name="check" 
			datasource="AppsSystem">
				SELECT * 
				FROM UserStatus 
				WHERE  HostSessionId   = '#HostSessionId#' 
		</cfquery>
		
		<cfif check.recordcount eq 1>
		
			<cfquery name="delete" 
				datasource="AppsSystem">
					DELETE UserStatus 
					WHERE  HostSessionId   = '#HostSessionId#' 
			</cfquery>
			<cfset vReturn = 1>
			
		<cfelse>
		
			<cfset vReturn = 0>	
			
		</cfif>	
		
		<cfquery name="get"
			datasource="AppsWorkOrder">
				SELECT	'#vReturn#' AS Result
		</cfquery>
		
		<cfset data = serializeJSON(get,true)>
		
		<cfreturn data>		
	
	</cffunction>

</cfcomponent>