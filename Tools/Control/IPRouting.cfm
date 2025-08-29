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
<cfquery name="Param" datasource="AppsInit">
		SELECT * 
		FROM Parameter
		WHERE HostName = '#CGI.HTTP_HOST#' 
</cfquery>

<cfparam name="client.acc" default="">

<cfif Param.DisableIPRouting eq "0">
	
	<cfquery name="GetAccount" 
	datasource="AppsSystem">
		SELECT  *
		FROM    userNames
		WHERE   NodeIP = '#CGI.Remote_Addr#' 
	</cfquery>
	
	<cfif GetAccount.DisableIPRouting eq "0" and GetAccount.recordcount eq "1" or client.acc neq "Administrator">	
		
		<cfset row  = 0>
		<cfset val  = 0>
		<cfset sec1 = 1000000000>
		<cfset sec2 = 1000000>
		<cfset sec3 = 1000>
		<cfset sec4 = 1>
		
		<cfloop index="itm" list="#CGI.Remote_addr#" delimiters=".">
		
			<cfset row = row+1>
			
			<cfif row neq "1">
				<cfif len(itm) eq "1">
				  <cfset nm = "00#itm#">
				<cfelseif len(itm) eq "2">
				  <cfset nm = "0#itm#">  
				<cfelse>
				  <cfset nm = itm>  
				</cfif>								
				<cfset val = "#val##nm#">
			<cfelse>
			    <cfset val = "#itm#">	
			</cfif>
			
		</cfloop>

		<cfquery name="RedirectIP" datasource="AppsSystem">
			SELECT  TOP 1 * 
			FROM    stRedirection
			WHERE   #val# >= IPRangeStartNum
			AND     #val# <= IPRangeEndNum 
			AND     ServerURL != 'DISABLED' 
		</cfquery>
		
		<cfquery name="RedirectDisabled" datasource="AppsSystem">
			SELECT  TOP 1 *
			FROM    stRedirection
			WHERE #val# >= IPRangeStartNum 
			AND   #val# <= IPRangeEndNum
			AND   ServerURL = 'DISABLED'
		</cfquery>
 							
		<cfif RedirectIP.Recordcount gte "1" 
		        and RedirectDisabled.recordcount eq "0" 
				and not FindNoCase("#CGI.HTTP_HOST#","#RedirectIP.ServerURL#")>
		      <cflocation url="#RedirectIP.ServerURL#" addtoken="No">
		</cfif>
	
	</cfif>
	
</cfif>