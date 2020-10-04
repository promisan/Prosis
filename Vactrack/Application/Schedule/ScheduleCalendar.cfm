
<!--- shows the information for the date as to how many are pending for that date --->
<!--- capture the selected warehouse --->

<cf_screentop jquery="yes" html="No">

<cf_calendarscript>
<cf_calendarviewscript>

  <cfquery name="get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Ref_Mission
	  WHERE  Mission = '#url.mission#'
  </cfquery>	  

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
			  
	<tr><td valign="top" style="padding-left:10px;padding-right:10px">		
	
			<cfparam name="client.selecteddate" default="#now()#">
			
			<cfif client.selecteddate lt (now()-300)>
			   <cfset client.selecteddate = now()>
			</cfif>	
			
			<cfparam name="url.selecteddate" default="#client.selecteddate#">								
								
			<cf_calendarView 
			   title          = "#get.MissionName#"	
			   selecteddate   = "#url.selecteddate#"
			   relativepath   =	"../../.."				
			   autorefresh    = "0"				   
			   preparation    = ""	    				  
			   content        = "Vactrack/Application/Schedule/ScheduleCalendarDate.cfm"			  
			   target         = "Vactrack/Application/Schedule/ScheduleCalendarList.cfm"
			   condition      = "mission=#get.mission#&systemfunctionid=#url.systemfunctionid#"		   
			   cellwidth      = "fit"
			   cellheight     = "90">
			
	</td></tr> 

</table>
 