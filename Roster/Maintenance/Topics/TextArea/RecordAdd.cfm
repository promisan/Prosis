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
<HTML><HEAD>
	<TITLE>Group registration</TITLE>
</HEAD><body bgcolor="#FFFFFF" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<cf_dialogTop text="Add">

<!--- Entry form --->

<table width="98%" align="center">

    <TR>
    <TD class="regular">Code:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10"class="regular">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD>Domain:</TD>
    <TD>
	   <select name="TextAreaDomain">
					<option value="Preliminary" SELECTED>Preliminary interview</option>
					<option value="Bucket">Roster bucket/Vacancy interview</option>
					<option value="JobProfile">Job profile</option>
		</select>
     </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40"class="regular">
    </TD>
	</TR>
		
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="regular">Order:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="ListingOrder" value="1" message="Please enter an integer value" validate="integer" required="Yes" visible="Yes" enabled="Yes" size="1" maxlength="2" class="regular">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="regular">Text area rows:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="NoRows" value="4" message="Please enter an integer value" validate="integer" required="Yes" visible="Yes" enabled="Yes" size="1" maxlength="2" class="regular">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD>Entry mode:</TD>
    <TD>
	  <input type="radio" name="EntryMode" value="Regular" checked>Standard
	  <input type="radio" name="EntryMode" value="Editor">Editor
     </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="regular">Explanation:</TD>
    <TD class="regular">
	   <textarea cols="50" rows="7" name="Explanation" class="regular"></textarea>
   </TD>
	</TR>
	
</table>

<hr>

<table width="100%">	
		
	<td align="right">
	<input class="button7" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button7" type="submit" name="Insert" value=" Submit ">
	
	</td>	
	
</TABLE>

</CFFORM>


</BODY></HTML>