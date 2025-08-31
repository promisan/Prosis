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
<cfset dateValue = "">
<CF_DateConvert Value="#url.selectedDate#">
<cfset vSelectedDate = dateValue>

<cfset link = "#session.root#/workOrder/Application/WorkOrder/ServiceDetails/ServiceLinePerson.cfm?workorderline=#url.workorderline#&workorderid=#URL.workorderid#&getDefaultPerson=0">	
<table cellspacing="0" cellpadding="0" width="96%">
	<tr>
						
	<td width="99%"><cfdiv bind="url:#link#" id="#url.boxName#"/></td>
	<td width="10" style="padding-left:2px">

		<cfset vWorkSchedule = url.workSchedule>
		<cfif vWorkSchedule eq "">
			<cfset vWorkSchedule = "__NotValidWS-84111d2">
		</cfif>
		
		<cf_selectlookup
		    box        = "#url.boxName#"
			link       = "#link#"
			button     = "Yes"
			close      = "Yes"							
			icon       = "search.png"
			iconheight = "25"
			iconwidth  = "25"
			class      = "employee"
			des1       = "PersonNo"
			filter1		 = "WorkSchedule"
			filter1Value = "#vWorkSchedule#"
			filter2Value = "#dateFormat(vSelectedDate,'yyyy-mm-dd')#"
			filter3Value = "#url.workorderid#">
			
	</td>	
	</tr>
</table>