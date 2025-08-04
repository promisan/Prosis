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

<cf_tl id="Add Keyword Class" var="1">
<cf_screentop height="100%" 
			  layout="webapp" 
			  label="#lt_text#" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Parent"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ExperienceParent
</cfquery>

<cfquery name="OccGroup"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM OccGroup
</cfquery>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="92%" align="center" class="formpadding">

    <tr><td height="10"></td></tr>
		
	
	<TR>
    <TD class="labelit"><cf_tl id="Parent">:</TD>
    <TD>
  	   <cfselect name="Parent" query="Parent" value="Parent" display="Parent" required="Yes" class="regularxl"></cfselect>
    </TD>
	</TR>
	
	<tr><td height="5"></td></tr>
	
    <TR>
    <TD class="labelit"><cf_tl id="Code">:</TD>
    <TD>
  	   <cfinput type="Text" name="ExperienceClass" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="5"></td></tr>
	
	<TR>
    <TD class="labelit"><cf_tl id="Name">:</TD>
    <TD>
	
			<cf_LanguageInput
				TableCode       = "Ref_ExperienceClass" 
				Mode            = "Edit"
				Name            = "Description"
				Value           = ""
				Key1Value       = ""
				Type            = "Input"
				Required        = "Yes"
				Message         = "Please enter a description"
				MaxLength       = "50"
				Size            = "50"
				Class           = "regularxl">
						
    </TD>
	</TR>
	
	<tr><td height="5"></td></tr>
	
	<TR>
    <TD class="labelit"><cf_tl id="Order">:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" value="0" message="Please enter a valid order" validate="integer" required="Yes" size="2" maxlength="2" class="regularxl amount">
    </TD>
	</TR>
			
	<tr><td height="5"></td></tr>
	
	<TR>
    <TD class="labelit"><cf_tl id="Occ. group">:</TD>
    <TD>
	   <cfselect 
		   	name="OccupationalGroup" 
			class="regularxl" 
			query="Occgroup" 
			value="OccupationalGroup" 
			display="DescriptionFull" 
			required="Yes" 
			message="Select a valid occupational group">
	   </cfselect>
     </TD>
	</TR>
	
	<tr><td colspan="2" height="6"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" height="6"></td></tr>

	<tr>
	<td align="center" colspan="2" height="40" valign="bottom">
		<cf_tl id="Save" var="1">
	    <input class="button10g" type="submit" name="Insert" value=" <cfoutput>#lt_text#</cfoutput> ">
	</td>	
	
</TABLE>

</CFFORM>


<cf_screenbottom layout="innerbox">
