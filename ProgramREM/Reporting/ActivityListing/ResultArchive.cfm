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
    <TITLE>Employee Inquiry</TITLE>
    <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
</HEAD><body onLoad="window.focus()">

<b><font face="BondGothicLightFH">

<table width="100%">
<TD><font size="4"><b>Archive program search result</b></font></TD>
<TD><img src="../../../warehouse.JPG" alt="" width="40" height="40" border="1" align="right"></TD>
</table>

<hr>

<!--- Search form --->
<form action="ResultArchiveSubmit.cfm" method="post" name="positionsearch1">

<table width=75% border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#002350">

 <tr bgcolor="#002350">
    <td height="30" class="Label">
	  <b>&nbsp;Roster search:</b>
	</td>
	<td align="right">
	<input class="button1" type="reset"  value=" Reset  ">
	<input type="submit" name="Submit" value="  Archive  " class="button1">
    &nbsp;
	</td>
 </tr> 	
 
  <tr bgcolor="#002350">
    <td height="10" colspan="2" class="Top"></td>
	 
 </tr> 	
  
  <tr><td colspan="2">
  
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">

    <Td>&nbsp;</TD>
		
    <TR><td height="30"></td>
	<TD align="left" class="regular"><b>Description:</b>
    </TD>
	<TD><cfoutput>
	    <input type="text" name="Description" size="40" maxlength="40" class="regular">
		<input type="hidden" name="SearchId" value="#URL.ID#" class="regular">
		</cfoutput>
	 	
				
	</TD>
		
	</TR>	
	
    <TR><td height="30"></td>
	<TD align="left" class="regular"><b>Access:</b>
    </TD>
	<TD class="regular">
	
	<input type="radio" name="Access" value="Personal" checked>Personal
	<input type="radio" name="Access" value="Personal" checked>Shared
	 	
				
	</TD>
		
	</TR>	
	
	 
 	
	</TD></TR>
	
	<TR><TD>&nbsp;</TD></TR>
	
	<tr><td colspan="1"></td><td colspan="3">
	
	<cfinclude template="ResultCriteriaLines.cfm">
		
	</td></tr>
	
	<tr><td>&nbsp;</td></tr>
	
	</TABLE>
	
    </td></tr>

</table>	

<p>

<HR>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr>
<td align="left" valign="middle" class="regular">
<input type="reset" name="Reset" value="    Reset    " class="Button3">
<input type="submit" name="Submit" value="   Archive  " class="Button3">

</td></tr>
</table>

</FORM>

</BODY></HTML>