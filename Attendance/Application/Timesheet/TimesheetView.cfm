
<cfoutput>
<table width="100%" height="100%">
<tr><td style="height:100%;width:100%;overflow:hidden">
	<iframe src="#session.root#/Attendance/Application/Timesheet/TimeSheet.cfm?mode=view&id=#url.id#&caller=listing&day=#url.day#&startmonth=#url.startmonth#&startyear=#url.startyear#&adam=#url.adam#" 
	  width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>