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

<cf_submenuLogo module="System" selection="Organization">

<!--- general menu--->
<cfset heading          = "Tree Maintenance">
<cfset module           = "'System'">
<cfset selection        = "'Organization'">
<cfset class            = "'Main'">
<cfinclude template     = "../../Tools/Submenu.cfm">

<!--- specific menu ; 30/4 adjusted for both OrgUnitManger and HR Position --->
<cfset verifysource     = "'OrgUnitManager','HRPosition'">
<cfset verifytable      = "">
<cfset module           = "">
<cfset menutemplate     = "Application/OrganizationView.cfm">
<cfset class = "">

<cfoutput>
	
	<cfparam name="URL.Operational" default="1">
	
	<table width="94%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td class="linedotted"></td></tr>
	<tr>
	<td style="padding-left:30px;padding-top:10px">
	
	    <table cellspacing="0" cellpadding="0">
		<tr>		
		<td>
		<input type="radio" class="radiol" name="toggle" id="toggle" value="1" onclick="ptoken.location('menu.cfm?operational=1')" <cfif url.operational eq "1">checked</cfif>>
		</td><td>&nbsp;</td><td style="cursor:pointer" class="labellarge" onclick="ptoken.location('menu.cfm?operational=1')"><cfif url.operational eq "1"><b></cfif>Active</td>
		<td>&nbsp;</td>
		<td>
		<input type="radio" class="radiol" name="toggle" id="toggle" value="0" onclick="ptoken.location('menu.cfm?operational=0')" <cfif url.operational eq "0">checked</cfif>>
		</td><td>&nbsp;</td><td style="cursor:pointer" class="labellarge" onclick="ptoken.location='menu.cfm?operational=0'"><font color="FF0000"><cfif url.operational eq "0"><b></cfif>Closed</td>
		</tr>
		</table>
	</td>
	</tr>	
	
	<tr><td>
	<cfinclude template="../../Tools/SubmenuMission.cfm">
	</td></tr>
	</table>

</cfoutput>
