
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
	