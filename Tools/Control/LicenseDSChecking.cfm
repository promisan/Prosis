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
<cfinvoke component="CFIDE.adminapi.administrator" method="login">
	<cfinvokeargument name="adminPassword" value="621004106"/>
</cfinvoke>
		
<cfinvoke component="CFIDE.adminapi.datasource" method="getDatasources" returnvariable="getDatasourcesRet"> </cfinvoke>
		
<table width="100%">
	<cfoutput>
	<cfloop collection = #getDataSourcesRet# item = "dsn"> 
		<tr>
			<td>#dsn#</td>
			<td><cfset vHost = "#getDataSourcesRet['#dsn#']['urlmap']['host']#">#vHost#</td>
		</tr>
	</cfloop>		
	</cfoutput>		
</table>		
