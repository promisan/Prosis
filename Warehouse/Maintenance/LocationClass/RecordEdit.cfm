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
			  title="" 
			  label="Edit Location" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">  
  
<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_LocationClass
	WHERE Code = '#URL.ID1#'
</cfquery>

<cfoutput>
<cf_tl id="Do you want to remove this location class ?" var="vRemove"> 

<script language="JavaScript">

	function ask()
	
	{
		if (confirm("#vRemove#")) {
		
		return true 
		
		}
		
		return false
		
	}	

</script>

</cfoutput>

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" enablecab="Yes" name="dialog">


<!--- edit form --->

<table width="92%" cellspacing="0" align="center" class="formpadding">

    <cfoutput>
	<tr><td height="5"></td></tr> 
    <TR>
    <TD class="labelit"><cf_tl id="Code">:</TD>
    <TD>
  	   <input type="text" name="Code" id="Code" value="#get.Code#" size="20" maxlength="20"class="regularxl">
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#" size="20" maxlength="20"class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit"><cf_tl id="Description">:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" requerided=  "yes" size="30" 
	   maxlenght = "30" class= "regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit"><cf_tl id="Icon">:</TD>
    <TD class="labelit">
  	   <cfinput type="text" name="ListingIcon" value="#get.ListingIcon#" tooltip="Please enter the name of a graphic icon" required="No" size="20" maxlength="20" class="regularxl">
    </TD>
	</TR>
		
	</cfoutput>
		
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="6">
	
	<tr><td align="center" colspan="2" height="40">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td>	
	
	</tr>
	
</TABLE>
	
</CFFORM>

