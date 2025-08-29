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
			  layout="webapp" 
			  label="Edit" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM #CLIENT.LanPrefix#Ref_Resource
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Resource Category?")) {	
	return true 	
	}	
	return false	
}	

</script>


<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- edit form --->

<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <tr><td></td></tr>
	
    <cfoutput>
    <TR class="labelmedium">
    <TD>Code:</TD>
    <TD>
  	   <input type="text"   name="Code"    value="#get.Code#" size="20" maxlength="20" class="regularxl">
	   <input type="hidden" name="Codeold" value="#get.Code#" size="20" maxlength="20" class="regular">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Name:</TD>
    <TD>
  	   <cfinput type="text" name="name" value="#get.name#" message="Please enter a name" required="Yes" size="15" maxlength="15" class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Description:</TD>
    <TD>
	<cf_LanguageInput
			TableCode       = "Ref_Resource" 
			Mode            = "Edit"
			Name            = "Description"
			Value           = "#get.Description#"
			Key1Value       = "#get.Code#"
			Type            = "Input"
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "50"
			Size            = "30"
			Class           = "regularxl">
	  	
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Listing Order">:</TD>
    <TD>
  	   <cfinput type="Text"
	       name="ListingOrder"
	       value="#get.ListingOrder#"
	       validate="integer"
	       required="No"
	       visible="Yes"
	       enabled="Yes"
	       size="1"
	       maxlength="2"
	       class="regularxl">
	  
    </TD>
	</TR>
	
	<TR>
      <TD class="labelmedium"><cf_tl id="Execution Inquiry">:</TD>    
	  <TD class="labelmedium">
		    <INPUT type="radio" class="radiol" name="ExecutionDetail" value="0" <cfif get.ExecutionDetail eq "0">checked</cfif>>Yes
			<INPUT type="radio" class="radiol" name="ExecutionDetail" value="1" <cfif get.ExecutionDetail eq "1">checked</cfif>>Disabled for budget officers
		</TD>
  	
	
	</TR>
	
	
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr>		
	<td colspan="2" height="35" align="center">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" value=" Update ">
	</td>	
	
</TABLE>
	
</CFFORM>
