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

<cf_submenuLogo module="System" selection="Utilities">

<!--- show only if the server is the distribution server, which means
it has replica directories in exactly the directories pointed out in the control tables
--->

<cfparam name="URL.ID" default="utility">

<cfif url.id eq "utility">

	<!--- Note can now be enabled for recording of change requests !!! --->
 
	<cf_distributer>
	
	<cfif master eq "1">
	
		<!--- source code management menu which can 
		only be run from the master !! --->
		<cfset heading = "Source Code Control">
		<cfset module = "'System'">
		<cfset selection = "'SourceCode'">
		<cfset class = "'Main'">
		<cfinclude template="../../Tools/Submenu.cfm">
	
	</cfif>
			
	<!--- general menu--->
	<cfset heading = "Settings">
	<cfset module = "'System'">
	<cfset selection = "'Setting'">
	<cfset class = "'Main'">
	<cfinclude template="../../Tools/Submenu.cfm">
	
	<!--- general menu--->
	<cfset heading = "Utilities and Localization">
	<cfset module = "'System'">
	<cfset selection = "'Utility'">
	<cfset class = "'Main'">
	<cfinclude template="../../Tools/Submenu.cfm">	
	
	<!--- general menu--->
	<cfset heading = "Monitoring Tools">
	<cfset module = "'System'">
	<cfset selection = "'Monitor'">
	<cfset class = "'Main'">
	<cfinclude template="../../Tools/Submenu.cfm">	

	<!--- general menu--->
	<cfset heading = "Inquiry">
	<cfset module = "'System'">
	<cfset selection = "'Utility'">
	<cfset class = "'Builder'">
	<cfinclude template="../../Tools/Submenu.cfm">	

<cfelse>
	
	<!--- general menu--->
	<cfset heading = "System Support Object Library">
	<cfset module = "'System'">
	<cfset selection = "'Library'">
	<cfset class = "'Main'">
	<cfinclude template="../../Tools/Submenu.cfm">
	
	<!--- general menu--->
	<cfset heading = "System Documentation utilities">
	<cfset module = "'System'">
	<cfset selection = "'Documentation'">
	<cfset class = "'Main'">
	<cfinclude template="../../Tools/Submenu.cfm">

</cfif>
