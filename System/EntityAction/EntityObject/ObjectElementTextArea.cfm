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
  <cfparam name="DocumentLayout" default="">
  
  <table class="formpadding">
     	   
	   <tr>
	   <td width="97" class="labelit">Layout:</td>
	  	   
  	   <td><input type="radio" class="radiol" name="fieldlayout" id="fieldlayout" value="HTM" <cfif DocumentLayout eq "HTM">checked</cfif>></td><td style="padding-left:4px;padding-right:10px" class="labelit">Rich text (HTML)</td>
	   <td><input type="radio" class="radiol" name="fieldlayout" id="fieldlayout" value="TXT" <cfif DocumentLayout neq "TXT">checked</cfif>></td><td style="padding-left:4px" class="labelit">Text</td>
	   
	   </tr>
	   
  </table>