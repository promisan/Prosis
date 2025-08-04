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
			  label="Edit" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_PostGradeParent
WHERE Code = '#URL.ID1#'
</cfquery>


<cfquery name="Posttype"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PostType
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Parent grade ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- edit form --->

<table width="93%" align="center" class="formpadding formspacing">

	<tr><td height="2" colspan="2"></td></tr>

    <cfoutput>
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
  	   <input type="text" name="Code" value="#get.Code#" size="20" maxlength="20" class="regularxxl">
	   <input type="hidden" name="CodeOld" value="#get.Code#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="Description" value="#Get.Description#" message="Please enter a display description" required="Yes" size="30" maxlength="40" class="regularxxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium2">Listing order:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="ViewOrder" value="#Get.ViewOrder#" message="Please enter a listing order" validate="integer" required="Yes" size="3" maxlength="3" class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Show subtotal:&nbsp;</TD>
    <TD style="height:25" class="labelmedium">
  	   <input type="Radio" name="ViewTotal" value="1" <cfif #Get.ViewTotal# eq "1">checked</cfif>>Yes
	   <input type="Radio" name="ViewTotal" value="0" <cfif #Get.ViewTotal# eq "0">checked</cfif>>No
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Posttype:</TD>
    <TD class="regular">
	   <select name="PostType" class="regularxxl">
	   <cfloop query="PostType">
	   <cfoutput>
	   <option value="#PostType.PostType#" <cfif #PostType.PostType# eq #Get.PostType#>selected</cfif>>#PostType.Description#</option>
	   </cfoutput>
	   </cfloop>
	   </select>
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium2">Category:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="Category" value="#Get.Category#" message="Please enter a category" required="Yes" size="20" maxlength="20" class="regularxxl">
    </TD>
	</TR>

	<tr><td height="1" colspan="2" class="line"></td></tr>
	
	<TR>
		<td align="center" colspan="2">		
	    <input class="button10g" type="submit" name="Delete" value="Delete" onclick="return ask()">
	    <input class="button10g" type="submit" name="Update" value="Save">
		</td>	
	</TR>
	
	</cfoutput>	

	
	
</TABLE>

	
	
</CFFORM>


