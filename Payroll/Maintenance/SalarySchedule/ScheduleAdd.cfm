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
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Record a salary schedule" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
			  
<cf_calendarscript>			  

<cfform action="ScheduleAddSubmit.cfm?idmenu=#URL.idmenu#" method="POST">

	<cfquery name="Get" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM SalarySchedule
	WHERE    SalarySchedule = '#URL.ID#'
	</cfquery>
			
	<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding formspacing">

	<tr><td colspan="2" class="labelit"><font color="gray">A payroll schedule groups calculations that follow a similar pattern. A schedule is associated to a employee contract.</font></i></td></tr>
	<cfoutput>
    <TR>
    <td width="30%" class="labelmedium">Code:</td>
    <TD>
  	   <input type="text" class="regularxl" name="SalarySchedule" value="#get.SalarySchedule#" size="10" maxlength="10">
    </TD>
	</TR>
	
	<cfquery name="Cur" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Currency
	</cfquery>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Currency">:</TD>
    <TD>
	<select name="Currency" class="regularxl">
		  <cfloop query="Cur">
		  <option value="#Currency#">#Currency#</option>
		  </cfloop>
	 </select>   
	</td>
	</tr>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Effective">:</TD>
    <TD>
			
	  <cf_intelliCalendarDate9
		FieldName="DateEffective" 
		Default=""
		class="regularxl"
		AllowBlank="False">	
			
	</td>
	</tr>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Description">:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" class="regularxl" required=  "yes" size="30" 
	   maxlenght = "40">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Calculation">&nbsp;Period:</TD>
    <TD>
	   <select name="SalaryCalculationPeriod" class="regularxl">
	   <option value="MONTH" <cfif #Get.SalaryCalculationPeriod# eq "MONTH">selected</cfif>>MONTH</option>
	   <!---
	   <option value="2WEEK" <cfif #Get.SalaryCalculationPeriod# eq "2WEEK">checked</cfif>>BI-WEEKLY</option>
	   <option value="WEEK" <cfif #Get.SalaryCalculationPeriod# eq "WEEK">checked</cfif>>WEEK</option>
	   --->
	   </select>
  	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Payable days">:</TD>
    <TD>
	   <select name="SalaryBasePeriodDays" class="regularxl">
	   <option value="30" <cfif Get.SalaryBasePeriodDays eq "30">selected</cfif>>Calendar Days (30)</option>
	   <option value="21.75" <cfif Get.SalaryBasePeriodDays eq "21.75">selected</cfif>>Average Working days (21.75)</option>	
	   </select>
  	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Salary">:</TD>
    <TD>
	   <select name="SalaryBaseRate" class="regularxl" onchange="base(this.value)">
	   <option value="1" selected>Rate</option>
	   <option value="0">Contract Amount</option>	
	   </select>
	   
	   <script language="JavaScript">
	   
	   function base(val) {
		   se = document.getElementById("salarybasepayrollitem")
		   if (val == "0") {
		     se.className = "regular"
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
	
	 <select name="salarybasepayrollitem" id="salarybasepayrollitem" class="hide" class="regularxl">
		  <cfloop query="PayrollItem">
		  <option value="#PayrollItem#">#PayrollItemName#</option>
		  </cfloop>
	 </select>   
	   
  	</TD>
	</TR>
	
	<cfquery name="Mission" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Ref_MissionModule
	WHERE    SystemModule = 'Payroll'
	</cfquery>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Entity">:</TD>
    <TD>
	 <select name="mission" class="regularxl">
		  <cfloop query="Mission">
		  <option value="#Mission#">#Mission#</option>
		  </cfloop>
	 </select>   
	</td>
	</tr>
	<tr><td height="4"></td></tr>
	<tr><td colspan="2" class="linedotted" height="1"></td></tr>
	<tr>
	<td colspan="2" align="center" height="30">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">	
	</td>	
</tr>	
	
</cfoutput>	

</table>

</cfform>


	