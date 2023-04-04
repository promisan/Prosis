
	
<!--- show person, status processing color and filter on raise by me --->

<cfparam name="client.header" default="">

<cfset itm = 0>
<cfset fields=ArrayNew(1)>

<cf_tl id="No" var="vNumber">
<cfset itm = itm+1>								
<cfset fields[itm] = {label        = "#vNumber#",                   
					 field         = "EventSerialNo",	
					 search        = "text"}>	
					 

<cf_tl id="Requester" var="vOfficer">
<cfset itm = itm+1>					
<cfset fields[itm] = {label       = "#vOfficer#",	
					field         = "OfficerLastName",
					search        = "text"}>	
					
<cf_tl id="Date" var="vDate">
<cfset itm = itm+1>					
<cfset fields[itm] = {label       = "#vDate#",  					
					field         = "Created",						
					column        = "month",	
					align         = "Center",			
					formatted     = "dateformat(Created,'dd/mm/yy')",
					search        = "date"}>
					
<cf_tl id="Event" var="vEvent">
<cfset itm = itm+1>						
<cfset fields[itm] = {label      = "#vEvent#",	
					field        = "Description",					
					filtermode   = "3",    
					search       = "text"}>		
					
					
<cf_tl id="Source" var="vSource">
<cfset itm = itm+1>						
<cfset fields[itm] = {label      = "#vSource#",	
					field        = "Source",					
					filtermode   = "3",    
					search       = "text"}>										
					
<cf_tl id="Stage" var="vStage">
<cfset itm = itm+1>						
<cfset fields[itm] = {label      = "#vStage#",	
					field        = "ActionDescriptionDue",
					formatted    = "left(ActionDescriptionDue,30)",				
					filtermode   = "3",    
					search       = "text"}>							
					 
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "S", 	
                    LabelFilter   = "Status",				
					field         = "ActionStatus",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=Yellow,1=Gray,3=green"}>		
										 	

<!---	
						 
<cf_tl id="PurchaseNo" var="vPurchaseNo">
<cfset itm = itm+1>					
<cfset fields[itm] = {label        = "#vPurchaseNo#",                   
					field          = "PurchaseReference",		
					functionscript = "ProcPOEdit",
					width          = "30",	
					functionfield  = "PurchaseNo",			
					search         = "text"}>	
														

--->	

<cf_tl id="Event" var="vEvent">
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "#vEvent#",    					
					display      = "No",					
					field        = "EventId"}>		
	
	
<cftry>


<cfparam name="url.hierarchyCode" default="">

<cfquery name="getmandate"
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT   DISTINCT MandateNo
		FROM     Organization.dbo.Organization
		WHERE    Mission = '#url.mission#'		
</cfquery>	

<cf_wfpending entityCode="PersonEvent"  
      table="#SESSION.acc#wfPersonEvent" mailfields="No" IncludeCompleted="No">		
	  
<cfoutput>
	
	<!--- pass the result to the script --->
	<cfsavecontent variable="myquery">
		 SELECT I.*,V.ActionDescriptionDue, R.Description
		 FROM   Employee.dbo.PersonEvent I 
		        INNER JOIN Employee.dbo.Ref_PersonEvent R ON I.EventCode = R.Code
		        LEFT OUTER JOIN #SESSION.acc#wfPersonEvent V ON ObjectkeyValue4 = I.EventId	
		  WHERE Mission = '#url.mission#'
		  AND   DateEventDue = '#dateformat(url.selecteddate,client.dateSQL)#' 
		  AND   ActionStatus IN ('0','1','2','3')	
		  <cfif url.HierarchyCode neq "">
				AND           I.OrgUnit IN (	SELECT   OrgUnit
												FROM     Organization.dbo.Organization
												WHERE    Mission           = '#url.Mission#'
												<cfloop query="getMandate">
													AND      MandateNo         = '#MandateNo#'
													AND      HierarchyCode LIKE '#url.HierarchyCode#%'																																					
													<cfif currentrow neq recordcount>
													UNION
													</cfif>
												</cfloop>																			
											)	
				</cfif>							  	
		  
	</cfsavecontent>

</cfoutput>	  					

<table width="100%" height="100%" align="center">
<tr><td style="background-color:fafafa;height:100%;padding-left:8px;padding-right:8px;padding-bottom:6px;">
							
<cf_listing
    header        = "lsEvent_#left(URL.mission,4)#"
    box           = "lsEvent_#left(URL.mission,4)#"
	link          = "#SESSION.root#/Vactrack\application\Schedule\PersonEvent\ScheduleCalendarSummary.cfm?#cgi.query_string#&selecteddate=#url.selecteddate#"    
	show          = "100"
	datasource    = "AppsQuery"
	listquery     = "#myquery#"
	listkey       = "EventId"		
	listorder     = "ActionStatus"
	listorderdir  = "ASC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Hide"
	excelShow     = "Yes"
	cachedisable  = "Yes"	
	annotation    = "PersonEvent"
	drillmode     = "tab"
	drillargument = "920;1200;false;false"	
	drilltemplate = "Staffing/Application/Employee/Events/EventDialog.cfm?id="
	drillkey      = "EventId">
	
	<cfcatch>
	
	 <cf_message width="100%"
			height="80"
			message="An error has occurred retrieving your data <br>#CFCatch.Message# - #CFCATCH.Detail#" return="no">
	
	</cfcatch>	
	
	</td>
	</tr>
</table>		
	
</cftry>	

