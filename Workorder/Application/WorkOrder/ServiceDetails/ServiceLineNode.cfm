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

<cfparam name="url.OrgUnit" default="">

<cfquery name="Line" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrderLine
		 WHERE   WorkOrderLine     = '#url.workorderline#'	
		 AND     WorkOrderId       = '#url.workorderid#'
</cfquery>

<cfif url.OrgUnit neq "">
		
		<cfquery name="OrgUnit" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Organization
			WHERE  OrgUnit = '#url.orgunit#'	
		</cfquery>
	
<cfelse>
	
	<cfquery name="OrgUnit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Organization
		WHERE  OrgUnit = '#Line.OrgUnit#'	
	</cfquery>
	
</cfif>

<table width="300" cellspacing="0" cellpadding="0"><tr><td>
	
	<cfoutput query="OrgUnit">
		<input type="hidden" name="OrgUnit" id="OrgUnit" value="#OrgUnit.OrgUnit#">
		<input type="hidden" name="Name" id="Name" value="#OrgUnit.OrgUnitName#" class="regular3">			
	</cfoutput>
	
	</td>

	<td class="labelmedium" style="padding-left:3px;padding-top:1px;padding-bottom:1px;height:25px;border: 1px solid Silver">
	<cfoutput query="OrgUnit">
		#OrgUnitName#
	</cfoutput>
	</td>
	
</tr></table>
