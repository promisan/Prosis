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

<!--- review listing 
1. Listing using listing tool
2. Edit : dialog with workflow
3. Process : refresh the listing
--->

<cfparam name="client.header" default="">

<!--- configuration file --->

<cfoutput>
	
	<cfsavecontent variable="myquery">
		SELECT    TOP 400 * 
		FROM      UserError
		WHERE     ActionStatus = '2'   <!--- defined as under workflow --->	
		
		<cfif SESSION.isAdministrator eq "No">
		AND    (HostServer IN (SELECT DISTINCT GroupParameter 
		                       FROM   Organization.dbo.OrganizationAuthorization
							   WHERE  Role        = 'ErrorManager'
							   AND    UserAccount = '#SESSION.acc#')
				OR
				
				Account = '#SESSION.acc#'
				)		
	   </cfif>					
		
		ORDER BY  ErrorNo
	</cfsavecontent>
	
	<cfset fields=ArrayNew(1)>
	
	<cfset fields[1] = {label      = "Diagnostics", 					
						field      = "ErrorDiagnostics",
						width      = "180",
						sort       = "No",
						search     = "text"}>		
	
	<cfset fields[2] = {label      = "Ticket No",                    
						field      = "ErrorNo",
						search     = "text"}>
						
	<cfset fields[3] = {label      = "Server",                    
						field      = "HostServer",
						search     = "text",
						filtermode = "2"}>
										
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
		link          = "#SESSION.root#/System/Portal/Exception/ExceptionListingForReview.cfm"
	    html          = "No"
		show          = "20"
		listquery     = "#myquery#"
		listkey       = "account"
		listorder     = "ErrorTimeStamp"
		listorderdir  = "DESC"
		headercolor   = "ffffff"
		listlayout    = "#fields#"
		filtershow    = "hide"	
		excelshow     = "No"		
		drillmode     = "window"
		drillargument = "840;900;false;false"	
		drilltemplate = "System/Portal/Exception/ExceptionView.cfm?errorid="
		drillkey      = "ErrorId">
	
</cfoutput>	
