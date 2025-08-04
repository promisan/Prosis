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
			  Label="Edit" 
			  scroll="No" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_PersonStatus
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this status?")) {	
	return true 	
	}	
	return false	
}	

</script>

<!--- edit form --->

<table width="95%" align="center" class="formpadding formspacing">

	<cfform action="RecordSubmit.cfm" method="POST" name="dialog">
    <cfoutput>
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
  	   <input type="text" name="Code" value="#get.Code#" size="3" maxlength="3" class="regularxl">
	   <input type="hidden" name="CodeOld" value="#get.Code#" size="15" maxlength="1" readonly>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="30" maxlength="30" class="regularxl">
    </TD>
	</TR>
			
	<TR>
    <TD class="labelmedium2">Color:</TD>
    <TD><INPUT type="color" class="regularxl" name="InterfaceColor" value="#get.InterfaceColor#"></TD>
	</TR>
				
	<TR>
    <TD class="labelit">Hide in Roster:</TD>
    <TD>
	    <INPUT class="radiol" type="radio" name="RosterHide" value="0" <cfif "0" eq "#get.RosterHide#">checked</cfif>> No
		<INPUT class="radiol" type="radio" name="RosterHide" value="1" <cfif "1" eq "#get.RosterHide#">checked</cfif>> Yes
	</TD>
	</TR>
	
	</cfoutput>
	
	<tr><td height="3"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center">

	<input class="button10s" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10s" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10s" type="submit" name="Update" value=" Update ">
	</td></tr>
		
	</CFFORM>
	
</TABLE>
	

