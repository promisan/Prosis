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

<cfparam name="url.id" default="">
<cfparam name="url.id1" default="">
<cfparam name="url.id2" default="">
<cfparam name="url.id3" default="">
<cfparam name="url.id4" default="">
	
	<table style="width:100%;height:99%">
	
	<tr>
	<td style="width:100%;height:100%" valign="top">
	
		<iframe src="#session.root#/System/Access/Lookup/UserSearchSelect.cfm?Form=#URL.Form#&ID=#URL.Id#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&ID4=#URL.ID4#" name="result" id="result" scrolling="yes" frameborder="0" style="width:100%;height:100%"></iframe>
	
	</td>
	</tr>
	
	</table>
	
</cfoutput>


