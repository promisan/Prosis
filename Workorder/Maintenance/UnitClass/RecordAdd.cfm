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
			  label="Add Unit Class" 
			  layout="webapp" 
			  user="No"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="95%" align="center">
	
	<tr><td height="6"></td></tr>
    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="20" maxlength="10" class="regularxxl">
    </TD>
	</TR>
	
	<TR valign="top" class="labelmedium2">
    <TD>Description:</TD>
    <TD>
	   <cf_LanguageInput
			TableCode		= "Ref_UnitClass"
			Mode            = "Edit"
			Name            = "Description"
			Id              = "Description"
			Type            = "Input"
			Value			= ""
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "50"
			Size            = "40"
			Class           = "regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Listing order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" value="" message="Please enter a number as a listing order" required="Yes" 
	     validate="integer" size="10" maxlength="3" class="regularxxl">
    </TD>
	</TR>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>		
	<td align="center" colspan="2" height="30">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Save" id="Save" value="Save">
	</td>	
	
	</tr>
	
</table>

</CFFORM>


