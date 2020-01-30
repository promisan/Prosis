			
<cfajaximport tags="cfform,cfdiv">

<cfparam name="URL.ajaxid"         default="">
<cfparam name="URL.presentation"   default="month">
<cfparam name="URL.day"            default="1">
<cfparam name="URL.enter"          default="0">
<cfparam name="URL.refer"          default="">

<cfif refer eq "Workflow">

	<cf_screentop height="100%" html="Yes" jquery="Yes" layout="webapp" label="Attendance">

<cfelse>

	<cf_screentop height="100%" html="No" jquery="Yes">
	
	<cfinvoke component      = "Service.Process.System.UserController"  
	    method            = "ValidateFunctionAccess"  
		SessionNo         = "#client.SessionNo#" 
		ActionTemplate    = "TimeView/View.cfm"
		ActionQueryString = "#url.id2#">	

</cfif>

<!--- open this based on the action for a workflow object --->

<cfquery name="action" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT   *
	FROM     OrganizationAction
	<cfif url.ajaxid neq "">
	WHERE    OrgUnitActionId = '#url.ajaxid#'	
	<cfelse>
	WHERE 1=0
	</cfif>
</cfquery>	

<cfif action.recordcount eq "1">
	<cfset client.timesheetdate = Action.CalendarDateStart>
<cfelse>
	<cfparam name="client.timesheetdate"   default="#now()#">
</cfif>	

<cfquery name="org" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT   *
	FROM     Organization
	WHERE    OrgUnit = '#url.id0#'	
</cfquery>	

<cfquery name="param"
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT 	 *
	FROM 	 Ref_ParameterMission
	WHERE    Mission = '#org.mission#'	
</cfquery>

<cfinvoke component      = "Service.Access"  
	    method            = "RoleAccess"  
		Mission           = "#Org.Mission#" 
		Unit              = "#Org.OrgUnit#"
		Role              = "'HROfficer','Timekeeper'"
		AccessLevel       = "'0','1','2'"
		returnvariable    = "access">	
		
<cfif access eq "DENIED" and url.refer neq "workflow">

	<table align="center"><tr><td align="center" class="labelmedium" style="font-size:20px;padding-top:70px;color:red"><cf_tl id="Sorry, but you have not been granted access to this unit"></td></tr></table>
	<cfabort>
	
</cfif>		

						
<cfoutput>
	
	<script language="JavaScript">
	
		_cf_loadingtexthtml=''; 
			
		function initbatch(val) {
		    Prosis.busy('yes')
			_cf_loadingtexthtml='';			
		    ptoken.navigate('#session.root#/Attendance/Application/TimeView/OrganizationBatch.cfm?mode='+val+'&id2=#url.id2#&id0=#URL.ID0#&ID=1','dProcessing');
		}
		
		function openview(pre) {	
			Prosis.busy('yes')
			_cf_loadingtexthtml='';	
			ptoken.open('#session.root#/Attendance/Application/TimeView/OrganizationListing.cfm?presentation='+pre+'&id2=#url.id2#&id0=#URL.ID0#','right');	
		}
		
		function showworkflow(id) {
			Prosis.busy('yes')
			_cf_loadingtexthtml='';	
			ptoken.navigate('#session.root#/Attendance/Application/TimeView/OrganizationWorkflow.cfm?ajaxid='+id,'timesheetbox');	
		
		}		
		
	</script>	
	
	<!--- edit access --->

	<cfinvoke component      = "Service.Access"  
	    method            = "RoleAccess"  
		Mission           = "#Org.Mission#" 
		Unit              = "#Org.OrgUnit#"
		Role              = "'HROfficer','Timekeeper'"
		AccessLevel       = "'1','2'"
		returnvariable    = "access">			
	
	<cf_timesheetscript>
	<cf_actionlistingscript>
	
	<cfif org.WorkSchema eq "1">	
		<cfinclude template="Propagate/ScheduleScript.cfm">		
	</cfif>
	
	<cf_layoutscript>
		 
	<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>
				
	<cf_layout attributeCollection="#attrib#">				
				
		<cf_layoutarea position="right" name="properties" minsize="270" maxsize="270" size="270" initcollapsed="yes" collapsible="true" splitter="true">	
		
			<cfinclude template="ViewProperties.cfm">
								
		</cf_layoutarea>
		
		<cf_layoutarea  position="center" name="box" style="height:100%">				
			
			<cf_divscroll overflowx="auto">
	
			<table width="100%" height="100%">
				<tr>
					<td class="clsPrintContent" height="100%">
						
						<table width="100%" height="100%" cellspacing="0" cellpadding="0">
							
							<tr class="xxxxhide"><td id="dProcessing"></td></tr>
							
							<cfif url.refer eq "Workflow">							
							     
								 <cfset session.Timesheet["Presentation"] = "month">
								 
								 <cfparam name="URL.startyear"   default="#Year(action.CalendarDateStart)#">
								 <cfparam name="URL.startmonth"  default="#Month(action.CalendarDateStart)#">
								 <cfparam name="URL.day"         default="1">										
							
							<cfelse>
																			
							<tr style="height:20px" class="clsNoPrint">
								<td valign="top" style="padding-left:15px;padding-right:15px">
															
								<table width="100%">
																			
								<tr>
								
								  <td valign="top">
								  
								 								  				  
									   <table>
									
										   <tr>
										   	 									   	   
											   <cfif url.presentation eq "month">
																						   
												   <cfparam name="URL.startyear"   default="#Year(client.timesheetdate)#">
												   <cfparam name="URL.startmonth"  default="#Month(client.timesheetdate)#">
												   <cfparam name="URL.day"         default="1">
														   
												   <cfset dateob=CreateDate(URL.startyear,URL.startmonth,1)>
												   
												    <td style="width:20px;padding-left:3px;padding-top:4px" align="right">
																										
												     <cfoutput>
														<span id="printTitle" style="display:none;">#Org.mission# <cf_tl id="Attendance"> - #dateformat(now(), CLIENT.DateFormatShow)#</span>
														
														<cf_tl id="Print" var="1">
														<cf_button2 
															mode		= "icon"
															type		= "Print"
															title       = "#lt_text#" 
															id          = "Print"					
															height		= "30px"
															width		= "30px"
															imageheight  = "24px"
															printTitle	= "##printTitle"
															printContent = ".clsPrintContent"
															printCallback="$('.clsCFDIVSCROLL_MainContainer').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','height:100%;');">
															
													</cfoutput>
												   
												   </td>
												   
												   <td align="right" style="min-width:150px;height:40px;padding-left:8px;padding-right:20px">
														<table>
														<tr>
														
														<cfif org.WorkSchema eq "1">
														
															<td><input type="button" onclick="parent.collapseArea('mybox', 'treebox');openview('rolling')" 
															    class="button10g" style="font-size:14px;width:160px;height:28px" name="Reset" value="Rolling View">
															</td>
														
														</cfif>
																											
														<cfif access eq "GRANTED">		
																																													
															<td style="padding-left:4px;"><input type="button" onclick="initbatch('reset')" class="button10g" 
															    style="font-size:14px;width:160px;height:28px" name="Reset" value="Verify and update">
															</td>
															
														</cfif>
														
														</tr>
														</table>						
													</td>		
											 		
												   <td style="width:50%;height:40px;padding-left:5px;font-size:26px;font-weight:300">#URL.ID2#: <font size="5">#Org.OrgUnitName#</td>
												   
												 <cfelse>
												 
												 	<cfset url.year  = "#Year(now())#">
													<cfset url.month = "#Month(now())#">
													<cfset url.day   = "#day(now())#">
													  													   
													<cfset dateob=CreateDate(URL.year,URL.month,URL.day)>												
													
													<td style="width:20px;padding-left:3px;padding-top:4px" align="right">
													
													     <cfoutput>
															<span id="printTitle" style="display:none;">#Org.mission# <cf_tl id="Attendance"> - #dateformat(now(), CLIENT.DateFormatShow)#</span>
															<cf_tl id="Print" var="1">
															<cf_button2 
																mode		= "icon"
																type		= "Print"
																title       = "#lt_text#" 
																id          = "Print"					
																height		= "30px"
																width		= "30px"
																imageheight  = "24px"
																printTitle	= "##printTitle"
																printContent = ".clsPrintContent"
																printCallback="$('.clsCFDIVSCROLL_MainContainer').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','height:100%;');">
														</cfoutput>
												   
												   </td>
													
													<td style="width:50%;height:40px;padding-left:5px;font-size:26px;font-weight:300">#URL.ID2#: <font size="5">#Org.OrgUnitName#</td>										     
													
													 <td style="min-width:150px;height:40px;padding-left:4px">
														<table>
														<tr>
														<td><input type="button" onclick="openview('month')" class="button10g" style="font-size:15px;width:160px;height:30px" name="Reset" value="Month view"></td>
														<td style="padding-left:5px;font-weight:200" class="labelmedium"><!--- <font color="0000A0">Refresh data reflected in below view ---></font></td>																							
														</tr>
														</table>						
													</td>
												
												</cfif>  	
											  
										   </tr>
									        
									    </table> 
								
								     </td>		    
								  </tr>		    
								</table>   
								
								</td>
							</tr>		
							
							</cfif>
							
							<cfif org.WorkSchema eq "1" and url.presentation eq "month">
							
							    <tr>
								<td><cfdiv bind="url:OrganizationAction.cfm?id0=#url.id0#&year=#url.startyear#&month=#url.startmonth#" id="statusbar"></td>
								</tr>
							
							</cfif>				
													
							<tr>
								<td valign="top" style="padding-top:1px;padding-bottom:3px;padding-left:25px;padding-right:20px" height="100%" id="timesheetbox">
								
								<cfif url.refer eq "workflow">
								
								    <cfinclude template="OrganizationWorkflow.cfm">
								
								<cfelse>
																																
									<cfif org.WorkSchema eq "1" and (action.actionstatus eq "0" or action.actionstatus eq "")>
																								
										<cf_TimeSheetView 
											label                  = "" 
											presentation           = "#url.presentation#"
											selectiondate          = "#dateob#" 
											object                 = "Unit" 
											objectkeyvalue1        = "#url.id0#"
											copyScheduleFunction   = "function(personNo, pType) { scheduleCopy(personNo, pType); }"
											removeScheduleFunction = "function(personNo) { scheduleRemove(personNo); }">
									
									<cfelse>
																		
										<cf_TimeSheetView 
											label                  = "" 
											presentation           = "#url.presentation#"
											selectiondate          = "#dateob#" 
											object                 = "Unit" 
											objectkeyvalue1        = "#url.id0#">
									
									</cfif>		
								
								</cfif>
								</td>
							</tr>					
											
						</table>
			
					</td>
				</tr>
			</table>
	
			</cf_divscroll>					
				
		</cf_layoutarea>			
	
	</cf_layout>
	
</cfoutput>

<cfset ajaxonload("doHighlight")>

<cfinclude template="Propagate/ValidatePersonSelection.cfm">

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#PersonWork">
