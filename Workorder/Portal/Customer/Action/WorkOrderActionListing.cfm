
<!--- workorder and date 	
	select action class (special request, daily)
	show all workorderline action of that date and class 
	group by domain class
---> 

<cfparam name="url.workorderid" default="F99087DD-9504-CB10-8407-E7200CC4DE41">
<cfparam name="url.date"        default="03/11/2012">
<cfparam name="url.entryMode"   default="Batch">

<cfset session.selectworkorderid = url.workorderid>
<cfset session.selectactiondate  = url.date>

<!--- we will determine the access, if workorder manager is edit/all, we have the edit mode if workorder manager is READ, they can only
record observation --->

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset dte = dateValue>
   
<cfquery name="WorkOrder" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	
	SELECT     W.Mission, W.Reference, W.ServiceItem, C.CustomerName, C.OrgUnit, W.OrderDate, S.Description, C.Mission as CustomerMission
	FROM       WorkOrder W INNER JOIN
               ServiceItem S ON W.ServiceItem = S.Code INNER JOIN
               Customer C ON W.CustomerId = C.CustomerId
	WHERE      WorkOrderId = '#url.workorderid#'		   
	
</cfquery>	
	
<cfinvoke component = "Service.Access"  
	   method           = "workordermanager" 
	   mission          = "#workorder.mission#" 
	   orgunit          = "#workorder.orgunit#"	 
	   mode             = "Any" 
	   returnvariable   = "access">
	    
<cfif Access eq "NONE" or access eq "READ"> 

	<!--- now we check for the processor --->  	   
	   
	<cfinvoke component = "Service.Access"  
	   method           = "workorderprocessor" 
	   mission          = "#workorder.mission#" 
	   orgunit          = "#workorder.orgunit#"
	   serviceitem      = "#workorder.serviceitem#"
	   returnvariable   = "access">
	   
	   <cfif Access eq "NONE" or access eq "READ">
	   
		   <!--- now we check for the customer 31/7/2013 --->  
		   
		   <cfinvoke component = "Service.Access"  
			   method           = "workorderprocessor" 
			   mission          = "#workorder.CustomerMission#" 
			   orgunit          = "#workorder.orgunit#"
			   serviceitem      = "#workorder.serviceitem#"
			   returnvariable   = "access">
	   
	   </cfif>
	   
</cfif>	   
	   
<cfif access eq "ALL" or access eq "EDIT">	  

	<cfset url.mode = "edit">	 
	
<cfelse>

	<cfset url.mode = "view">	 

</cfif> 

<cfset vGetOnlyVisibleActions = "1">
<cfif lcase(url.entryMode) eq "batch">
	<cfset vGetOnlyVisibleActions = "1">
</cfif>
<cfif lcase(url.entryMode) eq "manual">
	<cfset vGetOnlyVisibleActions = "0">
</cfif>

<cfinvoke component     		= "Service.Process.WorkOrder.WorkOrderLineAction"  
	   method           		= "getActions" 
	   workOrderId      		= "#url.WorkOrderId#" 
	   entryMode				= "#url.entryMode#"
	   getOnlyVisibleActions	= "#vGetOnlyVisibleActions#"
	   date						= "#dateFormat(dte,client.dateformatshow)#"
	   returnvariable   		= "Actions">
	  	     
<table width="100%" height="99%" align="center">

<tr>
	<td colspan="4" style="height:50px">
		<table border="0" width="96%" align="center">
			<cfoutput>	
			<tr><td colspan="3" style="padding-top:10px">
				
				<table width="100%">
				 <tr>
				    <td class="labellarge"><a href="javascript:ColdFusion.navigate('Action/WorkorderActionSelect.cfm?mission=#url.mission#&entryMode=#url.entryMode#','menucontent')"><font color="0080C0"><b><u>[<cf_tl id="SELECT">]</b></a></td>
					<td class="labelmedium"><cf_tl id="Customer">:</td><td class="labellarge"><b>#WorkOrder.CustomerName#</td>
				    <td class="labelmedium"><cf_tl id="Workorder">:</td><td class="labellarge"><b>#WorkOrder.Description# - #WorkOrder.Reference#</td>
					<td class="labelmedium"><cf_tl id="Date">:</td><td class="labellarge"><b>#dateformat(dte,client.dateformatshow)#</b></td>
					<cfif url.entryMode eq "Manual">
						<td class="labelmedium" align="right">
							<cfoutput>
								<label for="imgAddSpecialAction" style="cursor:pointer;"><cf_tl id="New Requirement"></label>
								<cf_tl id="New Requirement" var="1">
								<img 
									id="imgAddSpecialAction" 
									name="imgAddSpecialAction" 
									src="#session.root#/images/plus_green.png" 
									height="25" 
									align="absmiddle" 
									style="cursor:pointer;" 
									onclick="try{ ColdFusion.Window.destroy('popupCreateNewRequirement',true); } catch(e){} ColdFusion.Window.create('popupCreateNewRequirement', '#lt_text#', 'Schedule/ScheduleAdd.cfm?mission=#url.mission#' , {height:600,width:900,modal:true,closable:false,draggable:true,resizable:true,center:true,initshow:true,minheight:200,minwidth:200 }); ">
							</cfoutput>
						</td>
					</cfif>
				 </tr>
				</table>
			
			</td></tr>			
			
			<tr><td colspan="4" class="line"></td></tr>
			
			</cfoutput>
				
			<tr><td height="4"></td></tr>

		</table>
	</td>
</tr>

<tr>
	<td colspan="4" valign="top" style="padding-left:38px;padding-right:38px" width="100%">	 
						
		<cfset vTogglerColor = "f1f1f1">
		
		<cf_divscroll id="actioncontent">
			
			<cf_layout type="accordion"> 
				
				<cfset actionrow = 0>
				
				<cfoutput query="Actions" group="ActionClass">
					
					<cfset vClosed = "true">
					<cfif url.entryMode eq "Manual" and currentRow eq 1>
						<cfset vClosed = "false">
					</cfif>			
					
					<cfif url.entryMode eq "Batch" or (url.entryMode eq "Manual" and Manual gte "1")>
					
						<cf_layoutArea 
							id 		        = "layoutArea_#ActionClass#" 
							label 	        = "#ActionDescription#"  
							togglerColor    = "#vTogglerColor#"
							labelFontColor  = "gray"
							labelFontSize   = "18"
							labelHeight     = "20"
							labelIconHeight = "20"
							initCollapsed   = "#vClosed#">
								   
							<cfoutput group="ListingOrder">	 
								
								<table width="98%" style="width:100%; min-width:100%;" align="center" id="container_#actionClass#" cellpadding="0" cellspacing="0" class="navigation_table">
								
									<tr>
										<td colspan="4">
					
											<cfinvoke component = "Service.Presentation.TableFilter"  
											   method           = "tablefilterfield" 
											   name             = "linesearch_#ActionClass#"				  
											   filtermode       = "direct"
											   style            = "font-size:16px;height:25px;width:130px;"
											   rowclass         = "clsTransaction_#ActionClass#"
											   rowfields        = "cworkorderline_#ActionClass#">			
									
										</td>
									</tr>
								
							  	<cfoutput group="Description">	 
								
									<cfif url.entryMode eq "Batch" or (url.entryMode eq "Manual" and Manual gte "1")>
										<tr><td colspan="3" style="padding-top:4px;padding-left:10px;font-weight:200;font-size:25px;height:48px" class="labelmedium">#Description#</td><td></td></tr>
									</cfif>
									
									<cfoutput group="Reference">
													
									    <cfset actionrow = actionrow+1>
										
										<cfif url.entryMode eq "Batch" or (url.entryMode eq "Manual" and Manual gte "1")>
										
											<tr class="clsTransaction_#ActionClass#" id="line_#actionrow#">
											
											    <td colspan="3" height="30" style="padding-left:20px;border-bottom:1px solid silver" class="labelmedium">											
													<table width="100%">
														<tr><td width="60%" style="font-weight:200;font-size:20px" class="cworkorderline_#ActionClass#">#Reference# #ReferenceDescription#<div class="hide">#Description#</div></td>																				
															<td width="40%" align="right" class="labelmedium" style="padding-right:4px;">												
																
																<cfif url.entryMode eq "Manual">											
																	<!---<a href="javascript:ColdFusion.navigate('#session.root#/WorkOrder/Application/WorkOrder/ServiceDetails/Action/WorkActionListing.cfm?id2=new&tabno=#actionrow#&workorderid=#url.workorderid#&workorderline=#workorderline#&actionstatus=1&entrymode=manual','contentbox#actionrow#')">
																		<font color="0080C0">
																			<i>[<cf_tl id="Report an Observation">]
																		</font>
																	</a>--->
																</cfif>
																	
															</td>						
														</tr>
													</table>
												</td>
												
											</tr>
										</cfif>
									
										<cfoutput>
										
										    <!--- detail actions --->
												
											<cfif url.entryMode eq "Batch">
									
											<tr class="clsTransaction_#ActionClass# navigation_row">
											
											   <td valign="top" align="left" width="15%" style="padding-top:10px;padding-left:30px">
													<table width="100%" cellspacing="0" cellpadding="0">
													
														<tr class="line"><td  style="font-weight:200;font-size:20px"  class="labelmedium">#timeformat(DateTimePlanning,"HH:MM")#</td></tr>													
													    																																													
														<cfquery name="getSchedules" 
															datasource="appsWorkOrder" 
															username="#SESSION.login#" 
															password="#SESSION.dbpw#"> 	
																SELECT  DISTINCT P.PersonNo, FirstName, LastName 
																FROM    WorkOrderLineSchedulePosition P, Employee.dbo.Person E
																WHERE   P.PersonNo = E.PersonNo
																<cfif scheduleid neq "">
																AND     ScheduleId = '#scheduleid#'
																<cfelse>
																AND		1=0
																</cfif>
														</cfquery>		
																										
														<cfif scheduleid neq "">
														
															<cfloop query="getSchedules">
															<tr><td style="padding-left:18px;font-weight:200;font-size:13px" height="20" class="labelit">
															      <a href="javascript:EditPerson('#PersonNo#')">#FirstName# #LastName#</a>
															    </td>
															</tr>
															</cfloop>																			
														
														</cfif>																											
														
													</table>
												
												</td>
												<td width="2%" class="cworkorderline_#ActionClass#">
												  <div class="hide">h#timeformat(DateTimePlanning,"HH:MM")# #Reference# #ReferenceDescription# #Description# #quotedvalueList(getSchedules.LastName)# #quotedvalueList(getSchedules.FirstName)#</div>
												</td>											
																	
												<td width="85%" style="border-left:1px dotted silver;padding-left:10px">
																	
													<form name="form_#workactionid#" id="form_#workactionid#" method="post">
													
														<table width="100%" cellspacing="0" cellpadding="0">
														
															<tr><td>
															
																<table width="100%" cellspacing="0" cellpadding="0">
																
																<tr>
																
																<td style="padding-left:3px;padding-top:8px" class="labelmedium"><i>
																
																<cfif (actionStatus lt "3" or access eq "ALL") and url.mode eq "edit">
																
																    <cfif datetimeActual eq "">
																						
																		<cf_setCalendarDate name="date_#currentrow#" edit="Yes" future="No" mode="datetime" class="regularxl" valuecontent="datetime" value="#DateTimePlanning#">
																	
																	<cfelse>
																	
																		<cf_setCalendarDate name="date_#currentrow#" edit="Yes" future="No" mode="datetime" class="regularxl" valuecontent="datetime" value="#DateTimeActual#">
																									
																	</cfif>
																
																<cfelse>									
																											 
																    <cfif actionstatus lt "3">
																	
																		<table width="100%" cellspacing="0" cellpadding="0">
																		
																			<tr>											
																				<td style="width:41px" class="labelmedium">
																					<img src="#session.root#/images/pending.png" alt="" border="0" align="absmiddle">
																				<td>											
																				<td class="labellarge"><font color="FF8040"><cf_tl id="Pending"></td>											
																			</tr>
																		
																		</table>
																	
																	<cfelse>
																	
																		<table width="100%" cellspacing="0" cellpadding="0">
																		
																			<tr>
																			
																			<td style="width:41px" class="labelmedium">
																				<img width="21" height="21" src="#session.root#/images/completed.png" alt="" border="0" align="absmiddle">
																			<td>																			
																	
																			<cfif dateformat(DateTimeActual,CLIENT.DateFormatShow) eq dateformat(DateTimePlanning,CLIENT.DateFormatShow)>
																		
																				<td class="labellarge">												
																				<font color="gray">#timeFormat(DateTimeActual,"HH:MM")# : #ActionOfficerFirstName# #ActionOfficerLastName#</font>
																				</td>
																			
																			<cfelse>
																			
																				<td class="labellarge">												
																				<font color="gray">#dateformat(DateTimeActual,CLIENT.DateFormatShow)# #timeFormat(DateTimeActual,"HH:MM")# : #ActionOfficerFirstName# #ActionOfficerLastName#</font>
																				</td>
																			
																			</cfif>
																			
																			</tr>
																		
																		</table>
																		
																												
																	</cfif>	
																
																</cfif>
																
																</td>
																
																<td style="width:90;padding-top:8px;padding-left:4px" id="process_#workactionid#" class="labelit"></td>		
																
																<td align="right" width="100" style="padding-right:4px">
																
																	<table cellspacing="1" cellpadding="1">
																	<tr>							
																							
																	<cfif (actionStatus lt "3" or access eq "ALL") and url.mode eq "edit">
																	
																		<td style="padding-left:4px;padding-top:6px;">
											
																		<input onclick="actionsave('#workactionid#','#currentrow#')" 
																		     type="radio" style="width:18;height:18"																	 
																			 name="status_#currentrow#" 
																			 value="1" <cfif actionstatus eq "1">checked</cfif>>		
																			 
																		 </td>
																		<td style="font-weight:200;padding-top:7px;padding-right:3px;padding-left:6px" class="labelmedium"><cf_tl id="Pending"></td>	
																		
																		<td style="padding-left:4px;padding-top:6px;">
											
																		<input onclick="actionsave('#workactionid#','#currentrow#')" 
																		     type="radio" 
																			 style="width:18;height:18"	
																			 name="status_#currentrow#" 
																			 value="3" <cfif actionstatus eq "3">checked</cfif>>		
																			 
																		 </td>
																		<td style="font-weight:200;padding-top:7px;padding-right:3px;padding-left:6px" class="labelmedium"><cf_tl id="Completed"></td>	
																																														 
																	</cfif>	 	
																	
																	<!---
																	<cfif actionstatus eq "3">
																											
																			<td align="right" class="label" style="width:90;padding-right:4px;padding-top:8px;">												
																																	
																					<a href="javascript:ColdFusion.navigate('#session.root#/WorkOrder/Application/WorkOrder/ServiceDetails/Action/WorkActionListing.cfm?id2=new&tabno=#actionrow#&workorderid=#url.workorderid#&workorderline=#workorderline#&actionstatus=1&entrymode=manual','contentbox#actionrow#')">
																						<font color="0080C0">
																							[<cf_tl id="Observation">]
																						</font>
																					</a>
																					
																			</td>
																	
																	</cfif>
																	--->
																	
																	</tr>
																	</table>
																	
																</td>			
																														
																
																</tr>
																</table>
																					
															</td>
															</tr>
															
															<tr>
																					
																<cfif (actionStatus lt "3" or access eq "ALL") and url.mode eq "edit">
																	<td class="label" style="padding-top:1px;padding-left:3px">
																	
																	<table width="100%" cellspacing="0" cellpadding="0">
																	<tr>
																	<td width="100" valign="top" style="padding-right:4px">																
																															
																	<cf_filelibraryN
																	    box="box_#workactionid#"
																		DocumentPath="WorkOrder"
																		SubDirectory="#workactionid#" 
																		Filter=""	
																		ButtonHeight="23px"
																		listing="0"							
																		Insert="yes"																										
																		Loadscript="no">																		
																																	
																	</td>
																	
																	<td width="90%" style="padding-right:4px;padding-bottom:4px">																																		
																		<textarea style="background-color:ffffcf;border:1px dotted b1b1b1;padding:2px;width:99%;height:46;font-size:13px" onchange="actionsave('#workactionid#','#currentrow#')" class="regular"  name="memo_#currentrow#">#ActionMemo#</textarea>																																
																	</td>
																	</tr>
																	</table>
																	
																	</td>
																<cfelse>
																   <cfif actionMemo neq "">
																    <td>																
																		<table width="100%">
																		    <tr><td height="4"></td></tr>
																			<tr>
																				<td class="labelit" style="padding-left:47px"></td>
																				<td width="99%" class="label" bgcolor="f5f5f5" style="padding:5px;border-top:1px dotted silver;border-bottom:1px dotted silver;padding-left:3px">#ActionMemo#</td>
																			</tr>
																		</table>									  
																		
																	</td>
																	</cfif>
																</cfif>	
															
															</tr>
																															
															<tr>
															<td style="padding-right:4px">
															<table width="99%" cellspacing="0" cellpadding="0">
															<tr>
															
															<td style="border:1px dotted b1b1b1" class="labelit">
																																																																									
																<cfif (actionStatus lt "3" or access eq "ALL") and url.mode eq "edit">
																
																	<!--- Presentation="all" --->
																	
																	<cfdiv bind="url:#session.root#/workorder/portal/customer/action/getActionPictures.cfm?workActionId=#workactionid#&remove=yes">
																														
																	
																<cfelse>		
																
																	<cfdiv bind="url:#session.root#/workorder/portal/customer/action/getActionPictures.cfm?workActionId=#workactionid#&remove=no">												
																
																</cfif>	
															
															</td>
															</tr>
															</table>
															</td>
															</tr>
															
															<tr><td height="3"></td></tr>								
															
														</table>	
													
													</form>
																
												</td>
											</tr>
											
											</cfif>					
															
										</cfoutput>			
														
										<tr class="clsTransaction_#ActionClass#">
										
											<td class="cworkorderline_#ActionClass#"><div class="hide">h#timeformat(DateTimePlanning,"HH:MM")# #Reference# #ReferenceDescription# #Description#</div></td>
											<td></td>
																									
											<cfif Manual gte "1">
											
												<td colspan="1" style="border:1px dotted silver; padding:5px;">											
													<cfdiv id="contentbox#actionrow#" bind="url:#session.root#/workorder/Application/WorkOrder/ServiceDetails/Action/WorkActionListing.cfm?workorderid=#url.workorderid#&workorderline=#workorderline#&tabno=#actionrow#&entrymode=manual">																	
												</td>
											
											<cfelse>
											
												<td id="contentbox#actionrow#" bgcolor="ffffff" style="border-left:1px dotted silver;padding-left:5px;padding-bottom:5px"></td>
											
											</cfif>
																	
										</tr>
																									
									</cfoutput>
								
								</cfoutput>
								
								</table>
							
							</cfoutput>
						
						</cf_layoutArea>
						
					</cfif>
				
				</cfoutput>
			
			</cf_layout>
		
		</cf_divscroll>	
		
	</td>
</tr>

<tr class="xxhide"><td style="height:10px" align="right">

	<!--- establish the connection object for the attachment --->
	<cfdiv bind="url:#session.root#/workorder/portal/Customer/Action/setAttachmentConnection.cfm?date=#url.date#&workorderid=#url.workorderid#">

</td></tr>

</table> 	

<cfset AjaxOnLoad("doHighlight")>

