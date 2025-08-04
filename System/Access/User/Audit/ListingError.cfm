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

<cf_listingscript>
<cf_screentop html="No" jquery="Yes">

<cfparam name="client.header" default="">

<!--- configuration file --->
<cfoutput>
<cfsavecontent variable="myquery">
	 SELECT   TOP 400 * 
	 FROM     UserError
	 WHERE    Account = '#URL.ID#' 	
	 ORDER BY Created DESC
</cfsavecontent>

<cfset fields=ArrayNew(1)>

<cfset itm = "0">
<cfset itm = itm+1>
<cfset fields[itm] = {label      = "Diagnostics", 					
					  field      = "ErrorDiagnostics",
					  width      = "150",
					  sort       = "No",
					  search     = "text"}>		

<cfset itm = itm+1>
<cfset fields[itm] = {label      = "ErrorNo",                    
					  field      = "ErrorNo",
					  search     = "text"}>

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Server",                    
					  field      = "HostName",
					  search     = "text"}>		

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Directory",                    
					  field      = "TemplateGroup",
					  search     = "text"}>					

<cfset itm = itm+1>									
<cfset fields[itm] = {label      = "Sent",    					
				 	  field      = "ErrorTimeStamp",					
					  formatted  = "dateformat(ErrorTimeStamp,CLIENT.DateFormatShow)",
					  search     = "date"}>

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Time",    					
					  field      = "ErrorTimeStamp",
					  formatted  = "timeformat(ErrorTimeStamp,'HH:MM')"}>					

		
<cf_listing
    header        = "User System Error"
    box           = "userdetail"
	link          = "#SESSION.root#/System/Access/User/Audit/ListingError.cfm?id=#url.id#"
    html          = "No"
	show          = "15"
	listquery     = "#myquery#"
	listkey       = "account"	
	listgroup     = "TemplateGroup"
	listgroupdir  = "ASC"
	listorder     = "ErrorTimeStamp"
	listorderdir  = "DESC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	excelshow     = "Yes"
	filtershow    = "hide"	
	drillmode     = "dialogajax"
	drillargument = "740;800;false;false"	
	drilltemplate = "System/Access/User/Audit/ListingErrorDetail.cfm"
	drillkey      = "ErrorId">
		
</cfoutput>	