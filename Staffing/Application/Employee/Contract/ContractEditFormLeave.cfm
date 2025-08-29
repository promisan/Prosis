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
<cfif mode eq "edit">
	<tr><td height="19" colspan="3"  class="labelmedium" style="font-size:22px;border-top:1px solid silver;border-bottom:1px solid silver;height:45px;padding-left:3px"><cf_tl id="Leave"><cf_tl id="Entitlements"></td></tr>
</cfif>

<cfoutput query="Leave">		
						
	<cfquery name="Check" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      PersonLeaveEntitlement
		WHERE     PersonNo      = '#url.id#'
		AND       ContractId    = '#URL.ID1#'
		AND       LeaveType     = '#LeaveType#'
	</cfquery>
			
	<tr>
	    <TD style="padding-left:5px;padding-right:10px;" class="labelmedium bcell">#Description# <cf_tl id="accrual">:</TD>
	  							
			<cfif mode eq "view">
				<td bgcolor="#pclr#" class="ccell">
				
					<table cellspacing="0" cellpadding="0">
					
					<tr><td>
														
					<cfset url.mission       = ContractSel.Mission>
					<cfset url.leavetype     = leavetype>
					<cfset url.dateeffective = dateformat(ContractSel.DateEffective,CLIENT.DateFormatShow)>
					<cfinclude template="ContractLeaveEntitlement.cfm">
					
					</td></tr>
					</table>
				
				</td>
			</cfif>
	
	 		<cfif mode eq "edit" or last eq "1">  
				<td height="24" bgcolor="#color#" class="ccell" id="editfield" name="editfield">		
				
				    <cfif ContractSel.actionStatus eq "1">
					
					<table>
					<tr>
					<td style="padding-right:4px; border-right:1px solid silver;">											   			   
				    <INPUT type="input" name="#LeaveType#" value="#Check.DaysEntitlement#" style="width:30;text-align:center" maxlength="3" class="regularxlbl"> 
					</td>					
					<td style="padding-left:5px" class="labelit"><cf_tl id="days"></td>
					</tr>
					</table>
					
										   
				   <cfelse>
				   
					   <cfquery name="getThisLeave" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    *
							FROM      PersonLeaveEntitlement
							WHERE     PersonNo      = '#URL.ID#'
							AND       LeaveType     = '#LeaveType#'		
							AND       ContractId = '#URL.ID1#'			
						</cfquery>
						
						<table cellspacing="0" ccellpadding="0">
						<tr><td class="labelmedium">
											
					    <!--- new record --->				
													
						<input type="text" name="#LeaveType#" value="#getThisLeave.DaysEntitlement#" maxlength="3" class="regularxlbl" 
						style="border-left:1px solid silver;border-right:1px solid silver;width:30;text-align:right;padding-right:4px"> <cf_tl id="days">
						
						
						</td>
						</tr>
						
						<tr><td style="border-top:1px solid silver;">	
														
						<cfset url.mission       = ContractSel.Mission>
						<cfset url.leavetype     = leavetype>
						<cfset url.dateeffective = dateformat(ContractSel.DateEffective,CLIENT.DateFormatShow)>
						<cfinclude template="ContractLeaveEntitlement.cfm">
						
						</td></tr>
						
						</table>					
				  	
				   </cfif>	
				   
				</td>							
			</cfif>
			
		</TD>
	</TR>	
			
</cfoutput>	