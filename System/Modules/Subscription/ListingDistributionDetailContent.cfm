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
	SELECT  TOP 8 Created,
	        DistributionEMail, 
			DistributionSubject,
			DistributionCategory, 
			LayoutName,
			FileFormat,
			HostName,
			DATEDIFF(ms, PreparationStart, PreparationEnd) AS Duration,
			OfficerUserId,
			OfficerFirstName+' '+OfficerLastName as Contact,
			DistributionId
	FROM    UserReportDistribution
	WHERE   ReportId = '#url.id#'	
	ORDER BY Created DESC			 				
</cfsavecontent>
</cfoutput>

<cfset fields=ArrayNew(1)>

<cfset fields[1] = {label       = "Date",    
					width       = "10%", 
					field       = "Created",
					formatted   = "dateformat(Created,CLIENT.DateFormatShow)",
					search      = "date"}>
					
<cfset fields[2] = {label       = "Time",    
					width       = "8%", 
					field       = "Created",
					search      = "date",
					formatted   = "timeformat(Created,'HH:MM')"}>			

<cfset fields[3] = {label       = "MS", 
                    width       = "5%", 
					field       = "Duration",
					search      = "number",
					searchfield = "DATEDIFF(ms, PreparationStart, PreparationEnd)"}>
					
<cfset fields[4] = {label       = "HostName", 
                    width       = "30%", 
					field       = "HostName",
					search      = "text"}>
					
<cfset fields[5] = {label       = "Format", 
					width       = "8%", 
					field       = "FileFormat",
					search      = "text"}>
					
<cfset fields[6] = {label       = "Address", 
					width       = "26%", 
					field       = "DistributionEMail",
					search      = "text"}>
					
<cfset fields[7] = {label       = "Mode", 
					width       = "20%", 
					field       = "DistributionCategory",
				search      = "text"}>						

<cf_listing
    headershow    = "No"
	header        = ""
    box           = "i#url.row#"
	link          = "#SESSION.root#/System/Modules/Subscription/ListingDistributionDetailContent.cfm?row=#url.row#&id=#url.id#"
    html          = "No"	
	tablewidth    = "100%"
	listquery     = "#myquery#"
	listkey       = "account"
	listorder     = "Created"
	listorderdir  = "DESC"
	headercolor   = "ffffff"
	filtershow    = "No"
	allowgrouping = "No"
	listlayout    = "#fields#"
	drillmode     = "window"
	drillargument = "890;#client.widthfull-90#;false;false"	
	drilltemplate = "System/Access/User/Audit/ListingReportDetail.cfm?drillid="
	drillkey      = "DistributionId"
	datasource    = "appsSystem"
	deletetable   = "System.dbo.UserReportDistribution">
		
