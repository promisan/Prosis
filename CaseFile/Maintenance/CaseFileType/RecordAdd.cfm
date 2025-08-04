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


<cfoutput>
	<cf_tl id="Add Claim Type" var = "1">
	<cf_screentop height="100%" scroll="Yes" layout="webapp" title="#lt_text#" label="#lt_text#" jquery="yes">
</cfoutput>


 
<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<!--- Entry form --->
<cfoutput>
<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

	<tr><td height="6"></td></tr>

    <TR>
    <TD class="labelit"><cf_tl id="Code">:</TD>
    <TD class="labelit">
		<cf_tl id="Please enter a code" var="1" class="Message">
		<cfinput type="Text" name="Code" value="" message="#lt_text#" required="Yes" size="20" maxlength="20"
		class="regularxl">
	</TD>
	</TR>
	
	<tr><td height="3"></td></tr>
		
    <TR>
    <TD class="labelit"><cf_tl id="Description">:</TD>
    <TD class="labelit">
		<cf_tl id="Please enter a description" var="1" class="Message">
		<cfinput type="Text" name="Description" value="#lt_text#" message="" required="Yes" size="50" maxlength="50"
		class="regularxl">
	</TD>
	</TR>
	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="6">

	<tr>
		<td colspan="2" align="center">
		<cf_tl id="Cancel" var="1" class="Message">
		<input class="button10g" style="width:90" type="button" name="Cancel" value=" #lt_text# " onClick="window.close()">
		<cf_tl id="Submit" var="1" class="Message">
		<input class="button10g" style="width:90" type="submit" name="Insert" value=" #lt_text# ">
		</td>
	</tr>
    
</TABLE>
</cfoutput>

</CFFORM>

