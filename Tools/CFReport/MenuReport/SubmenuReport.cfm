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
<cfparam name="MenuClass" default="'Main'">
<cfparam name="Heading" default="">
<cfparam name="url.id" default="">
<cfparam name="uniqueheader" default="">

<cfquery name="Parameter" 
datasource="AppsSystem">
	SELECT   *
	FROM     Parameter
</cfquery>

<cfif uniqueheader eq "">

	<cf_screentop height="100%" scroll="Yes" html="No" jquery="yes">
	<cfajaximport tags="cfform,cfdiv">
</cfif>

<style>

	table.rpthighLight {
		BACKGROUND-COLOR: #f3f3f3;		
		border : 1px solid white;
	}
	table.rptnormal {
		BACKGROUND-COLOR: #ffffff;
		border : 1px solid white;
	}
	
</style>

<cfif uniqueheader eq "">
	<cf_submenuLogo module="#url.id#" selection="Reports">
</cfif>

<!--- script file --->
<cfinclude template="SubmenuReportScript.cfm">

<!--- menu listing if authorised --->
<cfinclude template="SubmenuReportList.cfm">


