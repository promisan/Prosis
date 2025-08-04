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
<cfoutput>
  
  <form action="javascript:send_tts_go()" name="tts_window" style="padding-top:10px">
  
  <table class="formpadding" align="center" valign="top" width="100%" height="100%"  style="background: url('Notification/TTS/Phone.png') no-repeat;">
  	<tr height="19"><td></td><td colspan="1"></td></tr>
	<tr height="30">
		<td width="220"></td>
		<td>
		<cfoutput>
		<textarea style="width:91%;font-size:13px;padding:3px" class="regular" rows="12" name="tts_text" id="tts_text">#CLIENT.SMS#</textarea>
		</cfoutput>
		</td>
	</tr> 
	
	<tr><td height="10"></td></tr> 
	
	<tr>
	    <td colspan="2" align="center">
		<table><tr>		
		<td><input class="button10g" type="Submit" value="Send"></td>				
		<td style="padding-left:1px"><input class="button10g" type="button" value="Close" onClick="ColdFusion.Window.hide('bb_tts');"></td>
		</tr></table>
		</td>
	</tr>
	  
	</table> 
	
  </form>
  
</cfoutput>


