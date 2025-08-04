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
	
<cfform onsubmit="return false" name="formmission" method="POST">

	<cfquery name="Get" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM SalaryScheduleMission
	WHERE    SalarySchedule = '#URL.Schedule#'
	AND      Mission = '#URL.Mission#'
	</cfquery>
		
	<table width="95%" align="center" class="formpadding formspacing">
	
	<cfoutput>
	 	
	<TR class="labelmedium2">
	
	    <TD width="20%"><cf_tl id="Effective Date">:</TD>
	    <TD>
		
		  <cf_intelliCalendarDate9
				FieldName="DateEffective" 
				class="regularxxl"
				Default="#dateformat(get.DateEffective,CLIENT.DateFormatShow)#"
				AllowBlank="False">	
	  	
	    </TD>
        
	</TR>
		
		<cf_verifyOperational 
         datasource= "appsSystem"
         module    = "Accounting" 
		 Warning   = "No">
		 
		<cfif Operational eq "1"> 
			
			<cfquery name="GL" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * FROM Ref_Account
				WHERE    GLAccount = '#get.GLAccount#'
			</cfquery>	
			
			<TR class="labelmedium2">
		    <TD><cf_tl id="Payroll Account">:</TD>
		    <TD>	
				    <cfoutput>	 
					
					<table><tr><td>
				    <img src="#SESSION.root#/Images/contract.gif" alt="Payroll Account" name="img3" 
						  onMouseOver="document.img3.src='#SESSION.root#/Images/button.jpg'" 
						  onMouseOut="document.img3.src='#SESSION.root#/Images/contract.gif'"
						  alt="" width="30" height="30" border="0" align="absmiddle" 
						  onclick="selectaccountgl('#URL.mission#','glaccount','','','applyaccount','')">
						</td>
						<td style="padding-left:2px">
					    <input type="text"   name="glaccount"     id="glaccount"     size="6" value="#GL.glaccount#" class="regularxxl" readonly style="text-align: center;">
						</td>
						<td style="padding-left:2px">
				    	<input type="text"   name="gldescription" id="gldescription" value="#GL.description#" class="regularxxl" size="40" readonly style="text-align: center;">
					    <input type="hidden" name="debitcredit"   id="debitcredit"   value="">
						</td></tr></table> 
				   </cfoutput>
			
		     </TD>
			</TR>
		
		</cfif>
		
		<TR class="labelmedium">
	
	    <TD width="20%"><cf_tl id="Advance">:</TD>
	    <TD>
		
		<table>
			<tr class="labelmedium2">
				<td>
				<input type="radio" class="radiol" name="SettleInitialMode" value="0" <cfif get.SettleInitialMode eq "0">checked</cfif> value="1">		
				</td>
				<td><cf_tl id="No"></td>
				<td style="padding-left:10px">
				<input type="radio" class="radiol" name="SettleInitialMode" value="1" <cfif get.SettleInitialMode eq "1">checked</cfif>>
				</td>
				<td><cf_tl id="Yes"></td>
				<td style="padding-left:8px">
				<input type="text" name="SettleInitial" class="regularxxl" value="#get.SettleInitial#" value="#get.SettleInitial#" maxlength="3" style="text-align:center;width:40px">
				</td>
				<td style="padding-left:3px">%</td>
			</tr>
		</table>
		
	    </TD>
        
	</TR>
	
	<tr><td id="processmanual"></td></tr>
	
	<tr><td class="line" colspan="2" align="center" height="30">
	
		<cfquery name="Check"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT TOP 1 *
				FROM   EmployeeSalary
				WHERE  SalarySchedule = '#URL.Schedule#'
				AND    Mission = '#URL.Mission#'
			</cfquery>
		
		<input class="button10g" type="button" name="Cancel" value="Close" onClick="ProsisUI.closeWindow('misdialog')">
		<cfif check.recordcount eq "0">
		<input class="button10g" type="submit" name="Delete" value="Delete" onclick"missioneditsubmit('#url.schedule#','#url.mission#','delete')>
		</cfif>
	    <input class="button10g" type="submit" name="Update" value="Update " onclick="missioneditsubmit('#url.schedule#','#url.mission#','update')">
		
	</td></tr>
	
	</cfoutput>
	
	</table>
				
</cfform>	

<cfset ajaxOnLoad("doCalendar")>
