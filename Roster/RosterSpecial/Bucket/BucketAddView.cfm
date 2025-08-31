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
<cfparam name="url.edition" default="">

<cfoutput>
	<table width="100%" height="100%">
		<tr>
		<td valign="top" height="100%">
		<iframe src="#session.root#/Roster/RosterSpecial/Bucket/BucketAdd.cfm?functionno=#url.functionno#&owner=#url.owner#&edition=#url.edition#" width="100%" height="99%" frameborder="0"></iframe>
		</td>
		</tr>
</table>
</cfoutput>