

<cfparam name="url.orgunit" default="0">

<cfoutput>			 
<table width="100%" height="100%">
	<tr>
		<td style="height:100%;padding-left:8px;padding-top:0px;padding-bottom:2px;padding-right:10px" align="center" id="main">
								
		    <cfparam name="client.selecteddate" default="#now()#">

			<cfif client.selecteddate lt (now()-300)>
			   <cfset client.selecteddate = now()>
			</cfif>	
			
			<cfparam name="url.selecteddate" default="#client.selecteddate#">		
			
			<cfset dateValue = "">
			<CF_DateConvert Value="#url.selecteddate#">
			<cfset DTS = dateValue>							
			<cf_tl id="Observation and Follow-up schema" var="lblCalendarTitle">
														
			<cf_calendarView 
			   title          = "#lblCalendarTitle#"	
			   selecteddate   = "#DTS#"
			   showjump       = "0"
			   relativepath   =	"../../.."				
			   autorefresh    = "0"	
			   preparation    = ""	    				  
			   content        = "WorkOrder/Application/FollowUp/ServiceDetails/WorkPlan/Agenda/ActivitySummary.cfm"		
			   targetid       = "calendartarget"	
			   target         = "WorkOrder/Application/Followup/ServiceDetails/WorkOrderLine/WorkOrderLineViewListing.cfm"
			   condition      = "mission=#url.mission#"	
			   conditionfly   = "orgunit=#url.orgunit#&positionno=#url.positionno#"	   
			   cellwidth      = "fit"
			   cellheight     = "fit"
			   showtoday 	  = "1">		
			  
			  			  
			   <!--- Removed by Kherrera: 20160603 --->
			   <!--- targetleft     = "WorkOrder/Application/Medical/ServiceDetails/WorkPlan/ActivitySelect.cfm"  --->		
		
		</td>
	</tr>
</table>
</cfoutput>	