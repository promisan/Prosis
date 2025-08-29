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
<cf_submenutop>

<cf_submenuLogo module="Roster" selection="Maintenance">

<cfset heading = "Configuration and Titles">
<cfset module = "'Roster'">
<cfset selection = "'System'">
<cfset class = "'Main'">
<cfinclude template="../../Tools/Submenu.cfm">

<cfset selection = "'Maintain'">
<cfset heading = "Bucket Reference tables">
<cfset class = "'Bucket'">
<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Personal History Profile Settings">
<cfset class = "'PHP'">
<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Roster Processing">
<cfset class = "'Roster'">
<cfinclude template="../../Tools/Submenu.cfm">

</BODY></HTML>