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
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Parameter 
</cfquery>

<cfform action="ParameterSubmit.cfm?idmenu=#URL.IDMenu#" method="post">

<table width="95%" cellspacing="0" cellpadding="0" class="formpadding" align="center">
	
	<cfoutput query = "Get">
      <input type="Hidden" name="Identifier" id="Identifier" value="#Identifier#">
    </cfoutput>  
   	
	 <!--- Field: Hours --->
    <TR>
    <td class="labelmedium">Default daily hours:</b></td>
    <TD class="regular">
	   
    <cfoutput query = "Get">
      <cfinput type="text" name="HoursworkDefault" id="HoursworkDefault" value="#HoursworkDefault#" size="3" maxlength="3" class="regularxl" style="text-align: center;" message="Please enter a correct number" validate="integer">
    </cfoutput>  
    </td>
    </tr>
	
  	<tr><td height="3"></td></tr>
	<tr><td></td><td class="labelit">The default hours worked in case no information was submitted (normally : 8 or 7.5).</td></tr>
	<tr><td height="20"></td></tr>
	
	<!---
		
    <TR>
    <td class="labelmedium">Maximum daily hours:</b></td>
    <TD>
	   
    <cfoutput query = "Get">
      <cfinput type="Text" name="HoursMaximum" id="HoursMaximum" value="#HoursMaximum#" message="Please enter a correct number" style="text-align: center;" validate="integer" required="Yes" size="2" maxlength="2" class="regularxl">
    </cfoutput>  
    </td>
    </tr>
	
	
	
  	<tr><td height="3"></td></tr>
	<tr><td></td><td class="labelit">The maximum hours that may be reported for work, leave, holiday or excused (normally : 8).</td></tr>
	<tr><td height="20"></td></tr>
	
	
	
	<TR>
    <td class="labelmedium">Maximum overtime hours:</b></td>
    <TD>
	   
    <cfoutput query = "Get">
      <cfinput type="Text" name="HoursOvertimeMaximum" id="HoursOvertimeMaximum" value="#HoursOvertimeMaximum#" message="Please enter a correct number" style="text-align: center;" validate="integer" required="Yes" size="2" maxlength="2" class="regularxl">
    </cfoutput>  
    </td>
    </tr>
	
  	<tr><td height="3"></td></tr>
	<tr><td></td><td class="labelit">The maximum hours that may be reported for combined overtime per day.</td></tr>
	<tr><td height="20"></td></tr>
	
	--->
	
	<TR>
    <td class="labelmedium">Leave balance hours:</b></td>
    <TD>
	   
    <cfoutput query = "Get">
      <cfinput type="Text" name="HoursInDay" id="HoursInDay" value="#HoursInDay#" message="Please enter a correct number" style="text-align: center;" validate="integer" required="Yes" size="2" maxlength="2" class="regularxl">
    </cfoutput>  
    </td>
    </tr>
	
  	<tr><td height="3"></td></tr>
	<tr><td></td><td class="labelit">The equivalent of a leave day in workhours (normally 8 hours).</td></tr>
	<tr><td height="20"></td></tr>
	
	<!---
	
	<TR>
    <td class="labelmedium">Leave accrual method:</b></td>
    <TD class="labelit">
	   
    <cfoutput query = "Get">
	  <input type="radio" name="LeaveAccrualMethod" id="LeaveAccrualMethod" value="Month" <cfif "Month" eq "#Get.LeaveAccrualMethod#">checked</cfif>>Month
	  <input type="radio" name="LeaveAccrualMethod" id="LeaveAccrualMethod" value="Day" <cfif "Day" eq "#Get.LeaveAccrualMethod#">checked</cfif>>Day
	</cfoutput>  
    </td>
    </tr>
	
  	<tr><td height="3"></td></tr>
	<tr><td></td><td class="labelit">The period on which is the accrual is calculated.</td></tr>
	<tr><td height="20"></td></tr>
	
	
	
		
	<TR>
    <td class="labelmedium">Enable eMail notification:</b></td>
    <TD class="labelit">
	   
    <cfoutput query = "Get">
	  <input type="radio" name="LeaveEmail" id="LeaveEmail" value="0" <cfif "0" eq "#Get.LeaveEMail#">checked</cfif>>No
	  <input type="radio" name="LeaveEmail" id="LeaveEmail" value="1" <cfif "1" eq "#Get.LeaveEMail#">checked</cfif>>Yes
	</cfoutput>  
    </td>
    </tr>
	
	--->
	
	<tr><td height="5"></td></tr>
	<tr><td class="linedotted" colspan="2"></td></tr>
	<tr><td height="5"></td></tr>
	
	<tr>
		<td align="center" colspan="2">
			<input type="Submit" name="Save" id="Save" value="Save" style="height:25;width:130" class="button10g">
		</td>
	</tr>			

</TABLE>

</cfform>