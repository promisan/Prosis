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

<!--- set account type --->

<table><tr><td class="labellarge" style="font-size:30px">

<cfparam name="url.type" default="">
<cfparam name="url.class" default="">

<cfif url.type eq "debit">

<cfif url.class eq "balance">
	Asset account
<cfelse>
	Cost account
</cfif>

<cfelse>
	
<cfif url.class eq "balance">
	Liability account
<cfelse>
	Income account
</cfif>

</cfif>

</td></tr>
<tr><td height="5"></td></tr>
</table>