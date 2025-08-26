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
<!---- By dev dev dev, 
Promisan b.v. 
November 2015
--->

	<cfparam name="SESSION.SMTP" default = "">
	<cfset notification = "SMTP">

	<cfquery name="qNotification" datasource="AppsWorkOrder">
		SELECT     Action, ServiceItem, Notification, NotificationName, TemplatePath, Operational, OfficerUserId, OfficerLastName, OfficerFirstName, Created
		FROM         Ref_ActionServiceItemNotification
		WHERE     Action IN
	                          (SELECT Code
	                            FROM  Ref_ActionNotification
	                            WHERE Protocol = '#notification#'
	                           )
	</cfquery>
	
    <cfinclude template="../../../../../../#qNotification.TemplatePath#">
    <cfset SESSION.SMTP = mailtext>
    <cfset SESSION.FROM = vfrom>

<cfinclude template="../prepareNotification.cfm">

<cfform id="fNotification">
	<cfoutput>		
	<table width="98%" class="navigation_table" cellspacing="1" align="center" style="padding-right:4px" height="100%">
		<tr><td colspan="7" style="height:40px" align="center">
			<input type="button" class="button10g" style="width:250px;height:28px" value="Send e-Mail" onClick="javascript:send_smtp('#resultList.recordcount#')">
		</td></tr>
		<tr class="line labelmedium">
				
			<td width="4%" align="center">
			
				<input type="checkbox" class="radiol" id="toggle" name="toggle" onclick = "mark_smtp(this.checked,'#resultlist.recordcount#')">
							
			</td>
			<td></td>		
			<td><cf_tl id="Administrative Unit"></td>
			<td><cf_tl id="Patient"></td>
			<td><cf_tl id="e-Mail"></td>
			<td><cf_tl id="Specialist"></td>		
			<td><cf_tl id="Schedule Time"></td>		
			<td><cf_tl id="Reference"></td>	 
		</tr>
		<cfset vCurrent = 0>
		<cfloop query="ResultList">
							
			<cfif NotificationEnabled eq "">
			
				<!--- we do not show here to be selected --->
				
			<cfelse>		
											
				<cfset vCurrent = vCurrent + 1>	
												
				<tr class="labelmedium" id="r#currentrow#" bgcolor="<cfif notifications eq 0>ffffaf</cfif>">
					<td align="center">								
					    <cfif emailaddress neq "">
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
					<td>#DateFormat(DateTimePlanning,CLIENT.DateFormatShow)# #TimeFormat(DateTimePlanning,'HH:mm:ss')#</td>				
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
						AND     ActionClass IN (
								SELECT Code
								FROM Ref_Action
								WHERE ActionFulfillment = 'Message'
						)
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
	</table>
	</cfoutput>	
	<input type="hidden" name="end_text" id="end_text">
</cfform>

	<cfdiv id = "processing_smtp"/>

	<cfset ajaxonload("doHighlight")>


	<script>
		Prosis.busy('no')
	</script>	

