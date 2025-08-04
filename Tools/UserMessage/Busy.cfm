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
<cf_PreventCache>

<body style="cursor: progress;">

<cfparam name="Attributes.Message" default="Please wait, while I am preparing your report...">
<cfparam name="Attributes.total" default="">

<cfoutput>
<table width="90%" align="center" id="busy">
  <tr><td height="100"></td></tr>
 
   <tr><td height="7"></td></tr>
   
   <tr>
    <td align="center" class="regular"><b><font color="black">#Attributes.message#</b>
	 <cfif #attributes.total# eq "">
	    <input type="hidden" name="progress" id="progress"> 
	 <cfelse>
	    [<input type="text" name="progress" id="progress" value="0" size="2" maxlength="2" class="message" style="text-align: center;">] 
	    of #Attributes.total#
 	 </cfif>
	 <img src="#SESSION.root#/Images/busy2.gif" alt="" border="0" align="middle">
   </td>
  </tr> 
   <tr><td height="2"></td></tr>
  <tr><td height="2" bgcolor="5289C7"></td></tr>
</table>

</cfoutput>

</body>
