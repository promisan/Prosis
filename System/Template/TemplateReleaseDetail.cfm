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
	 SELECT *, OfficerFirstName+' '+OfficerLastName as OfficerName
	  FROM   ParameterSiteVersion
	  WHERE  ApplicationServer = '#URL.site#'	 
</cfsavecontent>

<cfset fields=ArrayNew(1)>

<cfset fields[1] = {label   = "Version&nbsp;Date", 
                    width   = "10%",					
					field   = "VersionDate",
					formatted  = "dateformat(VersionDate,CLIENT.DateFormatShow)",
					search  = "date"}>
					
<cfset fields[2] = {label   = "Group", 
                    width   = "10%", 
					field   = "TemplateGroup",
					search  = "text"}>					
					
<cfset fields[3] = {label   = "Server", 
                    width   = "20%", 
					field   = "ApplicationServer",
					search  = "text"}>
						
<cfset fields[4] = {label   = "Prepared&nbsp;by&nbsp;Officer", 
					width   = "60%", 
					field   = "OfficerName",
					search  = "no"}>	
						
							
<cf_listing
    header        = "Release Log"
    box           = "releasedetail"
	link          = "#SESSION.root#/System/Template/TemplateReleaseDetail.cfm?site=#url.site#"
    html          = "No"
	show          = "10"
	datasource    = "AppsControl"
	listquery     = "#myquery#"
	listorder     = "VersionDate"
	listorderdir  = "DESC"
	filtershow    = "No"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	drillmode     = "workflow"
	drilltemplate = "workflow"
	drillkey      = "versionid">
	
</cfoutput>	
