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

<script language="JavaScript">

		function text(id) {
		
		   se = document.getElementById("va")			
		   url = "../../../vactrack/Application/Announcement/Announcement.cfm?id="+id+"&header=0"
		  	
			AjaxRequest.get({
			'url':url,
			   'onSuccess':function(req) {
					
					se.innerHTML = req.responseText;
					
				},
			   'onError':function(req) { 
					se.innerHTML = req.responseText;
				}	
			}
			);			
		}
		
		
</script>		


<tr><td colspan="4">
            
	  <table width="100%" cellspacing="0" cellpadding="0">
	   <tr><td height="1" bgcolor="silver"></td></tr>
	   <tr><td>
	   <table width="100%">
		    <tr><td align="center" width="30" height="25">
		    <cfoutput>
			<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
				id="textExp" border="0" class="regular" 
				align="middle" style="cursor: pointer;" 
				onClick="more('text','show')">
					
				<img src="#SESSION.root#/Images/arrowdown.gif" 
				id="textMin" alt="" border="0" 
				align="middle" class="hide" style="cursor: pointer;" 
				onClick="more('text','hide')">
					
			</cfoutput>	&nbsp;
			</td>
			<td><a href="javascript: more('text','show')">Announcement text</a></b></td>
			</tr>
	  </table>
	  </td></tr>
	 
	  <tr><td class="hide" id="text">
	  <table width="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	  <tr><td id="va">
	    <cfset URL.ID = "#URL.IDFunction#">
		<cfset URL.Header = "No">
	  	<cfinclude template="../../../Vactrack/Application/Announcement/Announcement.cfm">
	  </td></tr>
	  </table>
	  </td></tr>
	  </table>
</td></tr>	  