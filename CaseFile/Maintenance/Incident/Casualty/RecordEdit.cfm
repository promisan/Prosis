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

<cf_tl id = "Edit Casualty" var="1">
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
FROM  Ref_Incident
WHERE Code = '#URL.ID1#'
and class='Casualty'
</cfquery>

<cfoutput>
<cf_tl id = "Do you want to remove this record ?" var = "1" class = "Message">

<script language="JavaScript">

function ask() {
	if (confirm("#lt_text#")) {	
	return true 	
	}	
	return false	
}	

</script>
</cfoutput>

<CFFORM action="RecordSubmit.cfm" method="post" name="dialog">

<table width="96%" align="center" class="formpadding formspacing">

	 <cfoutput>
	 <TR class="labelmedium2">
	 <TD><cf_tl id="Code">:&nbsp;</TD>  
	 <TD>
	 	<cfinput type="Text" name="Code" id="Code" value="#get.Code#" size="20" maxlength="20" class="regularxxl">
		<cfinput type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#" size="20" maxlength="20"class="regular">
	 </TD>
	 </TR>
	 
	 <!--- Field: Description --->
    <TR class="labelmedium2">
    <TD><cf_tl id="Description">:&nbsp;</TD>
    <TD>
		<cf_tl id = "Please enter a description" var = "1" Class="Message">
  	  	<cfinput type="Text" name="Description" id="Description" value="#get.Description#" message="#lt_text#" required="Yes" size="50" maxlength="50" 
		 class="regularxxl">
				
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Remarks">:&nbsp;</TD>
    <TD>
		<cf_tl id = "Please enter a Remark" var = "1" Class="Message">
  	  	<cfinput type="Text" name="Remarks" id="Remarks" value="#get.Remarks#" message="#lt_text#" required="no" size="50" maxlength="50" class="regularxxl">
				
    </TD>
	</TR>	

	<tr><td colspan="2" class="line"></td></tr>

	<tr>	
		<td align="center" colspan="2">
		<cf_tl id="Cancel" var ="1">
		<input class="button10g" type="button" name="Cancel" value=" #lt_text# " onClick="window.close()">
		<cf_tl id="Delete" var ="1">
		<input class="button10g" type="submit" name="Delete" value=" #lt_text# " onclick="return ask()">
		<cf_tl id="Update" var ="1">
		<input class="button10g" type="submit" name="Update" value=" #lt_text# ">
		</td>
	</tr>
	

</cfoutput>
    	
</TABLE>

</CFFORM>

</BODY></HTML>