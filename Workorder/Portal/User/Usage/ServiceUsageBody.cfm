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
<cfparam name="url.mission"   default="O">
<cfparam name="url.mode"      default="standard">
<cfparam name="url.Year"      default="2010">
<cfparam name="url.Month"     default="3">
<cfparam name="url.Day"       default="0">
<cfparam name="url.content"   default="">
<cfparam name="url.Reference" default="undefined">
<cfparam name="url.calldirection"  default="">

<cfif url.content eq "NonBillable">
	<cfset dbselect = "NonBillable">
<cfelse>
	<cfset dbselect = "">		
</cfif>

<cfquery name="get" 
datasource="AppsWorkOrder"
username="#SESSION.login#" 
password="#SESSION.dbpw#">		
	SELECT    * 
	FROM      WorkorderLine 
	WHERE     WorkorderLineId = '#url.workorderlineid#' 
</cfquery>
	
<table cellpadding="0" cellspacing="0" border="0" height="100%" width="100%">
	
	<tr><td valign="top" height="100%" style="padding-left:3px;padding-right:3px;padding-bottom:16px">
	
		<cfset url.workorderid   = get.workorderid>
		<cfset url.workorderline = get.workorderline>	
		<cfset url.scope         = "portal">		
																				
		<cfif reference eq "" and url.calldirection eq "">			
		    <!--- this is an assumption which might not be try --->		
			<cfset url.mode = "planned">								
		<cfelseif reference neq "undefined" or calldirection neq "">					
		    <cfset url.mode = "unplanned">				
		<cfelse>	
		    <!--- reference is undefined --->
		    <cfset url.mode = "all">								
		</cfif>				
												
		<cfinclude template="../../../Application/WorkOrder/ServiceDetails/Charges/ChargesUsageDetail.cfm">		
									
	</td>
	</tr>
	
</table>

<script>
	Prosis.busy('no')	
</script>
