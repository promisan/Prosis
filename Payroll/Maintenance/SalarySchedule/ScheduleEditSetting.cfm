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
<table width="95%" align="center" class="formpadding ">
	
	    <tr><td height="4"></td></tr>
		
		<tr class="line"><td colspan="2" class="labellarge" style="font-weight:200;font-size:25px">Schedule general settings</td></tr>
		
		<TR>
	    <TD style="padding-left:10" width="20%" class="labelmedium2"><cf_tl id="Name">:</TD>
	    <TD>
			<table width="100%" cellspacing="0" cellpadding="0"><tr><td>
		  	   <input type="hidden" name="SalarySchedule" value="#get.SalarySchedule#" size="10" maxlength="10" class="regularxxl" disabled>
		  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" required=  "yes" size="40" 
			   maxlenght = "40" class="regularxxl" style="height:28">
		    </TD>
			<td align="right" style="padding-right:20px">
			 <table>
			 <tr>
			   <td class="labelmedium2"><cf_tl id="Sort">:</td>
			   
			  <td>
			   <input type="text" name="ListingOrder" value="<cfoutput>#get.ListingOrder#</cfoutput>" style="text-align:center;width:30px" class="regularxxl">
			   </td>
			 
			  <td>
			   <input type="checkbox" name="Operational" class="radiol" value="1" <cfif get.Operational eq "1">checked</cfif>>
			   </td>
			   <td class="labelmedium2" style="padding-left:4px">Operational</td>
			   </tr></table>
			</td>
					
			</TR>
			</table>
		</td>
		</tr>
		
		<tr>		
	    <TD style="padding-left:10"  class="labelmedium2"><cf_tl id="Calculation Period">:</TD>
	    <TD>
		   <table cellspacing="0" cellpadding="0"><tr><td>
		   <select name="SalaryCalculationPeriod" class="regularxxl">
		   <option value="MONTH" <cfif Get.SalaryCalculationPeriod eq "MONTH">selected</cfif>>MONTH</option>
		   <!---
		   <option value="2WEEK" <cfif #Get.SalaryCalculationPeriod# eq "2WEEK">checked</cfif>>BI-WEEKLY</option>
		   <option value="WEEK" <cfif #Get.SalaryCalculationPeriod# eq "WEEK">checked</cfif>>WEEK</option>
		   --->
		   </select>		   
		   </TD>
		   <td style="padding-left:3px">
		  

			   <select name="SalaryBasePeriodDays" class="regularxxl">
			   <option value="30"    <cfif Get.SalaryBasePeriodDays eq "30">selected</cfif>>Actual Calendar Days (28-31)</option>
			   <option value="30fix" <cfif Get.SalaryBasePeriodDays eq "30fix">selected</cfif>>Fixed 30 Day month</option>
			   <option value="21.75" <cfif Get.SalaryBasePeriodDays eq "21.75">selected</cfif>>Average Working days (21.75)</option>	
			   </select>
	  
		   </td>
		   		   		   
		   <TD style="padding-left:10" class="labelmedium2"><cf_tl id="Day definition">:&nbsp;</TD>
		       <TD>
			
			   <select name="SalaryBasePeriodMode" class="regularxxl">			   				   
				   <option value="0" <cfif get.SalaryBasePeriodMode eq "0">selected</cfif>>Consistent</option>			 
				   <option value="1" <cfif get.SalaryBasePeriodMode eq "1">selected</cfif>>Opportunistic</option>
			   </select>	
			
		       </TD>
		   
		   
		   
		   </td>
		   
		   </tr>
		   </table>
		</td>
		</tr>
				
		<tr>	   
	    <TD style="padding-left:10" class="labelmedium2"><cf_tl id="Entitlement rounding">:</TD>
    	<TD>
			<table>
			<tr class="labelmedium2">
			<td><input type="radio" name="PaymentRounding" <cfif Get.PaymentRounding eq "3">checked</cfif> value="3"></td>
			<td style="padding-left:4px">.00n</td>
			<td style="padding-left:10px"><input type="radio" name="PaymentRounding" <cfif Get.PaymentRounding eq "2">checked</cfif> value="2"></td>
			<td style="padding-left:4px">.0n</td>
			<td style="padding-left:10px"><input type="radio" name="PaymentRounding" <cfif Get.PaymentRounding eq "1">checked</cfif> value="1"></td>
			<td style="padding-left:4px">.n0</td>
			<td style="padding-left:10px"><input type="radio" name="PaymentRounding" <cfif Get.PaymentRounding eq "0">checked</cfif> value="0"></td>
			<td style="padding-left:4px">n</td>			
			</tr></table>

	  	</TD>
			
		</TR>
		
		<tr>
		 <TD style="padding-left:10px" class="labelmedium2"><cf_tl id="Include Zero Incumbency">:&nbsp;</TD>
		       <TD>
			
			   <select name="IncumbencyZero" class="regularxxl">			   
				   <option value="1" <cfif get.IncumbencyZero eq "1">selected</cfif>>Yes</option>
				   <option value="0" <cfif get.IncumbencyZero eq "0">selected</cfif>>No</option>			 
			   </select>	
			
		       </TD>
		</tr>	
					
		<tr>
		 <TD style="padding-left:10px" class="labelmedium2"><cf_tl id="Enforce Program">:</TD>
		       <TD>
			
			   <select name="EnforceProgram" class="regularxxl">			   
				   <option value="1" <cfif get.EnforceProgram eq "1">selected</cfif>>Yes</option>
				   <option value="0" <cfif get.EnforceProgram eq "0">selected</cfif>>No</option>			 
			   </select>	
			
		       </TD>
		</tr>	
	
		<tr><td height="10"></td></tr>
		
		<tr class="line"><td colspan="2" class="labellarge" style="font-weight:200;font-size:25px"><cf_tl id="Salary definition"></td></tr>
		
		<tr>	
		
	    <TD style="padding-left:10px" class="labelmedium2"><cf_tl id="Mode">:</TD>
	    <TD>
		   <select name="SalaryBaseRate" onchange="base(this.value)" class="regularxxl">
		   <option value="1" <cfif Get.SalaryBaseRate eq "1">selected</cfif>>Rate (default)</option>
		   <option value="0" <cfif Get.SalaryBaseRate eq "0">selected</cfif>>Contract Amount</option>	
		   </select>
		   
		   <script language="JavaScript">
		   
		   function base(val) {
		   se = document.getElementById("salarybasepayrollitem")
		   if (val == "0") {
		     se.className = "regularxxl"
		   } else {
		     se.className = "hide"
		   }	
		   }		 
		   
		   </script>
		   
		   <cfquery name="PayrollItem"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM   Ref_PayrollItem 
				ORDER BY ComponentOrder
			</cfquery>
			
			 <select id="salarybasepayrollitem" class="regularxxl" name="salarybasepayrollitem" <cfif Get.SalaryBaseRate eq "1">class="hide"</cfif>>
				  <cfoutput query="PayrollItem">
				  <option value="#PayrollItem#" <cfif get.SalaryBasePayrollItem eq PayrollItem>selected</cfif>>#PayrollItemName#</option>
				  </cfoutput>
			 </select>
		   		   
	  	</TD>
		</TR>
		
		<tr><td height="10"></td></tr>
		
		<tr class="line"><td colspan="2" class="labellarge" style="font-weight:200;font-size:25px">Settlement</td></tr>
		
		<tr>

			<TD style="padding-left:10" class="labelmedium2"><cf_tl id="Currency">:&nbsp;</TD>
		    <TD>
			
			<cfquery name="CurrencyList" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * FROM Currency
				</cfquery>
				
	
		  <select name="Currency" class="regularxxl">
			  <cfoutput query="CurrencyList">
			   <option value="#currency#" <cfif Get.Paymentcurrency eq currency>selected</cfif>>#Currency#</option>		 
			  </cfoutput> 
		   </select>
							
		    </TD>
			
		</tr>
				
		<TR>
	    <TD style="padding-left:10" class="labelmedium2">
			<cf_UItooltip tooltip="Option to allow settlement of entitlements enabled for this schedule and that were build-up under a different payroll schedule and that were not settled yet. (SAT related)"><cf_tl id="Settlement Mode">:</cf_UItooltip></TD>
	    <TD>		
		   <select name="SettleOtherSchedules" class="regularxxl">
		   <option value="1" <cfif Get.SettleOtherSchedules eq "1">selected</cfif>>Settle always all entitlements</option>
		   <option value="0" <cfif Get.SettleOtherSchedules eq "0">selected</cfif>>Settle only entitlements for this schedule</option>	
		   </select>
		</td>
		
		</tr>
		
		<tr>	
		
			<TD style="padding-left:10" class="labelmedium2"><cf_tl id="Process">:&nbsp;</TD>
		    <TD>
			
			 <table cellspacing="0" cellpadding="0">
			  <tr><td>
			
			   <select name="ProcessMode" class="regularxxl">			   
			   		<option value="None" <cfif get.ProcessMode eq "None">selected</cfif>>None</option>
			   		<option value="Financials" <cfif get.ProcessMode eq "Financials">selected</cfif>>Financials (Ledger)</option>
			   		<option value="Procurement" <cfif Get.SalaryBasePeriodDays eq "Procurement">selected</cfif>>Procurement (Obligation)</option>	
			   </select>	
			   
			   <td>&nbsp;</td>
			  
			   </tr></table>
			
		    </TD>
			
		</tr>	
		
		<tr>
		<td style="padding-left:10;padding-top:7px" class="labelmedium2" valign="top"><cf_tl id="Payslip Mail Memo">:</td>
		<td>
		<cfoutput>
		<textarea name="PaySlipMailText" style="font-size:14px;padding:5px;width:96%;height:150px" class="regular">#get.PayslipMailText#</textarea>
		</cfoutput>
		</td>
		
		</tr>
		
		<tr><td height="4"></td></tr>
		
	</table>