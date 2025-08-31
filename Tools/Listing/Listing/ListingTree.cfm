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

<cfset Criteria = "">

<cfset vContentTreeHeight = "100%">		

<!--- ------------------------------------------------ --->
<!--- provision to fix the height bug in IE10 and IE11 --->
<!--- ------------------------------------------------ 

<cfif client.browser eq "Explorer">
	<cfset vContentTreeHeight = url.height-250>		
</cfif>

 ----------------------------------------------- --->

<table style="height:100%; width:100%;">  
  <tr><td valign="top" style="padding-top:12px;padding-left:4px" style="height:100%; width:100%">
 
  		<cf_divscroll height="#vContentTreeHeight#" width="100%" overflowy="auto" overflowx="auto">
				<cf_UItree name="idtree"  font="Calibri" fontsize="13" format="html">
					<cf_UItreeitem bind="cfc:service.Tree.BuilderTree.getListingNodesV2({cftreeitempath},{cftreeitemvalue},'#url.systemfunctionid#','#url.FunctionSerialNo#','#url.box#')">
				</cf_UItree>
		</cf_divscroll>
  </td></tr>
</table>

</cfoutput>

