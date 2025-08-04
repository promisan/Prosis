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

<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" scroll="Yes" 
  layout="webapp" 
  banner="gray"   
  bannerheight="55"
  title="Payroll Location" 
  label="Add Payroll Location" 
  menuAccess="Yes" 
  systemfunctionid="#url.idmenu#">

<cfquery name="Nat" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Nation
</cfquery>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="91%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="6"></td></tr>
    <TR class="labelmedium">
    <TD>Code:</TD>
    <TD>
  	   <cfinput type="text" name="LocationCode" value="" message="Please enter a code" required="Yes" size="2" maxlength="2" class="regularxl">
    </TD>
	</TR>
	
	<cfquery name="Mission" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM Ref_ParameterMission	
	</cfquery>
	
	<TR class="labelmedium">
    <TD>Mission:</TD>
    <TD>
	 <select name="mission" class="regularxl" multiple>
		  <cfoutput query="Mission">
		  <option value="#Mission#">#Mission#</option>
		  </cfoutput>
	 </select>   
	</td>
	</tr>
	
	<TR class="labelmedium">
    <TD>Country:</TD>
    <TD>
	<select name="LocationCountry" class="regularxl">
	<cfoutput query="Nat">
	<option value="#Code#">#Name#</option>
	</cfoutput>
	</select>
	</TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="40" class="regularxl">
    </TD>
	</TR>
			
	<cf_calendarscript>
			
	<TR class="labelmedium">
    <TD>Effective:</TD>
    <TD>
			
	  <cf_intelliCalendarDate9
		FieldName="DateEffective" 
		Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
		class="regularxl"
		AllowBlank="False">	
			
	</td>
	</tr>
	
	<TR class="labelmedium">
    <TD>Expiration:</TD>
    <TD>
			
	  <cf_intelliCalendarDate9
		FieldName="DateExpiration" 
		Default=""
		class="regularxl"
		AllowBlank="True">	
			
	</td>
	</tr>
		
</table>

<table width="100%">
<tr><td height="3"></td></tr>
<tr><td class="linedotted"></td></tr>
<tr><td height="3"></td></tr>
<tr>
	<td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">	
	</td>	
</tr>	
	
</TABLE>

</CFFORM>
