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
<table width="100%" height="100%">
<tr><td style="height:100%;width:100%" valign="top">

	<iframe src="#session.root#/system/Organization/Application/Lookup/OrganizationView.cfm?mode=window&mission=#url.mission#&mandate=#url.mandate#&effective=#url.effective#" width="100%" height="99%" scrolling="no" frameborder="0"></iframe>

</td></tr>
</table>
</cfoutput>
