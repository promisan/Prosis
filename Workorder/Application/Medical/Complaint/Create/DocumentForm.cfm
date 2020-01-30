
<cfparam name="URL.scope"         default="Portal">
<cfparam name="url.mission"       default="Aldana">

<cfparam name="URL.drillid"       default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.requestid"     default="#url.drillid#">

<cfif URL.requestId eq "00000000-0000-0000-0000-000000000000">

	<cfquery name="qCheck" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Request
		WHERE  PersonNo = '#URL.ID#'
		AND    ActionStatus<'3'		
	</cfquery>	
	
	<cfif qCheck.recordCount neq 0>
			
		 <cf_tl id="You cannot record a new request as there are already some pending requests" var="1">	                                        
         <cf_message message = "#lt_text#" return="No">
         <cfabort>			
		
	</cfif>		
	
</cfif>	

<cfparam name="url.requestline"   default="1">
<cfparam name="url.workorderid"   default="">
<cfparam name="url.workorderline" default="">
<cfparam name="url.domain"        default="Interaction">
<cfparam name="url.status"        default="">
<cfparam name="url.accessmode"    default="edit">

<cfoutput>
    <!--- field for caputuring the selected workorderline --->
	<input type="hidden" name="workorderlineid" id="workorderlineid"  value="">		
	<input type="hidden" name="servicedomain"   id="servicedomain"    value="#url.domain#">			
</cfoutput>

<cfquery name="Parameter" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE Mission = '#url.mission#'	
</cfquery>

<cfquery name="RequestLine" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT ValueFrom as Serviceitem
		FROM   RequestWorkorderDetail
		WHERE  Amendment = 'ServiceItem'
		<cfif url.requestid eq "">
		AND 1=0
		<cfelse>
		AND  Requestid   = '#url.requestid#'
		</cfif>		
</cfquery>

<cfquery name="Request" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Request
	<cfif url.requestid eq "">
	WHERE 1=0
	<cfelse>
	WHERE  Requestid = '#url.requestid#'
	</cfif>		
</cfquery>

<!--- support this as at some point users can no longer edit it based on the actionstatus of the request 
    after it is applied into a workorder line --->
	
<cfif Request.ActionStatus lt "3">
	
		<cfset url.accessmode = "edit">
		<cfset url.mode = "edit">
		
<cfelse>

		<cfset url.accessmode = "view">
		<cfset url.mode = "view">
		
</cfif>		

<!--- ------- --->
		
<cfoutput>

<table style="width:100%;height:100%" border="0"><tr><td>

<cfform style="width:100%;height:100%" name="formrequest" id="formrequest" onsubmit="return false">	

	<table width="94%" align="center" cellspacing="0" cellpadding="0" class="formpadding formspacing">
	
	   <tr><td height="8"></td></tr> 
	   <tr><td colspan="4" id="process"></td></tr>
	 				   
	   <cfif Request.RequestDate eq "">
	   		<cfset dte = "#DateFormat(now(),CLIENT.DateFormatShow)#">
	   <cfelse>
	        <cfset dte = "#DateFormat(Request.RequestDate,CLIENT.DateFormatShow)#">
	   </cfif>
	   
	    <tr>			
			<td style="padding-left:16px" class="labelmedium"><cf_space spaces="60">
				<cf_tl id="Request Date">
			</td>			
			<td class="labelmedium">
				<cfif url.accessmode eq "view">
				
					#dateformat(dte,client.dateformatshow)#
				
				<cfelse>
				
				   <cf_intelliCalendarDate9
				      FieldName="RequestDate" 			 
					  class="regularxl enterastab"			  
				      Default="#dte#">
					  
				</cfif>	  
			</td>					  
		</tr>	
						
		<!--- the core of the core --->
		<cfinclude template="../Create/DocumentFormRequestType.cfm">				
			
		<!--- support the view mode here as well --->				
		<cfset url.inputclass = "regularxl">
		<cfset url.style      = "padding-left:16px">
		<cfinclude template="../Create/DocumentFormTopic.cfm">			
				
	    <cfif url.accessmode eq "view">
		
			<tr class="line">			
			<td valign="top" style="height:20px;border-top:1px solid silver;border-bottom:1px solid silver:padding:4px;padding-left:16px;padding-right:20px" class="labelmedium" colspan="2">
			#Request.Memo#</td></tr>	
		
		<cfelse>
		
			<tr>			
			<td valign="top" style="padding-top:4px;padding-left:16px;padding-right:20px" class="labelmedium" colspan="2">								
			<cf_textarea name="memo" width="98%" height="120" init="no" color="ffffff" toolbar="basic" onchange="updateTextArea();">#Request.Memo#</cf_textarea>	
			</td>				 
			</tr>	
			
		</cfif>	
			
		
		<cfif Request.ActionStatus eq "3">
		
			<tr>				
				   <td style="padding-left:16px" class="labelmedium"><cf_tl id="Status">:</td>
				   <td class="labelmedium">								   
				   <cf_tl id="This request has been processed">					   
				  </td>			  
			</tr>
					
			<tr>				
				   <td style="padding-left:16px" class="labelmedium"><cf_tl id="Upcoming appointment">:</td>
				   <td class="labelmedium">		
				   
				   <cfquery name="Schedule" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    SELECT     WLA.ActionClass, WPD.DateTimePlanning, WLA.WorkactionId
					FROM       WorkOrderLineAction AS WLA INNER JOIN
	                           WorkOrderLine AS WL ON WLA.WorkOrderId = WL.WorkOrderId AND WLA.WorkOrderLine = WL.WorkOrderLine INNER JOIN
	                           Request AS R INNER JOIN
	                           RequestWorkOrder AS RW ON R.RequestId = RW.RequestId ON WL.WorkOrderId = RW.WorkOrderId AND WL.WorkOrderLine = RW.WorkOrderLine INNER JOIN
	                           Ref_Action A ON WLA.ActionClass = A.Code INNER JOIN
	                           WorkPlanDetail AS WPD ON WLA.WorkActionId = WPD.WorkActionId
					WHERE      R.RequestId = '#url.requestid#' 
					AND        WL.Operational = 1 
					AND        WLA.ActionStatus <> '9' 
					AND        A.ActionFulfillment = 'Schedule'
					ORDER BY   WPD.DateTimePlanning DESC
				   </cfquery>	
				   
				   <cfif Schedule.recordcount eq "0">
				    		<cf_tl id="Not scheduled">
				   <cfelse>
				   		<a href="javascript:medicalopen('#schedule.workactionid#')">
						  <font color="0080C0">#dateformat(schedule.DateTimePlanning,client.dateformatshow)# #timeformat(schedule.DateTimePlanning,"HH:MM")#</font>
						</a>
				   </cfif>	   
				   				   
				   <!--- show an upcoming appointment date if this lies in the future otherwise allow to open here the appointment dialog like we have there --->
				   		   
				  </td>			  
			</tr>
			
			<tr>				  	  
				 <td>
				 
				 <cf_tl id="Back" var="1">
				 <input type="button" id="entryadd" style="width:160;font-size:13px" value="#lt_text#" 
				   class="button10g"  
				   onClick="closeComplaint('#URL.owner#','#URL.id#')">  				   
				 </td>							 
			</TR>				 
				
		
		<cfelse>	  
						
			<tr>			
				<td colspan="2">
					  <table align="center" cellspacing="0" cellpadding="0" class="formspacing formpadding"
					  	<tr>				  	  
							 <td>
							 
							 <cf_tl id="Back" var="1">
							 <input type="button" id="entryadd" style="width:160;font-size:13px" value="#lt_text#" 
							   class="button10g"  
							   onClick="closeComplaint('#URL.owner#','#URL.id#')">  
							   
							 </td>		
							 						  	  
						   	 <cfif URL.requestId eq "00000000-0000-0000-0000-000000000000">
							 
						   	 	<td>					   	 		
						   	 		<cf_tl id="Save" var="1">
							 		<input type="button" id="entryadd" style="width:160;font-size:13px" value="#lt_text#" 
						       		class="button10g" onClick="updateTextArea();addComplaint('#URL.owner#','#URL.id#','#URL.mission#')">
							 	</td>
								
							 <cfelseif Request.ActionStatus lte 1>
							 							 							 
							  		<td>
							  			
							 			<cf_tl id="Delete" var="1">
							 			<input type="button" id="entryadd" style="width:160;font-size:13px" value="#lt_text#" 
						       			class="button10g"  
							   			onClick="deleteComplaint('#URL.owner#','#URL.requestId#')">						  
							 		</td>									
									
									<td>			
								  		<cf_tl id="Save" var="1">
							 			<input type="button" id="entryadd" style="width:160;font-size:13px" value="#lt_text#" 
						       			class="button10g"  
								   		onClick="updateTextArea();updateComplaint('#URL.owner#','#URL.requestId#')">
							 		</td>	
									
								
															  
							 </cfif>  
						</tr>
					   </table>
				</td>			
			</tr>	
			
		</cfif>	
				
		<cfif url.scope eq "Backoffice" or getAdministrator("*") eq "1">
		
			<cfif URL.requestId neq "00000000-0000-0000-0000-000000000000">
				<tr>
					<td colspan="2">
																
						<cfset wflnk = "../Create/DocumentWorkflow.cfm">
						   
						<input type="hidden" 
						    id="workflowlink_#URL.RequestId#" 
						    value="#wflnk#"> 
						 
						<cfdiv id="#URL.RequestId#" 
						  bind="url:#wflnk#?ajaxid=#URL.RequestId#"/>
						
					</td>	
				</tr>
			</cfif>		
		
		</cfif>
		
	</table>
	
</cfform>


</td></tr></table>

<cfif request.requesttype eq "">
	
	<cfset ajaxOnLoad("function(){ loadrequesttype('#accessmode#','#url.scope#','#url.requestid#','#url.workorderid#',document.getElementById('serviceitem').value); }")> 
	
<cfelse>

    <!---
	
	<cfquery name="WorkOrder" 
	   datasource="AppsWorkOrder" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		 SELECT W.WorkOrderLineId	
	     FROM   RequestWorkOrder R,
		        WorkOrderLine W
		 WHERE  Requestid       = '#url.requestid#'	     
		 AND    R.WorkorderId   = W.WorkOrderId
		 AND    R.WorkorderLine = W.WorkOrderLine
	</cfquery>	
	
	 <!--- if edit we already do have the values, just load the custom form --->	    
		
	 <script language="JavaScript">
    	 loadcustomform('#request.requestid#','#Request.RequestType#','#RequestLine.Serviceitem#','#accessmode#','#Workorder.workorderlineid#','#Request.RequestAction#')		 
	 </script>
	 
	 --->
	 	 
</cfif>

</cfoutput>

<cfset AjaxOnload("doCalendar")>
<cfset AjaxOnload("initTextArea")>