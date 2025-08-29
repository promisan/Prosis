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
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Post Class" 
			  menuAccess="Yes" 
			  banner="gray"
			  jQuery="yes"
			  line="No"
			  systemfunctionid="#url.idmenu#">
			  
<cf_colorScript>			  
  
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ScheduleClass
	WHERE  Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Schedule Class ?")) {
		return true 
	}
	return false	
}	

</script>

<!--- edit form --->

<table width="92%" align="center" class="formpadding formspacing">

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

	<tr><td style="height:6px"></td></tr>

    <cfoutput>
    <TR class="labelmedium2">
    <TD width="120">Code:</TD>
    <TD>
  	   <input type="text" name="Code" value="#get.Code#" size="10" maxlength="10" class="regularxxl">
	   <input type="hidden" name="CodeOld" value="#get.Code#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="23" maxlength="50" class="regularxxl">
    </TD>
	</TR>

	<TR class="labelmedium2">
    <TD>Order:</TD>
    <TD>
  	   <cfinput type="Text" style="text-align:center" name="ListingOrder" value="#get.ListingOrder#" message="Please enter a valid Listing Order" required="No" size="2" maxlength="2" range="0,999" class="regularxxl">
    </TD>
	</TR>
	
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2">
	<input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" value=" Update ">
	</td>	
	
	</tr>

</CFFORM>
	
</TABLE>
	

