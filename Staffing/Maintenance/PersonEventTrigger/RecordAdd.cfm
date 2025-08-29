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
			  banner="gray"
			  label="Add Event Trigger" 
			  menuAccess="Yes" 
			  jQuery = "Yes"
			  line="no"
			  systemfunctionid="#url.idmenu#">
			  

<cf_colorScript>			  
			  
<!--- Entry form --->

<cfform action="RecordSubmit.cfm?id1=" method="POST" name="dialog">

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td height="5"></td></tr>

    <TR>
    <TD class="labelmedium">&nbsp;&nbsp;Code:</TD>
    <TD>
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="25" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;Order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" value="" message="Please enter a Listing Order" required="No" size="2" maxlength="2"class="regularxl">
    </TD>
	</TR>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<tr>		
	<td colspan="2" align="center" height="30">
    	<input class="button10g" type="submit" name="Insert" value=" Save ">	
	</td>		
	</tr>
	
</TABLE>

</CFFORM>
