
	<cfquery name="Class" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  Ref_ReportMenuClass 
		WHERE SystemModule = '#url.systemmodule#'				
	</cfquery>
	
xxxxx

<select name="menuclass" id="menuclass">
	<cfoutput query="Class">
		<option value="#MenuClass#">#Description#</option>
	</cfoutput>
</select>