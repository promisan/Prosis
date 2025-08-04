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

<table width="100%" height="20">
<tr>
	<td class="labelmedium" style="padding-left:4px">
	 <cf_tl id="Record"> <b>#First#</b> <cf_tl id="to"> <b><cfif #Last# gt #Counted#>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="transactions">
	</td>
	<td align="right" style="padding-right:5px">
	 <cfif URL.Page gt "1">
	     <input type="button" name="Prior" value="<<" class="button3" onClick="javascript:reloadForm('#URL.Id2#','#URL.id#','#URL.Page-1#')">
	   </cfif>
	  <cfif URL.Page lt Pages>
	       <input type="button" name="Next" value=">>" class="button3" onClick="javascript:reloadForm('#URL.id2#','#URL.id#','#URL.Page+1#')">
	   </cfif>
	   
	</td>	
</tr>						
</table>	
</cfoutput>						