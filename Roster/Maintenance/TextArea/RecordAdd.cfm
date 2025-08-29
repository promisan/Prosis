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
			  label="Add Text Area" 
			  scroll="Yes" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<script>
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
			  
<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" name="dialog" onsubmit="return validate();">

<table width="92%" align="center">

	<tr><td height="7"></td></tr>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="Code" id="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium">Domain:</TD>
    <TD>
	   <select name="TextAreaDomain" id="TextAreaDomain" class="regularxl">
					<option value="Preliminary" SELECTED>Preliminary interview</option>
					<option value="Bucket">Roster bucket/Vacancy interview</option>
					<option value="JobProfile">Job profile</option>
					<option value="Edition">Roster Edition</option>
		</select>
     </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" id="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxl">
    </TD>
	</TR>
		
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="ListingOrder" id="ListingOrder" value="1" message="Please enter an integer value" validate="integer" required="Yes" visible="Yes" enabled="Yes" size="1" maxlength="2" class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium">Text area rows:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="NoRows" id="NoRows" value="4" message="Please enter an integer value" validate="integer" required="Yes" visible="Yes" enabled="Yes" size="1" maxlength="2" class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium">Entry mode:</TD>
    <TD class="labelmedium">
	  <input type="radio" name="EntryMode" id="EntryMode" value="Regular" checked>Standard
	  <input type="radio" name="EntryMode" id="EntryMode" value="Editor">Editor
     </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR valign="top">
    <TD class="labelmedium">Explanation:</TD>
    <TD class="regular">
	   <textarea cols="50" rows="7" name="Explanation" id="Explanation" class="regular"></textarea>
   </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	<tr><td height="1" class="linedotted" colspan="2"></td></tr>
	
	<tr><td colspan="2" align="center" height="30">
	
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	
	</td>	
	
	</tr>
	
</table>

</cfform>