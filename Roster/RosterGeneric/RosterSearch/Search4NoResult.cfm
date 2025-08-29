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

<cf_screentop html="No">
		
<table width="100%" align="center" class="formpadding">

	<tr><td style="Padding-top:50px"></td></tr>
	<tr><td align="center" class="labellarge" style="font-size:30px">#session.welcome# Roster search</td></tr>
	<tr><td></td></tr>
	<tr><td align="center" class="labellarge"><font color="FF0000">We are sorry but your search criteria did not match any candidates</td></tr>
	<tr><td></td></tr>
	<tr><td></td></tr>
	<tr><td></td></tr>
	<tr><td align="center" class="labellarge"><font color="0080C0">
	  <a href="javascript:ptoken.location('#SESSION.root#/Roster/RosterGeneric/RosterSearch/Search4.cfm?mode=#url.mode#&docno=#url.docno#&id=#URL.ID#')">
	  <u><b>Press here</b></u> to adjust your criteria
	  </a></td></tr>
</table>

</cfoutput>