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
<TITLE>Assignment - Entry Form</TITLE>
</HEAD><body bgcolor="#FFFFFF" leftmargin="5" topmargin="5" rightmargin="3">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<script>

function check()

{

if (confirm("Do you want to remove this officer ?")) {
	EmployeeEntry.submit()
    }
	
}

</script>

<cf_dialogPosition>

<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT F.*, E.LastName, E.FirstName, E.Gender, E.IndexNo
   FROM ProgramPeriodOfficer F, Employee.dbo.Person E
   WHERE F.ProgramOfficerNo = '#URL.No#'
   AND E.PersonNo = F.PersonNo
</cfquery>

<cfparam name="URL.Layout" default="Program">

<!--- headers and necessary Params for expand/contract --->
<cfparam name="URL.Verbose" default="#CLIENT.Verbose#">
<cfset #CLIENT.Verbose# = #URL.Verbose#>
<cfset Caller = "EmployeeEdit.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#&No=#URL.No#">

<cfform action="EmployeeEditSubmit.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#" method="POST" name="EmployeeEntry">


<cfif #URL.Layout# eq 'Program'>
	<cfinclude template="../ProgramViewHeader.cfm">
<cfelse>
	<cfinclude template="../ComponentViewHeader.cfm">
</cfif>

<cfoutput>
<input type="hidden" name="ProgramCode" id="ProgramCode" value="#URL.ProgramCode#">
<input type="hidden" name="Period" id="Period" value="#URL.Period#">
<input type="hidden" name="ProgramOfficerNo" id="ProgramOfficerNo" value="#URL.No#">
<input type="hidden" name="Layout" id="Layout" value="#URL.Layout#">

<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="silver">

    <tr>
    <td width="100%" align="center" valign="middle" class="top3Nd">
	   	&nbsp;&nbsp;<b>Edit program officer</b>
    </td>
  </tr> 	
    
  <tr>
    <td width="100%">
    <table border="0" cellpadding="0" cellspacing="0" bordercolor="111111" width="100%">
	
    <TR><TD class="header">&nbsp;</TD></TR>		
 
    <TR>
    <TD class="header" width="20%">&nbsp;&nbsp;&nbsp;Period:</TD>
    <TD class="regular">&nbsp;
		
		  <cf_intelliCalendarDate
		FieldName="DateEffective" 
		Default="#DateFormat(Get.DateEffective,CLIENT.DateFormatShow)#"
		AllowBlank="True">	
		
	- 
	
		  <cf_intelliCalendarDate
		FieldName="DateExpiration" 
		Default="#DateFormat(Get.DateExpiration,CLIENT.DateFormatShow)#"
		AllowBlank="True">	
			
	</TD>
	</TR>
	
	<tr><td height="4" colspan="1" class="header"></td></tr>
	
	<TR>
    <TD class="header">&nbsp;&nbsp;&nbsp;Employee:</TD>
		
    <TD class="regular">&nbsp;
	<input type="button" class="button7" name="search0" value=" ... " onClick="selectperson('EmployeeEntry','personno','indexno','lastname','firstname','name')"> 
	&nbsp;&nbsp;<input type="text" name="name" value="#Get.FirstName# #Get.LastName#" size="40" maxlength="40" readonly class="disabled" style="text-align: center;">
	<input type="hidden" name="indexno" id="indexno" value="#Get.IndexNo#" class="disabled" size="10" maxlength="10" readonly style="text-align: center;">
    <input type="text" name="personno" value="#Get.PersonNo#" class="disabled" size="10" maxlength="10" readonly style="text-align: center;">
    <input type="hidden" name="lastname" id="lastname" value="#Get.LastName#" class="disabled" size="10" maxlength="10" readonly style="text-align: center;">
    <input type="hidden" name="firstname" id="firstname" value="#Get.FirstName#" class="disabled" size="10" maxlength="10" readonly style="text-align: center;">
	
	</TD>
	</TR>	
	
	<tr><td height="4" colspan="1" class="header"></td></tr>
	
	<TR>
        <td class="header">&nbsp;&nbsp;&nbsp;Task:</td>
        <TD class="regular">&nbsp;&nbsp;<textarea class="regular" cols="50" rows="3" name="ProgramDuty">#Get.ProgramDuty#</textarea> </TD>
	</TR>

	<tr><td height="4"  class="header"></td></tr>
	
	<TR>
        <td class="header">&nbsp;&nbsp;&nbsp;Memo:</td>
        <TD class="regular">&nbsp;&nbsp;<input type="text" name="Remarks" value="#Get.Remarks#" size="50" maxlength="50" class="regular"> </TD>
	</TR>	
	
	<tr><td height="4"  class="header"></td></tr>
	
	
	</table>
	</td></tr>
	</table>
</cfoutput>	

   <table width="100%" bgcolor="#FFFFFF"><td align="right">
   <input type="button" name="cancel" value="&nbsp;Cancel&nbsp;" class="button7" onClick="history.back()">
   <input class="button7" type="submit" name="Update" value=" Update ">
   <input type="button" name="Remove" value="Remove " class="button7" onClick="javascript:check()">
   </td>
   </table>


</CFFORM>

</BODY></HTML>