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
<table style="width:95%" align="center">
<tr class="labelmedium2">
<td style="font-size:20px">This customer is managed by</td>
</tr>
<tr class="labelmedium2">
<td style="font-size:20px" style="width:100%" id="processcustomer">
<cfinclude template="CustomerOutreachPosition.cfm">
</td>
</tr>

<tr>
<td>
Attention : this function is for the rest not enabled

Record planned exchanges, eMail, Whatsapp message and casual information about this customer
<br>
<br>
[structure : Workorder(line) under service = outreach and workorderline action to record activities]
</td></tr></table>


</cfoutput>