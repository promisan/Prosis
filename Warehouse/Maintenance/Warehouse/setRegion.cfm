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