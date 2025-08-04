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


<!--- content --->

<cfparam name="url.mid" default="">

<cfoutput>
<table style="width:100%;height:100%" ><tr><td style="width:100%;height:100%" >
<iframe style="width:100%;height:100%" src="#session.root#//Staffing/Application/Position/Position/PositionEntry.cfm?ID=#url.id#&ID1=#url.id1#&ID2=#url.id2#&ID3=#url.id3#&ID4=#url.id4#&ID5=#url.id5#&ID6=#url.id6#&ID7=#url.id7#&ID8=#url.id8#&mid=#url.mid#" frameborder="0"></iframe>
</td></tr></table>
</cfoutput>
