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
			  label="Edit Occupational Group" 
			  html="Yes" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   OccGroup 
	WHERE  OccupationalGroup = '#URL.ID1#'
</cfquery>


<cfquery name="Parent" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    #client.LanPrefix#OccGroup
		WHERE   ParentGroup is null
	</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {
		return true 
	}
	return false	
}	

</script>

<cfform action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">
<!--- edit form --->

<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

     <tr><td></td></tr>
	 <cfoutput>
	 <TR>
	 <TD style="width:20%" class="labelit">Code:</TD>  
	 <TD>
	 	<input type="Text" name="OccupationalGroup" id="OccupationalGroup" value="#get.OccupationalGroup#" size="10" maxlength="10" class="regularxl">
		<input type="hidden" name="OccupationalGroupOld" id="OccupationalGroupOld" value="#get.OccupationalGroup#" size="10" maxlength="10"class="regular">
	 </TD>
	 </TR>
	 
	  <TR>
	 <TD style="width:20%" class="labelit">Acronym:</TD>  
	 <TD>
	 	<input type="Text" name="Acronym" id="Acronym" value="#get.Acronym#" size="4" maxlength="4" class="regularxl">
		
	 </TD>
	 </TR>
	 
    <!--- Field: Description --->
    <TR>
    <TD class="labelit">Name:</TD>
    <TD>
			
	<cf_LanguageInput
			TableCode       = "OccGroup" 
			Mode            = "Edit"
			Name            = "Description"
			Type            = "Input"
			Required        = "Yes"
			Value           = "#get.Description#"
			Key1Value       = "#get.OccupationalGroup#"
			Message         = "Please enter a description"
			MaxLength       = "40"
			Size            = "30"
			Class           = "regularxl">
  				
    </TD>
	</TR>
	
	 <!--- Field: Description --->
    <TR>
    <TD class="labelit">Full:</TD>
    <TD>
	
		<cf_LanguageInput
			TableCode       = "OccGroup" 
			Mode            = "Edit"
			Name            = "DescriptionFull"
			Type            = "Input"
			Required        = "Yes"
			Value           = "#get.DescriptionFull#"
			Key1Value       = "#get.OccupationalGroup#"
			Message         = "Please enter a description"
			MaxLength       = "80"
			Size            = "50"
			Class           = "regularxl">
				
    </TD>
	</TR>
	
	<tr>
	   <td class="labelit">Parent:</td>
	   <td>	
		<cfselect name="ParentGroup" id="ParentGroup" class="regularxl">
			<option value="">None</option>
			<cfloop query="Parent">
				<option value="#OccupationalGroup#" <cfif get.ParentGroup eq OccupationalGroup>selected</cfif>>#OccupationalGroup# #DescriptionFull#</option>
			</cfloop>
		</cfselect>
	   </td>
	</tr>
	
	   <!--- Field: Description --->
    <TR>
    <TD class="labelit">Order:</TD>
    <TD>
		<cfinput type="Text" name="ListingOrder" id="ListingOrder" 
				 value="#get.ListingOrder#" message="Please enter correct No" 
				 validate="integer" required="Yes" size="4" maxlength="4" class="regularxl">
	</TD>
	</TR>

	   <!--- Field: Description --->
    <TR>
    <TD class="labelit">Active:</TD>
    <TD class="labelmedium">
	    <input type="radio" class="radiol" name="Status" id="Status" value="1" <cfif get.Status eq "1">checked</cfif>>Yes
		<input type="radio" class="radiol" name="Status" id="Status" value="0" <cfif get.Status eq "0">checked</cfif>>No  
	
	</td>
	</TR>
		
</cfoutput>

<tr><td colspan="2" class="linedotted"></td></tr>
	
<tr>
	<td colspan="2" align="center" height="30">
	<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Delete" value="Delete" onclick="return ask()">
    <input class="button10g" type="submit" name="Update" value="Update">
	</td>
</tr>
    	
</table>

</cfform>

<cf_screenbottom layout="innerbox">