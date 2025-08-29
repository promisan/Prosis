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
			  label="Settlement" 
			  option="Maintaing Settlement - #url.id1#" 
			  banner="yellow"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Settlement
	WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

	function ask() {
		if (confirm("Do you want to remove this settlement?")) {		
		return true 		
		}		
		return false		
	}	

</script>

<!--- edit form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="91%" align="center" class="formpadding">
	
	<tr><td height="10"></td></tr>

    <cfoutput>
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD class="labelmedium">
  	   <input type="text" name="Code" id="Code" value="#get.Code#" size="20" maxlength="20" class="regularxxl">
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#" size="20" maxlength="20"class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" requerided=  "yes" size="30" 
	   maxlenght = "30" class= "regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Mode:</TD>
    <TD class="labelmedium">
  	   <select name="mode" id="mode" class="regularxxl">
	   		<option value="" <cfif get.mode eq "">selected</cfif>>
			<option value="Cash" <cfif get.mode eq "Cash">selected</cfif>>Cash
			<option value="Check" <cfif get.mode eq "Check">selected</cfif>>Check
			<option value="Credit" <cfif get.mode eq "Credit">selected</cfif>>Credit
			<option value="Gift" <cfif get.mode eq "Gift">selected</cfif>>Gift
	   </select>
    </TD>
	</TR>
		
	<TR>
    <TD  class="labelmedium2">Operational:</TD>
    <TD  class="labelmedium">
	   <input type="radio" class="radiol"  name="Operational" value="1" <cfif get.Operational eq 1>checked</cfif>> Yes&nbsp;
 	   <input type="radio" class="radiol" name="Operational" value="0" <cfif get.Operational eq 0>checked</cfif>> No
    </TD>
	</TR>
	
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>	
	<tr><td height="6"></td></tr>	
			
	<tr>		
	<td align="center" colspan="2">	
    <input class="button10g" type="submit" name="Delete" ID="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td>	
	</tr>
		
</TABLE>

</CFFORM>
	
<cf_screenbottom layout="innerbox">
