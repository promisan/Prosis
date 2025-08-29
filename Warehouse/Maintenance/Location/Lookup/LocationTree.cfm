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
<table width="100%" border="0" cellspacing="0" cellpadding="0">

  <tr><td>

	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
		  
	<tr><td>
	
	<cfform>
	    	  
		<tr><td align="center">
				<table width="96%" >
				<tr><td>
				
				<cf_UItree name="idorg" font="tahoma"  fontsize="11" bold="No" format="html" required="No">
				     <cf_UItreeitem
					  bind="cfc:service.Tree.LocationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#mission#','LocationListing.cfm')">
			    </cf_UItree>
						
				</td></tr>
				</table>
		</td></tr> 	
		
	</cfform>	
		
	</td></tr>
	
	</table>

</td></tr>

</table>
