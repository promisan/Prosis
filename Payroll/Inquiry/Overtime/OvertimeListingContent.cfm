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

<cfsavecontent variable="myquery">		
	<cfoutput>
		SELECT	O.*,
				W.ActionDescriptionDue
		FROM	UserQuery.dbo.#session.acc#_OvertimeListing O
				LEFT OUTER JOIN #SESSION.acc#_wfOvertime W
					ON O.OvertimeId = W.ObjectId
	</cfoutput>
</cfsavecontent>		

<cfset fields=ArrayNew(1)>

<cfset itm = 0>

<cfset itm = itm+1>		
<cfset fields[itm] = {label         	= "Service",                  
					  field         	= "Parent",
					  filtermode    	= "2",
					  displayfilter 	= "Yes",
					  search        	= "text"}>	

<cfset itm = itm+1>		
<cfset fields[itm] = {label         	= "Unit",                  
					  field         	= "Organization",
					  filtermode    	= "2",
					  display			= "Yes",
					  displayfilter 	= "Yes",
					  search        	= "text"}>	
					
<cfset itm = itm+1>		
<cfset fields[itm] = {label         	= "IndexNo",                  
					  field         	= "IndexNo",
					  displayfilter 	= "Yes",
					  search        	= "text",
					  functionscript	= "EditPerson",
				      functionfield 	= "PersonNo"}>	
					  
<cfset itm = itm+1>		
<cfset fields[itm] = {label       		= "Name",                  
					  field         	= "PersonName",
					  displayfilter 	= "Yes",
					  search        	= "text"}>
					  
<cfset itm = itm+1>		
<cfset fields[itm] = {label      		= "Function",                  
					  field         	= "FunctionalTitle",
					  filtermode    	= "2",
					  displayfilter 	= "Yes",
					  search        	= "text"}>
				  
<cfset itm = itm+1>							
<cfset fields[itm] = {label         	= "Date",  					
					  field         	= "OvertimeDate",
					  search        	= "date",
					  formatted     	= "dateformat(OvertimeDate,'#CLIENT.DateFormatShow#')"}>
					  
<cfset itm = itm+1>		
<cfset fields[itm] = {label       		= "Time",                  
					  field         	= "OvertimeTime"}>
					  
<cfset itm = itm+1>		
<cfset fields[itm] = {label       		= "Current Stage",                  
					  field         	= "ActionDescriptionDue",
					  filtermode    	= "2",
					  displayfilter 	= "Yes",
					  search        	= "text"}>
					  
<cfset itm = itm+1>		
<cfset fields[itm] = {label       		= "Status",                  
					  field         	= "Status",
					  filtermode    	= "3",    
				      search        	= "text",
					  align         	= "center",
				  	  formatted     	= "Rating",
					  ratinglist    	= "0=Yellow,1=Green,2=Green,5=Blue"}>
							
<!--- <cfset filters=ArrayNew(1)>		
<cfset filters[1] = {field = "ActionStatus", value= "0"}> --->						 
		
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr><td style="padding:10px">	
		
	<cf_listing
	    header         = "Overtime"
	    box            = "overtime"
		link           = "#SESSION.root#/Payroll/Inquiry/Overtime/OvertimeListingContent.cfm?systemfunctionid=#url.systemfunctionid#"
	    html           = "No"		
		datasource     = "AppsQuery"
		listquery      = "#preserveSingleQuotes(myquery)#"
		listgroup      = "Parent"		
		listgroupdir   = "ASC"			
		listorder      = "OvertimeDate"
		listorderfield = "OvertimeDate"
		listorderdir   = "DESC"		
		headercolor    = "ffffff"
		listlayout     = "#fields#"
		filterShow     = "Hide"
		<!--- listfilter     = "#filters#"  --->
		excelShow      = "Yes"
		drillmode      = "window"	
		drillargument  = "900;1200;true;true"	
		drilltemplate  = "Payroll/Application/Overtime/OvertimeEdit.cfm?mycl=1&myclentity=EntOvertime&refer=workflow&id1="
		drillkey       = "OvertimeId">		
	
	</td></tr>
</table>		