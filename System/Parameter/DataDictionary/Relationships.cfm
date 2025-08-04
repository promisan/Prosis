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
<!--- Test made by Jorge Mazariegos on the new features of cfmx 9 on OOP --->
<cf_screentop height="100%" scroll="Yes" layout="webapp" title="" label="Relationship checking tool">

<cfset vDS = "AppsProgram">
<cfset vTable = "Program">

<cfset oTable = createObject('component', 'Service.Database.Table').init(vDS,vTable) />

<cfset qDependents="#oTable.getDependencies()#">
<cfoutput>

<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
			<td colspan="3"><b>Objects which depend on #vTable#</b></td>
		</tr>
		<tr>
			<td><b>Primary Key</b></td>		
			<td><b>Dependent Table</b></td>			
			<td><b>Dependent Field</b></td>
		</tr>

	<cfloop query="qDependents">
		<tr>
			<td>#qDependents.PK_COLUMN#</td>	
			<td>#qDependents.K_Table#</td>				
			<td>#qDependents.FK_Column#</td>
		</tr>
	</cfloop>
	
	<tr>
		<td colspan="3" align="center"><a href="DependencyScript.cfm.cfm?DS=#vDS#&table=#vTable#" target="_new">Generate Dependency cfm</a></td>
	</tr>
	
</table>

<cfset qFKs="#oTable.getFKs()#">


<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
			<td colspan="4"><b>Object on which #vTable# depends on</b></td>
		</tr>
		<tr>
			<td><b>Primary Key Table</b></td>						
			<td><b>Primary Key</b></td>						
			<td><b>Foreign Key</b></td>

		</tr>
	<cfloop query="qFKs">
		<tr>
			<td>#qFKs.PK_Table#</td>						
			<td>#qFKs.PK_Column#</td>			
			<td>#qFKs.FK_Column#</td>
		</tr>
	</cfloop>

	<tr>
		<td colspan="4" align="center"><a href="ForeignScript.cfm?DS=#vDS#&table=#vTable#" target="_new">Generate Foreign cfm</a></td>
	</tr>
	
</table>

</cfoutput>