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
			  title="Salutation" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Salutation" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Salutation
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this salutation?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="94%" align="center" class="formpadding">

    <cfoutput>
	
	<tr><td style="height:5px"></td></tr>
	
	<TR class="labelmedium2">
    <TD width="25%">Code:</TD>
    <TD>
		<b>#get.Code#</b>
  	   <cfinput type="hidden" name="Code" value="#get.Code#" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxxl">
    </TD>
	</TR>

	
	<TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="20" maxlength="20" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Abbreviation:</TD>
    <TD>
  	   <cfinput type="Text" name="Abbreviation" value="#get.Abbreviation#" message="Please enter an abbreviation" required="Yes" size="10" maxlength="10" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" value="#get.ListingOrder#" message="Please enter a ListingOrder" required="Yes" validate="integer" size="5" maxlength="3" class="regularxxl">
    </TD>
	</TR>
	
	</cfoutput>
		
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<tr><td colspan="2" valign="bottom" align="center">
    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" value=" Save ">
	</td></tr>
	
</table>

</cfform>
