<!--
    Copyright © 2025 Promisan B.V.

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
<!--- capture the selected warehouse --->

  <cf_screentop jquery="yes" html="No">

  <cf_calendarscript>
  <cf_calendarviewscript>
  
  <cf_listingscript>
   
  <cfoutput>

   <script>
	
	   function showdocument(vacno) {	
		  ptoken.open('#session.root#/Vactrack/Application/Document/DocumentEdit.cfm?ID=' + vacno, 'track'+vacno);
		}
					
	</script>
	
  </cfoutput>	

  <cfquery name="get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Ref_Mission
	  WHERE  Mission = '#url.mission#'
  </cfquery>	  
  
<table width="100%" height="100%">
			  
	<tr><td valign="top" style="padding-left:10px;padding-right:10px;">		
		    
	<cfif url.id eq "REC">  
	
			<cfparam name="client.selecteddate" default="#now()#">
			<cfparam name="url.hierarchycode" default="">
			
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
			   content        = "Vactrack/Application/Schedule/Recruitment/ScheduleCalendarDate.cfm"			   		  
			   target         = "Vactrack/Application/Schedule/Recruitment/ScheduleCalendarSummary.cfm"
			   condition      = "mission=#get.mission#&systemfunctionid=#url.systemfunctionid#&hierarchycode=#url.hierarchycode#"		   
			   cellwidth      = "fit"
			   cellheight     = "90">		
	
	<cfelseif url.id eq "EVT">	
	
		<cfparam name="client.selecteddate" default="#now()#">
			<cfparam name="url.hierarchycode" default="">
			
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
			   content        = "Vactrack/Application/Schedule/PersonEvent/ScheduleCalendarDate.cfm"			   		  
			   target         = "Vactrack/Application/Schedule/PersonEvent/ScheduleCalendarSummary.cfm"
			   condition      = "mission=#get.mission#&systemfunctionid=#url.systemfunctionid#&hierarchycode=#url.hierarchycode#"		   
			   cellwidth      = "fit"
			   cellheight     = "55">		
	
	</cfif>	
	</td></tr> 

</table>

 