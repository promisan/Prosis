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
<cfparam name="url.idmenu" default="">

<cfparam name="URL.ID" default="">
			
	<cfquery name="Delete" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM Ref_ReportControl
	    WHERE SystemModule is NULL
		AND   OfficerUserId = '#SESSION.acc#'
	</cfquery>
	
	<cf_assignId>
			
	<cfquery name="Insert" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   INSERT INTO Ref_ReportControl 
	          (ControlId,
			   Operational, 
			   OfficerUserId, 
			   OfficerLastName, 
			   OfficerFirstName, 
			   Created)
	  VALUES  ('#rowguid#',
		         '0',
				 '#SESSION.acc#', 
				 '#SESSION.last#', 
				 '#SESSION.first#', 
				 getDate())
	</cfquery>
		
	<cfquery name="InsertExcelInstance" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   INSERT INTO Ref_ReportControlLayout
	          (ControlId, 
			   LayoutName, 
			   TemplateReport, 
			   ListingOrder, 
			   Operational, 
			   OfficerUserId, 
			   OfficerLastName, 
			   OfficerFirstName, 
			   Created)
	VALUES  ('#rowguid#', 
	         'Export Fields to MS-Excel', 
			 'Excel', 
			 '9', 
			 '1',
			 '#SESSION.acc#', 
			 '#SESSION.last#', 
			 '#SESSION.first#', 
			 getDate())
	</cfquery>
	
	<cflocation url="RecordEdit.cfm?ID=#rowguid#" addtoken="No">
