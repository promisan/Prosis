   
  <cfparam name="fieldselectmultiple" default="0">
  
  <table class="formpadding">
     	   
	   <tr>
	   <td width="97" class="labelit">Multiple Select:</td>
  	   <td><input type="radio" class="radiol" name="FieldSelectMultiple" id="FieldSelectMultiple" value="0" <cfif FieldSelectMultiple neq "1">checked</cfif>></td><td style="padding-left:4px;padding-right:10px" class="labelit">No</td>
	   <td><input type="radio" class="radiol" name="FieldSelectMultiple" id="FieldSelectMultiple" value="1" <cfif FieldSelectMultiple eq "1">checked</cfif>></td><td style="padding-left:4px" class="labelit">Yes</td>
	   
	   </tr>
	   
  </table>
   