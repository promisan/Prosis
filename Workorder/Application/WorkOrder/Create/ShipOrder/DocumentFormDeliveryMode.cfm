<!--
    Copyright © 2025 Promisan

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