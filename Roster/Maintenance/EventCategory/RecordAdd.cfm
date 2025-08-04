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
			  title="Event class" 
			  scroll="no" 
			  layout="webapp" 
			  label="Add Event class" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">


<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="95%" align="center" class="formpadding spacing">

    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
  	   <cfinput class="regularxxl" type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10">
    </TD>
	</TR>

	
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD>
  	   <cfinput class="regularxxl" type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="30">
    </TD>
	</TR>
	
	<tr><td colspan="2" height="3"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" height="3"></td></tr>
	
	<tr>
	<td align="center" colspan="2">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	</td>	
	
	</tr>
	
</table>

</cfform>

