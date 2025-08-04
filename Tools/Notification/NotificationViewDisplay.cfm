<!--
    Copyright © 2025 Promisan

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
	
	<cfparam name="attributes.authentication"            default="true">
	<cfparam name="attributes.layout"                    default="top">
	<cfparam name="attributes.persistent"                default="false">
	<cfparam name="SESSION.acc"                           default="">
	<cfparam name="SESSION.authent"                       default="0">
	
	<cfquery name="Parameter" 
	datasource="AppsInit">
		SELECT *
		FROM   Parameter
		WHERE  Hostname = '#CGI.HTTP_HOST#' 
	</cfquery>
	
	<cfset SESSION.root     = "#Parameter.ApplicationRoot#">
	<cfset SESSION.welcome  = "#Parameter.SystemTitle#">
	
	<!--- Username and Password for DB query
	not used because maybe variables are not 
	created at this point --->
	<cfquery name="EventCheck" 
		datasource="AppsSystem">
		 SELECT * 
		 FROM SystemEvent
		 WHERE EventId IN (
		 	SELECT EventId
			FROM SystemEventServer
			WHERE HostName = '#CGI.HTTP_HOST#')
	</cfquery>
	
	<cfset cntx = "0">
	
	<cfloop query="EventCheck">
	<cfif EventCheck.AuthenticationRequired eq attributes.authentication>
	
		<cfif EventCheck.recordcount neq "0">
		
			<cfset DateEffective  =  DateDiff("s", 0, EventCheck.EventDateEffective)>
			<cfset DateExpiration =  DateDiff("s", 0, EventCheck.EventDateExpiration)>
			<cfset Now =  DateDiff("s", 0, now())>
			
	
			<cfset EVDATE = DateAdd("h", -EventCheck.EventDisplayDuration, EventCheck.EventDateEffective)>
			
			<cfif EVDATE lte now() and DateExpiration gte Now>
				<cfset _showNotification = "true">
			<cfelse>
				<cfset _showNotification = "false">
			</cfif>

			
			<cfif _showNotification eq "true">
			
				<cfset cntx = cntx +1>
			
				<cfquery name="EventUserCheck" 
					datasource="AppsSystem">
						SELECT * 
						FROM SystemEventServerUser
						WHERE EventId = '#EventCheck.EventId#'
						AND HostName  = '#CGI.HTTP_HOST#'
						AND Account   = '#SESSION.acc#'	
				</cfquery>
				
				<cfif EventUserCheck.recordcount eq "0">
					<cfif cntx eq "1">
						<script>
							$(document).ready(function() {	
								setTimeout("$('.notiwrapper').slideDown(800);",1000);				
							});
						</script>
					</cfif>
					
					<cfset eventid = EventCheck.EventId>
					<cfinclude template="NotificationViewDisplayContent.cfm">  
					
				</cfif>
				
			</cfif>
			
		</cfif>
	
	</cfif>
	</cfloop>



	
	
	
