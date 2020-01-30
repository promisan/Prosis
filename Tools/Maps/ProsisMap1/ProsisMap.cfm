<cfparam name="attributes.id" 			default="1">
<cfparam name="attributes.map" 			default="world">
<cfparam name="attributes.resolution" 	default="Low">
<cfparam name="attributes.theme" 		default="light">
<cfparam name="attributes.minValue" 	default="0">
<cfparam name="attributes.maxValue" 	default="100">
<cfparam name="attributes.colorFrom"	default="##E9D460">
<cfparam name="attributes.colorTo"		default="##F9690E">
<cfparam name="attributes.colorSteps" 	default="20">
<cfparam name="attributes.target" 		default="mapdiv">
<cfparam name="attributes.autoZoom"		default="false">
<cfparam name="attributes.zoom"			default="true">
<cfparam name="attributes.wheelZoom"	default="true">
<cfparam name="attributes.home"			default="true">
<cfparam name="attributes.label" 		default="<span style='font-size:14px;'><b>[[title]]</b>: [[value]]</span>">
<cfparam name="attributes.showSmallMap"	default="true">
<cfparam name="attributes.showExport"	default="true">
<cfparam name="attributes.responsive"	default="true">
<cfparam name="attributes.onClick"		default="">
<cfparam name="attributes.onHomeClick"	default="">

<cfoutput>

	<link rel="stylesheet" href="#session.root#/scripts/ammap/ammap.css" type="text/css">
	<script src="#session.root#/scripts/ammap/ammap.js" type="text/javascript"></script>
	<script src="#session.root#/scripts/ammap/maps/js/#attributes.map##attributes.resolution#.js" type="text/javascript"></script>

	<script>
		var map_#attributes.id# = new AmCharts.AmMap();

		AmCharts.ready(function() {
		    map_#attributes.id#.colorSteps = #attributes.colorSteps#;
		    map_#attributes.id#.theme = '#attributes.theme#';
		    map_#attributes.id#.mouseWheelZoomEnabled = #attributes.wheelZoom#;

		    map_#attributes.id#.areasSettings = {
		        autoZoom: #attributes.autoZoom#,
		        balloonText: "#attributes.label#",
		        "selectable": true,
		        color: "#attributes.colorFrom#",
		        colorSolid: "#attributes.colorTo#"
		    };
		    map_#attributes.id#.dataProvider = {
		        mapVar: AmCharts.maps.#attributes.map##attributes.resolution#,
		        areas: []
		    };

		    map_#attributes.id#.zoomControl = {
				"zoomControlEnabled": #attributes.zoom#,
				"homeButtonEnabled": #attributes.home#
			};

		    map_#attributes.id#.responsive = {
			  "enabled": #attributes.responsive#
			};

		    <cfif attributes.showSmallMap eq "yes" OR attributes.showSmallMap eq "1" OR attributes.showSmallMap eq "true">
		    	map_#attributes.id#.smallMap = {};
		    </cfif>

		    <cfif attributes.showExport eq "yes" OR attributes.showExport eq "1" OR attributes.showExport eq "true">
	  			map_#attributes.id#.export = {
											   	"enabled": true,
											    "position": "bottom-right"
											};
			</cfif>

		    var valueLegend_#attributes.id# = new AmCharts.ValueLegend();
		    valueLegend_#attributes.id#.right = 10;
		    valueLegend_#attributes.id#.minValue = "#attributes.minValue#";
		    valueLegend_#attributes.id#.maxValue = "#attributes.maxValue#";
		    map_#attributes.id#.valueLegend = valueLegend_#attributes.id#;

		    <cfif attributes.onClick neq "">
		    	map_#attributes.id#.addListener("clickMapObject", function(event) {
  					#attributes.onClick#(event);
				});
			</cfif>

			<cfif attributes.onHomeClick neq "">
				map_#attributes.id#.addListener("homeButtonClicked", function(event) {
  					#attributes.onHomeClick#(event);
				});
			</cfif>

		    map_#attributes.id#.write("#attributes.target#");
		});

		function loadMapData_#attributes.id#(pNewData) {
			AmCharts.ready(function() {
				map_#attributes.id#.dataProvider.areas = pNewData;
				map_#attributes.id#.validateData();
			});
		}

		function resetMap_#attributes.id#(pMinValue, pMaxValue, pLabel, pNewData) {

			map_#attributes.id#.areasSettings = {
		        autoZoom: #attributes.autoZoom#,
		        balloonText: pLabel,
		        "selectable": true,
		        color: "#attributes.colorFrom#",
		        colorSolid: "#attributes.colorTo#"
		    };

			var valueLegend_#attributes.id# = new AmCharts.ValueLegend();
		    valueLegend_#attributes.id#.right = 10;
		    valueLegend_#attributes.id#.minValue = pMinValue;
		    valueLegend_#attributes.id#.maxValue = pMaxValue;
		    map_#attributes.id#.valueLegend = valueLegend_#attributes.id#;

			map_#attributes.id#.write("#attributes.target#");
			
			map_#attributes.id#.dataProvider.areas = pNewData;
			map_#attributes.id#.validateData();
		}

	</script>

</cfoutput>