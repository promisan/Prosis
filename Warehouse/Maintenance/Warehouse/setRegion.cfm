	
<cfquery name="getRegions" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM   	Ref_WarehouseCity L
	WHERE  	L.Mission = '#url.mission#'	
	ORDER BY ListingOrder
</cfquery>

<cfif getRegions.recordcount eq "0">
	
	<select name="City" id="City" class="regularxl">
		<option value=""><cf_tl id="Not available"></option>
	</select>		
	
	<script>
	  	document.getElementById("submitbox").className = "hide";
		alert("Please record an entry on Ref_WarehouseCity first.");  
	</script>

<cfelse>
	
	<cfif client.googleMAP eq "1">	 
		<cfajaximport tags="cfmap" params="#{googlemapkey='#client.googlemapid#'}#"> 
		<cfset maplink = "mapaddress()">
	<cfelse>
		<cfset maplink = "">	
	</cfif>
	
	<select name="AddressCity" id="addresscity" class="regularxl" onchange="<cfoutput>#maplink#</cfoutput>">
	<cfoutput query="getRegions">
		<option value="#City#">#City#</option>
	</cfoutput>
	</select>		

	<script>
	  document.getElementById("submitbox").className = "regular" 
	</script>

</cfif>	