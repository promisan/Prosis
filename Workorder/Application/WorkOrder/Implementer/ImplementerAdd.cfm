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
<cf_tl id="Edit Implementers" var="1">

<!---
<cf_screentop height="100%" 
              scroll="Yes" 
			  user="No"
			  html="no"
			  layout="webapp" 
			  label="#lt_text#" 
			  banner="gray"
			  jQuery="yes">
--->			  
	
<table width="95%" align="center">
	<tr><td height="10"></td></tr>
	<tr>
		<td colspan="2">
			<cf_securediv id="divImplementerList" bind="url:#session.root#/WorkOrder/Application/WorkOrder/Implementer/ImplementerList.cfm?workOrderId=#url.workOrderId#&mission=#url.mission#&mandateno=#url.mandateno#">
		</td>
	</tr>
</table>