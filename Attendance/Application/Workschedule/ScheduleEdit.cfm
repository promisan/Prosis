
<cfparam name="url.contractid" default="">

<cfoutput>	

<cfquery name="param" 
  	datasource="AppsEmployee" 
  	username="#SESSION.login#" 
  	password="#SESSION.dbpw#">
	      SELECT *
		  FROM   Parameter								  			 
</cfquery>

<cf_divscroll>

<table width="99%">

<tr>

	<td align="center" valign="top" id="contentbox1" style="padding-left:20px;padding-right:12px">
			
			<table width="99%" align="center">
					
			<tr>
			
			<cfquery name="last" 
			  	datasource="AppsEmployee" 
			  	username="#SESSION.login#" 
			  	password="#SESSION.dbpw#">
				      SELECT *
					  FROM   PersonWorkSchedule
					  WHERE  PersonNo = '#URL.id#'
					  AND    DateEffective IN 
					             (SELECT MAX(DateEffective) 
								  FROM   PersonWorkSchedule 
								  WHERE  PersonNo = '#URL.id#')
					  			 
			</cfquery>
			
			<cfif last.DateEffective neq "">
				<cfparam name="url.dateeffective" default="#dateformat(Last.DateEffective,client.dateformatshow)#">
			<cfelse>
			    <cfparam name="url.dateeffective" default="#dateformat(now(),client.dateformatshow)#">
			</cfif>	
			
			<cfset dateValue = "">
		    <CF_DateConvert Value="#url.dateeffective#">
		    <cfset DTE = dateValue>
				
			<cfquery name="mission" 
			  	datasource="AppsEmployee" 
			  	username="#SESSION.login#" 
			  	password="#SESSION.dbpw#">
				      SELECT *
					  FROM   Ref_ParameterMission				 				  			 
			</cfquery>		
			
			<cfif last.mission eq "">
			   <cfparam name="url.mission" default="#last.mission#">
			<cfelse>
				<cfparam name="url.mission" default="#mission.mission#">
			</cfif>
			
			<td width="90%" align="center" id="weekschedule">
			
				<table width="100%" bgcolor="FFFFFF">
								
				<tr>	
				
				<cfif url.contractid eq "">	
			
				<td style="min-width:250px;padding-left:10px;border-right:1px solid silver" valign="top">
							
					<table width="99%" class="formpadding">
					
					<cfquery name="prior" 
					  	datasource="AppsEmployee" 
					  	username="#SESSION.login#" 
					  	password="#SESSION.dbpw#">
					      SELECT   Mission, 
						           DateEffective,
								   MAX(HourSlots) as Slots,
								   COUNT(DISTINCT WeekDay) as Days, 
								   COUNT(CalendarDateHour) as Hours
						  FROM     PersonWorkSchedule
						  WHERE    PersonNo  = '#URL.id#'	
						  GROUP BY Mission, DateEffective	
						  ORDER BY DateEffective DESC			 
					</cfquery>
					
					<tr>
						<td colspan="2" align="center" style="padding-right:10px">
						
							<table class="navigation_table labelmedium" width="98%" align="center">
							
								<tr class="labelmedium line">
									<td style="padding-left:4px"><cf_tl id="Entity"></td>
									<td><cf_tl id="Effective"></td>
									<td align="right"><cf_tl id="Days"></td>
									<td align="right"><cf_tl id="Hours"></td>
								</tr>
								
								<cfloop query="prior">
								
									<cfset ratio = hours/days>
									<tr class="navigation_row labelmedium line" onclick="scheduleedit('#url.id#','#mission#','#dateFormat(DateEffective,client.dateformatshow)#')">
										<td style="padding-left:4px">#Mission#</td>
										<td>#dateFormat(DateEffective,client.dateformatshow)#</td>
										<td align="right"><cfif ratio gt param.hoursInday><font color="FF0000"></cfif>#days#</td>
										<td align="right"><cfif ratio gt param.hoursInday><font color="FF0000"></cfif>#numberformat(hours/slots,'_._')#</td>								
									</tr>		
										
								</cfloop>
							
							</table>
						
						</td>
					</tr>
												
													
					</table>
				
				</td>
				
						
			</cfif>
							
				<td valign="top">
				
					<table border="0" width="100%">
					
					    <cfif url.contractid eq "">
					
						<tr>
						
						<td colspan="8" valign="top">
						
							<table width="100%">
									
							<tr class="labelmedium" style="height:45px">			
								<td style="min-width:80px;padding-left:7px;padding-right:7px;"><cf_tl id="Entity">:</td>
								<td>				
								
								<select name="Mission" id="mission" class="regularxl" style="width:134px">
									<cfloop query="mission">
										<option value="#mission#" <cfif last.mission eq mission>selected</cfif>>#mission#</option>
									</cfloop>
								</select>				
								</td>
							
								<td style="min-width:100px;padding-left:7px;padding-right:7px"><cf_tl id="effective">:</td>
								<td style="min-width:140px;">
							
								<cfform>
							
							     <cf_intelliCalendarDate9
									FieldName="DateEffective" 
									id="dateeffective"
									Manual="True"		
									class="regularxl"					
									DateValidStart="#Dateformat(Last.DateEffective, 'YYYYMMDD')#"								
									Default="#url.dateeffective#"
									AllowBlank="False">	
									
								</cfform>
							
								</td>
											
								<cfset hourSlots = Prior.Slots>
																												
								<td style="min-width:80px;padding-left:7px;padding-right:4px"><cf_tl id="slots">:</td>
									<td>
									<select name="slots" id="slots" class="regularxl" 
									  style="width:134px" 
									  onchange="ptoken.navigate('#session.root#/Attendance/Application/WorkSchedule/ScheduleEditContent.cfm?id=#url.id#&mission=#url.mission#&dateeffective=#url.dateeffective#&slots='+this.value,'schedulecontent')">
										<option value="1" <cfif hourSlots eq "1">selected</cfif>>Full Hour</option>
										<option value="2" <cfif hourSlots eq "2" or hourslots eq "">selected</cfif>>Half Hour</option>
										<option value="3" <cfif hourSlots eq "3">selected</cfif>>20 Minutes</option>
										<!--- <option value="4" <cfif hourSlots eq "4">selected</cfif>>15 Minutes</option>	--->
									</select>
									</td>
									
								<td align="right" style="width:50%;padding-right:0px">
									<input class="button10g" style="width:100px;height:28" type="button" onclick="schedulesave()" name="Submit" id="Submit" value="Save">
								</td>
						
							</tr>
							
							</table>
									
						</td>
						
					</tr>
					
					</cfif>
					
					<tr style="height:100%">
					
					<td id="schedulecontent">
					
						<cfif last.Hourslots neq "">
							<cfset url.slots = last.HourSlots>
						</cfif>						
						
						<cfinclude template="ScheduleEditContent.cfm">
									
						
				    </td>
			
					</tr>
		
				</table>
	
			</td>
			
			</tr>
		
		</table>
	
		</td>
			
		</tr>

						<tr>
							<td align="center" width="100%">
								<table width="100">
									<tr>
										<td>
											<button onclick="javascript:ProsisUI.closeWindow('myschedule')" class="button-2019-a">Close</button>
										</td>
										<td>
											<button onclick="javascript:ProsisUI.minimizeWindow('myschedule')" class="button-2019-a">Save</button>
										</td>
									</tr>
								</table>
							</td>

						</tr>

		
		</table>
		
	</td>
		
</tr>
	
</table>

</cf_divscroll>

</cfoutput>

<cfset ajaxonload("doCalendar")>
<cfset ajaxonload("doHighlight")>
<script>
	Prosis.busy('no')
</script>

