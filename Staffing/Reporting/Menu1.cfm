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

<cf_submenuLogo module="Staffing" selection="Application">

<cfset module = "'Staffing'">
<cfset heading = "Implementation">
<cfset selection = "'Application'">
<cfset class = "'Implementation'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset module = "'Staffing'">
<cfset heading = "National">
<cfset selection = "'Application'">
<cfset class = "'National'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset module = "'Staffing'">
<cfset heading = "International">
<cfset selection = "'Application'">
<cfset class = "'International'">

<cfinclude template="../../Tools/Submenu.cfm">