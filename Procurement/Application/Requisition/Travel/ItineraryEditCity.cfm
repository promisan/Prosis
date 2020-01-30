
<cfquery name="CitySelect" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Ref_CountryCity 
		WHERE CountryCityId = '#URL.CityId#'			
</cfquery>


<cfif CitySelect.recordcount eq "1">

<cfoutput query="cityselect">

	<input type="text" name="location#url.field#" id="location#url.field#" style="width:280" maxlength="120" readonly class="regularxl" value="#LocationCity#">
	<input type="hidden" name="#url.field#id" id="#url.field#id" value="#CountryCityId#">
		
	<cfif url.field eq "city1">

		<script>
		    try{
			document.getElementById("city99id").value       = "#CountryCityId#"
			document.getElementById("locationcity99").value = "#LocationCity#"
			} catch(e) {}
		</script>

	</cfif>
	
</cfoutput>

<cfelse>

	<cfoutput>
	
	<input type="text" name="location#url.field#" id="location#url.field#" style="width:280" maxlength="120" readonly class="regularxl">
	<input type="hidden" name="#url.field#id" id="#url.field#id">
	</cfoutput>

</cfif>

