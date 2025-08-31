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
	
	SELECT *
	FROM (
	SELECT  Code, Description,
	        (SELECT    COUNT(*) FROM Ref_PersonEventMission  WHERE PersonEvent = R.Code) AS EntityCount,
	        (SELECT    COUNT(*) FROM Ref_PersonEventTrigger  WHERE EventCode = R.Code)   AS TriggerCount,
	        (SELECT    COUNT(*) FROM PersonEvent             WHERE EventCode = R.Code) AS Used, 
			ListingOrder, 
			ActionPosition, 
			ActionPeriod, 
			EnablePortal, 
			EntityClass, 			
			Created
	FROM    Employee.dbo.Ref_PersonEvent AS R
	<cfif url.mission neq "">
	WHERE   Code IN (SELECT PersonEvent FROM Ref_PersonEventMission WHERE Mission = '#url.mission#') 
	</cfif>
	) as B
	WHERE 1=1
	-- condition

</cfsavecontent>
</cfoutput>

<!---
functionscript    = "ProcPOEdit",
functionfield     = "PurchaseNo",			
functioncondition = "tab",		
--->					


<cfset fields=ArrayNew(1)>

<cfset itm = 0>
					
<cfset itm = itm+1>			

<cf_tl id="Code" var="1">						
<cfset fields[itm] = {label           = "#lt_text#",                   
					field             = "Code",							
					search            = "text"}>		
					
<cfset itm = itm+1>		
<cf_tl id="Description" var="1">
<cfset fields[itm] = {label           = "#lt_text#",                    
					field             = "Description",					
					search            = "text"}>				
					
<cfset itm = itm+1>								
<cf_tl id="Position" var="1">
<cfset fields[itm] = {label      = "#lt_text#", 					
					field      = "ActionPosition",							
					filtermode = "2",    
					width      = "10", 		
					search     = "text"}>	
					
<cfset itm = itm+1>								
<cf_tl id="Period" var="1">
<cfset fields[itm] = {label      = "#lt_text#", 					
					field      = "ActionPeriod",						
					width      = "10", 						
					filtermode = "2",    
					search     = "text"}>						
					
<cfset itm = itm+1>								
<cf_tl id="Portal" var="1">
<cfset fields[itm] = {label      = "#lt_text#", 					
					field      = "EnablePortal",						
					width      = "10", 						
					filtermode = "2",    
					search     = "text"}>	
					
<cfset itm = itm+1>								
<cf_tl id="Entity" var="1">
<cfset fields[itm] = {label      = "#lt_text#", 					
					field      = "EntityCount",
					align      = "right",	
					width      = "10", 														
					search     = "number"}>							
					
<cfset itm = itm+1>								
<cf_tl id="Used" var="1">
<cfset fields[itm] = {label      = "#lt_text#", 					
					field      = "Used",	
					align      = "right",	
					width      = "10", 												
					search     = "number"}>			
					
<cfset itm = itm+1>		
<cf_tl id="workflow" var="1">
<cfset fields[itm] = {label      = "#lt_text#",                    
					field      = "EntityClass",
					filtermode = "2",
					search     = "text"}>														
					
						
<cfset itm = itm+1>							
<cf_tl id="Recorded" var="1">
<cfset fields[itm] = {label      = "#lt_text#",    					
					field        = "Created",		
					labelfilter  = "Recorded",			
					formatted    = "dateformat(Created,CLIENT.DateFormatShow)",
					search       = "date"}>					

<cf_listing
    	header        = "lsEvent"
    	box           = "lsEvent"
		link          = "#SESSION.root#/Staffing/Maintenance/PersonEvent/RecordListingContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"   	
		show	      = "1030"
		datasource    = "AppsEmployee"
		listquery     = "#myquery#"
		listkey       = "Code"		
		listorder     = "Description"		
		listorderdir  = "ASC"
		headercolor   = "ffffff"
		listlayout    = "#fields#"		
		filterShow    = "Yes"
		excelShow     = "Yes"
		CacheDisable  = "Yes"
		drillmode     = "tab"	
		drillstring   = "mode=list&idmenu=#url.systemfunctionid#"
		drilltemplate = "../Staffing/Maintenance/PersonEvent/RecordEdit.cfm?id1="
		drillkey      = "Code">					
