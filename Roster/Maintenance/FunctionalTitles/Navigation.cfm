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
<cfoutput>

<table width="100%" height="20">
<tr>
	<td class="labelit" style="padding-left:4px">
	Record <b>#First#</b> to <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> of <b>#Counted#</b> titles
	</td>
	<td align="right" style="padding-right:4px">
	 <cfif URL.Page gt "1">
	     <input type="button" name="Prior" value="<<" class="button3" onClick="reloadForm('#URL.Page-1#','#url.view#','#url.mode#')">
	   </cfif>
	  <cfif URL.Page lt Pages>
	       <input type="button" name="Next" value=">>" class="button3" onClick="reloadForm('#URL.Page+1#','#url.view#','#url.mode#')">
	   </cfif>
	  
	</td>	
</tr>						
</table>	
</cfoutput>						