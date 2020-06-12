
<!--- Position box --->

<cfparam name="url.mission"    default="STL">
<cfparam name="url.selection"  default="#dateformat(now(),client.dateSQL)#">

<cf_tl id="Positions View" var="vMainLabel">
<cfset vLayout = "webapp">

<cf_screentop jquery="yes" bootstrap="yes" layout="#vLayout#" label="#vMainLabel#">

	<cf_staffingPositionScript>

	<style>

		.row {
			margin-left: 0px;
			margin-right: 0px;
		}

		.clsUnit {
			font-size: 200%; 
			padding-bottom: 5px; 
			padding-left: 5px; 
			background-color: #EDEDED;
			position: sticky;
			top: 0;
			z-index:99;
			border-top:10px solid #FFFFFF;
		}

		.clsUnitContainer {
			padding: 10px; 
			padding-top: 0px;
		}

		.clsFilterContainer {
			position: sticky;			
			top: 0;
			z-index:100;
			background-color:#FFFFFF;
			padding-top:10px;
			padding-bottom:10px;
			overflow:auto;
		}

		.clsPosition {
			height: 320px; 
			overflow: auto;
			border-bottom: 1px solid #EDEDED; 
			border-right: 1px solid #EDEDED;
		}

		.clsPosition:hover {
			background-color: #F1F1F1;
		}

		.clsMainContainer {
			height: 100%;
			overflow-y: auto;
		}

		.clsMain {
			border-left: 1px solid #EDEDED;
			height: auto;
		}
	</style>

	<cf_mobileRow class="clsMainContainer">

		<cf_mobileRow>

			<cf_MobileCell id="filter" class="clsFilterContainer hidden-xs col-sm-2">
				<cfinclude template="StaffingPositionFilter.cfm">
			</cf_MobileCell>

			<cf_MobileCell id="main" class="clsMain col-sm-10"></cf_MobileCell>
			
		<cf_mobileRow>

	</cf_mobileRow>

	<script>
		doFilter();
	</script>
		
<cf_screenbottom layout="#vLayout#">

