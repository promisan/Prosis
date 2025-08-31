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
<cfset oTable = createObject('component', 'Service.Database.Table').init(URL.DS,URL.Table) />

<cfset qDependents="#oTable.getDependencies()#">
<cfoutput>

<cfsavecontent variable="file">


	<cfloop query="qDependents">

		<cfquery name="one" datasource="#URL.DS#">
					SELECT
					K_Table = FK.TABLE_NAME,
					FK_Column = CU.COLUMN_NAME,
					PK_Table = PK.TABLE_NAME,
					PK_Column = PT.COLUMN_NAME,
					Constraint_Name = C.CONSTRAINT_NAME
					FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
					INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
					INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
					INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU ON C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME
					INNER JOIN (
					SELECT i1.TABLE_NAME, i2.COLUMN_NAME
					FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS i1
					INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE i2 ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME
					WHERE i1.CONSTRAINT_TYPE = 'PRIMARY KEY'
					) PT ON PT.TABLE_NAME = PK.TABLE_NAME
					WHERE PK.TABLE_NAME='#URL.Table#'
					AND 
					ORDER BY
					1,2,3,4
			</cfquery>
		
	</cfloop>	
		
		
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

</cfsavecontent>