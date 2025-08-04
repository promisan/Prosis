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

<HTML><HEAD>
	<TITLE>Reference Add Form</TITLE>
</HEAD><body bgcolor="#FFFFFF" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_PreventCache>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<table><tr><td height="1" bgcolor="EAEAEA"></td></tr></table>

<table width="90%">

    <TR>
    <TD class="regular">Code:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="Code" value="" message="Please enter a code" required="Yes" size="2" maxlength="2" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="regular">Description:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regular">
    </TD>
	</TR>
			
	<TR>
    <TD class="regular">Order:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="ListingOrder" value="0" message="Please enter a valid number" validate="integer" required="Yes" size="1" maxlength="1" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="regular">Perc.:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="LinePercentage" value="100" message="Please enter a valid number" validate="integer" required="Yes" size="1" maxlength="3" class="regular">
    </TD>
	</TR>
	
</table>

<table width="100%">
<tr><td height="7"></td></tr>
<tr><td height="1" bgcolor="silver"></td></tr>
<tr><td height="7"></td></tr>
</table>

<table width="100%">	
		
	<td align="right">
	<input class="button7" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button7" type="submit" name="Insert" value=" Submit ">
	
	</td>	
	
</TABLE>

</CFFORM>


</BODY></HTML>