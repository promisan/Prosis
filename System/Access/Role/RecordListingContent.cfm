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
  SELECT *
  FROM (
    SELECT   R.* , 
	         S.Description as MenuName, 
			 S.MenuOrder	       
	FROM     Ref_AuthorizationRole R, System.dbo.Ref_SystemModule S
	WHERE    R.SystemModule = S.SystemModule
	AND      S.Operational = 1	
	) as S
	
	WHERE 1=1
	
	-- condition
	
</cfsavecontent>
	
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>
				
<cfset fields[1] = {label         = "Module",                  
					field         = "MenuName",
					fieldsort     = "MenuOrder",										
					filtermode    = "2",
					searchalias   = "S",		
					displayfilter = "Yes",				
					searchfield   = "MenuName",
					search        = "text"}>		
				
<cfset fields[2] = {label         = "Role",                  
					field         = "Description",		
					alias         = "S",	
					searchalias   = "S",	
					searchfield   = "Description",						
					search        = "text"}>	
									
<cfset fields[3] = {label         = "Code",                  
					field         = "Role",
					filtermode    = "0",
					search        = "text"}>					

<cfset fields[4] = {label         = "Area",                  
					field         = "Area",
					filtermode    = "2"}>	
					
<cfset fields[5] = {label         = "Function",                  
					field         = "SystemFunction",
					filtermode    = "0"}>								
						
<cfset fields[6] = {label         = "Scope",                  
					field         = "OrgUnitLevel",
					filtermode    = "2",
					search        = "text"}>				
					
<cfset fields[7] = {label         = "Parameter",                  
					field         = "Parameter",
					filtermode    = "2"}>		
					
<cfset fields[8] = {label         = "Owner",                  
					field         = "RoleOwner",
					alias         = "S",	
					searchalias   = "S",	
					filtermode    = "2",
					search        = "text"}>		
					
<cfset fields[9] = {label         = "Class",                  
					field         = "RoleClass",
					filtermode    = "2",
					column        = "common",
					search        = "text"}>	
					
<cfset itm = 10>						
<cf_tl id="Created" var="1">
<cfset fields[itm] = {label      = "#lt_text#",    					
					field        = "Created",		
					fieldentry   = "1",					
					labelfilter  = "#lt_text#",						
					formatted    = "dateformat(Created,CLIENT.DateFormatShow)"}>									
					

<cfinvoke component = "Service.Access"  
    method          = "system"        
    returnvariable  = "access">	
																							
<cfif access eq "ALL" or access eq "EDIT">	
    <cfset template = "/System/Access/Role/RecordEdit.cfm?drillid=">
	<cfset mode     = "window">
<cfelse>
    <cfset template = "">
	<cfset mode     = "">
</cfif>

<cfinvoke component = "Service.Access"  
    method          = "system"        
    returnvariable  = "access">	
	
<cf_tl id="Add Role" var="1">			
 
<cfset menu=ArrayNew(1)>		
<cfif access eq "ALL">	
  <cfset menu[1] = {label = "#lt_text#", script = "recordadd()"}>		  
</cfif>   
	
<cf_listing
    header         = "Role"		
    box            = "systemroles"
	link           = "#SESSION.root#/System/Access/Role/RecordListingContent.cfm?systemfunctionid=#url.systemfunctionid#"
    html           = "No"
	menu           = "#menu#"
	show           = "200"	
	width          = "100%"
	datasource     = "AppsOrganization"
	listquery      = "#myquery#"
	listkey        = "Role"
	
	listgroup      = "MenuOrder"
	listgroupfield = "MenuName"
	listgroupalias = "S"
	listgroupdir   = "ASC"	
	
	listorder      = "ListingOrder"	
	listorderalias = "S"
		
	listlayout     = "#fields#"
	filterShow     = "Yes"
	excelShow      = "Yes"
	drillmode      = "#mode#"	
	drillargument  = "700;900;true;true"	
	drilltemplate  = "#template#"
	drillkey       = "Role">