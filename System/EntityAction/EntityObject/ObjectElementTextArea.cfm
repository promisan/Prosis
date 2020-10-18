  <cfparam name="DocumentLayout" default="">
  
  <table class="formpadding">
     	   
	   <tr>
	   <td width="97" class="labelit">Layout:</td>
	  	   
  	   <td><input type="radio" class="radiol" name="fieldlayout" id="fieldlayout" value="HTM" <cfif DocumentLayout eq "HTM">checked</cfif>></td><td style="padding-left:4px;padding-right:10px" class="labelit">Rich text (HTML)</td>
	   <td><input type="radio" class="radiol" name="fieldlayout" id="fieldlayout" value="TXT" <cfif DocumentLayout neq "TXT">checked</cfif>></td><td style="padding-left:4px" class="labelit">Text</td>
	   
	   </tr>
	   
  </table>