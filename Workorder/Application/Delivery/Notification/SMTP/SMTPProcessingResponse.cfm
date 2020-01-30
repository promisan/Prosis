<cfif url.txt neq "">
	<cfset Message = "">
	<cfloop from="1" to=#ListLen(SESSION.csmtp)# index="i"> 
			<cfset workorder = ListGetAt(SESSION.csmtp, i)> 
			<cfset WorOrder = Replace(WorkOrder,"{","","all")>
			<cfset WorOrder = Replace(WorkOrder,"}","","all")>		
			<cfset WorkOrderId   = ListGetAt(workOrder, 1,"|")> 
			<cfset WorkOrderLine = ListGetAt(workOrder, 2,"|")> 
			<cfset veMailAddress = ListGetAt(workOrder, 3,"|")> 
			<cfquery name="qAction" datasource="AppsWorkOrder">
				SELECT *
			  	FROM WorkOrderLineAction
			  	WHERE 
			       	WorkOrderId   = '#WorkOrderId#' AND
			       	WorkOrderLine = '#WorkOrderLine#' AND
			       	ActionClass   = 'Notification'
			  	ORDER BY Created DESC
			</cfquery>  	
			<cfset Message = "#Message# #qAction.ActionMemo#<BR><HR><BR>">
	</cfloop>
</cfif>	

<cfoutput>
  <table align="center" valign="top" width="100%" height="100%">
  	<tr valign="top">
		<td style="padding:4px" class="labelmedium">
			<cfif url.txt neq "">
				#Message#
			<cfelse>
				Displaying results...	
			</cfif>	
		</td>
	</tr>
	</table> 
</cfoutput>