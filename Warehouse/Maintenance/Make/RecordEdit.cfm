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
			  layout="webapp" 
			  label="Make" 
			  option="Maintaing Make - #url.id1#" 
			  banner="yellow"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Make
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this make?")) {	
	return true 	
	}	
	return false	
}	

</script>


<!--- edit form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="95%" align="center" class="formpadding">

	<tr><td height="10"></td></tr>

    <cfoutput>
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD class="regular">
  	   <input type="text"   name="Code" id="Code" value="#get.Code#" size="20" maxlength="20"class="regularxxl">
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#" size="20" maxlength="20"class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="regular">Description:</TD>
    <TD class="regular">
  	   
	    <cfinput type="text" 
	       name="Description" 
		   value="#get.Description#" 
		   message="please enter a description" 
		   requerided="yes" 
		   size="30" 
	       maxlength="50" 
		   class="regularxxl">
    </TD>
	</TR>
		
	</cfoutput>
	
	<tr><td height="6"></td></tr>	
	<tr><td colspan="2" class="line"></td></tr>	
	<tr><td height="6"></td></tr>	
		
	<cfquery name="check" 
      datasource="appsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT TOP 1 Make
      FROM   AssetItem
      WHERE  Make  = '#url.id1#' 
    </cfquery>
			
	<tr>
		
	<td align="center" colspan="2">	
	    <cfif check.recordcount eq "0">
	    <input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()">
		</cfif>
    	<input class="button10g" type="submit" name="Update" id="Update" value="Update">
	</td>	
	</tr>
	
</table>

</cfform>
	
<cf_screenbottom layout="innerbox">
