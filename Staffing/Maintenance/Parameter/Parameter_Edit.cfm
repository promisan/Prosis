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
<HTML><HEAD>
	<TITLE>Parameters - Edit Form</TITLE>
</HEAD><BODY bgcolor="#FFFFFF">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
  
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Parameter 
</cfquery>

<CFFORM action="ParameterSubmit.cfm" method="post">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
<tr>
<td>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr>
<td height="22" valign="middle" class="top3nd"><font face="Verdana"><b>&nbsp;&nbsp;Parameters:</b></font></td></tr>
<tr>

<tr><td>

<!--- Entry form --->

<table width="97%" border="0" align="center">
<tr><td>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <tr><td height="10"></td></tr>
	
	<cfoutput query = "Get">
      <input type="Hidden" name="Identifier" value="#Identifier#">
    </cfoutput>  
	
	
   	<!---
	
	 <!--- Field: Hours --->
    <TR>
    <td>The date/time <b>staffing fact tables</b> have been updated:</b></td>
    <TD>
	   
    <cfoutput query = "Get">
	  <cfif #DateFormat(TimeStampFactTable,CLIENT.DateFormatShow)# neq "">
	  <cfoutput>#DateFormat(TimeStampFactTable,CLIENT.DateFormatShow)# #TimeFormat(TimeStampFactTable,"HH:mm")#</cfoutput>
	  &nbsp;<input type="checkbox" name="Reset" value="1">Enforce refresh
	  <cfelse>
	  <b>Data not available</b>
	  </cfif>
	  
    </cfoutput>  
    </td>
    </tr>
	<tr><td height="1" colspan="2" bgcolor="f4f4f4"></td></tr>
	
	--->
			
    <TR>
    <td>Enable multiple Assignment memos:</b></td>
    <TD>
	   
    <cfoutput query = "Get">
	  <input type="radio" name="AssignmentMemo" <cfif #Get.AssignmentMemo# eq "0">checked</cfif> value="0">No
	  <input type="radio" name="AssignmentMemo" <cfif #Get.AssignmentMemo# eq "1">checked</cfif>value="1">Yes
     </cfoutput>  
    </td>
    </tr>
	
	<tr><td height="1" colspan="2" bgcolor="f4f4f4"></td></tr>
		
	<TR>
    <td>Create candidate account upon entry of personnel record:</b></td>
    <TD>
	   
    <cfoutput query = "Get">
	  <input type="radio" name="GenerateApplicant" <cfif #Get.GenerateApplicant# eq "0">checked</cfif> value="0">No
	  <input type="radio" name="GenerateApplicant" <cfif #Get.GenerateApplicant# eq "1">checked</cfif> value="1">Yes
     </cfoutput>  
    </td>
    </tr>
	
	<tr><td height="1" colspan="2" bgcolor="f4f4f4"></td></tr>
	
	<TR>
    <td>Enable employee classification:</b></td>
    <TD>
	   
    <cfoutput query = "Get">
	  <input type="radio" name="EnablePersonGroup" <cfif #Get.EnablePersonGroup# eq "0">checked</cfif> value="0">No
	  <input type="radio" name="EnablePersonGroup" <cfif #Get.EnablePersonGroup# eq "1">checked</cfif> value="1">Yes
     </cfoutput>  
    </td>
    </tr>
	  	
	<tr><td height="1" colspan="2" bgcolor="f4f4f4"></td></tr>
	
	<TR>
    <td>Maximum overtime hours per day:</b></td>
    <TD>
	   
    <cfoutput query = "Get">
      <cfinput type="Text" name="HoursOvertimeMaximum" value="#HoursOvertimeMaximum#" message="Please enter a correct number" style="text-align: center;" validate="integer" required="Yes" size="2" maxlength="2" class="regular">
    </cfoutput>  
    </td>
    </tr>
	
	<tr><td height="1" colspan="2" bgcolor="f4f4f4"></td></tr>
	
	<TR>
    <td>Leave balance hours:</td>
    <TD>
	   
    <cfoutput query = "Get">
      <cfinput type="Text" name="HoursInDay" value="#HoursInDay#" message="Please enter a correct number" style="text-align: center;" validate="integer" required="Yes" size="2" maxlength="2" class="regular">
    </cfoutput>  
	The equivalent of a leave day in workhours (normally 8 hours).
    </td>
    </tr>
	
	<tr><td height="1" colspan="2" bgcolor="f4f4f4"></td></tr>
		
	<TR>
    <td>Leave accrual method:</td>
    <TD>
	   
    <cfoutput query = "Get">
	  <input type="radio" name="LeaveAccrualMethod" value="Month" <cfif "Month" eq "#Get.LeaveAccrualMethod#">checked</cfif>>Month
	  <input type="radio" name="LeaveAccrualMethod" value="Day" <cfif "Day" eq "#Get.LeaveAccrualMethod#">checked</cfif>>Day
	</cfoutput>  
    </td>
    </tr>
	
  				

</TABLE>
</td></tr>
</table>
</td></tr>
<tr><td bgcolor="e4e4e4"></td></tr>
<tr><td height="26"  align="center">
<input type="submit" name="Cancel" value=" Cancel " class="button10g">
<input type="submit" name="Update" value=" Update " class="button10g">

</td></tr>

</table>

</td></tr>

</table>

</CFFORM>

</BODY></HTML>