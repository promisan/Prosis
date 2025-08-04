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

<cfoutput>

<table width="100%" height="99%">
	<tr><td height="100%" width="320">
	<iframe src="#session.root#/Payroll/Application/SalaryScale/SalaryScaleTree.cfm?mission=#url.mission#&contractid=#url.contractid#"
        width="100%"
        height="99%"
        scrolling="no"
        frameborder="0">
	</iframe>
	</td>
	
	<td height="100%" style="border-left: 1px solid gray;padding:10px">
	<iframe width="100%"
        height="99%"
		name="scaleright" id="scaleright"
        scrolling="no"
        frameborder="0"></iframe>
	</td>
	</tr>
</table>

</cfoutput>

<cf_screenbottom layout="webapp">

