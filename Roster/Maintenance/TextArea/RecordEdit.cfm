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
datasource="AppsSelection" 
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

<table width="92%" align="center">

	<tr><td height="7"></td></tr>
	
	<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog" onsubmit="return validate();">

    <cfoutput>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD >
  	   <input class="regularxl" type="text" name="Code" id="Code" value="#get.Code#" size="10" maxlength="10">
	   <input type="hidden" name="CodeOld" value="#get.Code#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
		
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium">Domain:</TD>
    <TD>
	   <select name="TextAreaDomain" class="regularxl">
			<option value="Preliminary" <cfif get.TextAreaDomain eq "Preliminary">selected</cfif>>Preliminary Interview</option>
			<option value="Bucket" <cfif get.TextAreaDomain eq "Bucket">selected</cfif>>Roster bucket/Vacancy Interview</option>
			<option value="JobProfile" <cfif get.TextAreaDomain eq "JobProfile">selected</cfif>>Job Profile</option>
			<option value="Edition" <cfif get.TextAreaDomain eq "Edition">selected</cfif>>Roster Edition</option>
		</select>
     </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" value="#get.ListingOrder#" message="Please enter an integer value" validate="integer" required="Yes" visible="Yes" enabled="Yes" size="1" maxlength="2" class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium">Text area rows:</TD>
    <TD>
  	   <cfinput type="Text" name="NoRows" value="#get.NoRows#" message="Please enter an integer value" validate="integer" required="Yes" visible="Yes" enabled="Yes" size="1" maxlength="2" class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium">Entry mode:</TD>
    <TD class="labelmedium">
	  <input type="radio" name="EntryMode" value="Regular" <cfif #get.EntryMode# eq "Regular">checked</cfif>>Standard
	  <input type="radio" name="EntryMode" value="Editor" <cfif #get.EntryMode# eq "Editor">checked</cfif>>Editor
     </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR valign="top">
    <TD class="labelmedium">Explanation:</TD>
    <TD>
	   <textarea cols="50" rows="7" name="Explanation" class="regular">#get.explanation#</textarea>
   </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
		
	</cfoutput>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="30">

	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" value=" Update ">
	</td></tr>
	
	</CFFORM>
	
</TABLE>
	