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

<cfquery name="Org" 
		datasource="appsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM  Organization		
		WHERE OrgUnit = '#url.org#' 				
</cfquery>
			
<cfparam name="URL.ID"                default="ORG">	
<cfparam name="URL.Org"               default="#Org.OrgUnit#">		
<cfparam name="URL.ID1"               default="#Org.OrgUnitCode#">
<cfparam name="URL.Mission"           default="#Org.Mission#">
<cfparam name="URL.Mandate"           default="#Org.MandateNo#">
  
<cfparam name="URL.header"            default="Portal">
	
<cf_customLink
	FunctionClass = "Staffing"
	FunctionName  = "stPosition"
	Scroll        = "no"
	Key           = "">
	
<cfset url.lay = "listing">		


<table width="100%" align="center" border="0"><tr><td id="list">
	<cfinclude template="../../../Staffing/Application/Position/MandateView/MandateViewList.cfm">
</td></tr></table>


