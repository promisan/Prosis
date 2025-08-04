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
<cf_screentop 
	 height="100%"
     scroll="no" 
	 html="Yes" 
	 bannerheight="55"
	 label="Selfservice Portal #ucase(url.name)# Export" 	 
	 layout="webAPP"
	 jquery="yes" 
	 banner="gray">

<script language="JavaScript">
	
	function sendToClipboard() {
		var s = document.getElementById('exportPortal').innerHTML;
		var vText = s.replace(/<newPortalScriptLine>/gi,"\n");
		vText = vText.replace(/<\/newPortalScriptLine>/gi,"\n");
		vText = vText.replace(/&amp;/gi,"&");
		vText = $.trim(vText);
		if( window.clipboardData && clipboardData.setData )	{
			clipboardData.setData("Text", vText);
			alert("Script for exporting portal '<cfoutput>#ucase(url.name)#</cfoutput>' has been moved into your clipboard.");
		} else {
			alert("This function is only IE compatible");
		}
	}
	
</script> 	
	

<cfoutput>
<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr>
	<td height="20">
		<table width="100%">
			<tr>
				<td colspan="3" style="height:30px;padding-left:10px" class="labelmedium">&nbsp;Copy and paste the below script into a query analyzer to transfer the portal definitions to another DB server.</td>
			</tr>
			<tr><td colspan="3" class="linedotted"></td></tr>
			<tr>
				<td></td>
				<td style="height:30px;padding-left:10px" width="15%" class="labelit">&nbsp;Name:</td>
				<td class="labelmedium"><b>#ucase(url.name)#</b></td>
			</tr>
		</table>
	</td>
	</tr>

	<tr><td height="1" class="linedotted"></td></tr>
	<tr>
		<td height="10" style="padding:10px" class="labellarge">
			<span title="Get script into clipboard" style="cursor:pointer; color:##3F99FC;" onclick="sendToClipboard()">
				<u>Copy Script to Clipboard</u>
			</span>
		</td>
	</tr>
	
	<tr>
	<td>
		<table width="100%">
		<tr>
		<td align="center">
	   	<div align="left" ID='textespan' style="position:relative;width:795;height:650; overflow: auto; scrollbar-face-color: F4f4f4;">
			<cfset url.format = "html">
			<cfinclude template="doPortalExport.cfm">
		</div>
		<div ID='exportPortal' style="display:none;">
			<cfset url.format = "text">
			<cfinclude template="doPortalExport.cfm">
		</div>	
		</td>
		</tr>
		</table>
	</td>
	
	</tr>

</table>
</cfoutput>