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

<cf_submenuLogo module="Staffing" selection="Utilities">

<cfset presentation = "2">

<cf_tl id="Application Functions" var="lblGeneral">
<cfset heading   = "#lblGeneral#">
<cfset module = "'Staffing'">
<cfset selection = "'Application'">
<cfset class = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Custom Views" var="lblCustomViews">
<cfset heading   = "#lblCustomViews#">
<cfset selection = "">
<cfset class = "'Builder'">

<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Audit views" var="lblAuditViews">
<cfset heading = "#lblAuditViews#">
<cfset selection = "'Inquiry'">
<cfset class = "'Audit'">

<cfinclude template="../../Tools/Submenu.cfm">
