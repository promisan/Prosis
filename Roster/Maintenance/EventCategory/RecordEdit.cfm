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
			  title="Event class" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Event class" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_EventCategory
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this event category?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="94%" align="center" class="formpadding formspacing">

    <cfoutput>
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
  	   <input type="text" name="Code" value="#get.Code#" size="15" maxlength="15"class="regularxxl">
	   <input type="hidden" name="CodeOld" value="#get.Code#" size="15" maxlength="15" readonly>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="30" maxlength="30"class="regularxxl">
    </TD>
	</TR>
			
	<TR>
    <TD class="labelit">Operational:</TD>
    <TD>
	    <INPUT type="radio" class="radiol" name="Operational" value="0" <cfif "0" eq "#get.Operational#">checked</cfif>> Disabled
		<INPUT type="radio" class="radiol" name="Operational" value="1" <cfif "1" eq "#get.Operational#">checked</cfif>> Enabled
	</TD>
	</TR>
	
	</cfoutput>
	
	<tr><td colspan="2" height="6"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" height="6"></td></tr>
		
	<tr><td colspan="2" valign="bottom" align="center">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" value=" Update ">
	</td></tr>
	
</table>

</cfform>
