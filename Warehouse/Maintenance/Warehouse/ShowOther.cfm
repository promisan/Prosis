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
<cfquery name="Other" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Warehouse 
		WHERE  Mission  = '#url.mission#'  
		AND    Latitude != '' 
		AND    Longitude != ''
	</cfquery>
	
<script>
	 var bounds = new google.maps.LatLngBounds();
</script>
	
<cfoutput query="Other">

	<cfsavecontent variable="othercity">
	
		#WarehouseName#&nbsp;<br>#city#  #Address#
	 
	</cfsavecontent>
		
	<script>		
		 
		 <cfif  Other.Warehouse neq '#url.warehouse#'>
		 
			 var centerLongLat={
					latitude:  #Latitude#,
					longitude: #Longitude#,
					markercolor: 'ffffaf',
					markerwindowcontent: '#othercity#'
					};
					
			 marker = ColdFusion.Map.addMarker('gmap', centerLongLat)		
			 
		  </cfif>
		  
		   var point = new google.maps.LatLng( #Latitude#,#Longitude#);
           bounds.extend(point);
		  
	</script>
	
</cfoutput>	

<!--- fit the map bounds to show all the markers --->
<script>
	var map = ColdFusion.Map.getMapObject("gmap");
	map.fitBounds(bounds);
</script>
	