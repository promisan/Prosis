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
<table width="100%" height="100%">
	<tr><td style="height:100%;width:100%;overflow:hidden">
	
	<cfif url.mode eq "attachmentmultiple">
	<iframe src="#SESSION.root#/Tools/Document/FileFormDialogMultiple.cfm?host=#url.host#&mode=#url.mode#&box=#url.box#&dir=#url.dir#&ID=#url.id#&ID1=#url.id1#&reload=#url.reload#&documentserver=#url.documentserver#&pdfscript=#url.pdfscript#&memo=#url.memo#" width="100%" height="100%" frameborder="0"></iframe>
	<cfelse>
	<iframe src="#SESSION.root#/Tools/Document/FileFormDialogSingle.cfm?host=#url.host#&mode=#url.mode#&box=#url.box#&dir=#url.dir#&ID=#url.id#&ID1=#url.id1#&reload=#url.reload#&documentserver=#url.documentserver#&pdfscript=#url.pdfscript#&memo=#url.memo#" width="100%" height="100%" frameborder="0"></iframe>
	</cfif>
	</td></tr>
</table>
</cfoutput>