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

<cfoutput>

<cfquery name="get" 
  datasource="AppsPayroll" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT  *
  FROM   	SalarySchedulePeriod 
  WHERE  	CalculationId   = '#URL.ID2#'
</cfquery>

<cfset url.mission = get.mission>
<cfset url.schedule = get.SalarySchedule>

<cf_layoutScript>

<cf_tl id="Payroll entitlement review" var="1">

<cf_screenTop height="100%" title="#lt_text#" systemmodule="payroll" functionclass="portal" functionname="entitlement"
             jquery="Yes" html="yes" scroll="no" layout="webapp">

<cf_layout type="border" id="mainLayout" width="100%">	
			
	<cf_layoutArea 
			name       ="left" 
			position   ="left" 
			collapsible="true"
			size       ="200"
			overflow ="scroll">				

			<table width="100%">				  
			 <tr><td style="padding-left:20px;padding-top:10px">			 			
				<cf_payrollEntitlementTreeData mission = "#URL.Mission#" schedule="#url.schedule#" systemfunctionid="#url.systemfunctionid#">														
			 </td></tr>				
			</table>		
				
	</cf_layoutArea>
			
	<cf_layoutArea 
			name="center" 
			position="center"
			overflow ="scroll">

			<iframe src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
			        name="right"
			        id="right"
			        width="100%"
			        height="99%"
					scrolling="no"
			        frameborder="0"></iframe>
			
	</cf_layoutArea>
	
</cf_layout>
	
</cfoutput>

