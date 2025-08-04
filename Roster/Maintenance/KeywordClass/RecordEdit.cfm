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

<cf_tl id="Edit Class" var="1">
<cf_screentop height="100%" 
			  layout="webapp" 
			  label="#lt_text#" 
			  menuAccess="Yes" 
			  jquery="Yes"
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ExperienceClass
		WHERE ExperienceClass = '#URL.ID1#'
</cfquery>

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

<cfquery name="qOwners"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	O.*,
				(SELECT Owner FROM Ref_ExperienceClassOwner WHERE ExperienceClass = '#URL.ID1#' AND Owner = O.Owner) as Selected
		FROM 	Ref_ParameterOwner O
		WHERE 	O.Operational = 1
</cfquery>

<cf_tl id="Do you want to remove this Experience Class ?" var="vRemMsg">
<script language="JavaScript">

function ask() {
	if (confirm("<cfoutput>#vRemMsg#</cfoutput>")) {	
	return true 	
	}	
	return false	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- edit form --->

<table width="92%" align="center" class="formpadding">

    <tr><td></td></tr>
    <cfoutput>	
	
	<TR>
    <TD class="labelit"><cf_tl id="PHP section">:</TD>
    <TD>
	  <select name="Parent" class="regularxl">
	   <cfloop query="Parent">
	   <option value="#Parent.Parent#" <cfif #Get.Parent# eq #Parent#>selected</cfif>>#Parent#</option>
	   </cfloop>
	   </select>
    </TD>
	</TR>
	
    <TR>
    <TD class="labelit"><cf_tl id="Code">:</TD>
    <TD>
  	   <input type="text" name="ExperienceClass" value="#get.ExperienceClass#" size="10" maxlength="10" class="regularxl">
	   <input type="hidden" name="ExperienceClassOld" value="#get.ExperienceClass#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
		
	<TR>
    <TD class="labelit"><cf_tl id="Name">:</TD>
    <TD>
	
		<cf_LanguageInput
			TableCode       = "Ref_ExperienceClass" 
			Mode            = "Edit"
			Name            = "Description"
			Value           = "#Get.Description#"
			Key1Value       = "#get.ExperienceClass#"
			Type            = "Input"
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "50"
			Size            = "50"
			Class           = "regularxl">

    </TD>
	</TR>	
	
	<TR>
    <TD class="labelit"><cf_tl id="Occ. group">:</TD>
    <TD>
	   <cfselect 
		   	name="OccupationalGroup" 
			class="regularxl" 
			query="Occgroup" 
			value="OccupationalGroup" 
			display="DescriptionFull" 
			selected="#Get.OccupationalGroup#" 
			required="Yes" 
			message="Select a valid occupational group">
	   </cfselect>
     </TD>
	</TR>
		
	<TR>
    <TD class="labelit"><cf_tl id="Sorting">:</TD>
    <TD>
  	   <cfinput type="Text" value="#Get.ListingOrder#" name="ListingOrder" message="Please enter a valid order" validate="integer" style="text-align:center" required="Yes" size="2" maxlength="2" class="regularxl amount">
    </TD>
	</TR>	
	
	
	<cfif URL.ID1 neq "">
	<tr>
		<td class="labelit" valign="top" style="padding-top:4px;"><cf_tl id="Owners">:</td>
		<td>
			<table cellspacing="0" cellpadding="0">
				<tr>
				<cfset vCols = 5>
				<cfset vCnt = 0>
				<cfloop query="qOwners">
					<td style="height:25px;padding-right:5px;">
						<table cellspacing="0" cellpadding="0">
							<tr>
								<td><input type="Checkbox" class="radiol" name="owner_#owner#" id="owner_#owner#" <cfif owner eq selected>checked</cfif>></td>
								<td style="padding-left:3px;" class="labelit"><label for="owner_#owner#">#Owner#</label></td>
							</tr>
						</table>
					</td>
					<cfset vCnt = vCnt + 1>
					<cfif vCnt eq vCols>
						</tr>
						<tr>
						<cfset vCnt = 0>
					</cfif>
				</cfloop>
				</tr>
			</table>
		</td>
	</tr>
	</cfif>
		
		
	</cfoutput>

	<tr><td colspan="2" height="2"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" height="2"></td></tr>	
	
	<tr>
	<td colspan="3" align="center"  valign="bottom">
	<cf_tl id="Delete" var="1">
    <input class="button10g" type="submit" name="Delete" value=" <cfoutput>#lt_text#</cfoutput> " onclick="return ask()">
	<cf_tl id="Save" var="1">
    <input class="button10g" type="submit" name="Update" value=" <cfoutput>#lt_text#</cfoutput> ">
	</td>	
	</tr>
	
</TABLE>
	
</CFFORM>
