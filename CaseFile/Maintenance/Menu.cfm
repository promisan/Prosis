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

<cf_submenutop>

<cf_submenuLogo module="Insurance" selection="Maintenance">

<cfset heading = "System Configuration">
<cfset module = "'Insurance'">
<cfset selection = "'Maintain'">
<cfset class = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Incident Lookup reference">
<cfset selection = "'Incident'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Claimant Lookup reference">
<cfset selection = "'Person'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Financials Lookup reference">
<cfset selection = "'Financials'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Element Definition">
<cfset selection = "'Configuration'">

<cfinclude template="../../Tools/Submenu.cfm">


