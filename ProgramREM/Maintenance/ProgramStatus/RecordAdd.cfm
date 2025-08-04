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
			  label="Add Status" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="91%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

    <tr><td height="5"></td></tr>
	
    <TR>
    <TD class="labelmedium">Class:</TD>
    <TD class="labelmedium">
	   <select name="StatusClass" class="regularxl">
		   <option value="Status" selected>Status</option>
		   <option value="Urgency">Urgency</option>
		   <option value="Necessity">Necessity</option>
		   <option value="Importancy">Importancy</option>
	   </select>
     </TD>
	</TR>
	
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="40" class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
		
	<TR>	
	<td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	
	</td>		
	</TR>
</table>



</CFFORM>


