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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<title>Export to Excel</title>

<cfset URL.table1   = "#SESSION.acc#Staffing">
 			
<cfquery name="Layout" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT    ControlId
	FROM      Ref_ReportControl R
    WHERE     FunctionName = 'Facttable: Staffing Table'
	AND       TemplateSQL = 'Application'
</cfquery>

<cfif Layout.recordcount eq "1">
	
	<cfset context       = "application">	
	<cfset URL.ControlId = "#Layout.ControlId#">
	<cfinclude template="../../../../Tools/CFReport/ExcelFormat/FormatExcel.cfm">  

<cfelse>

    <cf_message message = "Export has not been configured ('Staffing'). Operation aborted." 
	            return = "">
    <cfabort>
	
</cfif>
	
	
	
