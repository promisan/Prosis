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

<cfparam name="Attributes.text" default="Please wait . . .">
<cfparam name="Attributes.mode"  default="Status">

<cfif Attributes.mode neq "Status">
	
	<cf_waitEnd>
	
	<cfoutput>
	<table width="70%" align="center" id="busy">
	  
	  <tr><td height="150"></td></tr>
	  
	  <tr><td height="7"></td></tr>
	   
	   <tr>
	    <td align="center" class="regular"><font color="737373">#Attributes.text#</b>
		 
		    <input type="hidden" name="progress" id="progress"> 
		
		 </font>
		 <img src="#SESSION.root#/Images/busy2.gif" alt="" border="0" align="middle">
	   </td>
	   
	  </tr> 
	  <tr><td height="2"></td></tr>
	  <tr><td height="1" bgcolor="silver"></td></tr>
	  <tr><td height="2" bgcolor="gray"></td></tr>
	</table>
	
	<cfflush>

</cfoutput>

</cfif>
	
<cfoutput>
	
<script language="JavaScript">
	
	{
	window.status = "#Attributes.text#";
	}
	
</script>
	
</cfoutput>
	
	



