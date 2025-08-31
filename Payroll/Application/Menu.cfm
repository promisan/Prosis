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

<cf_SubMenulogo module="Payroll" selection="Application">

<cfset heading            = "Application">
<cfset selection          = "'Application'">

<!--- specific menu--->
<cfset verifysource       = "'AdminProgram','PayrollOfficer','PayrollClear','Accountant','HRPosition'">
<cfset verifytable        = "">
<cfset menutemplate       = "">
<cfset module             = "'Payroll'">
<cfset class              = "'Mission','Builder'">

<cfinclude template="../../Tools/SubmenuMission.cfm">

<cfset module             = "'Payroll'">
<cfset class              = "'Main'">
<cfset heading            = "Custom">

<cfinclude template="../../Tools/Submenu.cfm">
