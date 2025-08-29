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
<cf_distributer>

<cfif master eq "1">
	
	<cfif FileStatus eq "Changed" 
	      and Line.Operational eq "1">
							
		 <cfquery name="Flow" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      Ref_EntityClassPublish
				WHERE     EntityCode = 'SysReport' 
				AND       EntityClass = '#Line.SystemModule#' 
		</cfquery>
		 	 
		 <cfif Flow.Recordcount gte "1">
		 
			  <cfquery name="SaveOldFlow" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE OrganizationObject
					SET    Operational = '0'
					WHERE  ObjectKeyValue4 = '#URL.ID#' 
			  </cfquery>
			 
			  <!--- create new instance --->
			  <cfinclude template="RecordSubmitInstance.cfm">			  
					 	 
		 <cfelse>
		 
			  <cfquery name="Reset" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE Ref_ReportControl
					SET    Operational = 0 
					WHERE  ControlId = '#URL.ID#'  
			  </cfquery>
				 
		 </cfif>
							
	</cfif>
		
	<cfquery name="Line" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT L.*
	    FROM Ref_ReportControl L
		WHERE ControlId = '#URL.ID#'
	</cfquery>

</cfif>