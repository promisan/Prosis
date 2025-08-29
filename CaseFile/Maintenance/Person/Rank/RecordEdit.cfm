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

<cf_tl id = "Edit Rank" var = "1">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="#lt_text#" 
			  label="#lt_text#" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

 
<cfquery name="Get" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Rank
	WHERE  Code = '#URL.ID1#'
</cfquery>

<cfoutput>
<cf_tl id= "Do you want to remove this record ?" class="Message" var = "1">

<script language="JavaScript">

function ask() {
	if (confirm("#lt_text#")) {
	
	return true 
	
	}
	
	return false
	
}	
</script>
</cfoutput>

<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<!--- edit form --->

<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
<!--- Field: code --->
	 <cfoutput>
	 <TR>
	 <TD class="labelit"><cf_tl id = "Code">:&nbsp;</TD>  
	 <TD class="labelit">
	 	<input type="Text" name="Code" id="Code" value="#get.Code#" size="20" maxlength="20"class="regularxl">
		<input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#" size="20" maxlength="20"class="regular">
	 </TD>
	 </TR>
	 
	 <!--- Field: Description --->
    <TR>
    <TD class="labelit"><cf_tl id="Description">:&nbsp;</TD>
    <TD class="labelit">
		<cf_tl id= "Please enter a description" class="Message" var = "1">
  	  	<cfinput type="Text" name="Description" id="Description" value="#get.Description#" message="#lt_text#" required="Yes" size="50" maxlength="50" class="regularxl">
				
    </TD>
	</TR>

	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="6">

	<tr>	
		<td align="center" colspan="2" height="30">
		<cf_tl id="Cancel" var = "1">
		<input class="button10g" type="button" name="Cancel" value=" #lt_text# " onClick="window.close()">
		<cf_tl id="Delete" var = "1">
		<input class="button10g" type="submit" name="Delete" value=" #lt_text# " onclick="return ask()">
		<cf_tl id="Update" var = "1">
		<input class="button10g" type="submit" name="Update" value=" #lt_text# ">
		</td>
	</tr>
	

</cfoutput>
    	
</TABLE>

</CFFORM>
