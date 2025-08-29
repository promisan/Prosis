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
<cfparam name="SESSION.acc"             default="">	
<cfparam name="CLIENT." default="1">	
<cfparam name="CLIENT.Timeout"         default="30">	
<cfparam name="CLIENT.SessionNo"       default="0">
<cfparam name="CLIENT.DisableTimeOut"  default="0">	

<!--- effort to adjust the host --->

<cf_getHost host="#cgi.http_host#">

<!--- revoke above --->
	
<cfquery name="Logon" 
datasource="AppsSystem">
	SELECT *
	FROM   UserStatus S
	WHERE  Account       = '#SESSION.acc#'  
	AND    HostName      = '#host#' 
	AND    HostSessionId = '#SESSION.SessionId#' 
</cfquery>

<cfparam name="SESSION.acc"             default="">	
<cfparam name="CLIENT.templateLogging" default="1">	
<cfparam name="CLIENT.Timeout"         default="30">	
<cfparam name="CLIENT.SessionNo"       default="0">
<cfparam name="CLIENT.DisableTimeOut"  default="0">	

<!--- effort to adjust the host --->

<cf_getHost host="#cgi.http_host#">

<!--- revoke above --->
	
<cfquery name="Logon" 
datasource="AppsSystem">
	SELECT *
	FROM   UserStatus S
	WHERE  Account       = '#SESSION.acc#'  
	AND    HostName      = '#host#' 
	AND    HostSessionId = '#SESSION.SessionId#' 
</cfquery>

<cfif Logon.recordcount eq "0" and SESSION.acc neq "Anonymous">	
	<cfset SESSION.authent= "0">			
<cfelseif SESSION.acc eq "Anonymous">	

		<cfquery name="sys" 
		datasource="AppsSystem">
			SELECT * FROM Parameter
		</cfquery>

	    <cfset pathname = "">
		<cfset filename = "">
		<cfset group    = "[root]">
		<cfset cnt      = 0>
		
		<cfloop index="itm" list="#CGI.SCRIPT_NAME#" delimiters="/">
		
			<cfif find(".",itm)>
			    <cfset fileName = "#itm#">
			<cfelse>
			    <cfif itm neq "nucleus" and itm neq "Prosis" and itm neq "dw">
				    <cfif itm eq sys.virtualdirectory and cnt eq "0">
						<!--- DO NOTHING --->				
					<cfelse>
					    <cfif pathname eq "">
						<cfset group = itm>
						</cfif>
						<cfset pathname = "#pathname#\#itm#">
					</cfif>
				</cfif>
			</cfif>
			<cfset cnt = cnt+1>
		
		</cfloop>
						
		<cfif pathname eq "">
		     <cfset pathname = "[root]">
		</cfif>
				
		<cftry>		
				
			<cfif len(CGI.HTTP_USER_AGENT) gte 200>
			  <cfset bws = left(CGI.HTTP_USER_AGENT,200)>
			<cfelse>
			  <cfset bws = CGI.HTTP_USER_AGENT>
			</cfif> 
								
			<cfquery name="insert" 
			datasource="AppsSystem">
				INSERT INTO UserStatusLog 
				(Account, 
				 HostName, 
				 NodeIP, 
				 NodeVersion,
				 HostSessionNo, 
				 ActionTimeStamp, 
				 ActionTemplate,
				 ActionQueryString,
				 TemplateGroup,
				 PathName,
				 FileName,				 
				 SystemFunctionId,
				 Mission)
				VALUES 
				('#SESSION.acc#',
				 '#host#',
				 '#CGI.Remote_Addr#', 
				 '#bws#',
				 '#CLIENT.sessionNo#', 
				 getDate(), 
				 '#CGI.SCRIPT_NAME#',
				 '#CGI.QUERY_STRING#',
				 '#group#',
				 '#PathName#',
				 '#FileName#',
				  <cfif Logon.SystemFunctionId neq "">
				 '#Logon.SystemFunctionId#',
				 <cfelse>
				 NULL,
				 </cfif>
				 '#Logon.Mission#'
				)
			</cfquery>
			
			<cfcatch></cfcatch>
		
		</cftry>
				
<cfelse>
	
	<cfquery name="sys" 
		datasource="AppsSystem">
		SELECT * 
		FROM   Parameter
	</cfquery>		

	<cfset diff = DateDiff("n", "#Logon.ActionTimeStamp#", "#now()#")>
	
	<cfset pathname = "">
	<cfset filename = "">
	<cfset group    = "[root]">
	<cfset cnt      = 0>
	
	<cfloop index="itm" list="#CGI.SCRIPT_NAME#" delimiters="/">
		
			<cfif find(".",itm)>
			    <cfset fileName = "#itm#">
			<cfelse>
			    <cfif itm neq "nucleus" and itm neq "Prosis" and itm neq "dw">
				    <cfif itm eq sys.virtualdirectory and cnt eq "0">
						<!--- DO NOTHING --->				
					<cfelse>
					    <cfif pathname eq "">
						<cfset group = itm>
						</cfif>
						<cfset pathname = "#pathname#\#itm#">
					</cfif>
				</cfif>
			</cfif>
			<cfset cnt = cnt+1>
		
	</cfloop>
			  
	<cfif Logon.ActionExpiration eq "1">
	
		<cfquery name="expire" 
		datasource="AppsSystem">
				DELETE FROM UserStatus 
				WHERE  Account       = '#SESSION.acc#' 
				AND    HostName      = '#host#' 
				AND    HostSessionId = '#SESSION.SessionId#' 
		</cfquery>
		
		<!--- end the session because it was done manually --->
		<cfset SESSION.authent= "0">
		
    <cfelseif diff gt CLIENT.Timeout>	
		
	 	<cfif CLIENT.DisableTimeout eq "0">  
							
			<cfquery name="expire" 
			datasource="AppsSystem">
				UPDATE UserStatus 
				SET    ActionExpiration = 1
				WHERE  Account       = '#SESSION.acc#' 
				AND    HostName      = '#host#' 
				AND    HostSessionId = '#SESSION.SessionId#' 
			</cfquery>
		
			<!--- end the session --->
			<cfset SESSION.authent= "0">	
		
		</cfif>  	
	
	<cfelseif (diff gte client.TemplateLogging or FindNoCase("MainMenu.cfm", CGI.SCRIPT_NAME) or FindNoCase("Logon", CGI.SCRIPT_NAME) ) 
		and not FindNoCase("Connection.cfc", filename)
		and not FindNoCase("Security.cfc", filename)>  <!--- we are not tracking connection.cfcas this is too repeated --->
				
		<!--- or : REMOVED BY HANNO 6/2/2012
		group neq logon.templategroup --->
		
		<cftransaction>		
					
		<cfquery name="update" 
		datasource="AppsSystem">
			UPDATE UserStatus 
			SET    ActionTimeStamp  =  getDate(),
			       ActionTemplate   =  '#CGI.SCRIPT_NAME#',
				   HostSessionNo    =  '#CLIENT.sessionNo#',
				   ActionExpiration = '0',
				   TemplateGroup    = '#group#'
			WHERE  Account          = '#SESSION.acc#' 
			AND    HostName         = '#host#' 
			AND    HostSessionId    = '#SESSION.SessionId#' 
		</cfquery>
		
		<cfif pathname eq "">
		  <cfset pathname = "[root]">
		</cfif>
		
		<cfif len(CGI.SCRIPT_NAME) gte 100>
		 <cfset tmp = left(CGI.SCRIPT_NAME,100)>
		<cfelse>
		 <cfset tmp = CGI.SCRIPT_NAME>
		</cfif> 
		
		<cfif len(CGI.QUERY_STRING) gte 200>
		 <cfset str = left(CGI.QUERY_STRING,200)>
		<cfelse>
		 <cfset str = CGI.QUERY_STRING>
		</cfif> 
		
		<cfif len(CGI.HTTP_USER_AGENT) gte 200>
		  <cfset bws = left(CGI.HTTP_USER_AGENT,200)>
		<cfelse>
		 <cfset bws = CGI.HTTP_USER_AGENT>
		</cfif> 
												
		<cfquery name="insert" 
			datasource="AppsSystem">
			
				INSERT INTO UserStatusLog 
				(Account, 
				 HostName, 
				 NodeIP, 
				 NodeVersion,
				 HostSessionNo, 
				 ActionTimeStamp, 
				 ActionTemplate,
				 TemplateGroup,
				 ActionQueryString,
				 PathName,
				 FileName,				 
				 SystemFunctionId,
				 Mission)
				VALUES 
				('#SESSION.acc#',
				 '#host#',				 
				 '#CGI.Remote_Addr#', 
				 '#bws#',
				 '#CLIENT.sessionNo#', 
				 getDate(), 
				 '#tmp#',
				 '#group#',
				 '#str#',
				 '#PathName#',
				 '#FileName#',
				 <cfif Logon.SystemFunctionId neq "">
				 '#Logon.SystemFunctionId#',
				 <cfelse>
				 NULL,
				 </cfif>
				 '#Logon.Mission#')
		</cfquery>
			
		</cftransaction>	
			
	</cfif>

</cfif>

