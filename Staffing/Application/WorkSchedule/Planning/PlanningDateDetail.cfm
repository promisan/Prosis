
<form method="post" name="scheduleform" id="scheduleform">

<cfoutput>
	<input type="hidden" id="currentDate" name="currentDate" value="#url.selectedDate#">
</cfoutput>

<table width="99%" height="100%" cellspacing="0" align="center" class="formpadding">

<tr><td height="5"></td></tr>

<tr>

	<cfquery name= "get" 
    	datasource= "AppsEmployee" 
	    username= "#SESSION.login#" 
		password= "#SESSION.dbpw#">    
		SELECT	* 
		FROM  	WorkSchedule
	    WHERE   Code = '#url.workschedule#'					  		
	</cfquery>	
			
	<cfquery name  = "getDate" 
    	datasource = "AppsEmployee" 
	    username   = "#SESSION.login#" 
		password   = "#SESSION.dbpw#">    
		SELECT	*
		FROM  	WorkScheduleDate D		
	    WHERE   WorkSchedule = '#url.workschedule#'					  
		AND     CalendarDate =  #url.selecteddate#	
	</cfquery>	
	
	<cfif url.selecteddate gte now()-1>
		<cfset accessmode = "edit">
	<cfelse>
		<cfset accessmode = "view">
	</cfif>
		
<cfoutput>

	<cfif accessmode eq "View" and getDate.recordcount eq "0">
	
		<td class="labelit" align="center">No schedule defined</td>
	
	<cfelse>
			
		<td colspan="2" valign="top">
					
				<table width="100%" cellspacing="0" cellpadding="0" style="border:0px dotted silver" class="formpadding navigation_table">
				
				<cfif accessmode eq "edit">
															
					<cfquery name  = "WorkClass" 
				    	datasource= "AppsEmployee" 
					    username  = "#SESSION.login#" 
						password  = "#SESSION.dbpw#">    
						SELECT	* 
						FROM  	Ref_WorkAction
					    WHERE   ActionClass IN (SELECT ActionClass
						                        FROM   Ref_WorkActionMission 
												WHERE  Mission = '#get.Mission#')	
						ORDER BY ListingOrder										  		
					</cfquery>	
					
					<cfif workclass.recordcount eq "0">
					
						<cfquery name  = "WorkClass" 
					    	datasource= "AppsEmployee" 
						    username  = "#SESSION.login#" 
							password  = "#SESSION.dbpw#">    
							SELECT	* 
							FROM  	Ref_WorkAction
							ORDER BY ListingOrder
						</cfquery>   
					
					</cfif>
								
				</cfif>							
				
				<tr class="linedotted">
					<td style="padding-left:4px" class="labelmedium"><b><cf_tl id="Schedule "> <cfoutput>(#dateformat(url.selecteddate,client.dateformatshow)#)</cfoutput>:</td>
					<td colspan="3" align="right">
						<table>
							<tr>
								<td class="labelit"><cf_tl id="Select/Unselect all"></td>
								<td style="padding-left:5px;"><input type="Checkbox" name="SelectAll" id="SelectAll" onclick="selectAllHours(this,500);"></td>
							</tr>
						</table>
						
					</td>
				</tr>
				
				<tr>	
					
					<cfset sel = 0>							
													
						<cfloop index="cnt" from="0" to="3">					
						
							<td width="25%">
							
								<table width="100%" cellspacing="0" cellpadding="0">
																						
								<!--- Kristhian adjust for the mode 60, 30, 20, 15 --->
								
								<cfif get.hourmode eq "60">								
									<cfset step = "1">
									<cfset stepto = "5">																		
								<cfelseif get.hourmode eq "30">								
									<cfset step = "0.5">
									<cfset stepto = "5.5">
								<cfelseif get.hourmode eq "20">								
									<cfset step = "0.333333333333333">
									<cfset stepto = "5.666666666666666">								
								<cfelseif get.hourmode eq "15">								
									<cfset step = "0.25">
									<cfset stepto = "5.75">								
								</cfif>								
														
								<cfloop index="hr" from="#sel#" to="#sel+stepto#" step="#step#">	
								
									<cfif int((hr - int(hr)) * 100) eq 99>
										<cfset hr = round(hr)>
									</cfif>
								
									<cfquery name="check" 
								     datasource="AppsEmployee" 
									 username="#SESSION.login#" 
									 password="#SESSION.dbpw#">    
										SELECT    *
										FROM       WorkScheduleDateHour D
										WHERE      WorkSchedule = '#url.workschedule#'					  
										AND        CalendarDate =  #url.selecteddate#	
										AND        CalendarHour = '#hr#'
									</cfquery>
									
									<cfif check.recordcount eq "1">
										<tr bgcolor="FFFF00">
									<cfelse>
										<tr>
									</cfif>												
									
									<td style="padding:1px;padding-left:4px">
									    <cfif accessmode eq "edit">
										<input type="checkbox" name="Hours" value="#hr#" <cfif check.recordcount eq "1">checked</cfif> class="clsHours" onclick="togglePositionSection(500);">
										</cfif>
									</td>
									<td style="padding:1px" class="labelit">
										<cfset hrS = Int(Abs(hr))>
										<cfset minS = (Abs(hr) - Int(Abs(hr))) * 60>
										<cfif hrS lt 10>0</cfif>#hrS#:<cfif minS lt 10>0</cfif>#minS#h
									</td>
									
																		
									<cfquery name  = "getWorkClass" 
									    datasource= "AppsEmployee" 
										username  = "#SESSION.login#" 
										password  = "#SESSION.dbpw#">    
										SELECT	* 
										FROM  	Ref_WorkAction
										WHERE   ActionClass = '#check.actionclass#'											
									</cfquery>   
									
									<td style="padding:1px;padding-right:4px" align="right" class="labelit" bgcolor="#getWorkclass.viewcolor#">		
																		
									<cfset fieldid = round(hr * 4)>
									
									<cfif accessmode eq "edit">
																											
										<select name="ActionClass_#fieldid#" class="regularx" style="height:20px;font-size:13px">
										    <option value="">--</option>
											<cfloop query="workclass">
												<option style="background-color:#viewcolor#" value="#actionClass#" <cfif check.actionclass eq actionclass>selected</cfif>>#ActionDescription#</option>									
											</cfloop>									
										</select>
									
									<cfelse>
																			
										<cfif getworkclass.recordcount eq "1">									
										#getWorkclass.actionDescription#
										<cfelse>
											<font size="1">standard</font>
										</cfif>
									
									</cfif>
									
																		
									</td>
									</tr>
									
								</cfloop>
																
								</table>
																	
							</td>
							
							<cfset sel = sel+6>
						
						</cfloop>												
															
				</tr>
															
			</table>
				
		</td>
		
		</tr>
		
		<tr>
		<td colspan="2" class="labelit" valign="top" style="padding-left:4px;border:0px dotted silver" id="positionContainer">		   
			    <cfinclude template="PlanningDateDetailPosition.cfm">		
		</td>
			
		</tr>		
			
		<cfif accessmode eq "edit">
			
			<tr><td colspan="2" class="linedotted"></td></tr>			
			<tr><td colspan="2" align="center" style="padding-top:4px">
				
				<table cellspacing="0" class="formspacing">
					<tr>
						<cfoutput>
						<td>
							<cf_tl id="Save for this date" var="vVal">
							
							<input type="button" name="Save" value="#vVal#" class="button10s" style="font-size:13px;height:26;width:230"  onclick="saveschedule('#url.workschedule#','#urlencodedformat(url.selecteddate)#','add', '#url.mission#', '#url.mandate#')">
						 								 
						</td>
						
						<td>
							<cf_tl id="Save and Inherit" var="vVal2">
							
							<input type="button" name="Save" value="#vVal2#" class="button10s" style="font-size:13px;height:26;width:230"  onclick="inheritschedule('#url.workschedule#','#urlencodedformat(url.selecteddate)#','inherit', '#url.mission#', '#url.mandate#')">
												
						</td>
						</cfoutput>
					</tr>
				</table>
			
			</td></tr>
			
			<tr><td height="3"></td></tr>
			
		</cfif>
						
	</cfif>	
	
</cfoutput>	

</table>

</form>

<cfset AjaxOnLoad("function(){ togglePositionSection(0); }")>
