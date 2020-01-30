
<cfset id = url.id>

<cfparam name="url.activityid" default="">
<cfparam name="url.hour" default="">
<cfparam name="url.class" default="">

<cfoutput>

<cfquery name="workdate" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
      SELECT *
	  FROM   PersonWork S 
	  WHERE  PersonNo = '#id#'
	  AND    CalendarDate = #dte#
	  AND    TransactionType = '1'
</cfquery>

<cfquery name="hasSchedule" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT   TOP 1 *
	  FROM     PersonWorkSchedule S 
	  WHERE    PersonNo      = '#id#'
	  AND      DateEffective <= #dte#
	  ORDER BY DateEffective DESC
 </cfquery>

<cfquery name="schedule" 
  	datasource="AppsEmployee" 
  	username="#SESSION.login#" 
  	password="#SESSION.dbpw#">
      SELECT TOP 1 *
	  FROM   PersonWorkSchedule S 
	  WHERE  PersonNo = '#id#'			
	  <cfif hasSchedule.recordcount gte "1">
	  AND    DateEffective    = '#hasSchedule.dateEffective#'
	  AND    Mission          = '#hasSchedule.mission#'
	  <cfelse>
	  AND    1=0
	  </cfif>			 
	  AND    WeekDay = #dayofweek(dte)#				
</cfquery>

<cfif schedule.recordcount eq "0">

	<cfset myslots = "2">

<cfelse>		
	
	<cfquery name="prior" 
	  	datasource="AppsEmployee" 
	  	username="#SESSION.login#" 
	  	password="#SESSION.dbpw#">
	      SELECT TOP 1 *					 
		  FROM   PersonWorkDetail D
		  WHERE  PersonNo         = '#id#'
		  AND    CalendarDate     = #dte#
		  AND    TransactionType = '1'
	</cfquery>
	
	<cfif prior.recordcount gte "1">
	   <cfset myslots = prior.hourslots>			  
	<cfelse>		
	   <cfset myslots = schedule.hourslots>
	</cfif>
		
</cfif>

<cfif myslots eq "">
					
	<cf_message message="You do not have a work schedule defined on this day of the week">				
	
<cfelse>	

<table align="left" border="0" cellspacing="0" cellpadding="0">
				
<tr class="line">

	<td></td>
	<td colspan="2" class="labelit"><b><cf_tl id="Slot"></td>
	
	<cfloop index="slot" from="1" to="#myslots#">
		<td align="center"></td>
		<td align="center" class="labelit">
   			<cf_HourSlots hourslots="#myslots#" slot="#slot#" icon="Yes">			
		</td>
	</cfloop>

</tr>

 <cfquery name="parameter" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
	  FROM   Parameter 
	  WHERE Identifier = 'A'				  
  </cfquery>
  
 					
<cfloop index="hr" from="#parameter.hourstart#" to="#parameter.hourend#" step="1">

	<cfset show = "1">
			
    <cfquery name="schedule" 
  	datasource="AppsEmployee" 
  	username="#SESSION.login#" 
  	password="#SESSION.dbpw#">
      SELECT *
	  FROM   PersonWorkSchedule S 
	  WHERE  PersonNo = '#id#'
	  <cfif hasSchedule.recordcount gte "1">
	  AND    DateEffective    = '#hasSchedule.dateEffective#'
	  AND    Mission          = '#hasSchedule.mission#'
	  <cfelse>
	  AND    1=0
	  </cfif>		
	  AND    WeekDay = #dayofweek(dte)#
	  AND    CalendarDateHour = '#hr#'
	</cfquery>
			
	<cfif hasSchedule.recordcount eq "0" or Schedule.recordcount gte "0" or hr lt 0>
			
		<cfquery name="group" 
	  	datasource="AppsEmployee" 
	  	username="#SESSION.login#" 
	  	password="#SESSION.dbpw#">
	      SELECT  *
		  FROM    PersonWorkDetail 
		  WHERE   PersonNo = '#URL.id#'
		  AND     CalendarDate = #dte#
		  AND     TransactionType = '1'
		  AND     ParentHour = (SELECT TOP 1 ParentHour 
		                        FROM   PersonWorkDetail 
							    WHERE  PersonNo = '#URL.id#'
							    AND    CalendarDate = #dte#
							    AND    CalendarDateHour = '#url.hour#')
		</cfquery>
	
		<cfset grp = "">
		
		<cfloop query="group">
		  <cfif currentrow eq 1>	
		  	  <cfset grp = ":">
		  </cfif>
		  <cfset grp = "#grp#:#CalendarDateHour#"> 	
		  <cfif currentrow eq recordcount>
		      <cfset grp = "#grp#:">
		  </cfif>
		</cfloop>								
					
		<tr class="line" style="height:20px">
							
			<td valign="top" align="center" style="min-width:50px;border-right: 1px solid b0b0b0">
			   			   
				<cfif hr lt 0>
					<cfset hour = "#24+hr#">
				<cfelseif hr lt "10">
					<cfset hour = "0#hr#">
				<cfelse>
					<cfset hour = "#hr#">
				</cfif>
				
				<font size="2">#hour#</font><font size="1">:00</font>
				
			</td>
			
			<cfif hr lt "0">
				<cfset fld = "#24+hr#">
			<cfelse>
			    <cfset fld = "#hr#">
			</cfif>	
			
			<td align="center">
				<cf_space spaces="8">
				<img src="#Client.VirtualDir#/images/copy.png" width="15" height="15" alt="" border="0" style="cursor:pointer" onclick="selectall('slot_#fld#_');setcolor()">
			</td>
			
			<td align="center" style="border-right: 1px solid silver">			
				<cf_space spaces="8">
				<img src="#Client.VirtualDir#/images/clear.png" width="15" height="15" alt="" border="0" style="cursor:pointer" onclick="removeall('slot_#fld#_');setcolor()">								
			</td>	
				
			<input type="hidden" name="slots_#fld#" id="slots_#fld#" value="#myslots#">				
				
				<cfquery name="actionclass" 
			  	datasource="AppsEmployee" 
			  	username="#SESSION.login#" 
			  	password="#SESSION.dbpw#">
			      	SELECT *				 
					FROM   Ref_WorkAction 
					WHERE  ActionClass    = '#url.class#' 
				</cfquery>
				
				<cfquery name="activity" 
			  	datasource="AppsEmployee" 
			  	username="#SESSION.login#" 
			  	password="#SESSION.dbpw#">
			      	SELECT *				 
					FROM   Ref_WorkActivity 
					WHERE  ActionCode    = '#url.activityid#' 
				</cfquery>
																						
				<cfloop index="slot" from="1" to="#myslots#">
																											
					<cfquery name="slotted" 
				  	datasource="AppsEmployee" 
				  	username="#SESSION.login#" 
				  	password="#SESSION.dbpw#">
				      SELECT R.*,
					         D.ActionCode,
					         D.ActionMemo, 
							 D.ActionCode, 
							 D.LocationCode,
							 D.Leaveid,		
							 (SELECT ActionDescription 
							  FROM   Ref_WorkActivity 
							  WHERE  ActionCode = D.ActionCode) as Description,					 
							 (SELECT ActionColor 
							  FROM   Ref_WorkActivity 
							  WHERE  ActionCode = D.ActionCode) as ActionColor,
							 BillingMode,
							 ActivityPayment 						 
					  FROM   PersonWorkDetail D, 
					         Ref_WorkAction R
					  WHERE  PersonNo         = '#URL.id#'
					  AND    CalendarDate     = #dte#
					  AND    TransactionType  = '1'
					  AND    CalendarDateHour = '#hr#'
					  AND    HourSlot         = '#slot#'
					  AND    D.ActionClass    = R.ActionClass 
					</cfquery>
					
					<cfif slotted.recordcount eq "1">
					
						<cfif slotted.actionCode neq "0">													
							<cfset color = slotted.actioncolor>								
						<cfelse>													
			   			    <cfset color = slotted.viewColor> 								 							
						</cfif>	
						
					<cfelse>
					
						<cfset color = "ffffff">
						
					</cfif>		
					
					<cfset name = slotted.description>
					
					<cfif url.activityid neq "">
											
						<!--- not slotted yet, so we check if we can get a proposed slot from the activity
						selected --->
																							
						<cfquery name="SchemaSlotted" 
						  datasource="AppsProgram" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
							  SELECT    PAS.ProgramCode, 
							            PAS.ActivityPeriod, 
										PAS.ActivityId, 
										PAS.WeekDay, 
										PASS.CalendarDateHour, 
										PASS.Hourslot, 
										PASS.ActivityPayment
							  FROM      ProgramActivitySchemaSchedule AS PASS INNER JOIN
		                                ProgramActivitySchema AS PAS ON PASS.ActivitySchemaId = PAS.ActivitySchemaId
							  WHERE     ActivityId       = '#activityId#'
							  AND       Operational      = 1
							  AND       Weekday          = '#dayofweek(dte)#'
							  AND       CalendarDateHour = '#hr#'
							  -- AND  	Hourslot         = '#slot#'				  
						</cfquery>
																																				
						<cfif SchemaSlotted.recordcount eq "1">
				   			<cfset color = activity.actionColor> 								 
						<cfelse>
							<cfset color = "ffffff">
						</cfif>		
					
					</cfif>
					
					<cfset name = "">																		
					
				    <td bgcolor="#color#" id="option_#fld#_#slot#" align="center" style="width:20;padding-left:2px;padding-right:2px">
																																												
					       <!--- define all hours/slots to be preselected with the same class and memo --->
					  					  				   
					       <!--- An activity is selected to be scheduled in the interface
										1. the existing slotting, 
										2. then we go to the schema to pre-slot it --->
					   
						   <cfif url.activityid neq "">								   					   	   
						  						   						   
						   	    <!--- we check if this lslot is populated already --->
						   
						   	     <cfquery name="Preset" 
								  datasource="AppsEmployee" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								      SELECT * 
									  FROM   PersonWorkDetail
									  WHERE  PersonNo           = '#URL.ID#'
									   AND   CalendarDate       = #dte#
									   AND   TransactionType    = '1'
									   AND   CalendarDateHour   = '#hr#'
									   AND   HourSlot           = '#slot#'									   
								</cfquery>
														   
						   	    <cfif Preset.Leaveid neq "">
																
										<!--- a leave record supersedes all --->
								
								        <img src="#client.root#/images/checkmark.png?1" 
											alt="#name#" 
											style="width:15;height:15"
											style="cursor:pointer"
											border="0" 
											align="absmiddle">	
																						
								<cfelseif SchemaSlotted.recordcount gte "1">	
																																
										<input type="checkbox" 							   
										   name    = "slot_#fld#_#slot#" 
			                               id      = "slot_#fld#_#slot#"
										   onclick = "setcolor()"
										   value   = "#slot#" 
										   style   = "cursor: pointer;" checked>	
										   										   
										<input type="hidden" 							   
										   name    = "pay_#fld#_#slot#" 
					                       id      = "pay_#fld#_#slot#"								  
										   value   = "#SchemaSlotted.ActivityPayment#">	 							
									   
								<cfelse>
																																
									<input type="checkbox" 							   
										   name    = "slot_#fld#_#slot#" 
			                               id      = "slot_#fld#_#slot#"
										   onclick = "setcolor()"
										   value   = "#slot#" 
										   style   = "cursor: pointer;">	
										 										   
									<input type="hidden" 							   
										   name    = "pay_#fld#_#slot#" 
					                       id      = "pay_#fld#_#slot#"								  
										   value   = "0"
										   value   = "#Preset.ActivityPayment#">		   
										   
								</cfif>		   	   		
																
						   <!--- 2 --->				   						   
	
	                       <cfelseif url.hour neq "" and last.recordcount gte "1">
						   					   					   																
								<cfquery name="Preset" 
								  datasource="AppsEmployee" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								      SELECT * 
									  FROM   PersonWorkDetail
									  WHERE  PersonNo           = '#URL.ID#'
									   AND   CalendarDate       = #dte#
									   AND   TransactionType    = '1'
									   AND   CalendarDateHour   = '#hr#'
									   AND   HourSlot           = '#slot#'
									   AND   ActionClass        = '#last.actionclass#'
									   <cfif last.actionmemo eq "">
									   AND   (ActionMemo         = '' or ActionMemo is NULL)
									   <cfelse>
									   AND   ActionMemo         = '#last.actionmemo#'
									   </cfif>
									   <cfif last.actioncode neq "">
									   AND   ActionCode         = '#last.actioncode#'		  
									   </cfif>
								</cfquery>
																															
								<cfif Preset.recordcount eq "1">
															
									<cfif Preset.leaveid eq "">
															
									<input type="checkbox" 							   
									   name    = "slot_#fld#_#slot#" 
		                               id      = "slot_#fld#_#slot#"
									   onclick = "setcolor()"
									   value   = "#slot#" 
									   style   = "cursor: pointer;" checked>	
									   
									<input type="hidden" 							   
										   name    = "pay_#fld#_#slot#" 
					                       id      = "pay_#fld#_#slot#"								  
										   value   = "#Preset.ActivityPayment#">	
									   
									<cfelse>
									
										<img src="#client.root#/images/checkmark.png?1" 
												alt="#name#" 
												style="width:15;height:15"
												style="cursor:pointer"
												border="0" 
												align="absmiddle">	
																				
									</cfif>   
																   
								<cfelse>
															
									<cfif slotted.recordcount eq "1">
								
										<img src="#client.root#/images/checkmark.png?1" 
											onclick="javascript:ColdFusion.navigate('HourEntryFormSlotsToggle.cfm?id=slot_#fld#_#slot#&value=#slot#','option_#fld#_#slot#')" 
											alt="#name#" 
											style="width:15;height:15"
											style="cursor:pointer"
											border="0" 
											align="absmiddle">	
											
										
									<cfelse>	
										 
									 	<input type="checkbox" 							   
										   name    = "slot_#fld#_#slot#" 
			                               id      = "slot_#fld#_#slot#"
										   onclick = "setcolor()"
										   value   = "#slot#" 
										   style   = "cursor: pointer;">	
										   
										  <input type="hidden" 							   
										   name    = "pay_#fld#_#slot#" 
					                       id      = "pay_#fld#_#slot#"								  
										   value   = "#Preset.ActivityPayment#">	
																					
									   
									 </cfif>
								
								</cfif>
						
						   <cfelse>					
																					
								<cfif slotted.recordcount eq "1">
								
									<cfif slotted.leaveid eq "">
																						
										<img src="#client.root#/images/checkmark.png?1" 
										onclick="javascript:ColdFusion.navigate('HourEntryFormSlotsToggle.cfm?id=slot_#fld#_#slot#&value=#slot#','option_#fld#_#slot#')" 
										alt="#name#" 
										style="width:15;height:15"
										style="cursor:pointer"
										border="0" 
										align="absmiddle">		
									
									<cfelse>
									
										<img src="#client.root#/images/checkmark.png?1" 
										alt="#name#" 
										style="width:15;height:15"								
										border="0" 
										align="absmiddle">		
																	
									</cfif>						  
								
								<cfelse>							
																										
							   	    <input type = "checkbox" 							   
								     name       = "slot_#fld#_#slot#" 
		                             id         = "slot_#fld#_#slot#"
								     onclick    = "setcolor()"
								     value      = "#slot#" 
								     style      = "cursor: pointer;">		
									 
									<input type="hidden" 							   
									   name    = "pay_#fld#_#slot#" 
					                   id      = "pay_#fld#_#slot#"								  
									   value   = "0">	
																   
								</cfif>   
						   
						   </cfif>   
					   					
					</td>
						
					<td align="center" class="labelit">																				
						<cf_space spaces="17">									
						<cf_HourSlots hourslots="#myslots#" slot="#slot#">						
					</td>																			
										
			</cfloop>
												
		</tr>		
	
	</cfif>
							
</cfloop>	

</table>	

</cfif>	

</cfoutput>		