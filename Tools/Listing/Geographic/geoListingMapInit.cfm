<cfparam name="attributes.mapId"        default="1">
<cfparam name="attributes.colorFrom"    default="##66eded">
<cfparam name="attributes.colorTo"      default="##007778">

<cf_ProsisMap 
    id="map_#attributes.mapId#" 
    target="mymap_#attributes.mapId#"
    minValue="" 
    maxValue=""
    colorFrom="#attributes.colorFrom#"
    colorTo="#attributes.colorTo#"
    showSmallMap="false"
    autoZoom="false"
    wheelZoom="false"
    onClick="clickGeoListingMap_#attributes.mapId#">

<cfoutput>
    <script>
        function clickGeoListingMap_#attributes.mapId#(e) {
            clickGeoListingMap('#attributes.mapId#', e);
        }
    </script>
</cfoutput>