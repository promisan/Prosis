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
<!---
<cf_screentop layout="webapp" user="No" bannerheight="1" height="100%" html="no" label="Copy Workflow Settings">
--->

<cfoutput>

<cfquery name="EntClass" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	Select EntityClass, EntityClassName
	FROM Ref_EntityClass
	WHERE EntityCode = '#URL.EntityCode#' 
	<cfif URL.PublishNo eq "">
		AND EntityClass != '#URL.EntityClass#'
	</cfif>
</cfquery>
	
<!--- edit form --->

<table width="90%" align="center" class="formpadding">

	<tr><td height="10"></td></tr>
	<tr><td colspan="2" class="labelmedium2">This option allows you to copy and overwrite the draft workflow of a workflow of your choice.</td></tr>	
	<tr><td colspan="2" class="labelmedium2">You may copy a workflow to a different class under the same entity.</td></tr>	
	<tr><td height="10"></td></tr>
	<tr><td colspan="2" class="labelmedium2"><font color="FF8080">Use with care as this action can not be undone.</font></td></tr>
	<tr><td height="10"></td></tr>
	
	<TR>
    <TD class="labelmedium fixlength">Class to restore:</TD>
    <TD>
            <select name="EClass" id="EClass" class="regularxxl">
            <cfloop query="EntClass">
            	<option value="#EntityClass#"<cfif EntityClass eq Url.EntityClass>Selected="Yes"</cfif>>#EntityClassName#</option>
            </cfloop>
			</select>					
	</TD>
	</TR>
	
	<tr><td height="40"></td></tr>	
	<tr><td colspan="2" class="line"></td></tr>	
	<tr><td height="5"></td></tr>

	<td align="center" colspan="2">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="ProsisUI.closeWindow('mydialog');">
	    <input class="button10g" type="button" name="Print"  id="Print"  value="Copy"     onClick="copytoreturn();">
	</td>	
	
</table>

</cfoutput>

<cf_screenbottom layout="webapp">
