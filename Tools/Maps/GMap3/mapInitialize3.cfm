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
<cfparam name="sensor" default="false">
<cfparam name="latitude" default="-34.397">
<cfparam name="longitude" default="150.644">
<cfparam name="zoom" default="8">

<cfoutput>

	<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=#sensor#"></script>

	<script type="text/javascript">
	  function initialize() {
	    var latlng = new google.maps.LatLng(#latitude#, #longitude#);
	    var myOptions = {
	      zoom: 8,
	      center: latlng,
	      mapTypeId: google.maps.MapTypeId.ROADMAP
	    };
	    var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
	  }
	  
	  window.onload = function () {initialize();}
	
	</script>
	
</cfoutput>
