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
<cf_screentop layout="webapp" jquery="Yes" html="No">

<table width="100%">
<tr>
	<TD style="font-size:25px;height:45px">Archive employee search result</b></font></TD>
	<TD style="padding-right:10px"><img src="../../../../Images/folder_check.gif" alt="" width="26" height="26" border="0" align="right"></TD>
</tr>

<tr><td>

<!--- Search form --->
<form action="ResultArchiveSubmit.cfm" method="post" name="positionsearch1">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
 
<tr><td colspan="2">
  
<table width="100%" class="formpadding" border="0" cellspacing="0" cellpadding="0" align="center">
		
    <tr class="labelmedium">
		<td height="30"></td>
		<td><cf_tl id="Description">:</b></TD>
		<td><cfoutput>
	    <input type="text" name="Description" size="40" maxlength="40" class="regularxl">
		<input type="hidden" name="SearchId" value="#URL.ID#" class="regular">
		</cfoutput>			
		</td>		
	</tr>	
	
    <tr class="line labelmedium">
		<td height="30"></td>
		<td><cf_tl id="Access">:</b></TD>
		<td>
			<input type="radio" class="radiol" name="Access" value="Personal" checked><cf_tl id="Personal">
			<input type="radio" class="radiol" name="Access" value="Personal" checked><cf_tl id="Shared">
		</td>		
	</tr>	
			
	<tr class="line" ><td colspan="1"></td>
	    <td colspan="2" style="padding:5px">	
		<cfinclude template="ResultCriteriaLines.cfm">		
		</td>
	</tr>
			
	<tr>
	<td colspan="3" align="center" style="padding-top:10px;" valign="middle" class="regular">
	<cfoutput>
		<cf_tl id="Reset" var="1">
		<input type="reset" name="Reset" value="#lt_text#" class="Button10g">
		<cf_tl id="Archive" var="1">
		<input type="submit" name="Submit" value="#lt_text#" class="Button10g">
	</cfoutput>    
	</td></tr>
	
	<tr><td height="5" colspan="3"></td></tr>
	
	</TABLE>
	
    </td></tr>

</table>	

</FORM>

</td></tr>
</table>
