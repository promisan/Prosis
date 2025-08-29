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
			  label="Add" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="93%" align="center" class="formpadding formspacing">

	<tr><td></td></tr>
    <TR class="labelmedium2">
    <TD><cf_tl id="Code">:</TD>
    <TD>
  	   <cfinput type="Text" name="DocumentType" value="" message="Please enter a code" required="Yes" size="10" maxlength="10"class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Description">:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="23" maxlength="40"class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <td><cf_tl id="Enable removal">:</td>
    <TD>  
	  <input type="radio" name="EnableRemove" checked value="0">No
	  <input type="radio" name="EnableRemove" value="1">Yes 
    </td>
    </tr>
	
	<TR class="labelmedium2">
    <td><cf_tl id="Enable edit">:</td>
    <TD>  
	  <input type="radio" name="EnableEdit" checked value="0">No
	  <input type="radio" name="EnableEdit" value="1">Yes 
    </td>
    </tr>
	
	<TR class="labelmedium2">
    <td><cf_tl id="Enable Validation">:</td>
    <TD>  
	  <input type="radio" name="VerifyDocumentNo" checked value="0"><cf_tl id="Optional">
	  <input type="radio" name="VerifyDocumentNo" value="1"><cf_tl id="Obligatory"> 
	  <input type="radio" name="VerifyDocumentNo" value="2"><cf_tl id="Validate"> 
    </td>
    </tr>
	
</table>

<cf_dialogBottom option="add">

</CFFORM>
