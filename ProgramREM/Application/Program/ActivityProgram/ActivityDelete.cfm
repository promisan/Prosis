
<cfparam name="URL.ActivityID" default="">
<cfparam name="URL.UserAccess" default="">

<cfif URL.UserAccess neq "ALL">

	<cfquery name="Progress" 
	datasource="AppsProgram" 
	username=#SESSION.login# 
	password=#SESSION.dbpw#>
	Select ProgressId
	FROM   ProgramActivity P 
	       INNER JOIN ProgramActivityOutput PO ON P.ActivityID = PO.ActivityID AND PO.RecordStatus != 9 
           INNER JOIN ProgramActivityProgress PA ON PO.OutputID = PA.OutputID AND PA.RecordStatus != 9
	WHERE  P.RecordStatus != 9 
	AND    P.ActivityID = '#URL.ActivityId#'		  		
	</cfquery>		

	<cfif #Progress.RecordCount# neq 0>			
		DELETION DENIED:  Must have Manager Access to delete Activities that contain active progress reports
	</cfif>	

<cfelse>

	<cfquery name="DeleteActivity" 
		datasource="AppsProgram" 
		username=#SESSION.login# 
		password=#SESSION.dbpw#>
		Update ProgramActivity
		    Set RecordStatus = 9
			WHERE ActivityId = '#URL.ActivityId#'		  
		</cfquery>		

		<cfoutput>

	<script language="JavaScript">
	 window.location="../ActivityProgram/ActivityView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#";
	</script>
	</cfoutput>
	
</cfif>	
