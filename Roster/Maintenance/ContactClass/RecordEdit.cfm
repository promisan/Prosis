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
			  title="Background Contact" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Contact" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ContactClass
		WHERE 	Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this contact class?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

	<table width="93%" align="center" class="formpadding formspacing">
	
	    <cfoutput>
		
		<tr><td style="height:6px"></td></tr>
	    <TR>
	    <TD class="labelmedium2">Code:</TD>
	    <TD class="labelmedium">
			<input type="Hidden" name="Code" id="Code" value="#get.Code#">
	  	    #get.Code#
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium2">Description:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Description" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl" value="#get.Description#">
	    </TD>
		</TR>
		
		<TR>
	    <TD  class="labelmedium2">Order:</TD>
	    <TD>
	  	  	<cfinput type="Text" name="ListingOrder" message="Please enter a numeric order" validate="integer" required="No" size="1" maxlength="3" class="regularxxl" style="text-align:center;" value="#get.ListingOrder#">
	    </TD>
		</TR>
		
		</cfoutput>
			
		<tr><td colspan="2" class="linedotted"></td></tr>
		
		
		<tr>
		<td align="center" colspan="2" valign="bottom">
	    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
	    <input class="button10g" type="submit" name="Update" value=" Update ">
		</td>	
		</tr>
		
	</table>	

</cfform>

