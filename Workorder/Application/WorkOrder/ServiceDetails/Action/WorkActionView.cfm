
<cf_screentop labelmedium="Workorder action" height="100%" scroll="Yes" jquery="Yes" layout="webapp" banner="gray">

<cf_ActionListingScript>
<cf_FileLibraryScript>
<cf_MenuScript>

<cfparam name="url.drillid" default="">

<cfif url.drillid eq "">
 
	  <cfabort>

</cfif>

<cfquery name="wfWorkorderLineAction" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT   C.CustomerName, 
	         W.Reference, 
			 W.ServiceItem, 
			 WS.Description AS ServiceLineDescription, 
			 WS.Reference AS ServiceLineReference, 
			 WLA.ActionClass, 
             WLA.DateTimePlanning, 
			 WLA.DateTimeActual, 
			 WLA.WorkActionId,
			 WLA.ActionMemo,
			 WLA.OfficerUserId,
			 WLA.OfficerLastName,
			 WLA.OfficerFirstName,
			 WLA.Created
	
	FROM     WorkOrderLineAction WLA INNER JOIN
             WorkOrderLine WL ON WLA.WorkOrderId = WL.WorkOrderId AND WLA.WorkOrderLine = WL.WorkOrderLine INNER JOIN
             WorkOrderService WS ON WL.ServiceDomain = WS.ServiceDomain AND WL.Reference = WS.Reference INNER JOIN
             WorkOrder W ON WL.WorkOrderId = W.WorkOrderId INNER JOIN
             Customer C ON W.CustomerId = C.CustomerId
		
	WHERE    WorkActionId   = '#url.drillid#'	
		
</cfquery>

<cfoutput>
<table width="96%" cellspacing="3" cellpadding="1" align="center">

	<tr><td class="labelmedium"><cf_tl id="Customer">:</td>
	    <td class="labelmedium">#wfWorkorderLineAction.CustomerName#</td>
		<td class="labelmedium">Reference:</td>
		<td class="labelmedium">#wfWorkorderLineAction.reference#</td>		
	</tr>
	
	<tr><td class="labelmedium"><cf_tl id="Service">:</td>
	    <td class="labelmedium">#wfWorkorderLineAction.ServiceLineReference#</td>
		<td class="labelmedium">Name:</td>
		<td class="labelmedium">#wfWorkorderLineAction.ServiceLineDescription#</td>		
	</tr>
	
	<tr><td class="labelmedium"><cf_tl id="Action">:</td>
	    <td class="labelmedium">#wfWorkorderLineAction.ActionClass#</td>
		<td class="labelmedium">Reporting Officer:</td>
		<td class="labelmedium">#wfWorkorderLineAction.OfficerFirstName# #wfWorkorderLineAction.OfficerLastName#</td>		
	</tr>
	
	<tr><td class="labelmedium"><cf_tl id="Due">:</td>
	    <td class="labelmedium">#dateformat(wfWorkorderLineAction.DateTimePlanning, client.dateformatshow)#</td>
		<td class="labelmedium">Reported:</td>
		<td class="labelmedium">#dateformat(wfWorkorderLineAction.Created, client.dateformatshow)# #timeformat(wfWorkorderLineAction.Created, "HH:MM")#</td>		
	</tr>
	
	<cfif wfWorkorderLineAction.ActionMemo neq "">
	<tr><td class="labelmedium"><cf_tl id="Memo">:</td>
	    <td class="labelmedium" colspan="3">#wfWorkorderLineAction.ActionMemo#</td>
	</tr>
	</cfif>
	
	<tr><td></td></tr>
	
	<tr><td class="line" colspan="4"></td></tr>
					
	<input type="hidden" name="workflowlink_#url.drillid#" id="workflowlink_#url.drillid#"
	   value="#session.root#/WorkOrder/Application/WorkOrder/ServiceDetails/Action/WorkActionWorkflow.cfm">	
		   
	 <tr id="box_#url.drillid#">
		   		     
		  <td id="#url.drillid#" colspan="4">
			  						 
			     <cfset url.ajaxid = url.drillid>
				 <cfinclude template="WorkActionWorkflow.cfm">				
				 		
		  </td>
	 </tr>			
	
</table>

</cfoutput>

<cf_screenbottom layout="webapp">