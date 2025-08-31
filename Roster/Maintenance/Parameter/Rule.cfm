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
<cfparam name="url.owner" default="">
<cfparam name="url.rule" default="">
<cfparam name="url.level" default="">
<cfparam name="url.from" default="">
<cfparam name="url.to" default="">

<cfoutput>
	<img src="#client.root#/images/link.gif" alt="Define a conditioning rule for this transition." 
		 style="cursor:pointer" onclick="selectRule('#url.owner#','#url.rule#','#url.level#','#url.from#','#url.to#')">
</cfoutput>