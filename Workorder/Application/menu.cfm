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
<cf_screentop height="100%" scroll="vertical" html="No" ValidateSession="No">

<cfset searchbar = false>

<cf_submenuLogo module="Workorder" selection="Application">

<cfset heading         = "Administration">
<cfset module          = "'WorkOrder'">
<cfset selection       = "'Application'">
<cfset class           = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset verifyarea      = "WorkOrder Management">
<cfset verifytable     = "">
<cfset menutemplate    = "">
<cfset class           = "'Mission','Builder'">

<cfinclude template="../../Tools/SubmenuMission.cfm">

