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