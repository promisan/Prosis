
<!--- 
   Name : /Component/Process/System/SystemError.cfc
   Description : Validation Functions  
   1.1.  TagSystemError
   1.2.  ...
   1.3.  ...
   1.4.  ...    
---> 

<cfcomponent>
	
    <cfproperty name="name" type="string">
    <cfset this.name = "CFRS Session Controller">
	<cfset VARIABLES.Instance.USR_MID = "_user" />
	<cfset VARIABLES.Instance.SES_MID = "_session" />

	<cffunction name="GetHash" access="public" returntype="string">
		
			<cfset vInit = now()>
			<cfset ts = DateFormat(vInit,"DDMMYYYY")&TimeFormat(vInit,"hhmmss")>						
	   		<cfset key    = SESSION.acc & "h@mesweeth@ome" & ts>
			<cfset hash   = Hash(key & VARIABLES.Instance.USR_MID, "SHA")>
			<cfreturn hash>	
				
	</cffunction>	

	<cffunction name="Hashit" access="public" returntype="boolean">
	
		<cfargument name = "vInit" type="date" required="true"  default="0">	 
		<cfargument name = "mid"   type="string" required="true" default = "000000000000000000000000">		
		<cfargument name = "pmode" type="string" required="true" default = "">
		
			<cfset dp = DateFormat(vInit,"DDMMYYYY")>		
			<cfset Match = FALSE>
			
			<cfloop from="0" to = "10" index = "i">
			
				<!--- going back 10 seconds backwards --->
				
				<cfset vPast   = DateAdd('s', -1*i, vInit)>
				<cfset tp     = TimeFormat(vPast,"hhmmss")>				
				<cfset vTry   = dp & tp>
				
		   		<cfset key    = SESSION.acc & "h@mesweeth@ome" & vTry>
				<cfset hash   = Hash(key & ARGUMENTS.pmode, "SHA")>
								
				<cfif hash eq mid>
				    
					<cfset Match = TRUE>
					<cfbreak>
				</cfif>
				
			</cfloop>					
					
			<cfreturn Match>	
				
	</cffunction>
	
	<cffunction name="RecordSessionTemplate"
        access="public"
        returntype="string"
        displayname="Record session">
				
		<cfargument name="ActionTemplate"    type="string"   required="true">		
		<cfargument name="ActionQueryString" type="string"   required="true">
		<cfargument name="Force"             type="string"   required="true"    default="No">
		<cfargument name="hash"              type="string"   required="true"    default = "000000000000000000000000">	
		<cfargument name="AccessValidate"    type="string"   required="true"    default="No">	
		<cfargument name="Redirect"          type="string"   required="yes"     default="No">
		<cfargument name="AccessRevoke"      type="string"   required="true"    default="No">	
		<cfargument name="AccessMessage"     type="string"   required="true"    default="Yes">	
				
		<cfquery name="param" 
			datasource="AppsInit">
				SELECT  * 
				FROM    Parameter
				WHERE   HostName           = '#CGI.http_host#'				
		</cfquery>		
		
		<cfif param.URLProtectionMode eq "0">	
				    
			<!--- we always allow for this as the CSFR is disabled --->	
		    <cfset force = "Yes">
			
		</cfif>	
				
		 <!--- check if request is a trusted request --->
		<cfset vInit = now()>
						
		<cfif len(ActionTemplate) gte 200>
			 <cfset tmp = left(ActionTemplate,200)>
		<cfelse>
			 <cfset tmp = ActionTemplate>
		</cfif> 
			
		<cfif FindNoCase("&mid=",ActionQueryString)>
		    <cfset vPos   = FindNoCase("&mid=",ActionQueryString)>
			<cfset str    = Left(ActionQueryString,vPos-1)>
		<cfelseif FindNoCase("?mid=",ActionQueryString)>		
		    <cfset vPos   = FindNoCase("?mid=",ActionQueryString)>
			<cfset str    = Left(ActionQueryString,vPos-1)>	
		<cfelse>
    		<cfset str    = ActionQueryString>
		</cfif>		
			
		<cfif len(str) gte 200>
			 <cfset str = left(str,200)>		
		</cfif> 	
				
		<!--- check if already exists for this user --->	
		
		<cftransaction isolation="READ_UNCOMMITTED">
		
			<cfquery name="get" 
				datasource="AppsSystem">				
					SELECT  * 
					FROM    UserStatusController
					WHERE   Account            = '#SESSION.acc#'
					AND     HostName           = '#CGI.http_host#'
					AND     HostSessionId      = '#SESSION.SessionId#'         				
					AND     ActionTemplate     = '#tmp#'
					AND     ActionQueryString  = '#str#'  									
			</cfquery>	
		
		</cftransaction>
														
		<cfif get.recordcount eq "0" or get.Operational eq "0">		
								
			<!--- validate the hash --->
						
			<cfset Match_USR = hashit(vInit,hash,VARIABLES.Instance.USR_MID)>			
				
			<cfif NOT Match_USR>
				 <cfset Match_SES = hashit(vInit,hash,VARIABLES.Instance.SES_MID)>
			<cfelse>
				 <cfset Match_SES = FALSE>	 
			</cfif>		

			<cf_gethost>	
													
			<cfif Match_USR or Match_SES or force eq "Yes">		
																						
					<cfquery name="getUser" 
						datasource="AppsSystem">
							SELECT * 
							FROM  UserStatus
							WHERE Account       = '#SESSION.acc#'
							AND   HostName      = '#host#'
							AND   HostSessionId = '#Session.SessionId#'
					</cfquery>		
					
					<cfif len(CGI.HTTP_USER_AGENT) gte 200>
					    <cfset bws = left(CGI.HTTP_USER_AGENT,200)>
					<cfelse>
					    <cfset bws = CGI.HTTP_USER_AGENT>
					</cfif> 
						
					<cfif getUser.recordcount eq "0" and session.acc neq "">
															
						<cfquery name="insert" 
							datasource="AppsSystem">
							INSERT INTO UserStatus 
									(Account, 
									 HostName, 
									 HostSessionId,
									 NodeIP, 
									 NodeVersion, 									 
									 TemplateGroup,
									 ActionTimeStamp, 
									 ActionTemplate)
							VALUES
									('#SESSION.acc#',
									 '#host#', 
									 '#Session.SessionId#',
									 '#CGI.Remote_Addr#', 
									 '#bws#', 									 
									 'Process',
									 getDate(), 
									 '#tmp#')
							</cfquery>							
					
					</cfif>		
															
					<cfif session.acc neq "">
					
						<cfif get.recordcount eq "0">
																							
								<cftry>
													
									<cfquery name="addRecord" 
										datasource="AppsSystem">
											INSERT INTO UserStatusController
											(Account,
											 HostName,
											 HostSessionId,									 
											 ActionTemplate,
											 ActionQueryString,
											 Operational)
										VALUES	
										   ( '#SESSION.acc#',
											 '#CGI.http_host#',									
											 '#Session.SessionId#',
											 '#tmp#',
											 '#str#',
											 '1')		
											 								
									</cfquery>		
									
								<cfcatch></cfcatch>
									
								</cftry>	
								
						<cfelse>
						
							<cfquery name="get" 
								datasource="AppsSystem">
									UPDATE  UserStatusController
									SET     Operational = 1
									WHERE   Account            = '#SESSION.acc#'
									AND     HostName           = '#CGI.http_host#'
									AND     HostSessionId      = '#SESSION.SessionId#'         				
									AND     ActionTemplate     = '#tmp#'
									AND     ActionQueryString  = '#str#'  				
							</cfquery>	
												
						</cfif>		
						
					</cfif>	
					
					<cfif Match_SES or param.URLProtectionMode eq "2">						
					    <!--- we enforce that access is revoked --->
						<cfset AccessRevoke = "Yes">
					</cfif>					
				
			</cfif>	
								
			<cfif AccessValidate eq "Yes" and (session.acc neq "" or hash eq "999")>
						
				<cfif param.URLProtectionMode eq "2">						
					    <!--- we enforce that access is revoked --->
						<cfset AccessRevoke = "Yes">
				</cfif>		
								
				<cfinvoke component  = "Service.Process.System.UserController"  
				   	method               = "ValidateFunctionAccess"  			
					ActionTemplate       = "#CGI.SCRIPT_NAME#"
					ActionQueryString    = "#CGI.QUERY_STRING#"
					AccessRevoke         = "#AccessRevoke#"
					AccessMessage        = "#AccessMessage#"
					Redirect             = "#redirect#"
					returnvariable       = "AccessRight">	
															
			<cfelse>
						
				<cfset accessRight = "GRANTED">								
								
			</cfif>			
			
		<cfelse>
		
			<cfif AccessValidate eq "Yes">
			
				<cfif param.URLProtectionMode eq "2">						
					    <!--- we enforce that access is revoked --->
						<cfset AccessRevoke = "Yes">
				</cfif>		
													
				<cfinvoke component  = "Service.Process.System.UserController"  
				   	method               = "ValidateFunctionAccess"  			
					ActionTemplate       = "#CGI.SCRIPT_NAME#"
					ActionQueryString    = "#CGI.QUERY_STRING#"
					AccessRevoke         = "#AccessRevoke#"
					AccessMessage        = "#AccessMessage#"
					returnvariable       = "AccessRight"
					Redirect             = "#redirect#">	
										
			<cfelse>
			
				<cfset accessRight = "GRANTED">						
								
			</cfif>
									
		</cfif>			
		
		<cfreturn AccessRight>	
		
	</cffunction>	
		
	<cffunction name="ValidateFunctionAccess" access="public" 
	     returntype="string" displayname="Verify Function Session Access to control CSRF" output="yes">
			
		<cfargument name="ActionTemplate"    type="string" required="true">
		<cfargument name="ActionQueryString" type="string" required="true">		
		<cfargument name="Redirect"          type="string" required="no"  default="No">
		<cfargument name="AccessRevoke"      type="string" required="yes" default="No">
		<cfargument name="AccessMessage"     type="string" required="yes" default="Yes">
									
		<cfquery name="param" 
			datasource="AppsInit">
				SELECT  * 
				FROM    Parameter
				WHERE   HostName = '#CGI.http_host#'				
		</cfquery>		
						
		<cfif param.URLProtectionMode eq "0">		
		
			<CFSET AccessRight = "GRANTED">	
									
		<cfelse>
				   			
			<!--- check if request is a trusted request --->
		
			<cfif len(ActionTemplate) gte 200>
				 <cfset tmp = left(ActionTemplate,200)>
			<cfelse>
				 <cfset tmp = ActionTemplate>
			</cfif> 
			
			<cfif FindNoCase("&mid=",ActionQueryString)>
			    <cfset vPos   = FindNoCase("&mid=",ActionQueryString)>
				<cfset str    = Left(ActionQueryString,vPos-1)>
			<cfelseif FindNoCase("?mid=",ActionQueryString)>
			    <cfset vPos   = FindNoCase("?mid=",ActionQueryString)>
				<cfset str    = Left(ActionQueryString,vPos-1)>
			<cfelse>
    			<cfset str    = ActionQueryString>
			</cfif>		
							
			<cfif len(str) gte 200>
				 <cfset str = left(str,200)>			
			</cfif> 
					
			<cfquery name="checkAccess" 
			datasource="AppsSystem">
				 SELECT * 
				 FROM   UserStatusController
				 <cfif session.acc eq "">
				 WHERE  HostSessionId = '#Session.sessionid#'				
				 <cfelse>
				 WHERE  Account = '#SESSION.acc#'
				 AND    HostSessionId = '#Session.sessionid#'
				 </cfif>
				 AND    ActionTemplate     = '#tmp#'
				 AND    ActionQueryString  = '#str#'  
				 AND    Operational        = '1'   						 	
			</cfquery>		
																	
			<cfif checkAccess.RecordCount eq "0">
					          
				  <CFSET AccessRight = "DENIED">
				  				  
		    <cfelse>
			
				<!--- function to remove this access so it can not be reloaded --->
							
				<cfif AccessRevoke eq "Yes">
				
				    <cfquery name="revertLoad" 
					datasource="AppsSystem">
						 UPDATE UserStatusController
						 SET    Operational        = '0'
						 WHERE  Account            = '#SESSION.acc#'						 
						 AND    ActionTemplate     = '#tmp#'					 
						 AND    ActionQueryString  = '#str#'  										 
					</cfquery>										
			
				</cfif>
			
		        <CFSET AccessRight = "GRANTED">
				
			</cfif>	  
					
			<cfif AccessMessage eq "Yes">
		
				<cfif AccessRight eq "DENIED">	 
				
					<cfif redirect eq "1">
					
					<!--- we now immediately move to the login screen as people might just click refresh here --->			
		
					<script language="JavaScript">		   		   
		 				window.location = "../default.cfm"
					</script>
					
					<cfelse>
									
				   <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					 <tr><td align="center" height="40" class="labellarge">					 
					   <font size="5" color="FF0000">					   
						   <cf_tl id="Detected an issue with your Authorization to access this function" class="Message">.
					   </font>
						</td>
					 </tr>
				   </table>	
				   <cfabort>
				   
				   </cfif>	
						
				</cfif>		
			
			</cfif>
								
		</cfif>	
			
		<cfreturn AccessRight>
							 
	</cffunction>
	
</cfcomponent>			 