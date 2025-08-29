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
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM UserNames 
WHERE Account = '#SESSION.acc#'
</cfquery>

<cfform onsubmit="return false" method="POST" name="formsetting">
 	
<table width="97%" cellspacing="0" cellpadding="" align="center" class="formpadding">

	<tr><td height="4"></td></tr>
	
    <tr class="line"><td colspan="2" class="labellarge"><span style="font-size: 24px;margin: 10px 0 6px;display: block;color: #52565B;"><cf_tl id="Features"></span></td></tr>
	
	<tr><td colspan="2" height="1" class="linedotted"></td></tr>
	<tr><td height="6"></td></tr>
	
	 <!--- Field: Ref_PageRecords--->
    <TR>
    <TD class="labelmedium" width="270" style="padding: 2px;"><cf_tl id="Listings"> : <cf_tl id="MAX Records per page">: &nbsp;</TD>
    <TD style="padding: 2px;">
    	<cfoutput query="get">
		<cfinput class="regularxl" type="Text" name="Pref_PageRecords" value="#Pref_PageRecords#" message="Please define a maximum number of record per page" validate="integer" required="Yes" size="2" maxlength="4"> 
		</cfoutput>	
	</TD>
	</TR>
	
	 <!--- Field: Ref_PageRecords--->
    <TR>
    <TD class="labelmedium" width="170" style="padding: 2px;"><cf_tl id="Google MAP feature">: &nbsp;</TD>
    <TD style="padding: 2px;" class="labelmedium">
		<cfoutput query="get">	
		<table><tr>
		<td style="padding-left:0px"><input type="radio" name="Pref_GoogleMAP" class="radiol" value="1" <cfif Pref_GoogleMAP eq "1">checked</cfif>></td><td style="padding-left:4px" class="labelmedium"><cf_tl id="Enabled"></td>
		<td style="padding-left:4px"><input type="radio" name="Pref_GoogleMAP" class="radiol" value="0" <cfif Pref_GoogleMAP eq "0">checked</cfif>></td><td style="padding-left:4px" class="labelmedium"><cf_tl id="Disabled"></td>
		
		</tr></table>
		</cfoutput> 
	</TD>
	</TR>
	
	 <!--- Field: Ref_PageRecords--->
    <TR>
    <TD class="labelmedium" width="170" style="padding: 2px;"><cf_tl id="Timesheet">: &nbsp;</TD>
    <TD style="padding: 2px;" class="labelmedium">
		<cfoutput query="get">	
		<table><tr>
		<td style="padding-left:0px"><input type="radio" name="Pref_Timesheet" class="radiol" value="1" <cfif Pref_Timesheet eq "1">checked</cfif>></td><td style="padding-left:4px" class="labelmedium"><cf_tl id="Enabled"></td>
		<td style="padding-left:4px"><input type="radio" name="Pref_Timesheet" class="radiol" value="0" <cfif Pref_Timesheet eq "0">checked</cfif>></td><td style="padding-left:4" class="labelmedium"><cf_tl id="Disabled"></td>
		</tr></table>
		</cfoutput> 
	</TD>
	</TR>
								  
	
	<cfquery name="Language" 
	datasource="AppsSystem">
	SELECT *
	FROM Ref_SystemLanguage 
	WHERE Operational >= 1
	</cfquery>
	    
    <TR>
    <td class="labelmedium" style="padding: 2px;"><cf_tl id="Language">:</b></td>
    <TD style="padding: 2px;" class="labelmedium">
	     <select name="SystemLanguage" class="regularxl">
	      <option value="" selected><cf_tl id="System default"></option>
	     <cfoutput query="Language">
		 	<option value="#Code#"  <cfif #Get.Pref_SystemLanguage# eq "#Code#">selected</cfif>>#LanguageName#</option>
		 </cfoutput>	
		</select>			
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium" style="padding: 2px;"><cf_tl id="Main menu skin">: &nbsp;</TD>
    <TD style="padding: 2px;" class="labelmedium">
		<cfoutput query="get">	
		<select name="Pref_Color" class="regularxl">
			<option value="Orange" <cfif Pref_Color eq "Orange">selected</cfif>><cf_tl id="Orange"></option>
			<option value="White" <cfif Pref_Color eq "White">selected</cfif>><cf_tl id="White"></option>
			<option value="Blue" <cfif Pref_Color eq "Blue">selected</cfif>><cf_tl id="Blue"></option>
			<option value="Green" <cfif Pref_Color eq "Green">selected</cfif>><cf_tl id="Green"></option>
		</select>
		</cfoutput> 
	</TD>
	</TR>
			
	<tr><td height="5"></td></tr>
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	<tr><td height="5"></td></tr>
	
	<tr><td height="1" colspan="2">
	
	<cf_tl id="Save" var="vSave">
	
	<cfoutput>
	<input type="button" onclick="prefsubmit('presentation')" name="Save" id="Save" value="#vSave#" class="button10g">
	</cfoutput>
		
	</td></tr>
	
</table>	

</cfform>


<script>
	Prosis.busy('no');	
</script>