<!--
    Copyright © 2025 Promisan

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

