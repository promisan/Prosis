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
<cfparam name="url.mission" default="">
<cfparam name="url.planner" default="1">
<cfparam name="url.scope" default="filter">
<cfparam name="url.planid" default="">


<cfoutput>
	
	<cfif url.planner  eq "1">
		<cfset tReportPath = "/Custom/Kuntz/WorkOrder/WorkPlanPrint/WorkPlan.cfr">
	<cfelse>
		<cfset tReportPath = "/Custom/Kuntz/WorkOrder/DeliveryPrint/DeliveryList.cfr">	
	</cfif>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#url.dts#">
	<cfset DTS = dateValue>

	<cfset url.date = url.dts>
	
	<cfinclude template="../getTreeData.cfm">
	
	
	<cfset SESSION.DateDelivery = DTS>
	<cfset SESSION.mission = url.mission>	
	<cfset SESSION.planid = url.planid>

	<cfif url.scope eq "filter">
		<script>
			 ptoken.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id=print&ID1=#units#&ID0=#tReportPath#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes")
		</script>
	<cfelse>
		<script>
			 ptoken.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id=print&ID1=&ID0=#tReportPath#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes")
		</script>
	</cfif>

</cfoutput>
