

<cfoutput>
	
	<cfset thisPending  	= "##E8E8E8">
	<cfset thisWaiting 		= "##ffff99">
	<cfset thisAbsent 		= "##ff9900">
	<cfset thisCanceled 	= "##ff0000">
	<cfset thisConfirmed 	= "##B5FFC3">
	<cfset thisBilled 		= "##00FF08">
	<cfset thisNBilled 		= "##e6e600">

	<cfif workorderlineactionstatus lt "9">
		<cfif workorderlineactionstatus eq "0">
		   <cfset cl = thisPending>   <!--- grey pending --->			      
	    <cfelseif workorderlineactionstatus eq "1" or workorderlineactionstatus eq "2">
		   <cfset cl = thisWaiting>   <!--- yellow pending --->	
		<cfelseif workorderlineactionstatus eq "9">
		   <cfset cl = thisCanceled>   <!--- red cancelled --->	
		<cfelseif workorderlineactionstatus eq "8">
		   <cfset cl = thisAbsent>   <!--- orange absent --->	
		<cfelse>				<!--- completed: 3,4--->   
		   <cfset cl = thisConfirmed>   <!--- green completed --->   
		</cfif> 		
	<cfelse>
		<cfset cl = thisCanceled>	<!--- red - canceled --->
	</cfif>

	<cfif hasBilling neq "">
		<cfset clb 	= thisBilled>	<!----- green billed ---->
	<cfelse>
		<cfset clb 	= thisNBilled>   <!----- yellow pending ---->
	</cfif>	
	
	<cfparam name="row" default="1">
			
	<cfif ParentWorkOrderId eq "" and WorkActionId eq firstWorkActionId > <!----- historical data without wlactions, now they do have "and firstWorkOrderID eq WorkORderID" ------->
		<!----check for the status ----->
		<cfif WorkOrderLineActionStatus eq "9">
			<cfset tpe = "<font color='FF0080'>1CCA</font>">
		<cfelseif WorkOrderLineActionStatus eq "8">
				<cfset tpe = "<font color='FF0080'>1CAU</font>">
			<cfelse>
				<cfset tpe = "<font color='FF0080'>1C</font>">
		</cfif> <!--- first appointment: PC stands for Primera Cita  --->
	<cfelse>
		<cfif  LastServiceDomainClass eq wlservicedomainclassnow>
			<cfif WorkOrderLineActionStatus eq "9">
				<cfset tpe = "<font color='FF0080'>RECA</font>">
			<cfelseif WorkOrderLineActionStatus eq "8">
				<cfset tpe = "<font color='FF0080'>REAU</font>">
			<cfelse>
				<cfset tpe = "<font color='FF0080'>RE</font>"> <!--- new problem: RE stands for Reconsulta --->
			</cfif>
		<cfelse>
			<cfif WorkOrderLineActionStatus eq "9">
				<cfset tpe = "NPCA">
			<cfelseif WorkOrderLineActionStatus eq "8">
				<cfset tpe = "NPAU">
			<cfelse>
				<cfset tpe = "NP"> <!--- new problem: NP stands for Nuevo Problema --->
			</cfif>
		</cfif>
	</cfif>
							
	<cfif url.size eq "small" or url.size eq "embed">
	
		<tr class="clsPatientRow navigation_row" style="<cfif currentrow gte "2">border-top:1px solid silver</cfif>">		
		    <td align="center" class="ecell" style="border-left:9px solid #cl#"></td> 						
			<cfif hasBilling neq "">
				<td style="border-left:9px solid #clb#"></td> 		
			<cfelse>
			    <td style="border-left:9px solid #clb#"></td> 		
			</cfif>													
			<td class="ccontent dcell" style="background-color:#plancolor#">
			<a class="navigation_action" style="font-size: 12px; color: 555" href="javascript:openaction('#workorderlineid#')">#FirstName# <cfif MiddleName neq "">#MiddleName# </cfif>#LastName# <cfif LastName2 neq "">#LastName2#</cfif>&nbsp;/
			<cfif documentReference neq "">#DocumentReference#<cfelse>#PersonNo#</cfif></a>
			</td>						
			<td class="ccontent acell" style="font-size: 12px; color: 555;background-color:#locationcolor#">
			<cfif locationname neq ""><cf_UITooltip Tooltip="#LocationName#">#UCASE(left(WorkOrderService,3))#</cf_UITooltip><cfelse>#UCASE(left(WorkOrderService,3))#</cfif>
			</td>	
			<td class="ccontent acell" style="font-size: 12px; color: 555;min-width:40px;background-color:#plancolor#">#tpe#</td>	
			<td class="ccontent acell" style="font-size: 12px; color: 555;background-color:#plancolor#"><cfif PlanOrder neq "">#left(PlanOrder,1)#</cfif></td>	
			<td class="ccontent acell" style="font-size: 12px; color: 555;background-color:#plancolor#">#Description#</td>	

			<cfset vLogOnClick = "">
			<cfif ScheduleLog gte 1>
				<cfset vLogOnClick = "toggleLog('#workactionid#');">
			</cfif>
			<td class="ccontent acell" onclick="#vLogOnClick#" style="font-size: 12px; color: 555;min-width:25px;background-color:<cfif scheduleLog gte "1">ffffaf</cfif>"><cfif scheduleLog gte "1">#ScheduleLog#</cfif></td>

			<td class="acell ccell clsNoPrint" align="center" style="font-size: 12px; color: 555;min-width:30px;background-color:#plancolor#">							    						
				<cfif actionstatus lt "3">						    
					<cf_img icon="delete" onclick="deleteaction('#workactionid#','#URLencodedformat(url.selecteddate)#','#url.mission#','#url.orgunit#','#url.positionno#','#url.personno#','#url.size#')">
				</cfif>				
			</td>				
		</tr>
				
		<cfif ScheduleLog gte 1>
			<tr id="log_#workactionid#" style="display:none;">
				<td colspan="2"></td>
				<td colspan="7" id="logContent_#workactionid#"></td>
			</tr>
			
			<tr id="#workactionid#" style="display:none;" class="hide"><td colspan="9" class="line" id="#workactionid#_content"></td></tr>
			
		</cfif>
					
	<cfelse>
	
		<tr class="clsPatientRow navigation_row" style="<cfif currentrow gte "2">border-top:1px solid silver</cfif>;">	
			
	    <td rowspan="2" align="center" class="fcell" style="background-color:#cl#;"></td> 							
		<td rowspan="2" align="center" class="gcell" style="border-left:12px solid #clb#;border-right:0px solid <cfif hasBilling neq "">#cl#<cfelse>silver</cfif>;">#row#.</td> 				
		<td rowspan="2" class="ccontent bcell hcell" style="background-color:#plancolor#;font-size:13px">
		   <a class="navigation_action" href="javascript:openaction('#workorderlineid#')"><cfif documentReference neq "">#DocumentReference#<cfelse>#PersonNo#</cfif></a> 
	    </td>					
		<td class="ccontent bcell" style="width:100%;background-color:#plancolor#;font-size:14px"> #FirstName# <cfif MiddleName neq "">#MiddleName# </cfif>#LastName# <cfif LastName2 neq "">#LastName2#</cfif></td>			
		<td class="ccontent acell" style="background-color:#plancolor#"><cfif locationname neq ""><cf_UITooltip Tooltip="#LocationName#">#UCASE(left(WorkOrderService,3))#</cf_UITooltip><cfelse>#UCASE(left(WorkOrderService,3))#</cfif></td>	
		<td class="ccontent acell" style="min-width:40px;background-color:#plancolor#">#tpe#</td>	
		<td class="ccontent acell" style="background-color:#plancolor#"><cfif PlanOrder neq "">#left(PlanOrder,1)#</cfif></td>	
		<td class="ccontent acell" style="background-color:#plancolor#">#Description#</td>	
		    <cfset vLogOnClick = "">
			
			<cfif ScheduleLog gte 1>
				<cfset vLogOnClick = "toggleLog('#workactionid#');">
			</cfif>
			
		<td class="ccontent acell" onclick="#vLogOnClick#" style="min-width:25px;border-right:1px solid silver;background-color:<cfif scheduleLog gte "1">ffffaf</cfif>"><cfif scheduleLog gte "1">#ScheduleLog#</cfif></td>									
										
		<td align="center" class="clsNoPrint" style="min-width:30px;padding-top:5px">					
				<cfif actionstatus lt "3">						   
					<cf_img icon="delete" 
					      onclick="deleteaction('#workactionid#','#URLencodedformat(url.selecteddate)#','#url.mission#','#url.orgunit#','#url.positionno#','#url.personno#','#url.size#')">
				</cfif>			
		</td>				
		</tr>
		
		<tr class="clsPatientRow">
				
		<td class="ccontent" colspan="7" style="height:20px;border-left:1px solid silver;border-top:1px solid silver">		
			<span class="hide">#FirstName# #LastName# #Middlename#</span>	
			   <cfif actionstatus lt "3">									
				<input type="text" name="Memo_#left(WorkPlanDetailId,8)#" value="#Memo#" 
					onchange="ColdFusion.navigate('Agenda/setScheduleMemo.cfm?id=#WorkPlanDetailId#','process','','','POST','agenda')"
					class="regularxl enterastab atext" style="font-size:13px;height:94%;width:100%;min-width:100px;border:0px;">
					
				<cfelse>
				<span style="padding-left:4px;color:gray">#Memo#</span>			
				</cfif>
			</td>		
					
		</tr>
		
		<cfif scheduleLog gte "1">		
			<tr id="log_#workactionid#" style="display:none;">
				<td colspan="2"></td>
				<td style="border-left:1px solid silver" colspan="8" id="logContent_#workactionid#"></td>
			</tr>
			<!---
			<tr id="#workactionid#" class="hide"><td colspan="8" class="line" id="#workactionid#_content"></td></tr>
			--->
		</cfif>
		
	</cfif>	
		
</cfoutput>
<cfset row = row+1>

<cfset ajaxOnLoad("doHighlight")>