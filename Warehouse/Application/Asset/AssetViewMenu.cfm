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
<cfoutput>

<cf_dialogMaterial>

<cf_submenuleftscript>

<script language="JavaScript">

function location() {
    parent.right.location =  "#SESSION.root#/Warehouse/Application/Asset/nnnnnnn.cfm?ID=#URL.ID#&ts="+new Date().getTime()
}

function holder() {
    parent.right.location =  "#SESSION.root#/Warehouse/Application/Asset/nnnnnnn.cfm?ID=#URL.ID#&ts="+new Date().getTime()
}

function service() {
    parent.right.location =  "#SESSION.root#/Warehouse/Application/Asset/nnnnnnn.cfm?ID=#URL.ID#&ts="+new Date().getTime()
}

</script>

</cfoutput>

<cfset fcolor = "002350">

<cfinvoke component="Service.Access"  
     method="asset" 
	 assetid="#URL.ID#" 
	 returnvariable="access">
	 
<cfset access = "ALL">

<!---
<cfinvoke component="Service.Access"  
     method="roster"
	 role="'AdminRoster','RosterClear'"
	 returnvariable="accessRoster">
	 --->
			  				  
<cfif access eq "READ" 
     OR access eq "EDIT" 
	 OR access eq "ALL">
	 
	<table width="93%" border="0" cellspacing="0" cellpadding="0" align="right">
	
		<tr><td height="12"></td></tr>
		<tr><td>
			<cf_tl id="General" var="1">
			<cfset heading = "#LT_Text#">
			<cfset module = "'Warehouse'">
			<cfset selection = "'Asset'">
			<cfset menuclass = "'General'">
			<cfinclude template="../../../Tools/SubmenuLeft.cfm">
		</td></tr>
			
		<tr><td>
		<cf_tl id="History" var="1">
		<cfset heading = "#LT_Text#">
		<cfset module = "'Warehouse'">
		<cfset selection = "'Asset'">
		<cfset menuclass = "'History'">
		<cfinclude template="../../../Tools/SubmenuLeft.cfm">
		</td></tr>
				
		<tr><td>
		
		<cf_tl id="Financials" var="1">
		<cfset heading = "#LT_Text#">
		<cfset module = "'Warehouse'">
		<cfset selection = "'Asset'">
		<cfset menuclass = "'Financials'">
		<cfinclude template="../../../Tools/SubmenuLeft.cfm">
		
		</td></tr>
		
		<tr><td>
		<cf_tl id="Miscellaneous" var="1">
		<cfset heading = "#LT_Text#">
		<cfset module = "'Warehouse'">
		<cfset selection = "'Asset'">
		<cfset menuclass = "'Miscellaneous'">
		<cfinclude template="../../../Tools/SubmenuLeft.cfm">
		</td></tr>
		
	</table>

</cfif>

