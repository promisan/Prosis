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

<cfset ToggleValue = Evaluate("#Toggle#")>

<td width="50" id="#Toggle#Red" Class=<cfif ToggleValue neq "0">"hide"<cfelse>"regular"</cfif>>
		 <img src="#SESSION.root#/Images/light_red3.gif"
	     alt="Activate"
	     width="24"
	     height="15"
	     border="0"
	     style="cursor: pointer;"
	     onClick="toggleParam('#Toggle#','#ToggleValue#','#URL.EntityCode#','#URL.EntityClass#','#URL.ActionCode#','#URL.PublishNo#','No')">
</td> 
<td width="50" id="#Toggle#Green" Class=<cfif ToggleValue neq "0">"regular"<cfelse>"hide"</cfif>>
		 <img src="#SESSION.root#/Images/light_green2.gif"
	     alt="Disabled"
	     width="24"
	     height="15"
	     border="0"
	     style="cursor: pointer;"
	     onClick="toggleParam('#Toggle#','#ToggleValue#','#URL.EntityCode#','#URL.EntityClass#','#URL.ActionCode#','#URL.PublishNo#','No')"> 
</td>
</cfoutput>
