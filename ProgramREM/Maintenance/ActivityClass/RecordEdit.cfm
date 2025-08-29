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
			   banner="gray"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ActivityClass
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this Activity Class?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>


<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- edit form --->

<table width="92%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

    <cfoutput>
    <TR>
    <TD class="labelit">Code:</TD>
    <TD>
  	   <input type="text" name="Code" value="#get.Code#" size="20" maxlength="20"class="regularxl">
	   <input type="hidden" name="Codeold" value="#get.Code#" size="20" maxlength="20"class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" requerided=  "yes" size="30" 
	   maxlenght = "30" class= "regularxl">
    </TD>
	</TR>
	
	<tr>
		<td class="labelit" style="padding-top:5px;" valign="top">Entities:</td>
		<td>
			<cfinclude template="ActivityClassMission.cfm">
		</td>
	</tr>
	
	</cfoutput>
	
	<tr><td height="5"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td height="5"></td></tr>
	<tr>	
		<td colspan="2" align="center" height="30">
	    <input class="button10g" type="submit" name="Delete" value="Delete" onclick="return ask()">
    	<input class="button10g" type="submit" name="Update" value=" Save ">
		</td>	
	</tr>
	
</TABLE>
	
</CFFORM>

