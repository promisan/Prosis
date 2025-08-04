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
	<TITLE>ePas - Edit Form</TITLE>
</HEAD><BODY bgcolor="#FFFFFF">
 <link rel="stylesheet" type="text/css" href="../../../../<cfoutput>#client.style#</cfoutput>">
 
<cf_PreventCache>
 
<cfquery name="Get" 
datasource="AppsePas" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Parameter 
</cfquery>

<cfquery name="Per" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ContractPeriod
	ORDER BY Code
</cfquery>

<CFFORM action="ParameterSubmit.cfm" method="post">

<table width="96%" border="0" align="center">

  <tr class="labellarge line">
   <td height="24" style="padding-top:40px;font-size:23px" class="labellarge" bgcolor="f4f4f4">EPas Global setting:</td></tr>
   </tr>   
   
<tr><td>

<table width="99%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
    <TR class="labelmedium">
    <td width="180">Application Name:</b></td>
    <td colspan="3">
  	    <cfoutput query="get">
		<input type="text" name="ApplicationName" class="regularxl" value="#ApplicationName#" size="30" maxlength="50" >
		</cfoutput>
    </td>
	
	</TR>
  
    <!--- Field: ProgramNo --->
    <TR class="labelmedium">
    <td width="180">Last PasNo:</b></td>
    <td colspan="3">
  	    <cfoutput query="get">
		<input type="text" name="PasNo" class="regularxl" value="#PasNo#" size="10" maxlength="10" style="text-align: right;">
		<input type="hidden" name="ParameterKey" value="#ParameterKey#">
		</cfoutput>
    </td>
	
	</TR>
		
	<tr><td colspan="4" class="line"></td></tr>
		
			
	 <!--- Field: Period --->
    <TR>
    <td class="labelmedium">Default Period:</b></td>
    <td colspan="3" class="regular">
	
		<select name="PeriodDefault" class="regularxl" message="Please select a default period" required="Yes" style="text-align: right;">
		<cfoutput query="Per">
		<option value="#Code#" <cfif Get.PeriodDefault eq Code> SELECTED</cfif>>#Code#</option>
		</cfoutput>
			    
   	</select>
	  	 
    </TD>
	</TR>
	
	<tr class="labelmedium"><td></td><td class="header" colspan="3">The default period that the system will display.</td></tr>
		
	<tr><td colspan="4" class="line"></td></tr>
	
    <TR>
    <td class="labelmedium">Template Root:</b></td>
    <td colspan="3" class="regular">
  	    <cfoutput query="get">
		<cfinput class="regularxl" type="Text" name="TemplateRoot" value="#TemplateRoot#" message="Please enter the correct root" required="Yes" size="40" maxlength="70">
		</cfoutput>
    </td>
	</tr>
	
	<tr>
	<td class="labelmedium">Home:</td>
    <TD colspan="3" class="regular">
  	    <cfoutput query="get">
		<cfinput class="regularxl" type="Text" name="TemplateHome" value="#TemplateHome#" message="Please enter the correct local path" required="Yes" size="60" maxlength="70">		
		</cfoutput>
    </TD>
	</TR>	
		
	<tr><td colspan="4" class="line"></td></tr>
			
	<!--- Field: Prosis Applicantion Root Path--->
    <TR class="labelmedium">
    <td>Disable main objective/task:</b></td>
    <TD class="regular" colspan="3">
  	    <cfoutput query="get">
		<input type="radio" name="HideObjective" class="radiol" value="1" <cfif HideObjective eq "1">checked</cfif>>Yes
		<input type="radio" name="HideObjective" class="radiol" value="0" <cfif HideObjective eq "0">checked</cfif>>No		
		</cfoutput>
    </TD>
	</TR>	
	
	<TR class="labelmedium">
    <td>No of tasks:</b></td>
    <TD colspan="3">
	
  	 <cfinput type="Text"
       name="MinTasks"
       value="#Get.MinTasks#"
       range="1,4"
       width="1"
	   class="regularxl amount"	   
       validate="integer"
       required="No"
       visible="Yes"
       enabled="Yes"
       size="1"> 
	   - 
	   <cfinput type="Text"
       name="NoTasks"
       range="1,9"
	   size="1"
	   class="regularxl amount"	   
	   value="#Get.NoTasks#"
       validate="integer"
       required="No"
	   visible="Yes"
       enabled="Yes"> 
	   
    </TD>
	</TR>	
		
	<tr><td colspan="4"  class="line"></td></tr>
	
	<TR class="labelmedium">
    <td>Disable training/education section:</b></td>
    <TD class="regular" colspan="3">
  	    <cfoutput query="get">
		<input type="radio" name="HideTraining" class="radiol" value="1" <cfif HideTraining eq "1">checked</cfif>>Yes
		<input type="radio" name="HideTraining" class="radiol" value="0" <cfif HideTraining eq "0">checked</cfif>>No		
		</cfoutput>
    </TD>
	</TR>			
				
	<tr><td colspan="4" class="line"></td></tr>
	
	<tr><td height="23" colspan="4" align="center" valign="middle">
      <input type="submit" name="Cancel" style="width:100px" value=" Cancel " class="button10g">
      <input type="submit" name="Update" style="width:100px" value=" Update " class="button10g">
    </td></tr>
	
</TABLE>
</td></tr>
</table>

</CFFORM>

