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
<cfparam name="attributes.map"          default="gmap">
<cfparam name="attributes.latitude"     default="">
<cfparam name="attributes.longitude"    default="">
<cfparam name="attributes.name"         default="">
<cfparam name="attributes.title"        default="(standard)">
<cfparam name="attributes.markercolor"  default="green">
<cfparam name="attributes.markericon"   default="">
<cfparam name="attributes.mode"  	    default="set">
<cfparam name="attributes.related"      default="">
<cfparam name="attributes.OnMouseOver"  default="markerOnMouseOver">
<cfparam name="attributes.OnMouseOut"   default="markerOnMouseOut">


<cfset vTitle = Replace(attributes.title,"'","","ALL")>

<cfif attributes.mode eq "set">
<cfoutput>

	<cfif attributes.latitude neq "" and attributes.longitude neq "">
			
			<script language="JavaScript">

			try{
				mapObj = ColdFusion.objectCache[_MAP_];
				sobj   = mapObj.mapPanelObject;
				sobj.showAllMarker = false;

				var markerObj={
					name: '#attributes.name#',
					title: '#vTitle#',	
					bindcallback: mapObj.markerBindListener};

				
				point = new google.maps.LatLng(#attributes.latitude#,#attributes.longitude#);
				
				var last_one = -1;
				
				//Ext.applyIf important function from sencha to add information to an existing json object
				
				<cfif attributes.markericon neq "">	
					Ext.apply(markerObj,{markericon: '#attributes.markericon#'}); 
			    <cfelseif attributes.markercolor neq "">
					Ext.apply(markerObj,{markercolor: '#attributes.markercolor#'}); 			    					
				</cfif>	
				
				<cfif attributes.related neq "">
					var gMarker = sobj.addMarker(point,markerObj,false,false,{click	  : $MAP.markerOnClickHandler, 
																			mouseover : #attributes.OnMouseOver#, 
																			mouseout  : #attributes.OnMouseOut#});  
				<cfelse>
					var gMarker = sobj.addMarker(point,markerObj,false,false,{click	  : $MAP.markerOnClickHandler});  
				</cfif>

				//checking if there is a InfoWindow open, if it is then Prosis has to close it
				if(currentopenwindow!=""){
					currentopenwindow.close();
				}			

				<cfif attributes.related neq "">
					var json_obj  = Ext.JSON.decode('#attributes.related#');
					aRelated['#attributes.name#'] = json_obj; 
				</cfif>
			 }
			 catch(ex)
			 {
			 	
			 }
			</script>
	</cfif>	

</cfoutput>
<cfelseif attributes.mode eq "delete">
		<script language="JavaScript">
			
			var mapObj = ColdFusion.objectCache[_MAP_];
			var sobj   = mapObj.mapPanelObject;
			
			<cfif attributes.name neq "">
	    		for (var i = 0; i < sobj.cache.marker.length; i++) {
	    			if (sobj.cache.marker[i].name=='#attributes.name#'){
						sobj.cache.marker[i].setMap(null);
	            		sobj.cache.marker.splice(i, 1);
	            		break; //we break the loop as we found the element
	        		}	
	    		}
	    	<cfelse>
	    		for (var i = 0; i < sobj.cache.marker.length; i++) {
					sobj.cache.marker[i].setMap(null);
            		sobj.cache.marker.splice(i, 1);
	    		}
			</cfif>	
		</script>
</cfif>