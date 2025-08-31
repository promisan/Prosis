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

<cfset attributes.selection = "Inquiry">

<cfif attributes.selection eq "Inquiry">
	<cf_submenuLogo module="Program" selection="Inquiry">
<cfelseif attributes.selection eq "Reports">
	<cf_submenuLogo module="Program" selection="Reports">
</cfif>

<cf_tl id="Inquiry" var="lblInquiry">
<cfset heading   = "#lblInquiry#">
<cfset module = "'Program'">
<cfset selection = "'Graph','Listing'">
<cfset class = "'Main'">
<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Supporting Functions" var="lblSupporting">
<cfset heading   = "#lblSupporting#">
<cfset selection = "'Function'">
<cfinclude template="../../Tools/Submenu.cfm">


<cf_tl id="Summary" var="lblSummary">
<cfset heading   = "#lblSummary#">
<cfset selection = "'Inquiry'">
<cfinclude template="../../Tools/Submenu.cfm">


<cf_tl id="Standard Views" var="lblViews">
<cfset heading   = "#lblViews#">
<cfset selection = "">
<cfset class = "'Builder'">
<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Extended Search (Collection)" var="lblExtended">
<cfset heading = "#lblExtended#">
<cfset selection = "'Search','Listing'">
<cfset class = "'Collection'">
<cfinclude template="../../Tools/Submenu.cfm">

