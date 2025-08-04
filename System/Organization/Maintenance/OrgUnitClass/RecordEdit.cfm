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
			  label="Edit" 
			  scroll="Yes" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_OrgUnitClass
WHERE OrgUnitClass = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask()	{
	if (confirm("Do you want to remove this class?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- edit form --->

<table width="90%" class="formpadding formspacing" align="center">

    <cfoutput>
	<tr><td></td></tr>
    <TR>
    <TD class="labelmedium"><cf_tl id="Code">:</TD>
    <TD class="labelmedium">
  	   <input type="text" name="Code" id="Code" value="#get.OrgUnitClass#" size="20" maxlength="20" class="regularxl">
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.OrgUnitClass#" size="20" maxlength="20"class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Description">:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" required="yes" size="30" 
	   maxlenght="30" class= "regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Icon">:</TD>
    <TD class="labelmedium"  title="Please enter the name of a graphic icon" style="cursor:pointer">
  	   <cfinput type="text" name="ListingIcon" value="#get.ListingIcon#" required="No" size="30" maxlength="30" class="regularxl">
    </TD>
	</TR>
		
	</cfoutput>
		
	<tr><td colspan="2" height="1" class="linedotted"></td></tr>
	
	<tr><td align="center" colspan="2" height="10">
	<input class="button10g" style="width:80" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" style="width:80" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" style="width:80" type="submit" name="Update" id="Update" value=" Update ">
	</td>	
	
	</tr>
	
</TABLE>
	
</CFFORM>

</BODY></HTML>