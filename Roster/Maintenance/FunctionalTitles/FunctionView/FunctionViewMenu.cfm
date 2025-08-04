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
<cf_screentop html="no"> 

<cfoutput>

<cf_submenuleftscript>

<script language="JavaScript">

function edition() {
    parent.right.location =  "FunctionRoster.cfm?ID=#URL.ID#"
}

</script>

</cfoutput>

<body>


<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left" class="menu">

<tr><td>

to be defined
<cfset heading = "Function">
<cfset module = "'Roster'">
<cfset selection = "'Function'">
<cfset menuclass = "'Main'">
<cfinclude template="../../../../Tools/SubmenuLeft.cfm">
</td></tr> 

</table>
