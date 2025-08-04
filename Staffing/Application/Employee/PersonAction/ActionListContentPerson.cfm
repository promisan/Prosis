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

<cfset fields=ArrayNew(1)>

<cfset itm = "0">

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Code", 
                    Display    = "0",						
					field      = "ActionCode"}>		

<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "Personnel Action", 					
					field      = "PersonnelAction",											
					filtermode = "3",
					search     = "text"}>	
							

<cfset itm = itm+1>						
<cfset fields[itm] = {label      = "Reason", 					
					field      = "ActionReason",											
					filtermode = "2",
					Display    = "0",	
					search     = "text"}>	
										
<cfset itm = itm+1>
<cfset fields[itm] = {label    = "No",                   	
					field      = "ActionDocumentNo",	
					width      = "20",					
					search     = "text"}>

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Entity",                   
					field      = "Mission", 	
					filtermode = "2",
					width      = "26",						
					search     = "text"}>					

<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "Status", 					
					field      = "ActionStatus",					
					alias      = ""}>		
					
<cfset itm = itm+1>								
<cfset fields[itm] = {label    = "Workflow", 					
					field      = "Workflow",					
					alias      = ""}>									

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Officer", 					
					field        = "OfficerLastName",										
					filtermode   = "3",
					search       = "text"}>													

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Effective",    					
					field        = "ActionDate",		
					column       = "month",				
					formatted    = "dateformat(ActionDate,CLIENT.DateFormatShow)",
					search       = "date"}>	
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Expiration",    					
					field        = "ActionExpiration",					
					formatted    = "dateformat(ActionExpiration,CLIENT.DateFormatShow)",
					search       = "date"}>										

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Processed",    					
					field        = "LastProcessed",	
					column       = "month",				
					formatted    = "dateformat(Lastprocessed,CLIENT.DateFormatShow) ",
					search       = "date"}>		
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "",    					
					field        = "LastProcessed",					
					formatted    = "timeformat(Lastprocessed,'HH:MM')"}>		
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Recorded",    					
					field        = "Created",	
					column       = "month",	
					search       = "date",				
					formatted    = "dateformat(Created,CLIENT.DateFormatShow)"}>											
								
														

<cfset itm = itm+1>
<cfset fields[itm] = {label      = "No", 
                    width      = "1%", 	
					Display    = "0",				
					field      = "ActionId"}>
					
<cfset itm = itm+1>											
<cfset fields[itm] = {label      = "Source", 					
					field      = "ActionSource",														
					filtermode = "3",
					search     = "text"}>								
		
<!--- embed|window|dialogajax|dialog|standard --->
	
	<cf_listing header  = "PersonnelAction"
	    box           = "actiondetailperson"
		link          = "#SESSION.root#/Staffing/Application/Employee/PersonAction/ActionListContent.cfm?init=0&id=#url.id#&systemfunctionid=#url.systemfunctionid#&mode=#url.mode#"
	    html          = "No"		
		datasource    = "AppsQuery"
		listquery     = "#myquery#"
		listgroup     = "ActionSource"		
		listorder     = "ActionDocumentNo"
		listorderdir  = "DESC"
		headercolor   = "ffffff"				
		tablewidth    = "100%"
		listlayout    = "#fields#"
		FilterShow    = "Hide"
		ExcelShow     = "Yes"
		drillmode     = "tab" 
		drillargument = "900;1080;false;true"	
		drilltemplate = "Staffing/Application/Employee/PersonAction/ActionDialog.cfm?drillid="
		drillkey      = "ActionDocumentNo">	
		
