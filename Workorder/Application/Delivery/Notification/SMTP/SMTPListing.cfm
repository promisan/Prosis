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
<!---- By dev dev dev, 
Promisan b.v. 
SMS, March 2011
--->

<cfparam name="CLIENT.SMTP" default = "">
<cfif CLIENT.SMTP eq "">
   <cfset CLIENT.SMTP = "Beste @CNAME@, uw aankoop van @BRANCH@ wordt vandaag bezorgd tussen: @DELIVERYTIME@ door chauffeur @DRIVER@, tel: @DRIVERTEL@">
</cfif>

<cfset notification = "SMTP">
<cfinclude template="../prepareNotification.cfm">

<table width="100%" height="100%">

<tr><td style="padding:6px">

<cf_divscroll>

<cfoutput>		

<table width="98%" class="navigation_table" cellspacing="1" align="center" style="padding-right:4px">

	<tr><td colspan="7" style="height:40px" align="center">
		<input type="button" class="button10g" style="width:250px;height:28px" value="Send e-Mail" onClick="javascript:send_smtp('#resultList.recordcount#')">
	</td></tr>
	
	<tr class="line labelmedium">
			
		<td width="4%" align="center">
		
			<input type="checkbox" class="radiol" id="toggle" name="toggle" onclick = "mark_smtp(this.checked,'#resultlist.recordcount#')">
						
		</td>
		<td></td>		
		<td>Branch</td>
		<td>Customer Name</td>
		<td>e-Mail</td>
		<td>Driver</td>		
		<td>Delivery time</td>		
		<td>Reference</td>	 
	</tr>
		
	<cfset vCurrent = 0>
	
	<cfloop query="ResultList">
						
		<cfif NotificationEnabled eq "">
		
			<!--- we do not show here to be selected --->
			
		<cfelse>		
										
			<cfset vCurrent = vCurrent + 1>	
											
			<tr class="labelmedium" id="r#currentrow#" bgcolor="<cfif notifications eq 0>ffffaf</cfif>">
				<td align="center">								
				    <cfif PhoneNumber neq "">
						<input type="checkbox" class="radiol"  id="csmtp" name="csmtp" value="#WorkOrderId#|#WorkOrderLine#|#emailaddress#">
					<cfelse>
					n/a	
					</cfif>
				</td>
				
				<td style="padding-left:4px;padding-right:7px">#vCurrent#.</b></td>
				<td>#OrgUnitName#</td>
				<td>#CustomerName#</td>
				<td>#eMailAddress#</td>
				<td>#Lastname#</td>				
				<td>#PlanOrderDescription#</td>				
				<td>#Reference#</td>	 
			</tr>
			
			<cfif notifications gte "1">
			
				<!--- we show the notifications that we sent --->
			
				<!--- Checking for the sms flag --->
				
				<cfif session.acc eq "Administrator">
			
				<cfquery name="Prior" datasource="AppsWorkOrder">		
					SELECT   *
					FROM     WorkOrderLineAction
					WHERE    WorkOrderId   = '#workOrderId#'
					AND      WorkOrderLine = '#WorkOrderLine#'
					AND      ActionClass   = 'Notification'
					AND      ActionStatus != '9'
					ORDER BY Created DESC
				</cfquery>		
						 
				<cfloop query="Prior">
				
					<tr class="labelit navigation_row_child">
					   <td></td>
					   <td></td>
					   <td></td>
					   <td class="line" valign="top" bgcolor="ffffcf" style="padding-left:4px" colspan="1">#dateformat(DateTimeActual,client.dateformatshow)# #timeformat(DateTimeActual,"HH:MM:SS")#</td>
					   <td class="line" valign="top" colspan="1" bgcolor="ffffcf">#OfficerLastName#</td>
					   <td class="line" colspan="4" style="padding-left:8px;padding-right:8px">#ActionMemo#</td>
					</tr>				
				
				</cfloop>		
				
				</cfif>		
						
			</cfif>
	
		</cfif>		
			
	</cfloop>
	
</cfoutput>

</table>

</cf_divscroll>
</td></tr>
</table>

<cfdiv id = "processing_smtp"/>

<cfset ajaxonload("doHighlight")>


<script>
	Prosis.busy('no')
</script>	

