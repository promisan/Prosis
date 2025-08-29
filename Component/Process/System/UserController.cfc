<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
	
	<cfparam name="SESSION.authent" default="0">
	<cfset VARIABLES.Instance.USR_MID = "_user" />
	<cfset VARIABLES.Instance.SES_MID = "_session" />
	<cffunction name="GetHash" access="public" returntype="string"  secureJSON = "yes" verifyClient = "yes">
		
			<cfset vInit = now()>
			<cfset ts = DateFormat(vInit,"DDMMYYYY")&TimeFormat(vInit,"hhmmss")>						
	   		<cfset key    = SESSION.acc & "h@mesweeth@ome" & ts>
			<cfset hash   = Hash(key & VARIABLES.Instance.USR_MID, "SHA")>
			<cfreturn hash>	
				
	</cffunction>	
	
	<cffunction name="GetMid" access="remote" returnFormat="json" output="false"  secureJSON = "yes" verifyClient = "yes">
	
		<cfif SESSION.authent eq 1>
			<cfset vInit = now()>
			<cfset ts = DateFormat(vInit,"DDMMYYYY")&TimeFormat(vInit,"hhmmss")>						
	   		<cfset key    = SESSION.acc & "h@mesweeth@ome" & ts>
			<cfset hash   = Hash(key & VARIABLES.Instance.USR_MID, "SHA")>
			<cfreturn hash>		
		</cfif>
	</cffunction>

	<cffunction name="Hashit" access="public" returntype="boolean" >
	
		<cfargument name = "vInit" type="date" required="true"  default="0">	 
		<cfargument name = "mid"   type="string" required="true" default = "000000000000000000000000">		
		<cfargument name = "pmode" type="string" required="true" default = "">
					
			<cfquery name="param" 
			datasource="AppsInit">
				SELECT  * 
				FROM    Parameter
				WHERE   HostName           = '#CGI.http_host#'				
		    </cfquery>	
		
			<cfset dp = DateFormat(vInit,"DDMMYYYY")>		
			<cfset Match = FALSE>
			
			<cfloop from="0" to = "#param.MIDThreshold#" index = "i">
			
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
			<cfset str    = "">	
		<cfelseif FindNoCase("mid=",ActionQueryString)>				    
			<cfset str    = "">		
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
			
						
			<cfif get.recordcount eq "0" and findNoCase("submit.cfm",tmp) eq "0">
			
			    <!--- NEW additionally we check if the SAME user/session has this link 
				  matched in length which qualifies for now as well
				  as we have in cfdiv the issue of the {mission} not to fire an M yet : Dev 19/5/2020 --->
				  		
			
				<cfquery name="check" 
					datasource="AppsSystem">				
						SELECT  * 
						FROM    UserStatusController
						WHERE   Account                = '#SESSION.acc#'
						AND     HostName               = '#CGI.http_host#'
						AND     HostSessionId          = '#SESSION.SessionId#'         				
						AND     ActionTemplate         = '#tmp#'
						AND     LEFT(ActionQueryString,20) = '#left(str,20)#'  <!--- same contained by length --->					
									
				</cfquery>	
				
				<!--- Dev temp measure : an almost match qualifies for a fresh link to be given --->
				
				<cfif check.recordcount gte "1">
				
					<cfinvoke component    = "Service.Process.System.UserController"  
					   	method             = "GetHash"
						returnvariable     = "hash">	
								
				</cfif>				
						
			</cfif>
		
		</cftransaction>
				
		<!--- link NOT found for user / session or no longer valid --->
																			
		<cfif get.recordcount eq "0" or get.Operational eq "0">	
							  
			<!---	
				 then we validate the passed Hash is authentic and valid			 
				 then we record the link OR activate the link (operational)			 
				 and THEN we check the link for access again 
			--->				
						
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
								
									<cf_assignId>
													
									<cfquery name="addRecord" 
										datasource="AppsSystem">
											INSERT INTO UserStatusController
											(ControllerLinkId,
											 Account,
											 HostName,
											 HostSessionId,									 
											 ActionTemplate,
											 ActionQueryString,		
											 ControllerMID,									 
											 Operational)
										VALUES	
										   ( '#rowguid#',
										     '#SESSION.acc#',
											 '#CGI.http_host#',									
											 '#Session.SessionId#',
											 '#tmp#',											 
											 '#str#',
											 '#hash#','1')		
											 								
									</cfquery>										
									
								<cfcatch></cfcatch>
									
								</cftry>	
								
						<cfelse>
						
							<!--- we enable the link for this purpose again --->
						
							<cfquery name="get" 
								datasource="AppsSystem">
									UPDATE  UserStatusController
									SET     ControllerMID = '#hash#',
									        Operational   = 1,
											Created       = getDate()
									WHERE   ControllerLinkId = '#get.ControllerLinkId#'									
									
							</cfquery>	
												
						</cfif>		
						
					</cfif>	
					
					<cfif Match_SES or param.URLProtectionMode eq "2">						
					    <!--- we enforce that access is revoked --->
						<cfset AccessRevoke = "Yes">
					</cfif>					
				
			</cfif>	
					    								
			<cfif AccessValidate eq "Yes" and (session.acc neq "" or hash eq "999")>
						
				<cfif param.URLProtectionMode eq "2"  or findNoCase("submit.cfm",tmp)>						
					 <!--- we enforce that access is revoked --->
					 <cfset AccessRevoke = "Yes">
				</cfif>		
																
				<cfinvoke component        = "Service.Process.System.UserController"  
					   	method             = "ValidateFunctionAccess"  			
						ActionTemplate     = "#CGI.SCRIPT_NAME#"
						ActionQueryString  = "#CGI.QUERY_STRING#"
						AccessRevoke       = "#AccessRevoke#"
						AccessMessage      = "#AccessMessage#"
						Hash               = "#hash#"
						Redirect           = "#redirect#"
						returnvariable     = "AccessRight">	
																				
			<cfelse>
											
				<cfset accessRight = "GRANTED">								
								
			</cfif>			
			
		<cfelse>
		
		
			<!--- A MATCH was found for this user  --->
									
				<cfif param.URLProtectionMode eq "2" or findNoCase("submit.cfm",get.actiontemplate)>		
								
				    <!--- we enforce that access is revoked 
					so it can be accessed as hyperlink only with
					MID  --->
					
						
					<cfquery name="get" 
						datasource="AppsSystem">
							UPDATE  UserStatusController
							SET     Operational = 0
							WHERE   ControllerLinkId = '#get.ControllerLinkId#'									
					</cfquery>	
					
				</cfif>		
				
				<!---
																	
				<cfinvoke component  = "Service.Process.System.UserController"  
				   	method               = "ValidateFunctionAccess"  			
					ActionTemplate       = "#CGI.SCRIPT_NAME#"
					ActionQueryString    = "#CGI.QUERY_STRING#"
					AccessRevoke         = "#AccessRevoke#"
					AccessMessage        = "#AccessMessage#"
					returnvariable       = "AccessRight"
					Redirect             = "#redirect#">	
					
					--->
					
				<cfset accessRight = "GRANTED">									
			
									
		</cfif>			
		
		<cfreturn AccessRight>	
		
	</cffunction>	
		
	<cffunction name="ValidateFunctionAccess" access="public" 
	     returntype="string" displayname="Verify Function Session Access to control CSRF" output="yes">
			
		<cfargument name="ActionTemplate"    type="string" required="true">
		<cfargument name="ActionQueryString" type="string" required="true">		
		<cfargument name="Datasource"        type="string" required="no" default="appsSystem">		
		<cfargument name="Redirect"          type="string" required="no"  default="No">
		<cfargument name="AccessRevoke"      type="string" required="yes" default="No">
		<cfargument name="AccessMessage"     type="string" required="yes" default="Yes">
									
		<cfquery name="param" 
			datasource="#datasource#">
				SELECT  * 
				FROM    Parameter.dbo.Parameter
				WHERE   HostName = '#CGI.http_host#'				
		</cfquery>		
								
		<cfif param.URLProtectionMode eq "0">
			
			<CFSET AccessRight = "GRANTED">	
									
		<cfelse>
						   			
			<!--- remove the MID --->
			
			<CFSET AccessRight = "DENIED">
		
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
				<cfset str    = "">
			<cfelseif FindNoCase("mid=",ActionQueryString)>		
			    <cfset vPos   = FindNoCase("mid=",ActionQueryString)>
				<cfset str    = "">			
			<cfelse>
    			<cfset str    = ActionQueryString>
			</cfif>		
							
			<cfif len(str) gte 200>
				 <cfset str = left(str,200)>			
			</cfif> 
					
			<cfquery name="checkAccess" 
			datasource="#datasource#">
				 SELECT * 
				 FROM   System.dbo.UserStatusController
				 <cfif session.acc eq "">
				 WHERE  HostSessionId  = '#Session.sessionid#'				
				 <cfelse>
				 WHERE  Account        = '#SESSION.acc#'
				 AND    HostSessionId  = '#Session.sessionid#'
				 </cfif>
				 AND    ActionTemplate     = '#tmp#'
				 AND    ActionQueryString  = '#str#'  
				 AND    Operational        = '1'
			</cfquery>
						
			<!--- added : no book mark disalbed but maybe the same MID + time --->
						
			<cfif checkAccess.recordcount eq "0" 
			    and param.URLProtectionMode eq "2" 
				and not findNoCase("submit.cfm",tmp)>
							
				<!--- we verify check if this user has maybe the same MID --->
				
				<cfif len(hash) gt "40">				
					<cfset hash = left(hash,40)>
				</cfif>
								
				<cfquery name="checkMID" 
				datasource="#datasource#">
					 SELECT TOP 1 * 
					 FROM   System.dbo.UserStatusController
					 <cfif session.acc eq "">
					 WHERE  HostSessionId  = '#Session.sessionid#'				
					 <cfelse>
					 WHERE  Account        = '#SESSION.acc#'
					 -- AND    HostSessionId  = '#Session.sessionid#'
					 </cfif>
					 AND    ActionTemplate     = '#tmp#'
					 -- AND    ActionQueryString  = '#str#'  
					 AND    ControllerMID      = '#hash#'	
					 ORDER BY Created DESC				 
				</cfquery>
								
				<cfif checkMID.recordcount gte "1">				
																
				      <cfset min = datediff("m",checkMID.created,now())>
					 				   
				      <cfif min lte "30">
					  				   
				          <!--- we grant access --->
				          <CFSET AccessRight = "GRANTED">						 
												
				      </cfif>	
					  
				</cfif>	  				
						
			</cfif>				
																													
			<cfif checkAccess.RecordCount eq "0" and accessRight eq "DENIED">
																	          
				  <CFSET AccessRight = "DENIED">
				  				  				  
		    <cfelse>
									
				<!--- function to remove this access so it can not be reloaded --->
												
			    <cfquery name="revertLoad" 
					datasource="#datasource#">
						 UPDATE System.dbo.UserStatusController
						 SET    Created            = getDate(),
						        ControllerMID      = '#hash#'
								<cfif AccessRevoke eq "Yes">
						        ,Operational        = '0'	
								</cfif>					        
						 WHERE  Account            = '#SESSION.acc#'						 
						 AND    ActionTemplate     = '#tmp#'					 
						 AND    ActionQueryString  = '#str#'  										 
				</cfquery>	
									
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
									
					   <table width="100%" height="100%" align="center">
						 <tr><td align="center" class="labellarge" style="color:ff0000;font-size:18px;padding-top:10px">					 						   				   
							   <cf_tl id="Authorization to access function is denied" class="Message">.				   
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
	
	<cffunction name="ValidateCFCAccess" access="public" 
	     returntype="string" displayname="Verify CFC Access to control CSRF" output="yes">
		 
		 	<cfargument name="sessionid"        type="string" required="true">
			<cfargument name="account"          type="string" required="true">				
			<cfargument name="defaultDSAuth"   	type="string" required="false" default="0">	
			<cfargument name="datasource"       type="string" default="AppsOrganization" required="yes">		
			
			<cfset vUserName = "">
			<cfset vPwd = "">
			<cfif defaultDSAuth eq "0">
				<cfset vUserName = SESSION.login>
				<cfset vPwd = SESSION.dbpw>
			</cfif>		
			
			<cfquery name="param" 
			datasource="#datasource#" username="#vUserName#" password="#vPwd#">
				SELECT  * 
				FROM    Parameter.dbo.Parameter
				WHERE   HostName = '#CGI.http_host#'				
		    </cfquery>		
								
		    <cfif param.URLProtectionMode neq "0">
		 		 	
			    <cfparam name="url.mid"           default="">
			
				<cfif not findNoCase("default.cfm",CGI.SCRIPT_NAME) 
					 and not findNoCase("actionview.cfm",CGI.SCRIPT_NAME)
					 and not findNoCase("public.cfm",CGI.SCRIPT_NAME)
					 and not findNoCase("errorrequest.cfm",CGI.SCRIPT_NAME)
					 and not findNoCase("error.cfm",CGI.SCRIPT_NAME)
					 and not findNoCase("selectFormContainer.cfm",CGI.SCRIPT_NAME)
					 and not findNoCase("mainmenuopen.cfm",CGI.SCRIPT_NAME)>		
					 
					<cfset vUserName = "">
					<cfset vPwd = "">
					<cfif defaultDSAuth eq "0">
						<cfset vUserName = SESSION.login>
						<cfset vPwd = SESSION.dbpw>
					</cfif>				
					
					<cfquery name="getmid" 
					  datasource="#datasource#" username="#vUserName#" password="#vPwd#">
				    	SELECT   TOP 1 *
					    FROM     System.dbo.UserStatusController
				    	WHERE    Account       = '#account#' 
						AND      ControllerMID = '#url.mid#'	
						AND      Created > getDate()-1							
					</cfquery>	
					
					<cfif getMid.recordcount eq "1">	
					
						<!--- we pass because this MID has been actively used today --->
					
					<cfelse>
					
						<cfquery name="getactivity" 
						  datasource="#datasource#" username="#vUserName#" password="#vPwd#">
						    	SELECT    TOP 1 *
							    FROM      System.dbo.UserStatusController
						    	WHERE     Account       = '#account#' 
								AND       HostName      = '#CGI.http_host#'
								and       HostSessionId = '#sessionid#'
								ORDER BY  Created DESC
								
						</cfquery>	
					
						<cfif getactivity.recordcount eq "0">
						    
							 <table width="100%" height="100%" align="center">
								 <tr><td align="center" class="labellarge" style="color:ff0000;font-size:18px;padding-top:10px">					 						   				   
									   <cf_tl id="Authorization to access function is revoked-mid" class="Message">.						   
									</td>
								 </tr>
							  </table>	
							  <cfabort>
							  
						<cfelseif getactivity.recordcount eq "1">	  
						
						   <cfset hrs = datediff("h",getactivity.created,now())>
						   
						   <cfif hrs gt "5">
						   
						      <table width="100%" height="100%" align="center">
								 <tr><td align="center" class="labellarge" style="color:ff0000;font-size:18px;padding-top:10px">					 						   				   
									   <cf_tl id="Authorization to access function is revoked" class="Message">.						   
									</td>
								 </tr>
							  </table>	
							  <cfabort>	 
							 
							<cfelse>
							
								<!--- we pass --->  
							  
							</cfif>    		
							
						</cfif>
					
				     </cfif>
									
				</cfif>	 
			
			</cfif>
		 
	</cffunction>	 

</cfcomponent>