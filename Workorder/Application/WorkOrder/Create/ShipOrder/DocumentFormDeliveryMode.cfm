
<cfoutput>

	<!---

	#url.mission#
	#url.action#
	#url.selected#
	
	--->
	
	<cfquery name="Action" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT   TOP 1 *
		FROM     WorkOrderLineAction
		WHERE    WorkOrderId   = '#url.workorderid#'		  
		AND      WorkOrderLine = '#url.workorderline#'	
		AND      ActionClass   = '#url.action#'					  
		ORDER BY Created DESC
	</cfquery>			
	
	<cfquery name="ServiceItem" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT   *
		FROM     ServiceItemMission
		WHERE    ServiceItem   = '#url.serviceitem#'		  
		AND      Mission       = '#url.Mission#'				  		
	</cfquery>		
	
	<cf_getLocalTime Mission="#url.mission#">
		
		
	<cfif url.selected eq "today" or (url.selected eq "tomorrow" and hour(localtime) gte "17")>
		
		<table width="100%">
		
			<tr><td class="labellarge"><font color="FF0000">
			<cf_tl id="For express deliveries you should always call to contact our office!">
			<font color="FF0000">#serviceItem.ServiceInformation#</font>
				
			</td>
			</tr>
			
			<tr><td class="labelmedium" style="padding-left:10px">
			
			<cf_tl id="With who did you speak?">:
			
			</td></tr>
			<tr><td style="width:100%;padding-left:10px">
			
			<textarea style="width:100%;height:30" class="regular" name="DateMemo#url.action#">#Action.ActionMemo#</textarea>
			
					
			</td></tr>
		
		</table>
	
	</cfif>

</cfoutput>