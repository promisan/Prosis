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


<cf_ListingScript>

<cfoutput>

	<cfsavecontent variable="myquery">
	
	SELECT     Pe.ProgramId,
	           P.ProgramCode, 
	           P.ProgramName, 
			   Pe.Reference, 
			   Pe.OfficerUserId, 
			   Pe.OfficerLastName, 
			   Pe.OfficerFirstName, 
			   Pe.Created
    FROM       Program P INNER JOIN ProgramPeriod AS Pe ON P.ProgramCode = Pe.ProgramCode 
	WHERE      P.Mission = '#url.mission#'
    AND        Pe.RecordStatus <> '9' 
	AND        Pe.OrgUnit NOT IN
                          (SELECT     OrgUnit
                            FROM      Organization.dbo.Organization
                            WHERE     Mission = '#url.mission#')
				 
	</cfsavecontent>	
		
</cfoutput>				  
				
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset fields[1] = {label   = "Code", 
                    width   = "8%", 
					alias = "P",
					field   = "ProgramCode",
					search  = "text"}>
					
<cfset fields[2] = {label   = "Reference", 
                    width   = "8%", 
					alias = "Pe",
					field   = "Reference",					
					search  = "text"}>					
					
<cfset fields[3] = {label   = "Name", 
                    width   = "35%", 
					field   = "ProgramName",					
					search  = "text"}>
									
<cfset fields[4] = {label   = "Period", 
                    width   = "10%", 
					field   = "Period",					
					search  = "text"}>		
					
<cfset fields[5] = {label   = "Officer", 
					width   = "25%",
					alias = "Pe", 
					field   = "OfficerLastName",					
					search  = "text"}>    
											
<cfset fields[6] = {label   = "FirstName", 
					width   = "10%",
					alias = "Pe", 
					field   = "OfficerFirstName",					
					search  = "text"}>    					
	
<cfset fields[7] = {label      = "Created",    
					width      = "10%", 
					alias = "Pe",
					field      = "Created",
					search     = "date",
					formatted  = "dateformat(Created,'#CLIENT.DateFormatShow#')"}>							
						
	
<cf_listing
    header        = "MissingOrg"
    box           = "MissingOrg"
	link          = "#SESSION.root#/ProgramREM/Application/Budget/Listing/MissingOrganization.cfm?mission=#url.mission#"
    html          = "No"
	show          = "40"
	datasource    = "AppsProgram"
	listquery     = "#myquery#"
	listkey       = "personNo"
	listorder     = "ProgramCode"
	listorderdir  = "ASC"
	listorderalias = "P"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Yes"
	excelShow     = "Yes"
	drillmode     = "window"
	drillargument = "540;600;false;false"	
	drilltemplate = "ProgramRem/Application/Program/ProgramView.cfm?programid="
	drillkey      = "ProgramId">
					  