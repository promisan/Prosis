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
			  label="Designation" 
			  option="Add" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- Entry form --->

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formspacing formpadding">

	<tr><td colspan="2" align="center" height="10"></tr>

    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="5" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="No" size="40" maxlength="50" class="regularxl">
    </TD>
	</TR>

	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="ListingOrder" value="" message="Please enter a listing order" required="Yes" validate="integer" size="1" maxlength="10" class="regularxl" style="text-align:center;">
    </TD>
	</TR>
	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="6">
	
	<tr>
	<td align="center" colspan="2" height="40">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	</td>	
	</tr>
	
</TABLE>

</CFFORM>


