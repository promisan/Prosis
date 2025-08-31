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
<cf_screentop height="100%" label="Salary schedule #URL.ID1#" banner="gray" bannerforce="Yes" layout="webapp" band="No" jquery="Yes" scroll="No">

<cf_menuScript>

<cfoutput>
<script>

function showLocation(sch,id,comp) {

	if ($.trim($('##detailLocation_'+id).html()) == '') {
		$('##twistie_'+id).attr('src','#session.root#/images/arrowdown.gif');
		ptoken.navigate('#session.root#/Payroll/Maintenance/SalarySchedule/ScheduleEditComponentLocation.cfm?schedule='+sch+'&id='+id+'&component='+comp, 'detailLocation_'+id);
	} else {
		$('##twistie_'+id).attr('src','#session.root#/images/arrowright.gif');
		$('##detailLocation_'+id).html('');
	}
}

function toggleme(id,val) {
   if (val) {   
      document.getElementById('twistie_'+id).className = "regular"
   } else {      
      document.getElementById('twistie_'+id).className = "hide"
   }
}

function savedates(com) {
		
	se = document.getElementsByName("c"+com)
	count = 0
	date = ""
	
	while (se[count]) {
		if (date == "") { 
	 	date = se[count].value 
		} else { 
		date = date+":"+se[count].value 
		}
		count++
		}
			 	
	url = "ScheduleEditDatesSave.cfm?componentid="+com+"&dates="+date;
	ptoken.navigate(url,'i'+com)
 
}

function togglePostingMode(v, sel) {
	if ($.trim(v).toLowerCase() == 'individual') {
		$(sel).fadeIn(350);
	} else {
		$(sel).fadeOut(350);
	}
}

</script>
</cfoutput>

	<cfquery name="Get" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     SalarySchedule
		WHERE    SalarySchedule = '#URL.ID1#'
	</cfquery>
	
	<cfform style="height:100%"
	  action="ScheduleEditSubmit.cfm?idmenu=#URL.idmenu#&ID1=#URL.ID1#" method="POST" target="result">
		
		<table width="98%" height="100%" align="center" class="formpadding">	
		
		<tr class="hide"><td colspan="5"><iframe name="result" id="result" width="100%" height="100"></iframe></td></tr>
		
		<tr><td height="5"></td></tr>
			
		<tr><td height="100%">			
				
			<table width="100%" height="100%">
			
			<cfoutput>
			<tr class="line"><td height="40">
			
					<!--- top menu --->
							
					<table width="100%" border="0" align="center">		  		
									
						<cfset ht = "58">
						<cfset wd = "58">
											
						<tr>					
									
								<cf_menutab item       = "1" 
								            iconsrc    = "Logos/Payroll/Green/SalarySchedule.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											class      = "highlight1"
											name       = "General settings">		
											
								<cf_menutab item       = "2" 
								            iconsrc    = "Logos/System/Green/Entity.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											name       = "Entities">							
												
								<cf_menutab item       = "3" 
								            iconsrc    = "Logos/Payroll/Green/Staff.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											name       = "Staff Grades">						
											
								<cf_menutab item       = "4" 
								            iconsrc    = "Logos/Payroll/Green/Component.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											name       = "Set Components">			
	
								<cf_menutab item       = "5" 
								            iconsrc    = "Logos/Staffing/Green/WorkSchedule.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											name       = "Default WorkSchedule">	
																					 		
							</tr>
					</table>
			
				</td>
			 </tr>
			 </cfoutput>
			 		
			<tr><td height="100%">			   
				
				<table width="100%" 			     
					  height="100%"				 
					  align="center">	  
				 		
						<tr class="hide"><td valign="top" id="result"></td></tr>
						
						<cf_menucontainer item="1" class="regular">
						    <cfinclude template="ScheduleEditSetting.cfm">
						</cf_menucontainer>
						<cf_menucontainer item="2" class="hide">	
						    <cfinclude template="ScheduleEditMission.cfm">
						</cf_menucontainer> 
						<cf_menucontainer item="3" class="hide">	
						    <cfinclude template="ScheduleEditGrade.cfm">
						</cf_menucontainer> 
						<cf_menucontainer item="4" class="hide">			
						    <cfinclude template="ScheduleEditComponent.cfm">
						</cf_menucontainer> 	
						<cf_menucontainer item="5" class="hide">			
						    <cfinclude template="ScheduleWorkdays.cfm">
						</cf_menucontainer> 	
									
				</table>
						
			</td></tr>
			
			</table>
		
		</td>
		</tr>
			
		<tr><td colspan="1" class="line"></td></tr>
		<tr><td colspan="1" align="center" style="padding-bottom:10px">
		
		<cfquery name="Check"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM   EmployeeSalary
			WHERE  SalarySchedule = '#URL.ID1#'
		</cfquery>
		
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		<cfif check.recordcount eq "0">
			<input class="button10g" type="submit" name="Delete" value="Delete">
		</cfif>
	    <input class="button10g" type="submit" name="Update" value=" Save ">
			
		</td></tr>
			
		</table>	
			
	</cfform>	
		
<cf_screenbottom layout="webapp">				
