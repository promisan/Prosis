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
<cfparam name="URL.Mission" default="">
<cfparam name="URL.Period" default="">

<cfoutput> 

	<cfsavecontent variable="myquery">  
		SELECT   *
		FROM  	tmp#SESSION.acc#Program
		WHERE   ShowUnit is not NULL	 			
	</cfsavecontent>	
	
			  
</cfoutput>

<!--- show person, status processing color and filter on raise by me --->

<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = "0">

<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "Code",                     				
					  field      = "ProgramCode",												
					  search     = "text"}>		

<cfset itm = itm+1>
<cfset fields[itm] = {label      = "Reference",                   
					  field      = "Reference",					
					  search     = "text"}>
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Class",                  			
					  field      = "ProgramClass",
					  filtermode = "2",  
					  search     = "text"}>								

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Name", 
                      width      = "50", 					
					  field      = "ProgramName",
					  search     = "text"}>	
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Scope",                  			
					  field      = "ProgramScope",
					  filtermode = "3",  
					  search     = "text"}>							

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Unit", 
                      width      = "40", 					
					  field      = "OrgUnitName",
					  fieldsort  = "HierarchyCode",
					  filtermode = "3",  
					  search     = "text"}>	
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Officer",                    			
					  field      = "OfficerLastName",
					  filtermode = "3",  
					  search     = "text"}>		
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Recorded",                    			
					  field      = "Created",					 
					  formatted  = "dateformat(Created,CLIENT.DateFormatShow)",
					  search     = "date"}>																	
					
	
									
<cf_listing
    header        = "lsProgram_#url.period#"
    box           = "lsProgram_#url.period#"
	link          = "#SESSION.root#/ProgramREM/Application/Program/ProgramView/ProgramViewListing.cfm?period=#url.period#"	
    html          = "No"
	show          = "40"
	datasource    = "AppsQuery"
	listquery     = "#myquery#"
	listkey       = "ProgramCode"	
	listorder     = "Reference"	
	listorderdir  = "ASC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Yes"
	excelShow     = "Yes"
	drillmode     = "tab"	
	drillargument = "950;1200;false;false"
	drilltemplate = "ProgramREM/Application/Program/ProgramView.cfm?period=#url.period#&programcode="
	drillkey      = "ProgramCode">

