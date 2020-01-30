	
<cfquery name="getLocations" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	L.*,
			(LocationCode + ' - ' + LocationName) as LocationDisplay,
			C.Description as ClassDescription
	FROM   	Location L,
			Ref_LocationClass C
	WHERE  	L.LocationClass = C.Code
	AND		L.Mission = '#missionselect.mission#'
	AND		L.StockLocation = 1
</cfquery>

<select name="locationId">
<cfoutput query="getlocations">
	<option value="#LocationId#">#LocationDisplay#</option>
</cfoutput>
</select>			