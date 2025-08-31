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

<cfparam name="CLIENT.SMS" default = "">
<cfif CLIENT.SMS eq "">
   <cfset CLIENT.SMS = "Beste @CNAME@, uw aankoop van @BRANCH@ wordt vandaag bezorgd tussen: @DELIVERYTIME@ door chauffeur @DRIVER@, tel: @DRIVERTEL@. www.kuntzonline.nl">
</cfif>


<cfset notification = "SMS">
<cfinclude template="../prepareNotification.cfm">

<table width="100%" height="100%">

<tr><td style="padding:6px">

<cf_divscroll>

<cfoutput>		

<table width="98%" class="navigation_table" navigationhover="transparent" cellspacing="1" align="center" style="padding-right:4px">

	<tr><td colspan="8" style="height:40px" align="center">
		<input type="button" class="button10g" style="width:250px;height:28px" value="Send SMS" onClick="javascript:send_sms('#resultList.recordcount#')">
	</td></tr>
	
	<tr class="line labelmedium">			
			
		<td width="1%"></td>	
		<td width="2%" align="center" style="padding-left:5px;padding-right:5px;">
		
			<input type="checkbox" class="radiol" id="toggle" name="toggle" onclick = "mark_sms(this.checked,'#resultlist.recordcount#')">
						
		</td>
		<td></td>		
		<td><b><cf_tl id="Branch"></td>
		<td><b><cf_tl id="Customer"></td>
		<td><b><cf_tl id="Mobile"></td>
		<td><b><cf_tl id="Driver"></td>		
		<td><b><cf_tl id="Schedule"></td>		
		<td><b><cf_tl id="Reference"></td>	 
	</tr>
		
	<cfset vCurrent = 0>
	
	<cfloop query="ResultList">
						
		<cfif NotificationEnabled eq "">
		
			<!--- we do not show here to be selected --->
			
		<cfelse>		
													
			<cfset vCurrent = vCurrent + 1>	
											
			<tr class="labelmedium navigation_row" id="r#currentrow#" bgcolor="<cfif notifications eq 0>ffffaf</cfif>">
			
				<td style="width:10px" align="center" class="navigation_pointer"></td>     
				<td align="center" style="padding-left:5px;padding-right:5px">								
				    <cfif MobileNumber neq "">
						<input type="checkbox" class="radiol"  id="csms" name="csms" value="#WorkOrderId#|#WorkOrderLine#|#MobileNumber#">
					<cfelse>
					n/a	
					</cfif>
				</td>
				
				<td style="padding-left:4px;padding-right:7px">#vCurrent#.</b></td>
				<td>#OrgUnitName#</td>
				<td>#CustomerName#</td>
				<td><cfif MobileNumber neq "">#MobileNumber#<cfelse>#PhoneNumber#</cfif></td>
				<td>#Lastname#</td>				
				<td>#PlanOrderDescription#</td>				
				<td>#Reference#</td>	 
			</tr>
			
			<cfif notifications gte "1">
						
				<!--- Checking for the sms flag --->
				
				<!---- 
				
				Ferry kindly asked us to remove this as he gets confused March 21 2015
				JHanno : we have to see an indicator that it was sent before.
				
				--->
				
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
						   <td class="line" valign="top" bgcolor="e4e4e4" style="padding-left:4px" colspan="1">#dateformat(DateTimeActual,client.dateformatshow)# #timeformat(DateTimeActual,"HH:MM:SS")#</td>
						   <td class="line" valign="top" style="border-right:1px solid gray" colspan="1" bgcolor="e4e4e4">#OfficerLastName#</td>
						   <td class="line" colspan="4" style="padding-left:8px;padding-right:8px"><font color="0080C0">
						   <cfif actionStatus eq "9"><font color="FF0000"></cfif>#ActionMemo#</td>
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

<cfdiv id = "processing"/>

<cfset ajaxonload("doHighlight")>

<script>
	Prosis.busy('no')
</script>	
