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

<cfquery name="Get" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	select *
	from Ref_UnitClass
	WHERE code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cf_screentop height="100%" 
			  label="Unit Class" 
			  layout="webapp" 
			  user="No" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- edit form --->

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

	<table width="95%" align="center" class="formpadding formspacing">
	
		<tr><td height="6"></td></tr>
	    <cfoutput>
	    <TR class="labelmedium2">
	    <TD>Code:</TD>
	    <TD>
	  	   <input type="text" name="Code" id="Code" value="#get.code#" size="20" maxlength="10" class="regularxxl" <cfif URL.OC neq 0>disabled</cfif>>
		   <input type="hidden" name="CodeOld" id="CodeOld" value="#get.code#" size="20" maxlength="20" readonly>
	    </TD>
		</TR>
		
		<TR class="labelmedium2">
	    <TD>Description:</TD>
	    <TD>
		   <cf_LanguageInput
				TableCode		= "Ref_UnitClass"
				Mode            = "Edit"
				Name            = "Description"
				Id              = "Description"
				Type            = "Input"
				Value			= "#get.Description#"
				Key1Value       = "#get.Code#"
				Required        = "Yes"
				Message         = "Please enter a description"
				MaxLength       = "50"
				Size            = "40"
				Class           = "regularxxl">
		   
	    </TD>
		</TR>
		
		<TR>
	    <TD>Listing order:</TD>
	    <TD>
			<cfinput type="Text" name="ListingOrder" value="#get.listingOrder#"
			 message="Please enter a number as a listing order" required="Yes" validate="integer" size="10" maxlength="3" class="regularxxl">	   
	    </TD>
		</TR>
				
		</cfoutput>
		
		<tr><td colspan="2" class="line"></td></tr>
		
		<tr>		
		<td align="center" colspan="2" height="40">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
	    <cfif URL.OC eq 0><input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()"></cfif>
	    <input class="button10g" type="submit" name="Update" id="Update" value="Update">
		</td>		
		</tr>
		
	</TABLE>

</CFFORM>

<cf_screenbottom layout="webapp">
	