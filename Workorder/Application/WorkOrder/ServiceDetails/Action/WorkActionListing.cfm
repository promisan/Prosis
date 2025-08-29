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
<cfparam name="url.tabno"                     default="1">
<cfparam name="url.workorderid"               default="">
<cfparam name="url.workorderline"             default="">

<cfif url.workorderid eq "">
	<table width="100%">
	    <tr><td height="60" align="center" class="labelmedium"><cf_tl id="Invalid request. Action interrupted"></td></tr>
	</table>
<cfabort>
</cfif>

<!--- selected line --->
<cfparam name="url.workactionid"              default="">
<cfif url.workactionid neq "">
	<cfset workactionid = url.workactionid>
</cfif>

<!--- show only relevant action lines --->
<cfparam name="url.actionstatus"              default="">  <!--- 1 pending, 3 completed --->
<cfparam name="url.entrymode"                 default="Manual">

<!--- action to be performed edit, delete --->
<cfparam name="url.action"                    default="">

<!--- relevant fields in the entry form --->
<cfparam name="form.ActionClass"              default="">
<cfparam name="form.DateTimePlanning_Date"    default="">
<cfparam name="form.DateTimePlanning_Hour"    default="">
<cfparam name="form.DateTimePlanning_Minute"  default="">
<cfparam name="form.ActionMemo"               default="">

 <!--- access mode new or edit --->
<cfparam name="url.id2"                       default=""> 

<cfquery name="Workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   WorkOrder
		WHERE  WorkOrderId   = '#URL.WorkOrderId#'		
</cfquery>

<!--- define access --->

<cfinvoke component = "Service.Access"  
   method           = "WorkorderManager" 
   mission          = "#workorder.mission#"    <!--- check for the create option --->
   returnvariable   = "access">	
   
<cfif Access eq "NONE" or access eq "READ">   

	<!--- it not then check if the person is a processor --->

	<cfinvoke component = "Service.Access"  
	   method           = "WorkorderProcessor" 
	   mission          = "#workorder.mission#" 
	   serviceitem      = "#workorder.serviceitem#"
	   returnvariable   = "access">	  
	     
</cfif>   
   
<cfquery name="getWorkorderLine" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   WorkOrderLine
		WHERE  WorkOrderId   = '#url.WorkOrderId#'	
		AND    WorkorderLine = '#url.workorderline#'	
</cfquery>

<cfif getWorkOrderLine.actionStatus eq "3" and getAdministrator("*") eq "0">

    <!--- we overwrite the action as the line is closed --->
	<cfset access = "READ">

</cfif>

<cfquery name="Serviceitem" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   ServiceItem
		WHERE  Code   = '#workorder.serviceitem#'		
</cfquery>

<cfquery name="Domain" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Ref_ServiceItemDomain
		WHERE  Code   = '#serviceitem.servicedomain#'		
	</cfquery>		

<cfquery name="ActionClassList" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Ref_Action
		WHERE  Operational = 1
		AND    Code IN (SELECT Code 
		                FROM   Ref_ActionServiceItem 
					    WHERE  Serviceitem = '#workorder.serviceitem#')	
		AND     EntryMode = 'Manual'
		AND     (Mission IS NULL or Mission = '#workorder.mission#')
		ORDER BY ListingOrder
</cfquery>

<cfif ActionClassList.recordcount eq "0">
	
	<cfquery name="ActionClassList" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   Ref_Action
			WHERE  Operational = 1		
			AND    EntryMode = 'Manual'
			ORDER BY ListingOrder
	</cfquery>

</cfif>

<cfif url.action eq "Delete">
	
	<cfquery name="Deleteworkplan" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM WorkplanDetail
		WHERE  WorkActionId  = '#workactionid#'		
	</cfquery>
	
	<cfquery name="DeleteBilling" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM WorkOrderLineBillingAction
		WHERE  WorkActionId  = '#workactionid#'		
	</cfquery>

	<cfquery name="Delete" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM WorkOrderLineAction
		WHERE  WorkOrderId   = '#URL.WorkOrderId#'
		AND    WorkOrderLine = '#URL.WorkOrderLine#'
		AND    WorkActionId  = '#workactionid#'		
	</cfquery>

<cfelse>		
		
	<cfif Form.DateTimePlanning_Date neq ''>
	    
		<CF_DateConvert Value="#Form.DateTimePlanning_Date#">
		<cfset dte = dateValue>
		
		<cftry>
			<cfset dte = DateAdd("h", LSParseNumber(form.datetimeplanning_hour), dte)>
			<cfset dte = DateAdd("n", LSParseNumber(form.datetimeplanning_minute), dte)>
		<cfcatch></cfcatch>		
		</cftry>
		
	<cfelse>
	    <cfset DTE = 'NULL'>
	</cfif>
		
	<!--- date convert --->
		
	<cfif form.ActionClass neq "">		
				
		<cfquery name="Check" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   WorkOrderLineAction
			WHERE  WorkOrderId   = '#URL.WorkOrderId#'
			AND    WorkOrderLine = '#URL.WorkOrderLine#'
			AND    WorkActionId  = '#workactionid#'			
		</cfquery>
		
		<cfif Check.recordcount eq "0">
			
			<cfquery name="Insert" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO WorkOrderLineAction
					(WorkOrderId, 
					 WorkOrderLine,
					 WorkActionId, 
					 ActionClass, 
					 DateTimePlanning, 
					 ActionMemo, 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName)
				VALUES
				   ('#URL.WorkOrderId#',
				    '#URL.WorkOrderLine#',
					'#workactionid#',
					'#form.ActionClass#',
					#dte#,
					'#form.ActionMemo#',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#')			
			</cfquery>
				
		<cfelse>
		
			<cfquery name="update" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE WorkOrderLineAction
				SET    ActionMemo       = '#form.ActionMemo#',
				       ActionClass      = '#form.ActionClass#',
					   DateTimePlanning = #dte#   
				WHERE  WorkOrderId      = '#URL.WorkOrderId#'
				AND    WorkOrderLine    = '#URL.WorkOrderLine#'  
				AND    WorkActionId     = '#workactionid#'					
			</cfquery>	
		
		</cfif>		
		
		<!--- create workflow if this enabled for the actionclass --->
		
		<cfquery name="CheckClass" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_ActionServiceItem
			WHERE  Code          = '#form.ActionClass#'
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
				WHERE   Code  = '#form.ActionClass#'						
			</cfquery>
				
			<cf_stringtoformat value="#getworkorderline.reference#" format="#domain.DisplayFormat#">	
												
			<cfset link = "WorkOrder/Application/WorkOrder/ServiceDetails/Action/WorkActionView.cfm?drillid=#workactionid#">				
										
			<cf_ActionListing 
			    EntityCode       = "WorkOrder"
				EntityClass      = "#CheckClass.EntityClass#"
				EntityGroup      = "#domain.code#"
				EntityStatus     = ""
				Mission          = "#workorder.mission#"						
				ObjectReference  = "#Serviceitem.Description#: #val#"
				ObjectReference2 = "#Action.description#" 					  
				ObjectKey4       = "#workactionid#"				
				ObjectURL        = "#link#"
				Show             = "No">									
							
		</cfif>
				
		<cfset wfobject = workactionid>				
		<cfset url.workactionid = "">		
					
	</cfif>
		
</cfif>
	
<cfquery name="WorkAction" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    SELECT *
	FROM (

    SELECT   A.*,	
	         WL.ActionStatus as WorkOrderLineStatus,     
			 WL.OrgUnitImplementer as LineOrgUnit,
			 WL.PersonNo as LinePersonNo,  
			 R.ActionFulfillment,
			 R.Description,
			 
			 <!--- support this screen to show info about the scheduling --->  
			 
			 (SELECT TOP 1 DateTimePlanning
			  FROM         WorkPlanDetail
			  WHERE        WorkActionId = A.WorkActionid
			  AND          Operational = 1
			  ORDER BY     DateTimePlanning DESC) as DateTimePlanningWorkPlan,
			  
			  ('') as LocationPlanningWorkPlan,
			  
			  (SELECT TOP 1 PlanOrderCode
			  FROM         WorkPlanDetail
			  WHERE        WorkActionId = A.WorkActionid
			  AND          Operational = 1
			  ORDER BY     DateTimePlanning DESC) as PlanOrderPlanningWorkPlan,  
			  
			 (SELECT TOP 1 DateTimePlanning
			  FROM         WorkPlanDetail
			  WHERE        WorkActionId = A.WorkActionid
			  AND          Operational = 0
			  ORDER BY     DateTimePlanning DESC) as DateTimePlanningWorkPlanPrior, 
			  			 	 
			 (SELECT TOP 1 BillingEffective
			  FROM         WorkOrderLineBillingAction
			  WHERE        WorkActionId = A.WorkActionid) as DateBilling, 
			  
			 (SELECT TOP 1 PersonNo
			  FROM         WorkPlanDetail WP, WorkPlan W
			  WHERE        WP.WorkPlanId   = W.WorkPlanId
			  AND          WP.WorkActionId = A.WorkActionid
			  AND          WP.Operational  = 1
			  ORDER BY     DateTimePlanning DESC) as PersonNo			  
				
    FROM     WorkOrderLineAction A INNER JOIN 
	         WorkOrderLine WL ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine INNER JOIN 
	         WorkOrder W ON W.WorkOrderId = A.WorkOrderId INNER JOIN 
			 Ref_Action R ON Code = A.ActionClass
	WHERE    A.WorkOrderId   = '#URL.WorkOrderId#'
	AND      A.WorkorderLine = '#url.workorderline#'
	AND      A.ActionClass NOT IN (
					SELECT  UsageActionClose
					FROM    ServiceItem S
					WHERE   S.Code = W.ServiceItem
					AND     UsageActionClose is not NULL
					)
	
	<cfif url.actionstatus eq "1">  <!--- only pending --->		
		AND A.ActionStatus = '1'
	</cfif>
	
	<cfif url.entrymode eq "Manual">
		AND A.ActionClass IN (SELECT Code
		                      FROM   Ref_Action 
							  WHERE  EntryMode = 'Manual')	
	<cfelseif url.entrymode eq "Batch">
	    AND A.ActionClass IN (SELECT Code
		                      FROM   Ref_Action 
							  WHERE  EntryMode = 'Batch')								  
	</cfif>
	
	) as Sub
					
	ORDER BY DateTimePlanningWorkPlan, Created 
</cfquery>


<cf_screentop html="no" jquery="yes">
		   
<cfform method="post" name="actionform_#url.tabno#" id="actionform_#url.tabno#">
	
	<table width="100%" 
	  align="center"  border="0"
	  navigationhover="transparent"
	  navigationselect="f4f4f4"
	  class="navigation_table">
		
	<tr class="line labelmedium fixlengthlist">
	    <td colspan="3">
		
		<cfif (access eq "EDIT" or access eq "ALL") and 
			      workorder.actionstatus lt "3" and 
				  getWorkorderLine.ActionStatus lt "3">
				<cfif url.id2 eq "">
				<cfoutput>
				     <cf_tl id="Add" var="1">
				     <input type="button" 
					  class="button10g" 
					  value="#lt_text#"
					  style="width:100%;height:20px;font-size:12px;border:1px solid silver"
					  onclick="_cf_loadingtexthtml='';ptoken.navigate('#session.root#/WorkOrder/Application/WorkOrder/ServiceDetails/Action/WorkActionListing.cfm?id2=new&tabno=#url.tabno#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&workactionid=&actionstatus=#url.actionstatus#&entrymode=#url.entrymode#','actioncontent')">
						
				</cfoutput>
				</cfif>
			</cfif>
		
		</td>
	    		
		<td><cf_tl id="Action"></td>
		<td><cf_tl id="Due"></td>		
		<td><cf_tl id="Completed"></td>
		<td><cf_tl id="Officer"></td>
		<td align="left"><cf_tl id="Date">/<cf_tl id="Time"></td>
		
		<!---
		<td align="right" style="width:30px;">
		
			<cfif (access eq "EDIT" or access eq "ALL") and 
			      workorder.actionstatus lt "3" and 
				  getWorkorderLine.ActionStatus lt "3">
				<cfif url.id2 eq "">
				<cfoutput>
				 	 <a href="javascript:_cf_loadingtexthtml='';ColdFusion.navigate('#session.root#/WorkOrder/Application/WorkOrder/ServiceDetails/Action/WorkActionListing.cfm?id2=new&tabno=#url.tabno#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&workactionid=&actionstatus=#url.actionstatus#&entrymode=#url.entrymode#','actioncontent')">
					 	<cf_tl id="add">
					 </a>				
				</cfoutput>
				</cfif>
			</cfif>
		
		</td>	
		--->
	</tr>
			
	<cfif access eq "EDIT" or access eq "ALL">
	
		<cfif url.workactionid eq "" and url.id2 eq "new">
		
			<cf_assignId>
			
			<cfset workactionid = rowguid>	
			
			<tr bgcolor="white" class="fixlengthlist">
			
			<td style="width:10px" class="navigation_pointer"></td>
			
			<td valign="top" style="padding-top:6px" class="labelmedium"><cfoutput>#workaction.recordcount+1#.</cfoutput></td>
			
			<td></td>
			
			<td colspan="6" align="center" style="width:100%">
			
				<table width="100%" class="formpadding">
						
						<tr><td height="3"></td></tr>
						
						<tr>
							<td class="labelmedium"><cf_tl id="Type">:</td>
							<td>
											
								<select name="ActionClass" id="ActionClass" class="regularxl">
								<cfoutput query="ActionClassList">
									<option value="#Code#" <cfif code eq workaction.actionclass>selected</cfif>>#Description#</option>
								</cfoutput>				
								</select>
							</td>									
						</tr>
						
						<tr><td height="3"></td></tr>
						
						<tr>
							<td class="labelmedium"><cf_tl id="Due date">/<cf_tl id="time">:</td>
							<td>		
														 								
									<cf_setCalendarDate name="DateTimePlanning"
									    font="15" 
										valuecontent="datetime" 
										future="Yes" 
										class="regularxl"
										value="#now()#" 
										dialog="Yes"
										mode="date">										
									
							</td>
						</tr>
						
						<tr><td height="3"></td></tr>
						
						<tr><td colspan="2" style="padding:3px">
						     <textarea name="ActionMemo" class="regular" style="font-size:15px;padding:3px;width:100%;height:75"></textarea>
						</td></tr>
		    	</table>
					
			</td>
			</tr>
						
			<tr><td colspan="9" style="padding-top:4px" align="center">
			
			    <cfoutput>
				
					<cf_tl id="Submit" var="vSubmit">
					<input type = "button"
					  name      = "Save"
                      id        = "Save" 
					  value     = "#vSubmit#" 
					  style     = "width:200px" 
					  class     = "button10g" 
					  onclick   = "_cf_loadingtexthtml='';ptoken.navigate('#session.root#/WorkOrder/Application/WorkOrder/ServiceDetails/Action/WorkActionListing.cfm?tabno=#url.tabno#&WorkOrderId=#url.WorkOrderId#&WorkorderLine=#url.workorderline#&workactionid=#workactionid#&actionstatus=#url.actionstatus#&entrymode=#url.entrymode#','actioncontent','','','POST','actionform_#url.tabno#')">
					  
				</cfoutput>
				
			</td></tr>
			
			<tr><td height="3"></td></tr>
		
			</cfif>
		
	</cfif>
	
	<cfset prior = "0">
		
	<cfoutput query="WorkAction">
	
		<cfset acl = actionclass>
					
		<cfif url.workactionid eq workactionid and SESSION.acc eq OfficerUserId>
		
			<tr class="navigation_row fixlengthlist labelmedium">
						
			    <td style="min-width:20px;width:20px;max-width:20px" class="navigation_pointer"></td>				
			    <td valign="top" style="width:10px;padding-top:7px">#currentrow#.</td>
				
				<td colspan="7" align="center" height="80" style="padding-top:4px">
				
					<table width="100%" class="formpadding">
					
					<tr class="labelmedium fixlengthlist">
					
						<td><cf_tl id="Type">:</td>
						<td>							
						<select name="ActionClass" id="ActionClass" class="regularxl">
							<cfloop query="ActionClassList">
								<option style="background-color: White;" value="#Code#" <cfif code eq WorkAction.actionclass>selected</cfif>>#Description#</option>
							</cfloop>				
						</select>
						</td>
									
					</tr>
					
					<tr class="labelmedium">
					<td><cf_tl id="Due Date">:</td>
					<td>				
						<cf_setCalendarDate name="DateTimePlanning" dialog="Yes" class="regularxl" valuecontent="datetime" future="Yes" value="#Dateformat(DateTimePlanning, CLIENT.DateFormatShow)#" 
							 mode="datetime">										
					</td>
					</tr>
					
					<tr class="labelmedium">
						<td colspan="2" style="padding:3px">
							<textarea name="ActionMemo" class="regular" style="padding:3px;font-size:15px;width: 100%;height:50">#ActionMemo#</textarea>
						</td>
					</tr>
					
					</table>
				
				</td>
			</tr>
			
			<tr><td height="2"></td></tr>

			<tr><td align="center" colspan="8" style="padding:3px">
			
				<input type="button" 
					   name="Save"
		               id="Save" 
					   value="Save" 
					   class="button10g" 
					   style="width:150px" 
					   onclick="_cf_loadingtexthtml='';ptoken.navigate('#session.root#/WorkOrder/Application/WorkOrder/ServiceDetails/Action/WorkActionListing.cfm?tabno=#url.tabno#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&workactionid=#workactionid#&actionstatus=#url.actionstatus#&entrymode=#url.entrymode#','actioncontent','','','POST','actionform_#url.tabno#')">
					   
			</td></tr>
			<tr><td height="2"></td></tr>
		
		<cfelse>
		
			<tr class="line labelmedium navigation_row fixlengthlist" style="height:30px">
			
			<td style="max-width:10px" class="navigation_pointer"></td>			
		    <td style="max-width:10px">#currentrow#.</td>							
			<td style="cursor:pointer;padding-top:1px" 
			    onclick="workflowaction('#workactionid#','box_#workactionid#')" align="center">				
								
				<!--- check for active workflow --->  
			    <cf_wfActive entitycode="workorder" objectkeyvalue4="#workactionid#">	
				
				<cfif wfstatus eq "open" and DateTimePlanning gt now()-1 and DateTimeActual eq "">
				<!------rfuentes 13-DEc-2016 on Hannos email to always show this open  it was: delay as wfstatus ---->
					<cfset wfStatus = "open">
				
				</cfif>
				
				<!--- check if workflow exists and if its status is pending
				      in case of pending we show the workflow  --->
				
				<cfif wfExist eq "1">
					
					<cfif wfstatus eq "open" and prior eq "0">
						<cfset cl = "hide">
						<cfset ex = "regular">
					<cfelse>	
						<cfset cl = "regular">
						<cfset ex = "hide">	
					</cfif>	
					
					<img id="exp#WorkActionId#" 
						     class="#cl#" 
							 src="#SESSION.root#/Images/arrowright.gif" 
							 align="absmiddle" 
							 alt="Expand" 
							 height="9"
							 width="7"			
							 border="0"> 	
										 
					<img id="col#WorkActionId#" 
						     class="#ex#" 
							 src="#SESSION.root#/Images/arrowdown.gif" 
							 align="absmiddle" 
							 height="10"
							 width="9"
							 alt="Hide" 			
							 border="0"> 
					
				 </cfif>	
						
			</td>
			<td>#Description#</td>
			<td id="plan#workactionid#">
			
				<cfif (ActionFulfillment eq "Schedule" or ActionFulfillment eq "Workplan")>
												
					 <cfif DateTimePlanningWorkplan eq "" and workorderlineStatus eq "3">
					 
					  <table width="100%">
					  <tr class="labelmedium"><td class="fixlength">	
					  		 					     
						 <font color="808080">
						 #dateformat(DateTimePlanning,client.dateformatshow)# 					  
						 </font>
						 						  						  
					  </td>
					 
					  </tr>
					  </table>	
					 
					 <cfelseif DateTimePlanningWorkplan neq "">
					
					  <table width="100%">
					  <tr class="labelmedium fixlengthlist">
					  <td>	
					  	  
						  <cfif WorkOrderLineStatus lt "3" and DateTimeActual eq "">
						  						  
						   <a href="javascript:workplan('#workactionid#')">
						   
						   <cfquery name="Person" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT  *
							    FROM    Person
								WHERE   PersonNo  = '#PersonNo#'						
							</cfquery>
						   
						   <font color="0080C0">#Person.LastName#:</font>	
						    <font color="0080C0"><b>#timeformat(DateTimePlanningWorkplan,"HH:MM")#</b></font>
						   #lsdateformat(DateTimePlanningWorkplan,"dd/mm/YYYY Dddd")# 						 
						  
						  
							</a>
						  
						  <cfelse>
						  
						  <cfquery name="Person" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT  *
							    FROM    Person
								WHERE   PersonNo  = '#PersonNo#'						
							</cfquery>
													   
 							#Person.LastName#: #timeformat(DateTimePlanningWorkplan,"HH:MM")#			
						  
						   #lsdateformat(DateTimePlanningWorkplan,"dd/mm/YYYY Dddd")#
						   					  					
						  
						  </cfif>						 		  
						  
						  </a>
						  
						  #LocationPlanningWorkPlan#
						  						  
					  </td>
					  					  
					  <td style="padding-left:3px;padding-top:2px">
					  					  
						  <cfif WorkOrderLineStatus lt "3" and DateTimeActual eq "">
						  
							  <cfif access eq "EDIT" or access eq "ALL">					  
							     <cf_img icon="delete" onclick="ptoken.navigate('#session.root#/WorkOrder/Application/WorkOrder/ServiceDetails/Action/deleteWorkPlan.cfm?workactionid=#workactionid#','plan#workactionid#')">					  
							  </cfif>
							  
						  </cfif>
					  
					  </td>
					  </tr>
					  
					  <cfif DateTimePlanningWorkPlanPrior neq "">
						  <tr class="labelit" style="font-size:13px;background-color:f1f1f1;height:10px"><td align="center"><cf_tl id="Prior">:
						      <font color="E64A00">
							  #dateformat(DateTimePlanningWorkplanPrior,client.dateformatshow)# #timeformat(DateTimePlanningWorkplanPrior,"HH:MM")#
							  </font>
						  </td></tr>
					  </cfif>
					  
					  </table>	
					 			
					 <cfelse>
					  			  	  
					  <u>					
					  <a href="javascript:workplan('#workactionid#','#lineorgunit#','#linepersonno#')">
					  <font color="FF0000">#dateformat(DateTimePlanning,client.dateformatshow)# <font size="2">#timeformat(DateTimePlanning,"HH:MM")#</font>
					  </a>
					  </u>
					  
					  </cfif>
				  				  
				<cfelse>
				
				#dateformat(DateTimePlanning,client.dateformatshow)# <font size="2">#timeformat(DateTimePlanning,"HH:MM")#
				
				</cfif>			
			
			</td>		
			
			<td style="height:100%">
				<table style="width:93%;padding-left:5px;border:1px solid gray">
					<tr class="labelmedium">		
					<cfif DateTimeActual neq "">	
					<td style="padding-left:4px;padding-right:4px" bgcolor="DDFBE2" align="center">		   		
					   #dateformat(DateTimeActual,client.dateformatshow)# <font size="2">#timeformat(DateTimeActual,"HH:MM")#</font>		
					</td>	
					<cfelseif ActionStatus eq "9">
					<td style="font-size:12px;padding-left:4px" bgcolor="red" align="center">		   		
					   <font color="FFFFFF"><cf_tl id="revoked"></font>	
					</td>
					<cfelseif ActionStatus eq "8">
					<td style="font-size:12px;padding-left:4px" bgcolor="orange" align="center">		   		
					   <font color="FFFFFF"><cf_tl id="absent"></font>	
					</td>		
					<cfelse>
					<td style=";font-size:12px;padding-left:4px" bgcolor="yellow" align="center">		   		
					   <cf_tl id="pending">	
					</td>	
					</cfif>
					<cfif datebilling neq "">
					<td align="center" bgcolor="6CEE83" style="padding-left:5px;padding-right:5px;border-left:1px solid gray;font-size:12px"><cf_tl id="Charged"></td>
					</cfif>
					</tr>
				</table>
				
			</td>							
										
			<td>#OfficerLastName#</td>
			<td>#dateformat(created,"dd/MM")# #timeformat(created,"HH:MM")#</td>
			
			<td align="right">
			
			    <!--- before it was looking at the access rights for that role but that was in my views not appropriate --->
				
				<cfif (DateTimePlanningWorkplan eq "" and getWorkorderLine.actionStatus lt "3")>
				
				<!---
				<cfif (DateTimePlanningWorkplan eq "" and getWorkorderLine.actionStatus lt "3") or getAdministrator(workorder.mission) eq "1">
				--->
												
					<!-----<cfif SESSION.acc eq OfficerUserId or getAdministrator(workorder.mission) eq "1"> ----->
						<cfif access eq "EDIT" or access eq "ALL" or getAdministrator(workorder.mission) eq "1">
																
						<table>
						<tr><td align="right" style="padding-right:2px;padding-top:2px">	
																		
						  <cf_img icon="edit" 
						  onclick="_cf_loadingtexthtml='';ptoken.navigate('#session.root#/WorkOrder/Application/WorkOrder/ServiceDetails/Action/WorkActionListing.cfm?tabno=#url.tabno#&WorkOrderId=#url.WorkOrderId#&workorderline=#url.workorderline#&workactionid=#workactionid#&actionstatus=#url.actionstatus#&entrymode=#url.entrymode#','actioncontent')">
						</td>
						<td style="padding-top:2px">
																	
						<cfif wfStatus eq "open" 
						   or wfexist eq "0"
						   or (DateTimePlanningWorkPlan eq "" and ActionFulfillment eq "Schedule")>		
						   <cf_img icon="delete" onclick="_cf_loadingtexthtml='';ptoken.navigate('#session.root#/WorkOrder/Application/WorkOrder/ServiceDetails/Action/WorkActionListing.cfm?tabno=#url.tabno#&WorkOrderId=#url.WorkOrderId#&workorderline=#url.workorderline#&workactionid=#workactionid#&action=delete&actionstatus=#url.actionstatus#&entrymode=#url.entrymode#','actioncontent')" border="0">				
						</cfif>
						</td>
						</tr>
						</table>
					
					</cfif>
				
				</cfif>
			
			</td>
			
			</tr>
			
			<cfif ActionMemo neq "">
			<tr class="navigation_row_child">
			   <td colspan="3"></td>
			   <td colspan="7" style="height:16px;font-size:15px;border-top:1px dotted e1e1e1;color:gray;" class="labelit navigation_row">#paragraphformat(ActionMemo)#</td>
		    </tr>			
			</cfif>	
						
			<cfif wfExist eq "0" and ActionFulFillment eq "Standard" and EntryMode neq "System">
			
				<tr><td colspan="1"></td><td colspan="9" style="padding-top:2px;padding-bottom:4px;padding-right:7px">
				
				<cfif (actionStatus lt "3" or access eq "ALL")>					
																		
					<cf_filelibraryN
					    box="box_#workactionid#"
						DocumentPath="WorkOrder"
						SubDirectory="#workactionid#" 
						Filter=""								
						Insert="yes"
						Remove="yes"										
						width="99%"	
						Loadscript="no"				
						border="1">	
					
				<cfelse>
				
					<cf_filelibraryN
					    box="box_#workactionid#"
						DocumentPath="WorkOrder"
						SubDirectory="#workactionid#" 
						Filter=""								
						Insert="no"
						Remove="no"
						width="99%"	
						Loadscript="no"														
						border="1">							
				
				</cfif>	
				
				</td>
				</tr>
					
			</cfif>					
						
			<cfif wfExist eq "1">
						
				<input type="hidden" 
				   name="workflowlink_#workactionid#" 
                   id="workflowlink_#workactionid#"
				   value="#session.root#/WorkOrder/Application/WorkOrder/ServiceDetails/Action/WorkActionWorkflow.cfm">	
				  				   
				   <tr id="box_#workactionid#" class="#ex#">
				   				   			  
					  <td colspan="9" style="border-left:1px solid d4d4d4;border-bottom:1px solid d4d4d4;border-right:1px solid d4d4d4" id="#workactionid#">
					  				
						  <cfif wfstatus eq "open" and prior eq "0">		
						     <cfset url.ajaxid = workactionid>
							 <cfinclude template="WorkActionWorkflow.cfm">				
							 <cfset prior = "1">
						  </cfif>
				
					  </td>
				   </tr>	
				   
				   <cfset wfobject = workactionid>				
						
			</cfif>
		
		</cfif>
					
	</cfoutput>
	
	</cfform>

</table>

<cfset AjaxOnLoad("doHighlight")>
<cfset AjaxOnload("doCalendar")>