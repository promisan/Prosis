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
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Relationship
	WHERE Relationship = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Relationship ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cf_screentop height="100%" 
              label="Relationship" 
			  layout="webapp" 
			  user="No"  
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- edit form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="95%" class="formpadding" align="center">
	
<tr><td></td></tr>	
	
    <cfoutput>
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
  	   <input type="text" name="Relationship" value="#get.Relationship#" size="20" maxlength="20" class="regularxxl">
	   <input type="hidden" name="RelationshipOld" value="#get.Relationship#" size="20" maxlength="20" readonly>
    </TD>
	</TR>
	
	 <TR>
    <TD class="labelmedium2">Descriptive:</TD>
    <TD>
  	   <input type="text" name="Description" value="#get.Description#" size="30" maxlength="50" class="regularxxl">
	   
    </TD>
	</TR>
			
	</cfoutput>
		
	<tr>
		
	<td align="center" colspan="2" height="40">
	<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Delete" value="Delete" onclick="return ask()">
    <input class="button10g" type="submit" name="Update" value="Update">
	</td>	
	
	</tr>
		
</TABLE>

</CFFORM>

<cf_screenbottom layout="webapp">
	