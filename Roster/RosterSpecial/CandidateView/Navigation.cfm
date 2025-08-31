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

<table width="100%">
	<tr class="line labelmedium2">
		<td style="height:25px;padding:2px;padding-left:4px">
		<cf_tl id="Record"> #First# to <cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif> of #Counted# records</b>
		</td>
		<td align="right" style="padding-right:5px">
		
		 <cfif URL.Page gt "1">
		      <input type="button" name="Prior" value="<<" class="button3" 
			 onClick="javascript:listing('#url.tab#','#url.box#','show','#url.mode#','#url.filter#','#url.level#','','#url.total#','#url.process#','#URL.page-1#',view.value)">
		 </cfif>
		 <cfif URL.Page lt "#Pages#">
		       <input type="button" name="Next" value=">>" class="button3" 
			   onClick="javascript:listing('#url.tab#','#url.box#','show','#url.mode#','#url.filter#','#url.level#','','#url.total#','#url.process#','#URL.page+1#',view.value)">
	      </cfif>
		 
		</td>	
	</tr>							
</table>	

</cfoutput>						