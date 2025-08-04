<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
			<cf_tl id="Consult and Activity schedule" var="lblCalendarTitle">
														
			<cf_calendarView 
			   title          = "#lblCalendarTitle#"	
			   selecteddate   = "#DTS#"
			   showjump       = "0"
			   relativepath   =	"../../.."				
			   autorefresh    = "0"	
			   preparation    = ""	    				  
			   content        = "WorkOrder/Application/Medical/ServiceDetails/WorkPlan/Agenda/ActivitySummary.cfm"		
			   targetid       = "calendartarget"	
			   target         = "WorkOrder/Application/Medical/ServiceDetails/WorkPlan/Agenda/ActivityList.cfm"
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