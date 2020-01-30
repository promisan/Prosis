		
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