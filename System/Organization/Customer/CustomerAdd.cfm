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
<cf_customerScript>

<cf_screentop height="100%" scroll="Yes" banner="green" line="no"
  layout="webapp" band="Yes" label="New Customer" option="Record a new customer">

<table width="95%" height="100%" align="center">
<tr><td id="savebox"></td></tr>
<tr><td valign="top">
	<cfinclude template="CustomerForm.cfm">
</td></tr>
</table>
