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
<cfparam name="Attributes.Cancel" default="True">
<cfparam name="Attributes.CancelScript" default="">
<cfparam name="Attributes.OK" default="OK">
<cfparam name="Attributes.OKScript" default="">
<cfparam name="Attributes.Deny" default="Deny">

<table width="100%" cellspacing="0" cellpadding="0">

<tr><td height="20" style="padding-left:5px" colspan="2" class="labelmedium"><b>Decision</b></td></tr>

<tr><td height="1" class="linedotted"></td></tr>

<tr><td colspan="2">

   <table width="100%" cellspacing="0" cellpadding="0">   
   
   <tr><td height="3"></td></tr>   
   <tr>
      <td width="25%" class="labelit" style="padding-left:10px">Memo:</td>
	  <td>
	    <input type="text" name="Memo" id="Memo" style="width:90%" size="60" class="regularxl" maxlength="100"></td>
	  <td align="right">
	  <cfoutput>	 
	 
	  </td> 
   </tr>
 
   <tr>
      <td width="25%" rowspan="3" align="right" style="padding-left:5px">
	  <img src="#SESSION.root#/Images/DecisionOK.jpg" alt="" name="img99_des" width="40" height="38" border="0" align="middle">
	  </td>
      <td height="38">
		  
		  <table>
		  
		  <tr>
		  <td class="labelit" style="padding-left:5px">
		  <input type="radio" class="radiol" name="status" id="status" value="1" checked onClick="#attributes.okscript#;document.img99_des.src='#SESSION.root#/Images/DecisionOK.jpg'">
		  </td><td class="labelit" style="padding-left:5px">#Attributes.OK#</td>
		  </td>
		  <td class="labelit" style="padding-left:5px">
		  <input type="radio" class="radiol" name="status" id="status" value="5" onClick="#attributes.cancelscript#;document.img99_des.src='#SESSION.root#/Images/DecisionDENY.jpg'">
		  </td><td class="labelit" style="padding-left:5px">Expire</td>
		  <td class="labelit" style="padding-left:5px">
		  <input type="radio" class="radiol" name="status" id="status" value="9" onClick="#attributes.cancelscript#;document.img99_des.src='#SESSION.root#/Images/DecisionDENY.jpg'">
		  </td><td class="labelit" style="padding-left:5px">#Attributes.Deny#</td>
		 
		  </cfoutput>
		  
					
		    <cfif Attributes.Cancel eq "True">
	   		  <td style="padding-left:7px"><input type="button" name="Return" id="Return" value="Cancel" class="button10g" onClick="history.back()"></td>
		    </cfif>  
		      <td style="padding-left:7px"><input type="submit" name="Return" id="Return"  value="Submit" class="button10g"></td>
		  </tr>
		  
		  </table>
		  
 	  </td>
   </tr>  
   </table>
   </td>
</tr>
   

<tr><td height="1" class="linedotted"></td></tr>

</table> 

