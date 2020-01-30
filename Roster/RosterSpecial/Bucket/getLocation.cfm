
<cfquery name="Location" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  Location
		WHERE Mission   = '#URL.Mission#' 
</cfquery>

<select name="LocationCode" id="LocationCode" class="regularxl enterastab">
<option value="">---<cf_tl id="Select">---</option>
<cfoutput query="Location">
<option value="#LocationCode#">#LocationName#</option>
</cfoutput>
</select>