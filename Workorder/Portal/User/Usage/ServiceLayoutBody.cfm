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
<cfif workorderlineid neq "">

	<cfparam name="url.mode"      default="standard">
	<cfparam name="url.Year"      default="2010">
	<cfparam name="url.Month"     default="3">
	<cfparam name="url.Reference" default="undefined">
	
	<cfquery name="get" 
	datasource="AppsWorkOrder"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT    * 
	FROM      WorkorderLine 
	WHERE     WorkorderLineId = '#url.workorderlineid#' 
	</cfquery>
	
	<cfif get.recordcount eq "1">
	
		<cfset url.workorderid   = get.workorderid>
		<cfset url.workorderline = get.workorderline>
		<cfset url.mode = "portal">
			
		<cfinclude template="../../../Application/WorkOrder/ServiceDetails/Charges/ChargesUsageDetail.cfm">
	
	<cfelse>
	
	Not found.
	
	</cfif>
	
</cfif>

<script>
   document.getElementById('calendar').className = "regular"	
</script>