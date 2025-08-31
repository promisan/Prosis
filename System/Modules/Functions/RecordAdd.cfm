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
<cfparam name="URL.ID" default="">
			
	<cfquery name="Delete" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM Ref_ReportControl
	    WHERE SystemModule is NULL
		AND OfficerUserId = '#SESSION.acc#'
	</cfquery>
			
	<cfquery name="Insert" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   INSERT INTO Ref_ReportControl 
	          (Operational, OfficerUserId, OfficerLastName, OfficerFirstName, Created)
	VALUES ('0','#SESSION.acc#', '#SESSION.last#', '#SESSION.first#', getDate())
	</cfquery>
	
	<cfquery name="Check" 
	datasource="AppsSystem" 
	maxrows=1
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT ControlId
		FROM   Ref_ReportControl
	    WHERE  SystemModule is NULL
		  AND  OfficerUserId = '#SESSION.acc#'
		ORDER BY Created DESC
	</cfquery>
	
	<cflocation url="RecordEdit.cfm?ID=#Check.ControlId#" addtoken="No">
