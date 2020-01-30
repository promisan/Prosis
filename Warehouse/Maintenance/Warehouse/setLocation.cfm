	
<cfquery name="getLocations" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	L.*,
			(LocationCode + ' - ' + LocationName) as LocationDisplay
	FROM   	Location L
	WHERE  	L.Mission = '#url.mission#'
	AND		L.StockLocation = 1
</cfquery>

<cfif getLocations.recordcount eq "0">

<select name="locationId" id="locationId"  class="regularxl">
	<option value=""><cf_tl id="Not available"></option>
</select>		

<cfelse>

<select name="locationId" id="locationId"  class="regularxl">
<cfoutput query="getlocations">
	<option value="#Location#">#LocationDisplay#</option>
</cfoutput>
</select>		

</cfif>	