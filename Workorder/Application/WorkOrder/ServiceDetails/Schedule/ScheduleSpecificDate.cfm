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
<cfquery name="scheduleValues" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     WorkOrderLineScheduleDetail
		WHERE  	 ScheduleId = '#url.ScheduleId#'
		AND		 IntervalDomain = 'date'
		ORDER BY IntervalValue ASC
</cfquery>

<table width="97%" align="right">
	
	<tr>
		<td class="labelit"  width="15%"><cf_tl id="Date"></td>
		<td class="labelit" ><cf_tl id="Memo"></td>
		<td width="5%"></td>
	</tr>
	
	<tr><td class="line" colspan="3"></td></tr>
	
	<cfif scheduleValues.recordCount eq 0>
		<tr><td align="center" colspan="3" height="22" class="labelit"><cf_tl id="No dates recorded"></td></tr>	
	</cfif>
	
	<cfoutput query="scheduleValues">
		<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="">
			<td class="labelit" height="20">#dateFormat(IntervalValue,"#CLIENT.dateFormatShow#")#</td>
			<td class="labelit" >#memo#</td>
			<td align="center">
				<cf_img icon="delete" onclick="deleteDateInterval('#url.ScheduleId#',#IntervalValue#);">
			</td>
		</tr>
	</cfoutput>
	
</table>