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
	 <cfquery name="Layout" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT    ControlId
		FROM      Ref_ReportControl R
	    WHERE     FunctionName = 'FunctionViewListing'
		AND       TemplateSQL  = 'Application'
	</cfquery>
	
	<cfif Layout.recordcount eq "0">
	
		<cf_assignid>
		
		<cfquery name="Insert" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_ReportControl
					(ControlId,
					 SystemModule, 
					 FunctionClass, 
					 FunctionName, 
					 ReportRoot,					 
					 TemplateSQL, 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName)
			 VALUES ('#rowGuid#',
			         'Roster',
			         'Reports',
					 'FunctionViewListing',					 
					 'Application',
					 'Application',
			         '#SESSION.acc#',
					 '#SESSION.last#',
					 '#SESSION.first#')
			</cfquery>	
			
			<cfquery name="Insert" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_ReportControlOutput
						(ControlId, 					 
						 DataSource, 
						 OutputClass,
						 VariableName, 
						 OutputName, 
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName) 
				 VALUES ('#rowguid#',					 
					     'appsQuery',
					     'variable',
					     'table1', 
					     'Candidates in Bucket',
					     '#SESSION.acc#',
					     '#SESSION.last#',
					     '#SESSION.first#')
			</cfquery>

	
	</cfif>
	
	 <cfquery name="Layout" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT    ControlId
		FROM      Ref_ReportControl R
	    WHERE     FunctionName = 'FunctionViewListing'
		AND       TemplateSQL  = 'Application'
	</cfquery>
	
	<cfset URL.ControlId = Layout.ControlId>
	
	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/>  

	<cfoutput>
		<script language="JavaScript">		
	  	  window.location = "#SESSION.root#/Tools/CFReport/ExcelFormat/FormatExcel.cfm?mid=#mid#&table1=#SESSION.acc#Roster_#FileNo#&controlid=#Layout.ControlId#"		 		 
		</script>
	</cfoutput>
