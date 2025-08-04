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
			  title="Casualty" 
			  label="Add Casualty" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">



 <CFFORM action="RecordSubmit.cfm" method="post" name="dialog">
<!--- Entry form --->
<cfoutput>
<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding formspacing">

   <!--- Field: Id --->
   
    <tr><td></td></tr>
	
    <TR class="labelmedium2">
    <TD><cf_tl id="Code">:</TD>
    <TD>
		<cf_tl id = "Please enter a code" var = "1" class="Message">
		<cfinput type="Text" name="Code" id="Code" value="" message="#lt_text#" required="Yes" size="20" maxlength="20"
		class="regularxxl">
	</TD>
	</TR>
	   <!--- Field: Description --->
    <TR class="labelmedium2">
    <TD><cf_tl id="Description">:</TD>
    <TD>
		<cf_tl id = "Please enter a description" var = "1" class="Message">
		<cfinput type="Text" name="Description" id="Description" value="" message="#lt_text#" required="Yes" size="50" maxlength="50"
		class="regularxxl">
	</TD>
	</TR>
	
	   <!--- Field: Remarks --->
    <TR class="labelmedium2">
    <TD><cf_tl id="Remarks">:</TD>
    <TD>
		<cf_tl id = "Please enter a Remarks" var = "1" class="Message">
		<cfinput type="Text" name="Remarks" id="Remarks" value="" message="#lt_text#" required="No" size="50" maxlength="50"
		class="regularxxl">
	</TD>
	</TR>		

	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		<td align="center" colspan="2">
		<cf_tl id="Cancel" var = "1">
		<input class="button10g" type="button" name="Cancel" value=" #lt_text# " onClick="window.close()">
		<cf_tl id="Submit" var = "1">		
		<input class="button10g" type="submit" name="Insert" value=" #lt_text# ">
		</td>	
	</tr>
	   
</TABLE>

</cfoutput>

</CFFORM>
