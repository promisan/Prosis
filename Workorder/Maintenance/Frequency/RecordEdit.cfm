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

<cfquery name="Get" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Frequency
	WHERE  Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cf_screentop height="100%" 
			  label="Frequency" 
			  layout="webapp" 
			  user="No" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- edit form --->

<form action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="95%" class="formpadding" align="center">

	<tr><td height="6"></td></tr>
    <cfoutput>
    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
  	   <input type="text" name="Code" id="Code" value="#get.code#" size="20" maxlength="10" class="regularxxl" <cfif URL.OC neq 0>disabled</cfif>>
	   <input type="hidden" name="CodeOld" id="CodeOld" value="#get.code#" size="20" maxlength="20">
    </TD>
	</TR>
	
	 <TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
  	   <input type="text" name="Description" id="Description" value="#get.Description#" size="30" maxlength="50" class="regularxxl">
	   
    </TD>
	</TR>
			
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="40">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
    <cfif URL.OC eq 0><input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()"></cfif>
    <input class="button10g" type="submit" name="Update" id="Update" value="Update">
	</td>	
	
	</tr>
	
</TABLE>

</FORM>

<cf_screenbottom layout="webapp">
	