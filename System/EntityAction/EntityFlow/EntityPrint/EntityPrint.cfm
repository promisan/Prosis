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
<!---
<cf_screentop height="100%" 
  user="No" html="Yes" label="Configuration Documenter" layout="webapp">
  --->

<cfoutput>
<!--- edit form --->

<table width="96%" align="center">

    <tr><td height="10"></td></tr>
	<tr><td width="80" valign="top">
	<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	<tr><td height="4"></td></tr></tr>
	<tr>
	<td align="center">
	<img src="#SESSION.root#/Images/pdf5.gif" alt="" border="0">	
	</td></tr>
	</table>
	</td>
	<td width="80%" align="right" height="200" style="border: 0px solid Silver;" valign="top">
	<table width="94%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	<tr><td></td></tr>
	<tr><td class="labellarge">Options</td></tr>
	<tr><td></td></tr>
	
	<tr class="labelmedium">
	<TD style="padding-left:10px" height="30">
	    <table><tr>
		<td><INPUT type="checkbox" class="radiol" name="ptworkflow" id="ptworkflow" checked></td>
		<td class="labelmedium" style="padding-left:5px">Workflow Diagram</td>
		</tr></table>
	</td>
	</tr>
	<tr  class="labelmedium"><td height="30" style="padding-left:10px">
	    <table><tr>
		<td>
	    <INPUT type="checkbox"  class="radiol" name="ptdocuments" id="ptdocuments" checked></td>
		<td class="labelmedium" style="padding-left:5px">Step Documents</td>
		</tr></table>
	</TD>
	</TR>
	<tr class="labelmedium">
		<td height="30" style="padding-left:10px">
		 <table><tr>
		 <td>
	    <INPUT type="checkbox"  class="radiol" name="ptconfig" id="ptconfig" checked></td>
		<td class="labelmedium" style="padding-left:5px">Step Configuration and Methods</td>
		</tr></table>
	</TD>
	</TR>
	
	</table>
	</td>
	</tr>
	
	<tr><td height="45"></td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>
		
	<tr><td height="5"></td></tr>

	<tr>	
	<td align="center" colspan="2" height="30">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="ProsisUI.closeWindow('mydialog');">
    <input class="button10g" type="button" name="Print" id="Print" value=" OK " onClick="printWFDetails()">
	</td>	
	</tr>
	
</TABLE>

</cfoutput>

<cf_screenbottom layout="webapp">
	