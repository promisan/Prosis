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
<table width="100%" height="100%" class="tree">

<tr><td valign="top">

	<table width="98%" class="formpadding">
	
	<cfoutput>
		<tr>
		<td height="18" style="padding-top:4px;padding-left:5px" class="labelit">
		<a id="refresh" href="javascript:ptoken.navigate('LocationTree.cfm?id2=#url.id2#','tree')"><cf_tl id="Refresh">
		</a>
		</td>
		</tr>
	</cfoutput>
		  
	<tr><td class="line"></td></tr> 
	
	<tr><td height="5"></td></tr>
	
	<cfform>
		   	  
		<tr><td align="center">
				<table width="96%" align="center">
				<tr><td>
				
				<cf_UItree name="idorg" fontsize="11" bold="No" format="html" required="No">
				     <cf_UItreeitem
					  bind="cfc:service.Tree.LocationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#url.id2#','LocationListing.cfm')">
			    </cf_UItree>
						
				</td></tr>
				</table>
		</td></tr> 	
	
	</cfform>
	
	<tr><td class="line" height="1"></td></tr> 
	
	</table>

	</td>
	</tr>

</table>

