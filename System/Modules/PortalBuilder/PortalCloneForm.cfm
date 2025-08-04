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
	 label="Selfservice Portal #ucase(url.name)# Clone" 	 
	 layout="webAPP" 
	 jquery="yes"
	 banner="gray">

<script language="JavaScript">
	
	function sendToClipboard() {
		var s = document.getElementById('clonePortal').innerHTML;
		var vText = s.replace(/<newPortalScriptLine>/gi,"\n");
		vText = vText.replace(/<\/newPortalScriptLine>/gi,"\n");
		vText = vText.replace(/&amp;/gi,"&");
		vText = $.trim(vText);
		if( window.clipboardData && clipboardData.setData )	{
			clipboardData.setData("Text", vText);
			alert("Script for cloning portal '<cfoutput>#ucase(url.name)#</cfoutput>' has been moved into your clipboard.");
		} else {
			alert("This function is only IE compatible");
		}
	}
	
</script> 

<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0">
	
	<tr>
	<td height="20">
		<table width="100%" cellspacing="0" cellpadding="0">
			<tr>				
				<td colspan="4" style="height:30px;padding-left:10px" class="labelmedium">Copy and paste the below script into a query analyzer to clone the portal definitions to another or the same DB server.</td>				
			</tr>
			
			<tr><td colspan="4" class="linedotted"></td></tr>
			
			<tr>	
						
				<td style="height:30px;padding-left:10px" width="15%" class="labelit">Name:</td>
				<td class="labelmedium">#url.name#</td>
			
				<td style="padding-left:10px" width="15%" class="labelit">New Name:</td>
				<td>
					<table cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<input type="text" id="newname" class="regularxl" value="_#url.name#" style="width:100px; height:25px;">
							</td>
							<td style="padding-left:5px;">
								<input class="button10s" style="height:25px;width:120;font-size:12px" type="Button" id="btnNewname" value="Generate" onclick="if($.trim($('##newname').val()) != ''){ ColdFusion.navigate('doPortalCloneContent.cfm?name=#url.name#&type=#url.type#&newname='+$.trim($('##newname').val()),'divContent'); }else{ alert('Please enter a valid new name.'); }">
							</td>
						</tr>
					</table>
				</td>
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
		<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
		<td align="center" style="padding:10px">
	   		<cfdiv id="divContent" bind="url:doPortalCloneContent.cfm?name=#url.name#&newname=_#url.name#&type=#url.type#">	
		</td>
		</tr>
		</table>
	</td>
	
	</tr>

</table>

</cfoutput>