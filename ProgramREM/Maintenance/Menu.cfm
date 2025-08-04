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

<cf_submenuLogo module="Program" selection="Maintenance">

<cfset heading = "Application Parameters">
<cfset module = "'Program'">
<cfset selection = "'System'">
<cfset class = "'Main'">
<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Program and project classification">
<cfset module = "'Program'">
<cfset selection = "'Maintain'">
<cfset class = "'Main'">
<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Program Indicators (BSC)">
<cfset module = "'Program'">
<cfset selection = "'Maintain'">
<cfset class = "'Indicator'">
<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Project Settings">
<cfset module = "'Program'">
<cfset selection = "'Maintain'">
<cfset class = "'Project'">
<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Donor management">
<cfset module = "'Program'">
<cfset selection = "'Maintain'">
<cfset class = "'Donor'">
<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Allotment management">
<cfset module = "'Program'">
<cfset selection = "'Maintain'">
<cfset class = "'Allotment'">
<cfinclude template="../../Tools/Submenu.cfm">
