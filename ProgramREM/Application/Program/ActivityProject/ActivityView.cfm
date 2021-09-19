
<cf_tl id="Maintain Project Activity" var="1">
			
<cf_screentop height="100%" label="#lt_text#" html="yes" 
	 line="no" jQuery="Yes" option="Maintain project activity details" 
	 scroll="yes" layout="webapp" banner="blue">
		 
<!--- check access --->

<cfparam name="URL.ActivityId"  default="">
<cfparam name="URL.ProgramCode" default="">

<cfquery name="Activity" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    SELECT *
	    FROM  ProgramActivity
		WHERE ActivityId = '#URL.ActivityID#'
</cfquery>

<cfif url.activityid neq "">
	
	<cfif url.programcode eq "" or activity.programcode neq url.programcode>
		<cfset url.programCode = Activity.ProgramCode>
		<cfset url.period      = Activity.ActivityPeriod>
	</cfif>

</cfif>

<cfquery name="Program" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Program
		WHERE  ProgramCode = '#URL.ProgramCode#'
</cfquery>

<cfquery name="OrgUnit" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    SELECT Org.*
	    FROM   ProgramPeriod Pe, 
		       Organization.dbo.Organization Org
		WHERE  Pe.ProgramCode = '#URL.ProgramCode#'
		AND    Pe.Period      = '#URL.Period#' 
		AND    Pe.OrgUnit     = Org.OrgUnit 
</cfquery>

<cfinvoke component="Service.Access"  
	Method="program"
	ProgramCode="#URL.ProgramCode#"
	Period="#URL.Period#"
	ReturnVariable="ProgramAccess">	
	
<cfif ProgramAccess eq "NONE" or ProgramAccess eq "READ">

	 <cf_message message = "You have not been granted access. Operation not allowed." return = "no">
	 <cfabort>

</cfif>

<cf_FileLibraryScript>
<cf_dialogStaffing>
<cf_menuscript>
<cf_calendarscript>
<cf_dialogOrganization>
<cf_textareascript>

<cfinclude template="ActivityEditScript.cfm">		
<cfajaximport tags="cfdiv,cfform">

<cfif OrgUnit.recordcount eq "0">

 <cf_message message = "Organization Unit does not exist anymore. Operation not allowed." return = "no">
 <cfabort>
  
</cfif>

<cfquery name="Parameter" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#Program.Mission#'
</cfquery>

<cfif Parameter.recordcount eq "0">

	 <cf_message message = "Module parameters are not initialised for this site. Operation not allowed."
	  return = "no">	 
	  <cfabort>
    
</cfif>

<script>
	
	function revise(st, no) {
	
		se  = document.getElementById("Rev"+no)
		
		if ((st == "1") || (st== "0")) {
		   se.className = "Hide"
		   se.value = ""  
		   } else {
		   se.className = "Regular"
		   }
	}
	
	function hourDayHighlight(day, hour, color){
	  	$('#day_'+day).css('background-color', color);
		$('#hour_'+hour).css('background-color', color);
		$('#tdHourDay_'+hour+'_'+day).css('background-color', color);
	}
	
</script>

<style>
	.k-content { background-color: rgba(255, 255, 255, 0) !important;}
</style>

<cfif url.activityId eq "">

	<!--- new activitiy --->

	<cf_tl id="AddActivity" var="1">
	
	<!--- in the top
	<cf_screentop height="100%" label="#lt_text#" option="Maintain activity and output details"
	    jQuery="Yes"  bannerheight="50" line="no" scroll="yes" banner="blue" layout="webapp">
		--->
			
		<table width="100%" height="99%">
				
		  <tr>
		  <td style="padding:4px" id="contentbox1">			 							 
		      <cfinclude template="ActivityEdit.cfm">		  
		  </td>
		  </tr>
		  
		 </table> 
	
	<!---
	<cf_screenbottom layout="webapp">
	--->
	
<cfelse>
		
	<cfset URL.ActivityID = trim("#URL.ActivityID#")>
	
	<!--- Query returning search results for activities  --->
	<cfquery name="EditActivity" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   A.*, 
		         O.OrgUnitName, 
				 O.OrgUnitCode, 
				 O.OrgUnitClass, 
				 O.Mission, 
				 O.MandateNo		
		FROM     #CLIENT.LanPrefix#ProgramActivity A left join Organization.dbo.#CLIENT.LanPrefix#Organization O
		ON       A.OrgUnit = O.OrgUnit
		WHERE    A.ActivityID = '#URL.ActivityID#'  
	</cfquery>
	 	
		<table width="100%" height="100%" align="center" cellspacing="0" cellpadding="0">
							
			<tr><td height="30" style="padding-top:6px;padding-bottom:6px">

				<table width="97%" height="100%" align="center"><tr>
					
					<cfset ht = "54">
					<cfset wd = "54">
					
					<cfset itm= 1>				
					
								
					<cf_tl id="Activity Definition" var="1">	
						
						<cf_menutab item  = "#itm#" 
						    iconsrc       = "Action.png" 
							iconwidth     = "#wd#" 
							padding       = "2"
							class         = "highlight1"
							targetitem    = "1"
							iconheight    = "#ht#" 
							name          = "#lt_text#"
							source        = "ActivityEdit.cfm?programaccess=#programaccess#&activityid=#url.activityid#&ajax=1">		
					
					<cfif program.programclass eq "component">
						<cf_tl id="Schedule" var="1">		
						<cfset itm = itm+1>								
						<cf_menutab item  = "#itm#" 
				            iconsrc       = "Logos/Staffing/workschedule.png" 
							iconwidth     = "#wd#" 
							iconheight    = "#ht#" 
							targetitem    = "2"
							padding       = "2"
							name          = "#lt_text#"
							source        = "../ActivityProgram/ActivitySchemaEdit.cfm?mission=#program.mission#&programcode=#url.programcode#&period=#url.period#&access=#programaccess#&activityid=#url.activityid#">
					</cfif>
					
					<cf_tl id="Costing" var="1">						
					<cfset itm = itm+1>								
					<cf_menutab item  = "#itm#" 
			            iconsrc       = "Invoice.png" 
						iconwidth     = "#wd#" 
						iconheight    = "#ht#" 
						targetitem    = "2"
						padding       = "2"
						name          = "#lt_text#"
						source        = "../../Budget/Request/RequestOpen.cfm?mission=#program.mission#&programcode=#url.programcode#&period=#url.period#&access=#programaccess#&activityid=#url.activityid#">							
						
					<cf_tl id="Activity Track" var="1">	
										
					<cfset itm = itm+1>								
					<cf_menutab item  = "#itm#" 
			            iconsrc       = "Logos/WorkFlow.png" 
						iconwidth     = "#wd#" 
						iconheight    = "#ht#" 
						padding       = "2"
						targetitem    = "2"
						name          = "#lt_text#"
						source        = "ActivityEditWorkflow.cfm?access=#programaccess#&programcode=#url.programcode#&period=#url.period#&activityid=#url.activityId#">		
										
					<cf_tl id="Documents" var="1">	
										
					<cfset itm = itm+1>								
					<cf_menutab item  = "#itm#" 
			            iconsrc       = "Logos/System/Documents.png" 
						iconwidth     = "#wd#" 
						iconheight    = "#ht#" 
						padding       = "2"
						targetitem    = "2"
						name          = "#lt_text#"
						source        = "ActivityEditAttachment.cfm?access=#programaccess#&activityid=#url.activityId#">	
						
					<cf_verifyOperational module="Staffing" Warning="No">		
						
					<cfif ProgramAccess eq "ALL">
																
						<cfif Operational eq "1">		
						
							<cf_tl id="Assigned Staff" var="1">	
											
								<cfset itm = itm+1>								
								<cf_menutab item  = "#itm#" 
						            iconsrc       = "Tasks.png" 
									iconwidth     = "#wd#" 
									iconheight    = "#ht#" 
									targetitem    = "2"
									padding       = "2"
									name          = "#lt_text#"
									source        = "../ActivityPerson/Employee.cfm?access=#programaccess#&activityid=#url.activityid#">	
									
						</cfif>
										
						<cf_tl id="Cluster" var="1">	
											
						<cfset itm = itm+1>								
						<cf_menutab item  = "#itm#" 
				            iconsrc       = "Cluster.png" 
							iconwidth     = "#wd#" 
							iconheight    = "#ht#" 
							padding       = "2"
							targetitem    = "2"
							name          = "#lt_text#"
							source        = "../ActivityCluster/ClusterView.cfm?programcode=#url.programcode#&access=#programaccess#&selclusterid=#EditActivity.ActivityClusterId#&activityid=#url.activityId#">				
			
					</cfif>
					
					<cf_tl id="Progress Reported" var="1">	
							
					    <cfset itm = itm+1>						
						<cf_menutab item  = "#itm#" 
						    iconsrc       = "Progress.png" 
							iconwidth     = "#wd#" 
							iconheight    = "#ht#" 
							padding       = "2"
							targetitem    = "2"
							name          = "#lt_text#"
							source        = "ActivityProgress.cfm?mode=dialog&activityid=#url.activityId#">
							
						<cfquery name="check" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT     TOP 1 ActionCode
							FROM       PersonWorkDetail
							WHERE      ActionCode = '#URL.ActivityId#'		
						</cfquery>																
										
				    <cfif Operational eq "1" and check.recordcount gte "1">		
					
						<cf_tl id="Work recorded" var="1">
										
							<cfset itm = itm+1>				
							<cf_menutab item  = "#itm#" 
					            iconsrc       = "Logos/Program/TaskTimeLog.png" 
								iconwidth     = "#wd#" 
								targetitem    = "2"
								padding       = "2"							
								iconheight    = "#ht#" 
								name          = "#lt_text#"
								source        = "ActivityWork.cfm?activityid=#url.activityid#">			
					
					</cfif>											
							
				</tr>
				
				</table>
			
			</td>
			</tr>
											
			<tr><td height="100%" style="padding:3px">
			
				<table width="100%" height="100%" align="center" cellspacing="0" cellpadding="0">
											
					<cf_menucontainer item="1" class="regular">			
						<cfinclude template="ActivityEdit.cfm">									
					</cf_menucontainer>
													
					<cf_menucontainer item="2" class="hide"/>
									
					<cf_menucontainer item="3" class="hide">
						 <cfinclude template="../ActivityPerson/Employee.cfm"> 
					</cf_menucontainer>										
								
				</table>
				
				</td>
			</tr>
					
		</table>
			
	<cf_screenbottom layout="webapp">
	
</cfif>


