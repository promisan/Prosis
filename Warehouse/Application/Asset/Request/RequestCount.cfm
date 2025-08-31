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
<cfset i = 0>

<cfparam name="form.assetId" default="">

<cfif Form.AssetId neq "">

<cfloop index="itm" list="#Form.AssetId#" delimiters=",">
	<cfset i = i+1>
</cfloop>

</cfif>

<cfoutput><font size="4" color="008000"><b>#i#</b></cfoutput>

