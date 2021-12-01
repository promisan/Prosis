
<!--- define custom topics --->

<cfparam name="attributes.mission"            default = "">
<cfparam name="attributes.orgunit"            default = "">
<cfparam name="attributes.personno"           default = "">
<cfparam name="attributes.slots"              default = "1">

<cfparam name="attributes.serviceitem"        default = "">
<cfparam name="attributes.actionfulfillment"  default = "">

<cfparam name="attributes.workorderid"        default = "00000000-0000-0000-0000-000000000000">
<cfparam name="attributes.workorderline"      default = "0">
<cfparam name="attributes.customerid"         default = "">
<cfparam name="attributes.validation"         default = "No">

<cfparam name="attributes.mode"               default = "edit">  <!--- view, edit, save --->
<cfparam name="attributes.actiondatemode"     default = "">      <!--- request | planning | actual --->
<cfparam name="attributes.calendar"           default = "8">
<cfparam name="attributes.date"               default = "#dateformat(now(),client.dateformatshow)#">
<cfparam name="attributes.time"               default = "No">
<cfparam name="attributes.padding"            default = "5">

<cfquery name="GetAction" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">  
	  SELECT   A.*, ActionLines
	  FROM     Ref_Action A INNER JOIN Ref_ActionServiceItem S ON A.Code = S.Code
	  WHERE    (Mission          = '#attributes.Mission#' or Mission is NULL)	
	  AND      ServiceItem       = '#attributes.ServiceItem#'	  	  
	  AND      Operational       = 1 
	  AND      EntryMode         = 'Manual'	  
	  <cfif attributes.ActionFulFillment neq "">
	  AND      ActionFulFillment = '#attributes.actionfulfillment#'
	  </cfif>
	  ORDER BY ListingOrder	 
	  
</cfquery>

<cfoutput query="GetAction">

	<cfloop index="row" from="1" to="#ActionLines#">
	
		<cfif attributes.mode neq "Save">													
					
				<!--- Action fields --->
				<cfquery name="Action" 
				 datasource="AppsWorkOrder" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					SELECT   TOP 1 *
					FROM     WorkOrderLineAction
					WHERE    WorkOrderId   = '#attributes.workorderid#'		  
					AND      WorkOrderLine = '#attributes.workorderline#'	
					AND      ActionClass   = '#Code#'					  
					ORDER BY Created DESC					
				</cfquery>		
			
				<!--- -------------------------- --->	
				<!--- 1 of 3 ENTER REQUEST DATE- --->	
				<!--- -------------------------- --->											
										
				<cfif Attributes.actiondatemode eq "Request" or ActionRequestMode eq "0">	
								
					<tr>
				
					<td class="labelmedium" valign="top" style="padding-top:6px;padding-left:#attributes.padding#px">#Description#
									
					<cfif ActionFulFillment eq "Standard"><cf_tl id="completed by"><cfelseif ActionFulFillment eq "Schedule"><cf_tl id="requested for"><cfelse><cf_tl id="on"></cfif>:
														
					</td>
				
					<td style="z-index:#99-currentrow#; position:relative;padding-left:0px">
				
					<table>
					
					<tr>
										
						<td class="labelmedium">		
				
						<cfset val = evaluate("Action.DateTimeRequested")>
					
						<cfif attributes.mode eq "View">
						
							#dateformat(val,client.dateformatshow)#
						
						<cfelse>					
										
							<cfif Action.recordcount eq "1">
							   <cfset st = dateformat(val,"#CLIENT.DateFormatShow#")>
							<cfelse>
							   <cfset st = dateformat(now(),"#CLIENT.DateFormatShow#")>   
							</cfif>
							
							<cfif st lt now()-50>
								<cfset st = "">
							</cfif>
														
							<cfif attributes.calendar eq "8">
						
							<cf_intelliCalendarDate8
								FieldName="DateRequested#Code#_#row#" 
								Default="#st#"
								class="regularxl enterastab"
								AllowBlank="True">		
								
							<cfelse>
							
							<cf_intelliCalendarDate9
								FieldName="DateRequested#Code#_#row#" 
								Default="#st#"
								class="regularxl enterastab"
								AllowBlank="True">		
												
							</cfif>	
								
						</cfif>		
						
						</td>					
					
					</tr>
					
					</table>		
					
					</td>		
					
					</tr>		
				
				<!--- -------------------------- --->	
				<!--- 2 of 3 enter planning date --->	
				<!--- -------------------------- --->					   
				
				<cfelseif Attributes.actiondatemode eq "Planning">
										
					<tr>
							
					<td colspan="2" style="z-index:#99-currentrow#; position:relative;padding-left:0px">
				
					<table border="0">
					
					<cfif row eq "1">
					<tr>		
						<td colspan="2"></td>
						<td style="min-width:100px;height:25px;padding-top:4px;" class="labelit">#Description#<cf_tl id="Requested">:</td>
						<td style="padding-top:4px;height:25px;padding-right:4px"  class="labelit"><cf_tl id="Scheduled">:</td>				
					</tr>
					</cfif>
					
					<tr class="labelmedium" style="height:15px">
					
						<td align="right" style="padding-right:7px;min-width:25px">
																		
							<cfif row gte "2">
								<input type="checkbox" 
								   id="action#code#_#row#" 								  
								   name="action#Code#_#row#" 
								   value="3" class="radiol"
								   onchange="$('.row#code#_#row#').toggle()">					
								<cfset cl = "hide">
							<cfelse>
							    <input type="hidden" name="action#Code#_#row#" id="action#code#_#row#" value="3">		
								<cfset cl = "regular">	
							</cfif>
							
						</td>
						
						<td style="min-width:20px;padding-right:5px">#row#</td>
										
						<td class="labelmedium row#code#_#row# #cl#" style="min-width:139px;font-size:15px;padding-right:10px;padding-right:10px">		
												   																	
							<cfset val = evaluate("Action.DateTimeRequested")>
																					
							<cfif attributes.mode eq "View">
					
								#dateformat(val,client.dateformatshow)#
								
							<cfelse>	
							
								<cfif Action.recordcount eq "1" and val neq "01/01/1900">																			
								   <cfset st = dateformat(val,"#CLIENT.DateFormatShow#")>
								<cfelse>								
								   <cfset st = dateformat(now(),"#CLIENT.DateFormatShow#")>   
								</cfif>
								
								<cfif getAdministrator("*") eq "1">
														
									<cfif attributes.calendar eq "8">	
								
										<cf_intelliCalendarDate8
											FieldName="DateRequested#Code#_#row#" 
											Default="#st#"
											class="regularxl enterastab"
											AllowBlank="False">	
										
									<cfelse>
									
										<cf_intelliCalendarDate9
											FieldName="DateRequested#Code#_#row#" 
											Default="#st#"
											class="regularxl enterastab"
											AllowBlank="False">								
									
									</cfif>	
										
								<cfelse>				
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#dateformat(st,client.dateformatshow)#</b>					
								</cfif>	
								
							</cfif>	
							
						</td>					
																						
						<td class="row#code#_#row# #cl#" style="font-size:15px;padding-right:4px">													
																		
							<cfif attributes.mode eq "View">
							
							<cfelse>
													
								<cfparam name="attributes.selecteddate" 
								       default="#dateformat(now(),client.dateformatshow)#">
									   
								<CF_DateConvert Value="#attributes.selecteddate#">
								<cfset DTS = dateValue>							
															
								<cfquery name="Position" 
								 datasource="AppsEmployee" 
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
									SELECT   DISTINCT P.PositionNo, 
									         P.FunctionDescription, 
											 Pe.PersonNo, 
											 Pe.LastName, 
											 Pe.FirstName
								    FROM     Position P INNER JOIN
								             PersonAssignment PA ON P.PositionNo = PA.PositionNo INNER JOIN
								             Person Pe ON PA.PersonNo = Pe.PersonNo
									<cfif attributes.orgunit neq "">		 
								    WHERE    P.OrgUnitOperational = '#attributes.orgunit#' 
									<cfelse>
									WHERE    P.MissionOperational = '#attributes.mission#' 						
									</cfif>
													
									<!--- not needed a assignment rules
									AND      P.DateEffective   <= #dts+30# 
									AND      P.DateExpiration  >= #dts# 
									 --->
									 
									AND      PA.Incumbency = 100 
									AND      PA.AssignmentStatus IN ('0','1')
									
									<!--- is indeed working in that period --->
									AND      PA.DateEffective  <= #dts+30# 
									AND      PA.DateExpiration >= #dts#
									
									<!--- this position is enabled in one of the schedules --->
								 	
									AND      P.PositionNo IN ( SELECT   WSP.PositionNo
														       FROM     WorkSchedulePosition AS WSP 
														       WHERE    WSP.PositionNo = P.PositionNo 
															   AND      WSP.CalendarDate >= #dts#
															 )	
									
								</cfquery>		
								
								<cfif Position.recordcount eq "0">
									
									<cfquery name="Position" 
									 datasource="AppsEmployee" 
									 username="#SESSION.login#" 
									 password="#SESSION.dbpw#">
										SELECT   DISTINCT P.PositionNo, 
										         P.FunctionDescription, 
												 Pe.PersonNo, 
												 Pe.LastName, 
												 Pe.FirstName
									    FROM     Position P INNER JOIN
									             PersonAssignment PA ON P.PositionNo = PA.PositionNo INNER JOIN
									             Person Pe ON PA.PersonNo = Pe.PersonNo
									    <cfif attributes.orgunit neq "">		 
									    WHERE    P.OrgUnitOperational = '#attributes.orgunit#' 
										<cfelse>
										WHERE    P.MissionOperational = '#attributes.mission#' 						
										</cfif>
														
										<!--- not needed a assignment rules
										AND      P.DateEffective   <= #dts+30# 
										AND      P.DateExpiration  >= #dts# 
										 --->
										 
										AND      PA.Incumbency = 100 
										AND      PA.AssignmentStatus IN ('0','1')
										
										<!--- is indeed working in that period --->
										AND      PA.DateEffective  <= #dts+30# 
										AND      PA.DateExpiration >= #dts#
												
									</cfquery>		
								
								</cfif>	
																					
								<select class="regularxl" name="PositionNo#Code#_#row#" id="PositionNo#Code#_#row#" onchange="<cfif attributes.time eq 'Yes'>_cf_loadingtexthtml='';document.getElementById('result#Code#_#row#').click()</cfif>">
									<cfloop query="Position">
										<option value="#PositionNo#" <cfif attributes.personno eq personno>selected</cfif>>#LastName#, #FirstName#</option>					
									</cfloop>
								</select>	 
												
							</cfif>
						
						</td>
						
						<td class="labelmedium row#code#_#row# #cl#" style="font-size:15px;padding-right:6px;min-width:139px">
												  																				
						    <!--- ---------------------------------------------- ---> 
						    <!--- attention this field has to be sync with
							
							  the workplan field if workplan is applicable       --->
							<!--- ---------------------------------------------- --->  
											
							<cfset val = evaluate("Action.DateTimePlanning")>
							
							<cfif attributes.mode eq "View">
					
								#dateformat(val,client.dateformatshow)# #timeformat(val,"HH:MM")#
								
							<cfelse>								
							    
								<cfif Action.recordcount eq "1">
								   <cfset val = dateformat(val,"#CLIENT.DateSQL#")>
								   <cfset stDT = val>
								<cfelse>	
								   <cfset stDT = dateformat(attributes.date,"#CLIENT.DateFormatShow#")>   
								</cfif>
																																																	
								<cfif attributes.time eq "Yes">
																								
									<cf_securediv id="_woaf_datetime#code#_#row#" 
									  bind="url:#session.root#/tools/process/workOrder/WorkOrderActionFields_Datetime.cfm?applyid=result#Code#_#row#&code=#code#_#row#&val=#stDT#&positionNo={PositionNo#Code#_#row#}">
								
								<cfelseif attributes.calendar eq "8">	
							
									<cf_intelliCalendarDate8
										FieldName="DatePlanning#Code#_#row#" 
										Default="#st#"
										class="regularxl enterastab"
										AllowBlank="False">	
									
								<cfelse>
															
									<cf_intelliCalendarDate9
										FieldName="DatePlanning#Code#_#row#" 
										Default="#st#"
										class="regularxl enterastab"
										AllowBlank="False">	
															
								</cfif>	
									
							</cfif>		
						
						</td>
																		
						<cfif attributes.time eq "Yes">
						
							<td title="Slots to be set" class="labelmedium row#code#_#row# #cl#">
							
							<select class="regularxl" name="Slots#Code#_#row#" id="Slots#Code#_#row#" onchange="<cfif attributes.time eq 'Yes'>_cf_loadingtexthtml='';document.getElementById('result#Code#_#row#').click()</cfif>">
								<cfloop index="itm" from="1" to="24">
									<option value="#itm#" <cfif attributes.slots eq itm>selected</cfif>>#itm#</option>					
								</cfloop>
							</select>								
							
							</td>
						
							<td style="padding-left:3px" class="labelmedium row#code#_#row# #cl#">		
							
							 <cf_tl id="Check" var="1"> 
																						
							<input type="button" value="#lt_text#" style="width:70px"
							   class="button10g" id="result#Code#_#row#" 
							   onclick="_cf_loadingtexthtml='';ptoken.navigate('#session.root#/Tools/Process/WorkOrder/validateWorkplanInit.cfm?customerid=#attributes.customerid#&mission=#attributes.mission#&code=#Code#_#row#','result#Code#_#row#_content')">
							</td>		
										
							<td id="result#Code#_#row#_content" style="min-width:25px;padding-left:3px;padding-right:3px" class="labelmedium row#code#_#row# #cl#"></td>
						
						</cfif>			
												
						<!--- PlanOrder --->
						<cfquery name="PlanOrder" 
						 datasource="AppsWorkOrder" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							SELECT   *
							FROM     Ref_PlanOrder
							ORDER BY ListingOrder
						</cfquery>		
											
						<td class="row#code#_#row# #cl#" style="font-size:15px;padding-left:4px">
						
							<select class="regularxl" 
							   onchange="<cfif attributes.time eq 'Yes'>document.getElementById('result#Code#_#row#').click()</cfif>" 
							   id="PlanOrderCode#Code#_#row#" 
							   name="PlanOrderCode#Code#_#row#">
								<cfloop query="PlanOrder">
									<option value="#Code#">#Description#</option>
								</cfloop>
							</select>
						
						</td>
						
						<!--- Location --->
						<cfquery name="Location" 
						 datasource="AppsWorkOrder" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							SELECT   *
							FROM     Location
							WHERE    Mission = '#mission#'
							AND      LocationId IN (SELECT LocationId FROM LocationServiceItem WHERE ServiceItem = '#attributes.serviceItem#')
							ORDER BY ListingOrder
						</cfquery>		
						
						<cfif Location.recordcount eq "0">
						
							<cfquery name="Location" 
							 datasource="AppsWorkOrder" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								SELECT   *
								FROM     Location
								WHERE    Mission = '#mission#'
								ORDER BY ListingOrder
							</cfquery>		
						
						</cfif>
											
						<td class="row#code#_#row# #cl#" style="font-size:15px;padding-left:4px">
						
							<select class="regularxl" 
							   onchange="<cfif attributes.time eq 'Yes'>document.getElementById('result#Code#_#row#').click()</cfif>" 
							   id="LocationId#Code#_#row#" 
							   name="LocationId#Code#_#row#">
								<cfloop query="Location">
									<option value="#LocationId#">#LocationName#</option>
								</cfloop>
							</select>
						
						</td>
						
															
					
					</tr>
									
					</table>
													
					</td>					
					
					</tr>		
					
					<tr><td style="height:1px" class="line" colspan="13"></td></tr>		
					
				<cfelseif Attributes.actiondatemode eq "Actual">										
																						
					<tr class="labelmedium">	
					
						<td style="padding-left:5px;padding-right:18px">#Description# <cf_tl id="Requested">:</td>		
						<td class="labelmedium" style="font-size:15px;padding-right:10px;padding-right:10px">										
						
						<cfset val = evaluate("Action.DateTimeRequested")>
						
						<cfif attributes.mode eq "View">
					
								#dateformat(val,client.dateformatshow)#		
								
						<cfelse>		
																	
							<cfif Action.recordcount eq "1">										
							   <cfset st = dateformat(val,"#CLIENT.DateFormatShow#")>						  
							<cfelse>
							   <cfset st = dateformat(now(),"#CLIENT.DateFormatShow#")>   
							</cfif>
						
							<cfif SESSION.isAdministrator eq "1">	
							
								<!--- also show other fields --->		
								
								<cfif attributes.calendar eq "8">	
							
									<cf_intelliCalendarDate8
										FieldName="DateRequested#Code#_#row#" 
										Default="#st#"
										class="regularxl enterastab"
										AllowBlank="False">	
									
								<cfelse>
								
									<cf_intelliCalendarDate9
										FieldName="DateRequested#Code#_#row#" 
										Default="#st#"
										class="regularxl enterastab"
										AllowBlank="False">							
								
								</cfif>	
								
							<cfelse>				
							
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#dateformat(st,client.dateformatshow)#</b>
							
							</cfif>	
							
						 </cfif>	
							
						</td>	
						
					</tr>
						
					<tr class="labelmedium">								
						
						<td valign="top" style="padding-left:5px;padding-top:6px;padding-right:4px">#Description#<cf_tl id="Scheduled">:</td>
													
						<td valign="top" style="padding-top:4px;font-size:15px;padding-right:10px;padding-right:10px">
						
							 <table cellspacing="0" cellpadding="0"><tr><td valign="top">
							
								<cfset val = evaluate("Action.DateTimePlanning")>
								
								<cfif attributes.mode eq "View">
						
									#dateformat(val,client.dateformatshow)#		
									
								<cfelse>		
								
									<cfif Action.recordcount eq "1">
									   <cfset st = dateformat(val,"#CLIENT.DateFormatShow#")>
									<cfelse>
									   <cfset st = dateformat(now()+1,"#CLIENT.DateFormatShow#")>   
									</cfif>
									
									<cfif SESSION.isAdministrator eq "1">	
									
										<cfif attributes.calendar eq "8">			
									
											<cf_intelliCalendarDate8
												FieldName="DatePlanning#Code#_#row#" 
												Default="#st#"
												class="regularxl enterastab"
												AllowBlank="False">	
											
										<cfelse>
										
											<cf_intelliCalendarDate9
												FieldName="DatePlanning#Code#_#row#" 
												Default="#st#"
												class="regularxl enterastab"
												AllowBlank="False">									
										
										</cfif>	
											
									<cfelse>	
													
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#dateformat(st,client.dateformatshow)#</b>					
											
									</cfif>	
											
								</cfif>
								
								</td>					
																					
							<cfif ActionFulfillment eq "WorkPlan" and attributes.mode eq "Edit">				
							
							    <td valign="top" style="padding-left:10px;padding-top:7px;padding-right:10px"class="labelmedium"><img src="#session.root#/Images/Logos/WorkOrder/Planner/WorkPlan.png" alt="" border="0"></td>							
								<td valign="top" style="padding-left:10px">
																																												
									<cfdiv id="workplan" 
									  bind="url:#session.root#/WorkOrder/Application/Delivery/Planner/WorkPlan.cfm?action=embed&workactionid=#action.workactionid#&dts={DatePlanning#Code#_#row#}&mission=#url.mission#">					
									
								</td>													
								
							<cfelseif ActionFulfillment eq "Schedule" and attributes.mode eq "Edit">						
							
								<td valign="top" style="padding-left:10px;padding-top:7px;padding-right:10px"class="labelmedium"><img src="#session.root#/Images/arrowright.gif" alt="" width="13" height="13" border="0"></td>							
								<td valign="top" style="padding-left:10px">																					
									<cf_tl id="Schedule" var="qSchedule">															
								</td>							
							
							</cfif>	
																				
							</tr>
							</table>
						</td>
											
						</tr>							
						
						<tr>		
						
						<td style="padding-left:5px;padding-right:4px"  class="labelmedium">#Description# Completed:</td>
									
						<td style="font-size:15px;padding-right:10px;padding-right:10px">
						
							<cfset val = evaluate("Action.DateTimeActual")>
							
							<cfif attributes.mode eq "View">
					
								#dateformat(val,client.dateformatshow)#		
								
							<cfelse>			
							
								<cfif Action.recordcount eq "1">
								   	<cfset st = dateformat(val,"#CLIENT.DateFormatShow#")>
								<cfelse>
								    <cfset st = dateformat(now(),"#CLIENT.DateFormatShow#")>   
								</cfif>
								
								<cfif attributes.calendar eq "8">	
																
									<cf_intelliCalendarDate8
										FieldName="DateActual#Code#_#row#" 
										Default="#st#"
										class="regularxl enterastab"
										AllowBlank="False">	
									
								<cfelse>
								
									<cf_intelliCalendarDate9
										FieldName="DateActual#Code#_#row#" 
										Default="#st#"
										class="regularxl enterastab"
										AllowBlank="False">	
								
								</cfif>	
									
							</cfif>		
														
						</td>
					
					</tr>
									
			</cfif>
					
		<cfelse>
		
			<!--- ------------------------------- --->
			<!--- ------------ saving ----------- --->
			<!--- ------------------------------- --->		
			
			<cfparam name="FORM.Action#Code#_#row#" default="0">	
			<cfset doit   = Evaluate("FORM.Action#Code#_#row#")>				
						
			<cfif doit eq "3">
			
				<cfquery name="Check" 
					 datasource="AppsWorkOrder" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					  SELECT *
					  FROM   WorkOrderLineAction						 
					  WHERE  WorkOrderId      = '#attributes.workorderid#'		  
					  AND    WorkOrderLine    = '#attributes.workorderline#' 
					  AND    ActionClass      = '#code#' 		 
				</cfquery>		
				
				<cf_getLocalTime Datasource="AppsWorkOrder" Mission="#attributes.mission#">
				
			    <cfparam name="FORM.DateMemo#Code#_#row#" default="">		
				<cfset memo  = Evaluate("FORM.DateMemo#Code#_#row#")>
								
				
				<!--- -------------------------------------------------------------------------------------------------- --->
				<!--- Requested date ----------------------------------------------------------------------------------- --->
				<!--- -------------------------------------------------------------------------------------------------- --->
				
				<cfparam name="FORM.DateRequested#Code#_#row#" default="">	
				<cfset dateValue = "">
				<cfset rdte      = Evaluate("FORM.DateRequested#Code#_#row#")>	
				<CF_DateConvert Value="#rdte#">	
				<cfset rdte      = datevalue>	
						
				<!--- -------------------------------------------------------------------------------------------------- --->
				<!--- Iinherts from Planning by default in case it is not defined but only for data entry--------------- --->
				<!--- -------------------------------------------------------------------------------------------------- --->
				
				<cfif check.recordcount eq "0" or check.DateTimePlanning eq "">
				
					<cfif rdte neq "">				
						<cfparam name="FORM.DatePlanning#Code#_#row#" default="#dateformat(rdte,client.dateformatshow)#">	
					<cfelse>
						<cfparam name="FORM.DatePlanning#Code#_#row#" default="#dateformat(now(),client.dateformatshow)#">	
					</cfif>			
						
				<cfelse>
				
					<!--- we get the existing planning date --->						
					<cfparam name="FORM.DatePlanning#Code#_#row#" default="#dateformat(check.DateTimePlanning,client.dateformatshow)#">	
						
				</cfif>		
							
				<!--- -------------------------------------------------------------------------------------------------- --->
				<!--- PLANNING date ------------------------------------------------------------------------------------ --->
				<!--- -------------------------------------------------------------------------------------------------- --->
				
				<cfset dateValue   = "">
				<cfset caller.setworkplan = "0">
				
				<cftry>		
				
					<cfset pdte   = Evaluate("FORM.DatePlanning#Code#_#row#_date")>
					<CF_DateConvert Value="#pdte#">
					<cfset pdte = datevalue>					
					<cfset hour  = Evaluate("FORM.DatePlanning#Code#_#row#_hour")>
					<cfset pdte  = DateAdd("h",  hour,  pdte)>
					<cfset minu  = Evaluate("FORM.DatePlanning#Code#_#row#_minute")>
					<cfset pdte  = DateAdd("n",  minu,  pdte)>
					
					<cfparam name="FORM.PositionNo#Code#_#row#" default="">				
					<cfset pos  = Evaluate("FORM.PositionNo#Code#_#row#")>
					
					<cfparam name="FORM.PlanOrderCode#Code#_#row#" default="">				
					<cfset pln  = Evaluate("FORM.PlanOrderCode#Code#_#row#")>
					
					<cfparam name="FORM.LocationId#Code#_#row#" default="00000000-0000-0000-0000-000000000000">				
					<cfset loc  = Evaluate("FORM.LocationId#Code#_#row#")>
											
					<cfif pos neq "">				
						<cfset caller.setworkplan = "1">				
					</cfif>			
														
					<cfcatch>
					
						<cfset pdte   = Evaluate("FORM.DatePlanning#Code#_#row#")>
						<CF_DateConvert Value="#pdte#">
						<cfset pdte = datevalue>					
								
					</cfcatch>
					
				</cftry>	
							
				<!--- -------------------------------------------------------------------------------------------------- --->
				<!--- ACTUAL DATE -------------------------------------------------------------------------------------- --->
				<!--- -------------------------------------------------------------------------------------------------- --->
				
				<cfparam name="FORM.DateActual#Code#_#row#" default="">	
				<cfset adte   = Evaluate("FORM.DateActual#Code#_#row#")>
				<cfset dateValue = "">
				<cfif adte neq "">
					<CF_DateConvert Value="#adte#">
					<cfset adte = datevalue>
				<cfelse>
					<cfset adte = "NULL">
				</cfif>			
										
				<cfquery name="Prior" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT  * 
					  FROM    WorkOrderLineAction
					  WHERE   WorkOrderId   = '#attributes.workorderid#'		  
					  AND     WorkOrderLine = '#attributes.workorderline#'
					  AND     ActionClass   = '#code#' 		
				</cfquery>		
				
				<cfif Prior.recordcount eq "0" or actionLines gte "2">
				
				    <cf_assignid>
					
					<cfquery name="InsertAction" 
					  datasource="AppsWorkOrder" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  					  
					      INSERT INTO WorkOrderLineAction
						 		 (WorkActionId,
								  WorkOrderId,
								  WorkOrderLine, 
								  ActionClass,
								  DateTimeRequested,
								  DateTimePlanning, 
								  DateTimeActual,	
								  ActionMemo,						
								  OfficerUserId,
								  OfficerLastName,
								  OfficerFirstName)
						  VALUES ('#rowguid#',
						          '#attributes.workorderid#',
						          '#attributes.workorderline#',
								  '#Code#',
								   #rdte#,		
								   <cfif ActionRequestMode eq "0">
									   #rdte#,
									   #rdte#,
								   <cfelse>
									   #pdte#,
									   #adte#,
								   </cfif>
								  '#memo#',					 
								  '#SESSION.acc#',
								  '#SESSION.last#',
								  '#SESSION.first#')	 
								  
					</cfquery>	
					
					<cfquery name="WorkOrder" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT  *
					    FROM    WorkOrder W, WorkOrderLine WL
						WHERE   W.Workorderid    = WL.WorkorderId
						AND     W.WorkOrderId    = '#attributes.workorderid#'		  
					    AND     WL.WorkOrderLine = '#attributes.workorderline#'								
					</cfquery>
					
					<cfquery name="ServiceItem" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT  *
					    FROM    ServiceItem
						WHERE   Code = '#workorder.serviceItem#'									
					</cfquery>
					
					<cfquery name="CheckClass" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   Ref_ActionServiceItem
						WHERE  Code          = '#code#'
						AND    Serviceitem   = '#workorder.serviceitem#'	
						<!--- has a published class --->		
						AND    EntityClass IN (SELECT EntityClass 
						                       FROM   Organization.dbo.Ref_EntityClassPublish
											   WHERE  EntityCode = 'WorkOrder')
					</cfquery>		
								
				    <cfif checkClass.recordcount gte "1">	
				
						<cfquery name="Action" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT  *
						    FROM    Ref_Action
							WHERE   Code  = '#code#'						
						</cfquery>		
						
						<cfquery name="Domain" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT  *
						    FROM    Ref_ServiceItemDomain
							WHERE   Code = '#ServiceItem.ServiceDomain#'									
						</cfquery>
										
						<cf_stringtoformat value="#workorder.reference#" format="#domain.DisplayFormat#">	
															
						<cfset link = "WorkOrder/Application/WorkOrder/ServiceDetails/Action/WorkActionView.cfm?drillid=#rowguid#">			
										
						<cf_ActionListing 
						    EntityCode       = "WorkOrder"
							EntityClass      = "#CheckClass.EntityClass#"
							EntityGroup      = "#domain.code#"
							EntityStatus     = ""
							Mission          = "#workorder.mission#"						
							ObjectReference  = "#Serviceitem.Description#: #val#"
							ObjectReference2 = "#Action.description#" 					  
							ObjectKey4       = "#rowguid#"				
							ObjectURL        = "#link#"
							Show             = "No">					
								
					</cfif>
								
					<!--- if we have a schedule record 
									we now also create the workplan --->
										
					<cfquery name="afterPost" 
					  datasource="AppsWorkOrder" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						  SELECT  * 
						  FROM    WorkOrderLineAction
						  WHERE   WorkActionId = '#rowguid#'					 
					</cfquery>			
		
				<cfelse>
						
					<cfquery name="Update" 
					  datasource="AppsWorkOrder" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						  UPDATE WorkOrderLineAction
						  SET    <cfif rdte neq "NULL">
						         DateTimeRequested = #rdte#, 
								 </cfif>	
						         <cfif ActionRequestMode eq "0">						 
						         DateTimePlanning  = #rdte#,
								 DateTimeActual    = #rdte#
								 <cfelse>
								 DateTimePlanning  = #pdte#,
								 DateTimeActual    = #adte#
								 </cfif>
								
		 				  WHERE  WorkOrderId       = '#attributes.workorderid#'		  
						   AND   WorkOrderLine     = '#attributes.workorderline#' 
						   AND   ActionClass       = '#code#' 		 
					</cfquery>	
								
					<!--- plan date edit validation --->
					
					<cfif ActionRequestMode eq "1">				
								
						   <!--- plan date lies before actual date --->								
						   <cfif datediff("d",  localtime,  pdte) lt "0" 				   
						   <!--- and determine if planning was also changed --->
						   and datediff("d",  prior.datetimeplanning,  pdte) neq "0"				   
						   <!--- determine if we do not have an actual date here which would allow it to be done --->
						   and not isValid("date",adte)>
						   
						   <!--- ----------------------------------------------- --->
						   <!--- also to be added if the actual date is recorded --->
						   <!--- ----------------------------------------------- --->
						   		   		
							<script>
								alert("A activity planning date needs to have either today's date or a date into the (near) future !")
							</script>
							
							<cfabort>
							
						</cfif>
					
					</cfif>		
					
					<cfquery name="afterPost" 
					  datasource="AppsWorkOrder" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						  SELECT  * 
						  FROM    WorkOrderLineAction
						  WHERE   WorkOrderId   = '#attributes.workorderid#'		  
						  AND     WorkOrderLine = '#attributes.workorderline#'
						  AND     ActionClass   = '#code#' 		
						  ORDER BY Created DESC
					</cfquery>	
				  
				    <cfif afterPost.DateTimeRequested neq Prior.DateTimeRequested or 
				  	      afterPost.DateTimePlanning  neq Prior.DateTimePlanning or
						  afterPost.DateTimeActual    neq Prior.DateTimeActual>
						  
						  <cfquery name="Log" 
						  datasource="AppsWorkOrder" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
							  SELECT   TOP 1 * 
							  FROM     WorkOrderLineActionLog
							  WHERE    WorkActionId = '#Prior.WorkActionId#'
							  ORDER BY AmendmentNo DESC				
						  </cfquery>	
						  
						  <cfif log.recordcount gte "1">
						  		<cfset no = log.AmendmentNo+1>
						  <cfelse>
						  		<cfset no = "1">
						  </cfif>
						  
						  <cfquery name="update" 
						  datasource="AppsWorkOrder" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
							  UPDATE WorkOrderLineAction
							  SET    OfficerUserId    = '#SESSION.acc#', 
							         OfficerLastName  = '#SESSION.last#',
									 OfficerFirstName = '#SESSION.first#',
									 Created          = getDate()
							  WHERE  WorkActionId = '#afterPost.WorkActionId#'				 
						 </cfquery>	
						  			
						  <cfquery name="InsertActionLog" 
						  datasource="AppsWorkOrder" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						  INSERT INTO WorkOrderLineActionLog
							 		 (WorkActionId,
									  AmendmentNo,						 
									  DateTimeRequested,
									  DateTimePlanning, 
									  <cfif Prior.DateTimeActual neq "">
									  DateTimeActual,						
									  </cfif>				
									  OfficerUserId,
									  OfficerLastName,
									  OfficerFirstName,
									  Created)
							  VALUES ('#Prior.workactionid#',
							          '#no#',
									  '#Prior.DateTimeRequested#',
									  '#Prior.DateTimePlanning#', 
									  <cfif Prior.DateTimeActual neq "">
									  '#Prior.DateTimeActual#',			
									  </cfif>				  						  		 
									  '#Prior.OfficerUserId#',
									  '#Prior.OfficerLastName#',
									  '#Prior.OfficerFirstName#',
									  '#Prior.Created#') 
						</cfquery>					
						
				    </cfif>										 
						
				</cfif>			
									
				
				<!--- ----------------------------------- --->
				<!--- -------SET Schedule WorkPlan------- --->
				<!--- ----------------------------------- --->
				
				<cfparam name="listpdte" default="">
								
				<cfif caller.setworkplan eq "1">
								
					<!--- now we post the workplan record as well --->
											
					<cfinvoke component = "Service.Process.WorkOrder.Delivery"  
					   method           = "applyWorkPlan" 
					   Validation       = "#attributes.validation#"
					   Mission          = "#attributes.Mission#" 
					   WorkActionId     = "#afterpost.workactionid#" 
					   Date             = "#dateformat(pdte,client.dateformatshow)#"
					   DateHour			= "#hour#"	
					   DateMinute       = "#minu#"		   
					   PositionNo       = "#pos#"
					   PlanOrderCode    = "#pln#"
					   LocationId       = "#loc#">   	
					   
					   <cfif listpdte eq "">
					  	 <cfset listpdte = "#pdte#">
					   <cfelse>
			  	      <cfset listpdte = "#listpdte#,#pdte#">
					   </cfif>
					   
					 				
				</cfif>
												
				<cfif row eq "1">
						
					<!--- create workflow if this isenabled for the actionclass --->
					
					<cfquery name="workorder" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   WorkOrder W, ServiceItem S
						WHERE  W.WorkOrderId = '#attributes.WorkOrderid#'			
						AND    W.ServiceItem = S.Code
					</cfquery>	
					
					<cfquery name="domain" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
					SELECT    *
					FROM      Ref_ServiceItemDomain
					WHERE     Code = '#workorder.servicedomain#'
					</cfquery>
					
					<cfquery name="workorderline" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   WorkOrderLine
						WHERE  WorkOrderId   = '#attributes.WorkOrderid#'		
						AND    WorkOrderLine = '#attributes.workorderline#'	
					</cfquery>					
					
					<cfquery name="CheckClass" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   Ref_ActionServiceItem
						WHERE  Code          = '#code#'
						AND    Serviceitem   = '#workorder.serviceitem#'	
						<!--- has a published class --->		
						AND    EntityClass IN (SELECT EntityClass 
						                       FROM   Organization.dbo.Ref_EntityClassPublish
											   WHERE  EntityCode = 'WorkOrder')
					</cfquery>		
					
					<cfif checkClass.recordcount gte "1">
					
						<cfquery name="Action" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT  *
						    FROM    Ref_Action
							WHERE   Code  = '#code#'						
						</cfquery>
							
						<cf_stringtoformat value="#workorderline.reference#" format="#domain.DisplayFormat#">	
															
						<cfset link = "WorkOrder/Application/WorkOrder/ServiceDetails/Action/WorkActionView.cfm?drillid=#workorderline.workorderlineid#">			
										
						<cf_ActionListing 
						    DataSource       = "AppsWorkOrder"
						    EntityCode       = "WorkOrder"
							EntityClass      = "#CheckClass.EntityClass#"
							EntityGroup      = "#domain.code#"
							EntityStatus     = ""
							Mission          = "#workorder.mission#"						
							ObjectReference  = "#workorder.Description#: #val#"
							ObjectReference2 = "#Action.description#" 					  
							ObjectKey4       = "#workorderline.workorderlineid#"				
							ObjectURL        = "#link#"
							Show             = "No">									
						
					</cfif>		
					
				</cfif>	
				
				<!--- include logging if changes have occurred in the request, planning, actual fields --->
				
				<cfparam name="Form.PositionNo_wp" default="">
				
				<!--- planning mode is enabled, maybe this was for Kuntz --->
								
				<cfif form.PositionNo_wp neq "" and ActionFulfillment eq "WorkPlan">	
									
					<cfinvoke component = "Service.Process.WorkOrder.Delivery"  
					   method           = "applyWorkPlan" 
					   Validation       = "#attributes.validation#"
					   Mission          = "#attributes.mission#" 
					   WorkActionId     = "#afterPost.WorkActionId#" 
					   Date             = "#dateformat(pdte,client.dateformatshow)#"
					   PositionNo       = "#form.PositionNo_wp#"
					   PlanOrderCode    = "#form.PlanOrderCode_wp#"
					   Topic1           = "f004"
					   Topic1Value      = "#form.Topic_f004_wp#">   
					   
				<cfelseif ActionFulfillment eq "WorkPlan">
				
					 	<cfquery name="clear" 
						  datasource="AppsWorkOrder" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
							  DELETE WorkPlanDetail					 
							  WHERE  WorkActionId = '#afterPost.WorkActionId#'		
							  AND    WorkPlanId IN (SELECT WorkPlanId 
							                        FROM   WorkPlan 
													WHERE  DateEffective = #pdte# AND DateExpiration = #pdte#)
						</cfquery>					   
				   
				 </cfif>  
			
			</cfif>	
			
		</cfif>	
	
	</cfloop>
	
	<cfparam name="caller.setworkplan" default="0">
	
	<cfif attributes.mode eq "Save" and caller.setworkplan eq "1">
	
		<cfparam name="listpdte" default="">	
		<cfset caller.pdte = listpdte>
	
	</cfif>
		
</cfoutput>
