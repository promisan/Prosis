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
		
<table width="98%" align="center">
		
	<cfif url.mode eq "copy">
	
		<tr>
			<td colspan="2" class="labelmedium" style="border:1px dashed #C0C0C0; background-color:#FCF57A; padding-left:8px;">
				** <cf_tl id="Select the day that you want to copy to all the days of the new schedule.">
			</td>
		</tr>
		
	</cfif>
	
	<tr>
		<td colspan="2">
				
			<cfdiv id="divPeriodicityDetail" 
			  bind="url:#session.root#/workorder/application/workOrder/serviceDetails/Schedule/ScheduleDateView.cfm?scheduleId=#url.scheduleId#&mode=#url.mode#">
			  					  
		</td>
	</tr>

</table>