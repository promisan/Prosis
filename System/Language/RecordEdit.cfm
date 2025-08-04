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

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp"  
			  label="Settings" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_SystemLanguage
	WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Removing a language might result in loss of language sensitive data. Do you want to continue?")) {	
	return true 	
	}	
	return false
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="92%" align="center" class="formspacimg formpadding">

    <tr><td height="10"></td></tr>
    <cfoutput>
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD><input type="text" name="Code" id="Code" class="regularxxl" value="#get.Code#" style="text-align:center;padding-left:1px" size="4" maxlength="4" readonly>
     </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD><cfinput type="text" name="Description" value="#get.LanguageName#" message="please enter a description" requerided="yes" size="30" 
	   maxlenght = "30" class= "regularxxl">
    </TD>
	</TR>
		
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium2">Default:</TD>
    <td height="25" class="labelmedium" style="padding-right:4px">
	
	   <cfif get.SystemDefault eq "1">
	       Yes
		   <input type="hidden" name="SystemDefault" id="SystemDefault" value="1">
	   <cfelse>
	  	   <input type="checkbox" class="radiol" style="width:18px;height:18px" name="SystemDefault" id="SystemDefault" value="1">
	   </cfif>
	   
    </td>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium2">Selectable:</TD>
    <td height="25" class="labelmedium" style="padding-right:4px">
	
	   <cfif get.Interface eq "1">
	  	   <input type="checkbox" checked style="width:18px;height:18px" name="Interface" id="Interface" value="1">
	   <cfelse>
	       <input type="checkbox" class="radiol" style="width:18px;height:18px" name="Interface" id="Interface" value="1">
	   </cfif>	   
	 
	   
    </td>
	</TR>
	
	<tr><td height="3"></td></tr>
				
	<TR>
    <TD valign="top" style="padding-top:3px" class="labelmedium2">Operational:</TD>
    <TD class="labelmedium">	  
	    <table><tr>
		<td><INPUT type="radio" class="radiol" style="width:16px;height:16px" name="Operational" id="Operational" value="2" <cfif get.Operational eq "2" or get.SystemDefault eq "1">checked</cfif>></td><td style="padding-left:4px" class="labelmedium">Data entry mode</td>
		</tr>
		<!---
		<tr>
		<td><INPUT type="radio" style="width:16px;height:16px" name="Operational" id="Operational" value="2d" <cfif get.Operational eq "2d">checked</cfif>></td><td style="padding-left:4px" class="labelmedium">Data entry only</td>
		</tr>
		--->
		<tr>
		<td><INPUT type="radio" class="radiol"  style="width:16px;height:16px" name="Operational" id="Operational" value="1" <cfif get.Operational eq "1">checked</cfif>></td><td style="padding-left:4px" class="labelmedium">Enabled</td>
		</tr>
		<tr>
		<td><INPUT type="radio" class="radiol"  style="width:16px;height:16px" name="Operational" id="Operational" value="0" <cfif get.Operational eq "0">checked</cfif>></td><td style="padding-left:4px" class="labelmedium">Disabled</td>
		</tr>
		</table>  
	</TD>
	</TR>
	
	</cfoutput>
		
	<tr><td style="padding:5px" height="1" class="line" colspan="2"></td></tr>
	
	<tr>	
	<td align="center" colspan="2" height="30">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">	
    	<input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td>	
	</tr>
		
</TABLE>
	
</CFFORM>	

<cf_screenbottom layout="innerbox">
