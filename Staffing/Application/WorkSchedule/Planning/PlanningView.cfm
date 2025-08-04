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

<cfparam name="url.header" default="0">

<cfif url.header eq "1">

	<cf_screentop height="100%" html="yes" label="Workschedule Manager" jquery="yes" line="no" banner="gray" layout="webapp">
	
	<cfoutput>
	<script language="JavaScript">
	
	function saveschedule(schedule,date,action) {
	
		_cf_loadingtexthtml="";		
		  ColdFusion.navigate('#session.root#/staffing/application/workschedule/planning/PlanningDateDetailSubmit.cfm?action='+action+'&selecteddate='+date+'&workschedule='+schedule,'calendartarget','','','POST','scheduleform')
		_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";
	
	}	
		
	</script>
	
	<cf_calendarviewscript>
	
	</cfoutput>

</cfif>

<cfquery name  = "workschedule" 
    datasource= "AppsEmployee" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">      				 
		SELECT   *
		FROM     WorkSchedule
		WHERE    Code = '#url.workschedule#'		
</cfquery>

<cfparam name="url.workschedule"     default="MORNING">
<cfparam name="url.mission"          default="#workschedule.mission#">
<cfparam name="url.systemfunctionid" default="">
<cfparam name="url.selecteddate"     default="#now()#">


<cfquery name  = "Mandate" 
    datasource= "AppsOrganization" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">      				 
		SELECT   *
		FROM     Ref_Mandate
		WHERE    Mission = '#url.mission#'
		ORDER BY MandateDefault DESC		
</cfquery>

<cfparam name="url.mandate"  default="#mandate.mandateno#">

<cf_divscroll>

<table width="100%" align="center" height="100%">

	<tr>
	
	<td width="20%" style="padding-left:10px;padding-right:10px" class="labelit" valign="top">
	
		<table width="100%" cellspacing="0" cellpadding="0">
		
			<tr><td height="30">

				<cfoutput>
					<table>
						<tr>						
							<td class="labellarge">#url.workschedule#</td>						
							<td class="labellarge">: #workschedule.description#</td>
						</tr>
					</table>
				</cfoutput>
			
			</td></tr>
			
			<tr><td class="line"></td></tr>
			
			<tr><td id="targetleft">
						
			    <cfset url.date = dateformat(url.selecteddate,client.dateformatshow)>
				<cfinclude template="../Create/ScheduleOrganization.cfm">
				
			</td></tr>
		
		</table>
			
	</td>
	
	<td width="85%" height="100%" valign="top" style="padding-left:3px;padding-right:10px">
			
		<table width="99%" height="99%" align="center">
		<tr><td height="100%" valign="top" style="padding-top:0px;padding-bottom:10px">
																
			<cf_calendarView 
			   title           = "Workschedule"	
			   selecteddate    = "#url.selecteddate#"
			   relativepath    =  "../../.."		
			   targetleft      = "Staffing/Application/WorkSchedule/Create/ScheduleOrganization.cfm"			
			   targetleftdate  = "Staffing/Application/WorkSchedule/Create/ScheduleOrganizationPosition.cfm"					    				  
			   content         = "Staffing/Application/WorkSchedule/Planning/PlanningDate.cfm"			  
			   target          = "Staffing/Application/WorkSchedule/Planning/PlanningDateDetail.cfm"
			   condition       = "mission=#url.mission#&mandate=#url.mandate#&workschedule=#url.workschedule#&systemfunctionid=#url.systemfunctionid#"
			   cellwidth       = "fit">
			   
		</td></tr>			   
		</table>
		   	
	</td>
	
	</tr>
		
</table>

</cf_divscroll>		   
		