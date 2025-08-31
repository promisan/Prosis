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
<cfparam name="client.header" default="">

<!--- configuration file --->
<cfoutput>

<cfsavecontent variable="myquery">
	SELECT *
	FROM   UserError
	WHERE  ActionStatus IN ('3') 
	<!--- prevent duplicated errors --->
	AND    EnableProcess = '1'	
	<!--- last 2 months only --->
	AND    Created >  '#dateformat(now()-50,client.dateSQL)#'
	<!--- has a server --->
	AND    HostServer > ''
	
	<cfif SESSION.isAdministrator eq "No">
	AND    (HostServer IN (SELECT DISTINCT GroupParameter 
	                       FROM   Organization.dbo.OrganizationAuthorization
						   WHERE  Role        = 'ErrorManager'
						   AND    UserAccount = '#SESSION.acc#')
			OR
			
			Account = '#SESSION.acc#'
			)		
	</cfif>			
		
</cfsavecontent>

<cfset fields=ArrayNew(1)>

<cfset fields[1] = {label   = "Diagnostics", 					
					field   = "ErrorDiagnostics",
					width   = "150",
					sort    = "No",
					search  = "text"}>		

<cfset fields[2] = {label   = "Ticket No",                    
					field   = "ErrorNo",
					search  = "text"}>
					
<cfset fields[3] = {label   = "Server",                    
					field   = "HostName",
					search  = "text"}>
									
<cfset fields[4] = {label      = "Sent",    					
					field      = "ErrorTimeStamp",
					formatted  = "dateformat(ErrorTimeStamp,CLIENT.DateFormatShow)",
					search     = "date"}>
					
<cfset fields[5] = {label      = "Time",    					
					field      = "ErrorTimeStamp",
					formatted  = "timeformat(ErrorTimeStamp,'HH:MM')"}>					
							
<cf_listing
    header        = "#client.header#"
    box           = "userdetail"
	link          = "#SESSION.root#/System/Portal/Exception/ExceptionListingDismiss.cfm"
    html          = "No"
	show          = "20"
	listquery     = "#myquery#"
	listkey       = "account"
	listorder     = "ErrorTimeStamp"
	listorderdir  = "DESC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filtershow    = "show"	
	drillmode     = "dialog"
	drillargument = "740;800;false;false"	
	drilltemplate = "System/Access/User/Audit/ListingErrorDetail.cfm"
	drillkey      = "ErrorId">
	
</cfoutput>	