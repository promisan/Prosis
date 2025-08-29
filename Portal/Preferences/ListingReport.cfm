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
<cfoutput>

<cfsavecontent variable="myquery">
		SELECT  Created,
		        DistributionEMail, 
				DistributionSubject,
				DistributionCategory,
				FunctionName, 
				SystemModule,
				LayoutName,
				FileFormat,
				DATEDIFF(ms, PreparationStart, PreparationEnd) AS Duration,
				OfficerUserId,
				OfficerFirstName+' '+OfficerLastName as Contact,
				DistributionId
		FROM    UserReportDistribution
		WHERE   Account = '#SESSION.acc#' 	
		AND     DistributionStatus = '1'			 		
</cfsavecontent>

<cfset fields=ArrayNew(1)>
			
<cfset fields[1] = {label       = "Module",               
					field       = "SystemModule",
					filtermode  = "3",
					search      = "text"}>
									
<cfset fields[2] = {label       = "Name",               
					field       = "FunctionName",
					search      = "text"}>

<cfset fields[3] = {label       = "Date",    					
					field       = "Created",
					formatted   = "dateformat(Created,CLIENT.DateFormatShow)",
					search      = "date"}>
					
<cfset fields[4] = {label       = "Time",   					
					field       = "Created",
					formatted   = "timeformat(Created,'HH:MM')"}>			

<cfset fields[5] = {label       = "MS",                    
					field       = "Duration",
					search      = "number",
					searchfield = "DATEDIFF(ms, PreparationStart, PreparationEnd)"}>
					
<cfset fields[6] = {label       = "Layout",               
					field       = "LayoutName",
					filtermode  = "3",
					search      = "text"}>
					
<cfset fields[7] = {label       = "Format", 					
					field       = "FileFormat",
					filtermode  = "2",
					search      = "text"}>					
				
<cfset fields[8] = {label       = "Mode", 					
					field       = "DistributionCategory"}>		
														
<cf_listing
    header        = "<b><font size='2'>Report Distribution Log</font></b>"
    box           = "setting"
	link          = "#SESSION.root#/Portal/Preferences/ListingReport.cfm"
    html          = "No"	
	tablewidth    = "100%"	
	listquery     = "#myquery#"
	listkey       = "account"
	listorder     = "Created"
	listorderdir  = "DESC"
	filtershow    = "Yes"	
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	drillmode     = "securewindow"
	drillargument = "910;1030;false;false"	
	drilltemplate = "System/Access/User/Audit/ListingReportDetail.cfm?drillid="
	drillkey      = "DistributionId"
	deletetable   = "UserReportDistribution">
	
	
	
</cfoutput>	
