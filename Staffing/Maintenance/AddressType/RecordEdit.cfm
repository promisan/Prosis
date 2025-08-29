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
			  label="Address Type" 			  
			  banner="yellow" 
			  scroll="Yes" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  jquery="Yes"
			  systemfunctionid="#url.idmenu#">
			  
<cf_colorScript>			  

<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT 	*
FROM 	Ref_AddressType
WHERE 	AddressType = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Address Type ?")) {	
	return true 	
	}	
	return false
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" border="0" align="center" class="formpadding formspacing">

     <tr><td height="6"></td></tr>
	 
    <cfoutput>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
  	   <input type="text" name="AddressType" value="#get.AddressType#" size="20" maxlength="20" class="regularxxl">
	   <input type="hidden" name="AddressTypeOld" value="#get.AddressType#" size="20" maxlength="20" readonly>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium" valign="top" style="padding-top:4px">Description:</TD>
    <TD class="labelmedium">
	
		<cf_LanguageInput
				TableCode       = "Ref_AddressType" 
				Mode            = "Edit"
				Name            = "Description"
				Value           = "#get.Description#"
				Key1Value       = "#get.AddressType#"
				Type            = "Input"
				Required        = "Yes"
				Message         = "Please enter a description"
				MaxLength       = "50"
				Size            = "35"
				Class           = "regularxxl">	
		<!---
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="35" maxlength="50" class="regularxl">	   
	   --->
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Listing order:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="ListingOrder" value="#get.ListingOrder#" message="Please enter a description" required="Yes" size="1" maxlength="50" class="regularxxl">
    </TD>
	</TR>
	
	<cfquery name="Workflow" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_EntityClass
		WHERE EntityCode = 'PersonAddress'
	</cfquery>
	
	<td class="labelmedium">Workflow Class:</td>
	<td class="labelmedium">
		
		<select name="EntityClass" class="regularxxl">
		    <option value="">N/A</option>
			<cfloop query="WorkFlow">
				<option value="#EntityClass#" <cfif get.EntityClass eq EntityClass>selected</cfif>>#EntityClassName#</option>
			</cfloop>		
		</select>		
		
	</td>
	</tr>	
	<tr>
	<td class="labelmedium">Marker Color:</td>
	<td class="labelmedium">		  			
		<cf_color name="color" 
				  value="#get.MarkerColor#"
				  style="cursor: pointer; font-size: 0; border: 1px solid gray; height: 20; width: 20; ime-mode: disabled; layout-flow: vertical-ideographic;">			  					   
		</td>
	</tr>
	
	<tr>
	<TD class="labelmedium">Operational:</TD>
	    <TD class="labelmedium">
			<input type="radio" name="operational" class="radiol" value="0" <cfif get.Operational eq "0">checked</cfif>>No
			<input type="radio" name="operational" class="radiol" value="1" <cfif get.Operational eq "1">checked</cfif>>Yes	
	    </TD>
	</tr>
	</cfoutput>
		
</TABLE>

<cf_dialogBottom option="edit">
	
</CFFORM>

