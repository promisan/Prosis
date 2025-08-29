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
			  label="Add" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td height="4"></td></tr>

    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="AssignmentType" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxxl">
    </TD>
	</TR>
	
</table>

<cf_dialogBottom option="add">

</CFFORM>

