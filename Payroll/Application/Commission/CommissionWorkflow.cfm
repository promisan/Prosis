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
<cfquery name="Get" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">												
	SELECT      *
	FROM        Organization.dbo.OrganizationAction AS A 
	WHERE       OrgUnitActionId = '#url.ajaxid#'
</cfquery>	
				
<cfquery name="org" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
	SELECT * FROM Organization.dbo.Organization WHERE OrgUnit = '#get.orgunit#'	
</cfquery>			

<cfset link = "Payroll/Application/Commission/CommissionListing.cfm?ajaxid=#url.ajaxid#&ID0=#org.OrgUnit#">
		
<cf_ActionListing 
	    EntityCode       = "OrgAction"
		EntityClass      = "Payroll"
		EntityGroup      = ""
		EntityStatus     = ""		
		Mission          = "#org.Mission#"
		OrgUnit          = "#org.OrgUnit#"
		ObjectReference  = "Miscellneous #org.OrgUnitName# #dateformat(get.CalendarDateEnd,'YYYY/MM')#"			    
		ObjectKey4       = "#URL.AjaxId#"
		AjaxId           = "#URL.AjaxId#"
		ObjectURL        = "#link#"
		Show             = "Yes"		
		Toolbar          = "Yes">