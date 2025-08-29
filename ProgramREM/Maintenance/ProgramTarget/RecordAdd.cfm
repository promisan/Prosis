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
<HTML><HEAD>
	<TITLE>Reference Add Form</TITLE>
</HEAD><body bgcolor="#FFFFFF" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">


<cf_PreventCache>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<cf_dialogTop text="Add">

<!--- Entry form --->

<table width="90%">

    <TR>
    <TD class="regular">Code:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="20" maxlength="20" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="regular">Description:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regular">
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