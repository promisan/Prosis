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
						 	   <cfif findNoCase("@",Account)>		 
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

	<cffunction  
		access      = "public"
		name        = "PasswordChange"
		returntype  = "numeric" 
		displayname = "PasswordChange">

		<cfargument name = "Account" 	type = "string" 	default = ""  	required = "Yes">
		<cfargument name = "OldPwd" 	type = "string" 	default = ""  	required = "Yes">
		<cfargument name = "Pwd1" 		type = "string" 	default = ""  	required = "Yes">
		<cfargument name = "Pwd2" 		type = "string" 	default = ""  	required = "Yes">
		<cfargument name = "MinLength"	type = "numeric" 	default = "8" 	required = "No">
		<cfargument name = "SendMail"	type = "string" 	default = "Yes" required = "Yes">
		<cfargument name = "Welcome"	type = "string" 	default = ""  	required = "No">
		<cfargument name = "Root"		type = "string" 	default = ""  	required = "No">

		<!--- 
		all ok:  password changed 
		<cfset vReturn = 1>

		error: account does not exist
		<cfset vReturn = 2>

		error: old password does not match
		<cfset vReturn = 3>

		error: new/confirm not the same
		<cfset vReturn = 4>

		error: old password and new password are the same
		<cfset vReturn = 5>

		error: new password too short
		<cfset vReturn = 6>
		--->

		<cfquery name="VerifyUser" 
			datasource="AppsSystem">
				SELECT   * 
				FROM    UserNames
				WHERE   Account = '#Account#' 
		</cfquery>

		<cfif VerifyUser.recordCount eq 0>

			<!--- error: account does not exist --->
			<cfset vReturn = 2>

		<cfelse>

			<cfif len(VerifyUser.Password) gt 20> 
				<!--- encrypt password --->
				<cf_encrypt text = "#OldPwd#">
				<cfset vPassword  = EncryptedText>
				<!--- end encryption --->
			<cfelse>	  
				<cfset vPassword  = OldPwd>
			</cfif>	  

			<cfquery name="VerifyPwd" 
				datasource="AppsSystem">
					SELECT   * 
					FROM    UserNames
					WHERE   Account = '#Account#'
					AND     Password = '#vPassword#'
			</cfquery> 

			<cfif VerifyPwd.recordCount eq 0>
		
				<!--- error: old password does not match --->
				<cfset vReturn = 3>

			<cfelse>

				<cfif Pwd1 neq Pwd2>

					<!--- error: new/confirm not the same --->
					<cfset vReturn = 4>

				<cfelse>

					<cfif Pwd1 eq OldPwd>
						
						<!--- error: old password and new password are the same --->
						<cfset vReturn = 5>

					<cfelse>

						<cfif len(Pwd1) lt MinLength>

							<!--- error: new password too short --->
							<cfset vReturn = 6>

						<cfelse>
					
							<!--- all good now --->

							<cf_encrypt text = "#Pwd1#">
							<cfset vNewPassword = EncryptedText>	
				
							<cfquery name="LogPassword" 
								datasource="AppsSystem">
									INSERT INTO UserPasswordLog 
											(Account, Password, PasswordExpiration)
									VALUES  ('#Account#', '#VerifyPwd.Password#', GETDATE())
							</cfquery>  
				
							<cfquery name="UpdateUser" 
								datasource="AppsSystem">
									UPDATE	UserNames 
									SET		Password           = '#vNewPassword#',
											PasswordResetForce = '0',
											PasswordModified   = GETDATE()
									WHERE 	Account            = '#Account#'
							</cfquery>		
				
							<cfif SendMail eq "Yes" OR SendMail eq "1">
								<!--- send email notification --->			
								<cf_MailPasswordChangeConfirmation 
									acc="#Account#" 
									welcome="#Welcome#"
									root="#Root#">
							</cfif>

							<!--- all ok:  password changed --->
							<cfset vReturn = 1>

						</cfif>

					</cfif>

				</cfif>

			</cfif>  

		</cfif>

		<cfreturn vReturn>

	</cffunction>

</cfcomponent>