<cfparam name="url.owner" default="">

<cfquery name="Status" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_StatusCode
	WHERE  Owner = '#url.owner#' AND Id='FUN' AND RosterAction = 0
</cfquery>

<select id="StatusTo" name="StatusTo" class="regularxl">
	<cfoutput query="Status">
		<option value="#Status#">#Meaning#</option>
	</cfoutput>
</select>