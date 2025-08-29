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
			  label="Edit Text Area" 
			  scroll="Yes" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_TextArea
	WHERE  Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

	function ask() {
	
		if (confirm("Do you want to remove this textarea ?")) {
			return true 
		}
		return false
	}	

	function validate(){
		c = document.getElementById('Code');
		var found = c.value.match(/^[a-zA-Z]/);
		if (found){
			return true;
		}else{
			alert('Code must start with a letter.');
			c.focus();
			c.select();
			return false;
		}
		return false;
	}

</script>

<!--- edit form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog" onsubmit="return validate();">
	
<table width="93%" align="center" class="formpadding fromspacing">
	
	<tr><td></td></tr>
    <cfoutput>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD >
  	   <input type="text" class="regularxl" name="Code" id="Code" value="#get.Code#" size="10" maxlength="10">
	   <input type="hidden" name="CodeOld" value="#get.Code#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Domain:</TD>
    <TD>
	   <select name="TextAreaDomain" class="regularxl">
			<option value="Category" <cfif get.TextAreaDomain eq "Category">selected</cfif>>Classification</option>
			<option value="Review" <cfif get.TextAreaDomain eq "Review">selected</cfif>>Review Cycle</option>			
		</select>
     </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="40" maxlength="20" class="regularxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" style="text-align:center" value="#get.ListingOrder#" message="Please enter an integer value" validate="integer" required="Yes" visible="Yes" enabled="Yes" size="1" maxlength="2" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Text area rows:</TD>
    <TD>
  	   <cfinput type="Text" name="NoRows" style="text-align:center" value="#get.NoRows#" message="Please enter an integer value" validate="integer" required="Yes" visible="Yes" enabled="Yes" size="1" maxlength="2" class="regularxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Entry mode:</TD>
    <TD class="labelmedium">
	  <input type="radio" class="radioL" name="E   ntryMode" value="Regular" <cfif get.EntryMode eq "Regular">checked</cfif>>Standard
	  <input type="radio" class="radioL" name="EntryMode" value="Editor" <cfif get.EntryMode eq "Editor">checked</cfif>>Editor
     </TD>
	</TR>
		
	<TR valign="top">
    <TD class="labelmedium" style="padding-top:6px">Explanation:</TD>
    <TD>
	   <textarea style="padding;3px;font-size:13px;width:95%"  rows="6" rows="7" name="Explanation" class="regular">#get.explanation#</textarea>
   </TD>
	</TR>
			
	</cfoutput>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="35">

	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" value=" Update ">
	</td></tr>
		
</TABLE>

</CFFORM>
	