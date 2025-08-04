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
			  title="Edit Job Group" 
			  label="Edit Job Group" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_JobCategory
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record?")) {
		return true 
	}
	return false	
}	

</script>

<!--- edit form --->

<cfform action="RecordSubmit.cfm" name="dialog">
	
<table width="94%" align="center" class="formspacing formpadding">
		
	<tr><td height="4"></td></tr>
	
	<tr><td colspan="2" class="labelit"><font color="808080">Job groups are a means to classify jobs. 
	Groups will also be used for workflow allowing to define different actors for each group although the workflow follows the same pattern (class)
	</font>
	</td></tr>
	
	<tr><td height="5"></td></tr>
	
    <cfoutput>
	<!--- Field: Code--->
	 <TR>
	 <TD class="labelmediunm2" width="100">Code:&nbsp;</TD>  
	 <TD class="labelit" width="70%">
	 	<input type="Text" name="Code" id="Code" value="#get.Code#" size="20" maxlength="20"class="regularxxl">
		<input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#" size="20" maxlength="20"class="regular">
	 </TD>
	 </TR>
	
	<!--- Field: Description --->
    <TR>
    <TD class="labelmedium2">Description:&nbsp;</TD>
    <TD class="labelit">
  	  	<input type="Text" name="Description" id="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl">
				
    </TD>
	</TR>
	
	<tr><td></td></tr>
	
	</cfoutput>
	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="6">
	
	<tr><td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
	<input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
	<input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td></tr>
			
</TABLE>

</CFFORM>
	

