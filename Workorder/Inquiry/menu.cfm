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

<cf_submenuLogo module="Workorder" selection="Inquiry">

<cf_tl id="General" var="lblGeneral">
<cfset heading         = "#lblGeneral#">
<cfset module          = "'WorkOrder'">
<cfset selection       = "'Inquiry'">
<cfset verifytable     = "">
<cfset menutemplate    = "">
<cfset class           = "'Mission'">

<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Standard Views" var="lblViews">
<cfset heading         = "#lblViews#">
<cfset selection       = "'Inquiry'">
<cfset class           = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Custom Views" var="lblExtended">
<cfset heading        = "#lblExtended#">
<cfset selection      = "">
<cfset class          = "'Builder'">

<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Extended Inquiry" var="lblViews">
<cfset heading        = "#lblViews#">
<cfset selection      = "'Dataset'">
<cfset class          = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Extended Search (Collection)" var="lblExtended">
<cfset heading       = "#lblExtended#">
<cfset selection     = "'Search','Listing'">
<cfset class         = "'Collection'">

<cfinclude template="../../Tools/Submenu.cfm">
