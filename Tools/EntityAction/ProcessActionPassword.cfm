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

<form method="post" name="formpwdvalidate" id="formpwdvalidate">

<table width="100%" height="90%" bgcolor="FFFFFF">
	   
	<tr>
	
	<td width="15"></td>
	<td style="padding-top:15px" valign="top"><img height="50" width="50" src="#SESSION.root#/images/password.png" alt="" border="0"></td>		
			
	<td valign="top">
	
		<table>
		
			<tr>
				<td class="labelit">Re-enter Password please:</td>	
			</tr>
			
			<tr><td height="4"></td></tr>
			
			<tr><td>
				<input type="password" 
				    style="width:220;height:40;font-size:30px" 
					onKeydown="if (window.event.keyCode == '13') {return false}"
					onKeyup="if (window.event.keyCode == '13') {ptoken.navigate('ProcessActionPasswordValidate.cfm?wfmode=#url.wfmode#','passwordvalidate','','','POST','formpwdvalidate');return false}"
					name="ProcessPassword" 		
					id="ProcessPassword"							
					class="regularxl">
			</td></tr>
						
			<tr><td height="4"></td></tr>
			
			<tr><td id="passwordvalidate"></td></tr>
			
		</table>
	
	</td>
	
	</tr>
			
	<tr><td class="linedotted" colspan="3" height="1"></td></tr>
	
	<tr>
			<td height="34" colspan="3">
			
			<table align="center" class="formspacing">
			<tr><td>
			
			    <cf_tl id="Cancel" var="1">
			  
			    <input type = "button" 
			      name    = "cancel" 
				  id      = "cancel"
			      onclick = "ProsisUI.closeWindow('boxauth');document.getElementById('r0').click()" 
				  value   = "#lt_text#" 
				  class   = "button10g"
				  style   = "width:120">
				  
				</td>
				<td>  
				  
				<cf_tl id="Submit" var="1">	  
				  					  
				<input type = "button" 
				      name    = "saveaction"
					  id      = "saveaction" 
				      onclick = "ptoken.navigate('ProcessActionPasswordValidate.cfm?wfmode=#url.wfmode#','passwordvalidate','','','POST','formpwdvalidate')" 
					  value   = "#lt_text#" 
					  class   = "button10g"
					  style   = "width:120">
				  					
			</td></tr>
			
			</td>
	</tr>
		
</table>

</form>

</cfoutput>		

