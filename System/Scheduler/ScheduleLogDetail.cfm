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
<cfquery name="LogStepDetail" 
	datasource="appsSystem">
	SELECT *
	FROM ScheduleLogDetail  
	WHERE ScheduleRunId = '#url.idlog#'	
</cfquery>

<cfif LogStepDetail.recordcount neq "0">
	
	<cfoutput>
	
		<table width="100%">
		
			<cfloop query="LogStepDetail">
			
				<cfif stepStatus eq "9">
				  <cfset color = "FF8080">
				<cfelse>
				  <cfset color = "white">	  
				</cfif>
				<tr class="labelmedium" bgcolor="#color#" style="height:20px">
					<td width="100" align="right">#TimeFormat(StepTimeStamp,"HH:MM:SS")#:</td>
					<td width="100%" style="padding-left:10px">#StepDescription#</td>
				</tr>
				<cfif stepException neq "">
				<tr class="labelmedium"><td></td>	
					<td>#StepException#</td>
				</tr>
				</cfif>
			
			</cfloop>
	
		</table>

	</cfoutput>

</cfif>

