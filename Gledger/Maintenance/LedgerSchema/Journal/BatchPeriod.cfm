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

<cf_screentop height="100%" close="parent.ColdFusion.Window.destroy('mydialog',true)" scroll="Yes" label="Maintain Journal Batch" html="no" layout="webapp">

<cfajaximport tags="cfform">

<table width="95%" height="100%" align="center" class="formpadding">

<tr><td height="4"></td></tr>
<tr><td valign="top">

<cfdiv id="list">

<cfinclude template="BatchPeriodList.cfm">

</cfdiv>

<!---
<cfoutput>
<iframe src="BatchPeriodList.cfm?journal=#url.journal#" width="100%" height="100%" scrolling="no" frameborder="0">
</iframe>
</cfoutput>
--->

</td></tr></table>

<!---
<cf_screenbottom layout="innerbox">
--->