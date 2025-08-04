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
			  label="Add Occupational Group" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Parent" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    #client.LanPrefix#OccGroup
		WHERE   ParentGroup is null
	</cfquery>
	 
<cfform action="RecordSubmit.cfm" method="post" name="dialog">

<!--- Entry form --->

<table width="90%" align="center" class="formpadding">

	<tr><td></td></tr>
	
    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
		<cfinput type="Text" name="OccupationalGroup" id="OccupationalGroup" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxxl">
	</TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Acronym:</TD>
    <TD>
		<cfinput type="Text" name="Acronym" id="Acronym" value="" message="Please enter a code" required="Yes" size="5" maxlength="5" class="regularxxl">
	</TD>
	</TR>
	
	   <!--- Field: Description --->
    <TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
	<cf_LanguageInput
			TableCode       = "OccGroup" 
			Mode            = "Edit"
			Name            = "Description"
			Type            = "Input"
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "50"
			Size            = "30"
			Class           = "regularxxl">
	</TD>
	</TR>
	
	   <!--- Field: Description --->
    <TR class="labelmedium2">
    <TD>Full:</TD>
    <TD>
	
		<cf_LanguageInput
			TableCode       = "OccGroup" 
			Mode            = "Edit"
			Name            = "DescriptionFull"
			Type            = "Input"
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "80"
			Size            = "40"
			Class           = "regularxxl">
	
	</TD>
	</TR>
	
	<tr class="labelmedium2">
	   <td>Parent:</td>
	   <td>	
		<cfselect name="ParentGroup" id="ParentGroup" class="regularxxl">
		<option value="">None</option>
		<cfoutput query="Parent">
		<option value="#OccupationalGroup#">#OccupationalGroup# #DescriptionFull#</option>
		</cfoutput>
		</cfselect>
	   </td>
	</tr>
	
    <TR>
    <TD class="labelit">Order:</TD>
    <TD>
		<cfinput type="Text" name="ListingOrder" id="ListingOrder" message="Please enter correct No" validate="integer" required="Yes" size="4" maxlength="4" class="regularxxl">
	</TD>
	</TR>

	   <!--- Field: Description --->
    <TR class="labelmedium2">
    <TD>Active:</TD>
    <TD>
	     <input type="radio" class="radiol" name="Status" id="Status" value="1" checked>Yes
		 <input type="radio" class="radiol" name="Status" id="Status" value="0">No
	
	</TD>
	</TR>
   
   <tr><td colspan="2" height="1" class="linedotted"></td></tr>

   <tr>
	
	<td align="center" colspan="2">
	<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
	<input class="button10g" type="submit" name="Insert" value="Submit">
	</td>
	
   </tr>
	
</table>

</cfform>
