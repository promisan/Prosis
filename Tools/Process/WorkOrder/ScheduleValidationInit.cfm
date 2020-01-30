
<cfoutput>
<script>
	ptoken.navigate('#session.root#/Tools/Process/WorkOrder/validateWorkplan.cfm?mission=#url.mission#&selecteddate='+document.getElementById('DatePlanning#url.Code#_date').value+'&datehour='+document.getElementById('DatePlanning#url.Code#_hour').value+'&dateminute='+document.getElementById('DatePlanning#url.Code#_minute').value+'&positionno='+document.getElementById('PositionNo#url.Code#').value+'&planordercode='+document.getElementById('PlanOrderCode#url.Code#').value,'result#url.Code#_content')"
</script>
</cfoutput>