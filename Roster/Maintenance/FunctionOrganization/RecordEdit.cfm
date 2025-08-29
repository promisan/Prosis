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
			  title="Class" 
			  scroll="Yes" 
			  layout="webapp" 
			  Label="Edit" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Organization
WHERE Organizationcode = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this area?")) {	
	return true 	
	}	
	return false	
}	

</script>

<!--- edit form --->

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="95%" align="center" class="formpadding formspacing">

    <cfoutput>
	
	<tr><td height="4"></td></tr>
	
    <TR>
    <TD class="labelit">Code:</TD>
    <TD>
  	   <input type="text" name="Organizationcode" id="Organizationcode" value="#get.Organizationcode#" size="20" maxlength="20"class="regularxxl">
	   <input type="hidden" name="OrganizationcodeOld" id="OrganizationcodeOld" value="#get.Organizationcode#" size="20" maxlength="20" readonly>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="OrganizationDescription" id="OrganizationDescription" value="#get.Organizationdescription#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl">
    </TD>
	</TR>
	
	</cfoutput>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<tr>
		<td align="center" colspan="2" valign="bottom">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
	    <input class="button10g" type="submit" name="Update" value=" Update ">
		</td>	
	</tr>
	
</TABLE>

</CFFORM>

