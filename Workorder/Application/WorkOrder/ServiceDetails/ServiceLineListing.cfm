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

<!--- container for the service workorder lines to be shown --->

<!--- Removed by dev on 9/6/2013 due to flickering issues on IE 10 --->

<cfparam name="url.ref"       default="">
<cfparam name="url.domain"    default="">

<cf_screentop html="No">

<cfajaximport tags="cfdiv,cfwindow,cfform">

<table width="100%" height="100%" style="padding:6px">
    <tr>
	    <td class="labelmedium"></td>
	</tr>
	<tr>
		<td>
		<cfdiv bind="url:ServiceLineListingContent.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#url.workorderid#&ref=#url.ref#&domain=#url.domain#">
		</td>
	</tr>
</table>


