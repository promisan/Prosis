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
<cf_screentop 
	  html   = "no" 	 
	  jquery="Yes"
	  layout = "webapp">
	  
<cf_listingScript>
	  
<cfoutput>
	
	<cfsavecontent variable="myquery">
	
		SELECT 	*
		FROM
			(
			 	SELECT	Par.OrgUnitName AS RootUnit, 
						O.OrgUnitName, 
						P.ProgramName, 
						Pe.Reference, 
						Pe.ProgramCode, 
						Pe.Period,
						Pe.Status,
						O.HierarchyCode
				FROM	ProgramPeriod AS Pe
						INNER JOIN Program AS P 
							ON Pe.ProgramCode = P.ProgramCode 
						INNER JOIN Organization.dbo.Organization AS O 
							ON Pe.OrgUnit = O.OrgUnit 
						INNER JOIN Organization.dbo.Organization AS Par 
							ON Par.Mission = O.Mission 
							AND Par.MandateNo = O.MandateNo 
							AND O.HierarchyRootUnit = Par.OrgUnitCode
				WHERE	P.Mission = '#url.mission#'
				AND		Pe.Period = '#url.period#'
				AND		Pe.RecordStatus <> '9'
				AND		P.ProgramClass <> 'Program'
			) AS D
							
	</cfsavecontent>

</cfoutput>

<cfset fields=ArrayNew(1)>
				
<cfset itm = 0>
		
<cfset itm = itm+1>
<cf_tl id="Parent" var="vRoot">
<cfset fields[itm] = {label      = "#vRoot#", 
					width      = "0", 
					field      = "RootUnit",		
					search     = "text",
					filtermode = "2"}>
					
<cfset itm = itm+1>
<cf_tl id="BID" var="vReference">
<cfset fields[itm] = {label      = "#vReference#", 
					width      = "0", 
					search     = "text",	
					field      = "Reference"}>
					
<cfset itm = itm+1>
<cf_tl id="Name" var="vName">
<cfset fields[itm] = {label      = "#vName#", 
					width      = "0", 
					search     = "text",	
					field      = "ProgramName"}>					
					
<cfset itm = itm+1>
<cf_tl id="Unit" var="vUnit">
<cfset fields[itm] = {label      = "#vUnit#", 
					width      = "0", 
					search     = "text",	
					field      = "OrgUnitName"}>
					
<cfset itm = itm+1>
<cf_tl id="Code" var="vCode">
<cfset fields[itm] = {label      = "#vCode#", 
					width      = "0", 
					search     = "text",	
					field      = "ProgramCode"}>	
					
					
<cfset itm = itm+1>
<cf_tl id="Status" var="vStatus">
<cfset fields[itm] = {label      = "#vStatus#", 
					width      = "0", 						
					field      = "Status",							
					alias      = "D",
					align	   = "center",
					formatted   = "Rating",
					ratinglist  = "9=Red,0=white,1=Gray,2=yellow,3=Green"}>
					
					
<table style="height:100%;width:100%"><tr><td style="padding:10px">		

	
<cf_listing header          = "listing1"
		    box             = "programdetail#url.mission#"
			link            = "#SESSION.root#/Procurement/Application/Requisition/Program/ProgramListingContent.cfm?mission=#url.mission#&period=#url.period#"
		    html            = "No"		
			datasource      = "AppsProgram"
			listquery       = "#myquery#"
			listorder       = "HierarchyCode"		
			listorderdir    = "ASC"
			listgroup       = "RootUnit"
			headercolor     = "transparent"		
			height          = "100%"			
			filtershow      = "show"
			excelshow       = "yes"
			listlayout      = "#fields#"			
			show            = "200"
			drillmode       = "window"	
		    drillargument   = "#client.height-90#;#client.width-60#;true;true"				
			drilltemplate   = "ProgramREM/Application/Program/ProgramView.cfm?Period=#url.period#&ProgramCode="
			drillkey        = "ProgramCode"			
			drillbox        = "editProgram">
			
</td></tr></table>				