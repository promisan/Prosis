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
<cfparam name="attributes.systemfunctionid" default="">
<cfparam name="attributes.mission"          default="">
<cfparam name="url.systemfunctionid"        default="#attributes.systemfunctionid#">
<cfparam name="url.mission"                 default="#attributes.mission#">
<cfparam name="attributes.ActionObject"          default = "">
<cfparam name="attributes.ActionObjectKeyValue1" default = "">
<cfparam name="attributes.ActionObjectKeyValue2" default = "">
<cfparam name="attributes.ActionObjectKeyValue3" default = "">
<cfparam name="attributes.ActionObjectKeyValue4" default = "">

<cfif url.systemfunctionid neq "" and url.systemfunctionid neq "undefined">

	<cf_getHost host="#cgi.http_host#">			
		
		<cfquery name="user" 
			datasource="AppsSystem">
				SELECT * 
				FROM   UserNames
				WHERE  Account = '#session.acc#'				
		</cfquery>
	
		<cfquery name="get" 
			datasource="AppsSystem">
				SELECT * 
				FROM   Ref_ModuleControl
				WHERE  SystemFunctionId = '#url.systemfunctionid#'				
		</cfquery>
						
		<cfif user.recordcount eq "1" and get.recordcount eq "1">
		
			<cfquery name="check" 
				datasource="AppsSystem">
					SELECT *
					FROM   UserActionModule 
					WHERE  Account           = '#SESSION.acc#'
					AND    SystemFunctionId  = '#url.systemFunctionId#'
					AND    ActionTimeStamp   = '#dateformat(now(),client.dateSQL)# #timeformat(now(),'HH:MM:SS')#'					
			</cfquery>
			
			<cfif check.recordcount eq "0">
		
				<cfquery name="LogMenuAction" 
					datasource="AppsSystem">
						INSERT INTO UserActionModule 
							   (Account, 
								AccountMission,
								HostName, 
								HostSessionId,
								NodeIP,
								SystemFunctionId,
								FunctionName,
								Mission,
								ActionDescription,
								ActionObject,
								ActionObjectKeyValue1,
								ActionObjectKeyValue2,
								ActionObjectKeyValue3,
								ActionObjectKeyValue4,
								ActionTimeStamp)
						VALUES ('#SESSION.acc#',
								 '#User.AccountMission#',
								 '#host#',
								 '#session.Sessionid#',
								 '#CGI.Remote_Addr#',
								 '#url.systemFunctionId#',
								 '#get.FunctionName#',
								 '#url.mission#',
								 'Open Function',
								 '#attributes.ActionObject#',
								 '#attributes.ActionObjectKeyValue1#',
								 '#attributes.ActionObjectKeyValue2#',
								 '#attributes.ActionObjectKeyValue3#',
								 <cfif attributes.ActionObjectKeyValue4 neq "">
								 	'#attributes.ActionObjectKeyValue4#',
								 <cfelse>
								 	NULL,
								 </cfif>
								 '#dateformat(now(),client.dateSQL)# #timeformat(now(),'HH:MM:SS')#' ) 			
				</cfquery>
			
			</cfif>
						
			<cfif url.mission eq "">
			
				<cfquery name="LogStatus" 
					datasource="AppsSystem">
						UPDATE UserStatus
						SET    SystemFunctionId = '#url.systemFunctionId#'
						WHERE  Account          = '#session.acc#'
						AND    HostName         = '#host#'	 
						AND    HostSessionId    = '#SESSION.Sessionid#'				
				</cfquery>		
			
			<cfelse>
							
				<cfquery name="LogStatus" 
					datasource="AppsSystem">
						UPDATE UserStatus
						SET    SystemFunctionId = '#url.systemFunctionId#',
						       Mission          = '#url.mission#'
						WHERE  Account          = '#session.acc#'
						AND    HostName         = '#host#'	 
						AND    HostSessionId    = '#SESSION.Sessionid#'				
				</cfquery>		
			
			</cfif>
			
		</cfif>		
	
<cfelse>

	<cf_getHost host="#cgi.http_host#">

	<cfquery name="LogStatus" 
		datasource="AppsSystem">
				UPDATE UserStatus
				SET    Mission          = '#url.mission#'
				WHERE  Account          = '#session.acc#'
				AND    HostName         = '#host#'	 
				AND    HostSessionId    = '#SESSION.Sessionid#'				
	</cfquery>				

</cfif>