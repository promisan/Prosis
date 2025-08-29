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
	
		SELECT     C.CaseNo, 
		           C.Mission, 
				   D.FirstName+' '+D.LastName as Dependent, 				  
				   C.DocumentDate, 
				   C.ClaimType, 
				   C.ActionStatus, 
				   C.DocumentNo,
				   ClaimId
		FROM       Claim C LEFT OUTER JOIN
                   Employee.dbo.PersonDependent D ON C.PersonNo = D.PersonNo AND C.DependentId = D.DependentId
		WHERE      C.PersonNo = '#url.id#' 
	 				 
	</cfsavecontent>	

</cfoutput>				  
		
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

				
<cfset fields[1] = {label   = "CaseNo",                
					field   = "CaseNo",
					alias   = "C",
					filtermode = "0",
					search  = "text"}>
					
<cfset fields[2] = {label   = "Mission",                    
					alias   = "C",
					field   = "Mission",
					search  = "text"}>		
					
<cfset fields[3] = {label   = "Reference",                
					field   = "DocumentNo",
					alias   = "C",
					filtermode = "0",
					search  = "text"}>							
					
<cfset fields[4] = {label   = "Type",                
					field   = "ClaimType",
					alias   = "C",
					filtermode = "0",
					search  = "text"}>							
					
<cfset fields[5] = {label   = "Dependent",                
					field   = "Dependent",					
					filtermode = "0",
					search  = ""}>																
						
<cfset fields[6] = {label      = "Date",  				
					field      = "DocumentDate",
					search     = "date",
					align      = "center",
					formatted  = "dateformat(DocumentDate,'#CLIENT.DateFormatShow#')"}>											
				
<cfset fields[7] = {label     = "ClaimId",   					
					display    = "No",
					alias      = "C",
					field      = "ClaimId"}>		
								
<cf_listing
    header        = "CaseFile"
    box           = "CaseFile"
	link          = "#SESSION.root#/Staffing/Application/Employee/CaseFile/CaseFileListingContent.cfm?id=#url.id#"
    html          = "No"
	show          = "40"
	height        = "100%"
	datasource    = "AppsCaseFile"
	listquery     = "#myquery#"
	listorder     = "Mission"
	listorderdir  = "ASC"	
	listlayout    = "#fields#"
	filterShow    = "Hide"
	excelShow     = "Yes"
	drillmode     = "window"
	drillargument = "#client.height-80#;#client.width-70#;false;true"	
	drilltemplate = "CaseFile/Application/Case/CaseView/CaseView.cfm?claimid="
	drillkey      = "ClaimId">
	
					  