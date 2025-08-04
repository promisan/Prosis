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

<cfparam name="url.mode" default="customer">
<cfoutput>
<table width="100%" height="100%" bgcolor="FFFFFF">
<tr><td height="100%" style="overflow:hidden">
<iframe src="#session.root#/warehouse/Application/SalesOrder/POS/Sale/addCustomerForm.cfm?mode=#url.mode#&mission=#url.mission#&warehouse=#url.warehouse#&reference=#url.reference#" width="100%" height="100%" scrolling="no" frameborder="0">
</iframe>
</td></tr>
</table>
</cfoutput>