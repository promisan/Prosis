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

<table width="90%" height="40" align="center">

<tr><td align="center"><font size="5" color="FF0000">An error has occurred.</font></td></td></tr>
<tr><td align="center"><font size="3">Please contact your administrator if this error persists</td></tr>
<tr><td align="center" bgcolor="f4f4f4"><font size="2">#error.diagnostics#</td></tr>

<!---
<tr><td align="left"><font size="2">#DateFormat(error.dateTime,"dd/mm/yyy")#</td></tr>
<tr><td width="5%">&nbsp;</td><td align="left"><font size="2">#error.remoteAddress#</td></tr>
<tr><td width="5%">&nbsp;</td><td align="left"><font size="2">#error.browser#</td></tr>
<tr><td width="5%">&nbsp;</td><td align="left"><font size="2">#error.template#</td></tr>
<tr><td width="5%">&nbsp;</td><td align="left"><font size="2">#error.querystring#</td></tr>
<tr><td width="5%">&nbsp;</td><td align="left"><font size="2">#error.diagnostics#</td></tr>
--->

</table>

</cfoutput> 