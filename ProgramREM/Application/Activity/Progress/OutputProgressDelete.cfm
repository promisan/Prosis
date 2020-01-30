
<cfparam name="URL.ProgressID" default="">

<cfquery name="DeleteProgress" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  UPDATE ProgramActivityProgress  	
	SET  RecordStatus = '9'
	WHERE ProgressId = '#URL.ProgressId#'		  
</cfquery>	

<cfoutput>
	<script>
		ColdFusion.navigate('#SESSION.root#/programrem/application/activity/progress/ActivityProgressOutput.cfm?mode=#url.mode#&mission=#url.mission#&activityid=#activityId#&fileno=#url.fileNo#','box#activityid#')
	</script>
</cfoutput>

