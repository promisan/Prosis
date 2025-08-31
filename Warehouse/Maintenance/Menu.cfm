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

<cf_submenuLogo module="Warehouse" selection="Maintenance">

<cfset heading = "System">
<cfset module = "'Warehouse'">
<cfset selection = "'Maintain'">
<cfset Class = "'System'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Stock and Requests">
<cfset Class = "'Stock'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Sales">
<cfset Class = "'Sale'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Assets">
<cfset Class = "'Asset'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Reference Tables">
<cfset Class = "'Lookup'">

<cfinclude template="../../Tools/Submenu.cfm">

