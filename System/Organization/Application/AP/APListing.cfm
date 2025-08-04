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

<cf_screentop height="100%" scrolll="No" html="No" jquery="Yes">

<cf_DialogProcurement>
<cf_DialogOrganization>
<cf_listingscript>

<cfquery name="Org" 
	datasource="appsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  Organization
		WHERE Orgunit = '#url.id#'	
</cfquery>

<table width="100%" height="100%">
    <tr><td height="90">
	    <cfinclude template="../UnitView/UnitViewHeader.cfm">		
	</td></tr>
	<tr><td height="90%" style="padding-left:4px;padding-right:4px" valign="top">
	
	   <!--- obtain the data --->	   
	   <cfset url.mission = "#org.mission#">
	   <cfset url.orgunit = "#url.id#">
	   <cfset url.mode    = "AP">
	  	   
	   <!--- this query from AP_AR puts data into a temporary table --->
	   <cfinclude template="../../../../Gledger/Inquiry/AP_AR/InquiryData.cfm">
	   	   
	   <!--- now we output the data table into the listing --->	   	   	   
		<cf_securediv style="height:100%" 
		   bind="url:#SESSION.root#/System/Organization/Application/AP/APListingContent.cfm?systemfunctionid=#url.systemfunctionid#&mode=#url.mode#&orgunit=#url.orgunit#&mission=#url.mission#" 
		   id="detail">
		
	</td></tr>	
</table>
