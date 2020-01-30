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
