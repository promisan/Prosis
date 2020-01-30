
<cfif url.scheduleid neq "">

	<table width="99%" cellspacing="0" cellpadding="0" align="center">
	
		<tr><td height="24" style="Padding-left:6px" class="labelmedium" colspan="6"><cf_tl id="Year schedule"></td></tr>		
		<tr><td colspan="6" class="line"></td></tr>		
						
			<cfquery name="scheduleactions" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    TOP 12 YEAR(ScheduleDate) AS Year, MONTH(ScheduleDate) AS Month, COUNT(*) AS Actions
				FROM      WorkOrderLineScheduleDate
				WHERE     ScheduleId = '#url.scheduleid#' 
				AND       Operational = 1
				AND       ScheduleDate > GETDATE()
				AND       Operational = 1
				GROUP BY YEAR(ScheduleDate), MONTH(ScheduleDate)
				ORDER BY YEAR(ScheduleDate), MONTH(ScheduleDate)
			</cfquery>
			
			<cfset row = "0">
			
			<cfoutput query="scheduleactions">
			
			    <cfset row = row+1>
				<cfif row eq "1"><tr></cfif>
				
				<td width="23%" style="padding-left:8px" class="labelit"><cf_tl id="#monthasstring(month)#">: </td>
			    <td width="10%" align="right" class="labelit" style="padding-right:10px">#Actions#</td>
				
				<cfif row eq "3">
				     
					 <cfset row = "0">
					 </tr><tr><td colspan="6" class="line"></td></tr>	
					 
				</cfif>
						
			</cfoutput>		
			
	</table>
	
</cfif>	