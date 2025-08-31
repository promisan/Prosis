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
	
	<tr class="line">
		<td class="labelmedium" height="20" style="padding-left:4px">
		 <cf_tl id="Record"> <b>#First#</b> <cf_tl id="to2"> <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records"> 
		</td>
		<td align="right" style="padding-right:4px">
	
		 <cfif URL.Page gt "1">	 
		       <input type="button" name="Prior" id="Prior" value="<<" class="button3" onClick="ptoken.navigate('#SESSION.root#/tools/selectlookup/Item/ItemResult.cfm?stock=#url.stock#&page=#url.page-1#&close=#url.close#&box=#box#&link=#url.link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','result#url.box#','','','POST','select_#url.box#')">
		   </cfif>
		  <cfif URL.Page lt "#Pages#">
		       <input type="button" name="Next" id="Next" value=">>" class="button3" onClick="ptoken.navigate('#SESSION.root#/tools/selectlookup/Item/ItemResult.cfm?stock=#url.stock#&page=#url.page+1#&close=#url.close#&box=#box#&link=#url.link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','result#url.box#','','','POST','select_#url.box#')">
		   </cfif>		  
		</td>	
	</tr>		
								
</table>	

</cfoutput>						