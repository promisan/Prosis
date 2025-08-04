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

<!--- asset entry container --->

<cf_screentop html="no" title="Select Item">

<cfparam name="url.mode" default="manual">
<cfparam name="url.mid" default="">

<table width="100%" height="100%">
	<tr>
		<td height="100%">
		<cfoutput>
			<iframe src="../Item/ItemSearchMaster.cfm?mission=#url.mission#&mode=#url.mode#&mid=#url.mid#" name="result" id="result" width="100%" height="100%" frameborder="0" marginheight="0px" marginwidth="0px" hspace="0px" vspace="0px" ></iframe>
		</cfoutput>
		</td>
	</tr>
</table>