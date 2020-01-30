
<!--- Query returning search results --->
<cfquery name="Schedule"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Schedule S
	WHERE  ScheduleId = '#URL.ID#'
</cfquery>

<cfquery name="Host" 
	datasource="AppsInit">
	SELECT *
	FROM    Parameter P 
	WHERE   P.HostName = '#CGI.HTTP_HOST#' 
	</cfquery>

<cfoutput>
	
	<cfif schedule.operational eq "1" and 
	(Schedule.applicationserver eq host.Applicationserver 
	     or Schedule.ApplicationServer eq CGI.HTTP_HOST)>
	
	  <img src="#CLIENT.VirtualDir#/Images/Execute.png" 
	      alt="Run Selected Task" 
		  name="img8#schedule.schedulename#" 
		  style="cursor: pointer;" 
		  width="17" 
		  height="17" 
		  border="0" 
		  onClick="recordrun('#Schedule.ScheduleId#');"
		  align="absmiddle">
		  
	<cfelse>
		
		<cf_compression>	  
	
	</cfif>		
	
</cfoutput>	
