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
<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes" TreeTemplate="Yes">

<table width="100%" border="0" style="height:100%;padding-left:3px;padding-right:3px" align="center">		
	<tr><td style="height:100%;padding-left:10px;padding-top:10px" valign="top">
			
	<cf_UItree name="idtree" format="html">
		<cf_UItreeitem bind="cfc:service.Tree.VacTrackTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#url.systemfunctionid#')">
	</cf_UItree>
	
	</td>
	</tr>			
	
</table>

