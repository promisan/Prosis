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
			  title="Units of Measure" 
			  label="Add" 
			  banner="gray"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">



 
<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">


<!--- Entry form --->

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

   <!--- Field: Id --->
    <TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelit">
		<cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="20" maxlength="20"
		class="regularxl">
	</TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	   <!--- Field: Description --->
    <TR>
    <TD class="labelit">Description:</TD>
    <TD class="labelit">
		<cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="50"
		class="regularxl">
	</TD>
	</TR>
	
	<!--- Field: FieldDefault --->
    <TR>
    <TD class="labelit">Default UoM:&nbsp;</TD>
    <TD class="labelit">
  	  	<input type="Checkbox" name="FieldDefault" id="FieldDefault">
    </TD>
	</TR>
	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="6">
	
	<tr>	
		<td align="center" colspan="2" height="30">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit ">
		</td>
	</tr>
	

    
</TABLE>

</CFFORM>

</BODY></HTML>