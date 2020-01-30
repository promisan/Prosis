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
