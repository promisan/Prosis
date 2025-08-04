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

<table width="100%" height="100%">
<tr><td style="height:100%">

<cfparam name="url.mid" default="">
<cf_divscroll overflowy="hidden">
<cfoutput>
<iframe src="#SESSION.root#/Tools/Mail/Mail.cfm?ID1=#url.id1#&ID2=#url.id2#&Source=#url.source#&Sourceid=#URL.SourceID#&Mode=#url.mode#&GUI=#url.gui#&mid=#url.mid#" width="100%" height="100%" frameborder="0"></iframe>
</cfoutput>

</cf_divscroll>

</td></tr></table>