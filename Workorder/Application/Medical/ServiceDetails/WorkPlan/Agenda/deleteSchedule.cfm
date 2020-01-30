
<!---
<cfquery name="undoWorkAction" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM WorkPlanDetail
	WHERE WorkActionId = '#url.workactionid#' 
</cfquery>
--->

<!--- we keep the history --->

<cfquery name="undoWorkAction" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE WorkPlanDetail
	SET Operational = 0
	WHERE WorkActionId = '#url.workactionid#' 
</cfquery>

<!--- we keep this action for easy replanning 
<cfset url.workactionid = "">
--->

<cfinclude template="ActivityList.cfm">

<cfoutput>
<script>
    _cf_loadingtexthtml='';
	calendarrefreshonly('#day(url.selecteddate)#','#urlencodedformat(url.selecteddate)#')
</script>
</cfoutput>