<cfoutput>

<!--- after completion check the status --->
	
	<cfquery name="Last" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   TOP 1 *
	FROM     ScheduleLog R
	WHERE    ScheduleId = '#URL.ID#' 
	ORDER BY ProcessStart DESC
	</cfquery>
		
		
	<cfif last.actionStatus eq "9">
	  <font color="FF0000">Not completed</font>
	<!---  
	<cfelseif last.actionStatus eq "0">
		<font color="008000">Executing........</font>
	--->	
	<cfelse> 
	    <a title="open published output" href="javascript:output('#Last.ScheduleRunId#')"> 
		#dateFormat(Last.ProcessEnd,CLIENT.DateFormatShow)# - #timeFormat(Last.ProcessEnd,"HH:MM")#
		</a>
	</cfif>
	
</cfoutput>	