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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->
<HTML><HEAD>
<TITLE>Assignment - Entry Form</TITLE>
</HEAD>

<script>

function check() {

	if (confirm("Do you want to remove this officer ?")) {
		EmployeeEntry.submit()
	    }
	
	}

</script>

<cf_screenTop height="100%" html="No" scroll="yes" jquery="Yes">

<cf_calendarScript>
<cf_dialogPosition>

<cfajaximport tags="cfwindow,cfdiv">

<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT F.*, E.LastName, E.FirstName, E.Gender, E.IndexNo
    FROM   ProgramPeriodOfficer F, Employee.dbo.Person E
    WHERE  F.ProgramOfficerNo = '#URL.No#'
    AND    E.PersonNo = F.PersonNo
</cfquery>

<cfparam name="URL.Layout" default="Program">

<cfform action="EmployeeEditSubmit.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#" method="POST" name="EmployeeEntry">

<table width="100%"><tr><td style="padding:10px">
	<cfset url.attach = "0">
	<cfinclude template="../Header/ViewHeader.cfm">

</td></tr>

<tr><td style="padding:10px">

<cfoutput>

<input type="hidden" name="ProgramCode" id="ProgramCode"      value="#URL.ProgramCode#">
<input type="hidden" name="Period" id="Period"          value="#URL.Period#">
<input type="hidden" name="ProgramOfficerNo" id="ProgramOfficerNo" value="#URL.No#">
<input type="hidden" name="Layout" id="Layout"           value="#URL.Layout#">

	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	
	    <tr>
	    <td width="100%" valign="middle" style="height:38px" class="labellarge">
		   <cf_tl id="Program officer">
	    </td>
	  </tr> 	
	  
	  <tr><td colspan="1" class="linedotted"></td></tr>
	   
	      
	  <tr>
	    <td width="100%" style="padding:10px">
		
	    <table border="0" cellpadding="0" cellspacing="0" class="formpadding" width="100%">
			 
	    <TR>
	    <TD width="20%" class="labelmedium"><cf_tl id="Period">:</TD>
	    <TD>
		
			<table cellspacing="0" cellpadding="0" class="formpadding">
			<tr><td style="padding-right:4px">
			
			  <cf_intelliCalendarDate9
			FieldName="DateEffective" 
			Default="#DateFormat(Get.DateEffective,CLIENT.DateFormatShow)#"
			Class="regularxl"
			AllowBlank="True">	
			
			</td>
			<td>-</td>
			<td style="padding-left:4px">
			
			  <cf_intelliCalendarDate9
			FieldName="DateExpiration" 
			Default="#DateFormat(Get.DateExpiration,CLIENT.DateFormatShow)#"
			Class="regularxl"
			AllowBlank="True">	
			
			</td></tr>
			</table>
				
		</TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Name">:</TD>		
	    <TD>		
			
			<table cellspacing="0" cellpadding="0">
				<tr>
				
				<td id="member">
															
				<input type="text" name="name" value="#Get.FirstName# #Get.LastName#" size="40" maxlength="40" class="regularxl" readonly style="padding-left:4px">				
				<input type="hidden" name="personno" id="personno" value="#Get.PersonNo#" size="10" maxlength="10" readonly>
				
				</td>
				<td>
				
				<cfset link = "#SESSION.root#/ProgramREM/Application/Program/Employee/setEmployee.cfm?programcode=#url.programcode#">	
							
				 <cf_selectlookup
				    class      = "Employee"
				    box        = "member"
					button     = "yes"
					icon       = "search.png"
					iconwidth  = "25"
					iconheight = "25"
					title      = "#lt_text#"
					link       = "#link#"						
					close      = "Yes"
					des1       = "PersonNo">
						
				</td>
				</tr>
			</table>		
		</TD>
		</TR>	
		
			<TR>
	        <td class="labelmedium"><cf_tl id="Role">:</td>
	        <TD><input type="text" name="Remarks" value="#Get.Remarks#" size="50" maxlength="50" class="regularxl"> </TD>
		</TR>	
				
		<TR>
	        <td class="labelmedium" valign="top" style="padding-top:3px"><cf_tl id="Task">:</td>
	        <TD><textarea class="regular" style="font-size:13px;height:60px;padding:3px;width:90%" name="ProgramDuty">#Get.ProgramDuty#</textarea> </TD>
		</TR>
			
	
						
		<tr><td colspan="2" class="linedotted"></td></tr>
	  
	   <tr><td height="28" colspan="2" align="center">
		    <cf_tl id="Cancel" var="1">
		    <input type="button" name="cancel" value="<cfoutput>#lt_text#</cfoutput>" class="button10g" onClick="history.back()">
			<cf_tl id="Remove" var="1">
		    <input type="button" name="Remove" value="<cfoutput>#lt_text#</cfoutput>" class="button10g" onClick="javascript:check()">
			<cf_tl id="Save" var="1">
			<input class="button10g" type="submit" name="Update" value="<cfoutput>#lt_text#</cfoutput>"> 
	   </td></tr>
		
		</table>
	
		</td></tr>
		
	</table>
	
</cfoutput>	

</CFFORM>
