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
    <iframe 
        width="100%" 
        height="101%" 
        name="iCustomerView"
        scroll="yes"
        frameborder="0"
        src="#session.root#/warehouse/application/salesorder/picking/monitor/customerView.cfm?warehouse=#url.warehouse#&mission=#url.mission#">
</cfoutput>