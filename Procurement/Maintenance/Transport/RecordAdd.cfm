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
	<TITLE>Reference Add Form</TITLE>
</HEAD><body bgcolor="#FFFFFF" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_PreventCache>
 

<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<cf_dialogTop text="Add">

<!--- Entry form --->

<table width="100%">

	<!--- Field: Code--->
	 <TR>
	 <TD class="regular" width="60%">Code:&nbsp;</TD>  
	 <TD class="regular">
		<cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="20" maxlength="20"
		class="regular">

	 </TD>
	 </TR>
	
	<tr><td height="4"></td></tr>
	
	<!--- Field: Description --->
    <TR>
    <TD class="regular">Description:&nbsp;</TD>
    <TD class="regular">
		<cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="50" maxlength="50"
		class="regular">
				
    </TD>
    </TR>


	<tr><td height="4"></td></tr>
	<!--- Field: Tracking --->	
	<TR>
    <td class="regular">Tracking:&nbsp;</td>
	<td class="regular">
  	   <input type="checkbox" name="Tracking" id="Tracking" value="0">
    </TD>
	</TR>
  
</TABLE>

<HR>	

<table width ="100%">
	
	<td align="right">
	<input class="button7" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
	<input class="button7" type="submit" name="Insert" id="Insert" value=" Submit ">
	</td>
</table>

</CFFORM>

</BODY></HTML>