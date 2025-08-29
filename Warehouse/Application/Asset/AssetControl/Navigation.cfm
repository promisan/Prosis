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

<table width="100%" cellspacing="0" cellpadding="0">
<tr>
	<td class="labelit" style="padding-left:4px">
	<cf_tl id="Record"> <b>#First#</b> <cf_tl id="to"> <b><cfif #Last# gt #Counted#>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records">
	</td>
	<td align="right">
	 <cfif URL.Page gt "1">
	     <button name="Prior" id="Prior" class="button3" onClick="listreload('#URL.ID#','#URL.ID1#','#URL.ID2#','#URL.Page-1#',sort.value,view.value,'0')">
		 <img src="#SESSION.root#/images/pageprior.gif" border="0">		 
		 </button>
		</cfif> 
		 <cfif URL.Page lt "#Pages#">
	    <button name="Prior" id="Prior" class="button3" onClick="listreload('#URL.ID#','#URL.ID1#','#URL.ID2#','#URL.Page+1#',sort.value,view.value,'0')">
		 <img src="#SESSION.root#/images/pagenext.gif" border="0">		 
		 </button>
		 </cfif>
	</td>	
</tr>										
</table>	

</cfoutput>						