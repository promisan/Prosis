
<!--- Position box --->

<cfparam name="url.mission"    default="STL">
<cfparam name="url.selection"  default="#dateformat(now(),client.dateSQL)#">

<cf_tl id="Positions View" var="vMainLabel">
<cfset vLayout = "webapp">

<cf_screentop jquery="yes" bootstrap="yes" html="no" label="#vMainLabel#">

	<cf_staffingPositionScript>
	
	<script>
	
		function toggleActions(unit) {
			var vIcon = $('.actionsIcon_'+unit);
			$('.actions_'+unit).slideToggle(); 
			
			if ($(vIcon).hasClass('fa-plus-circle')) {
				$(vIcon).removeClass('fa-plus-circle');
				$(vIcon).addClass('fa-minus-circle');
			} else {
				$(vIcon).removeClass('fa-minus-circle');
				$(vIcon).addClass('fa-plus-circle');
			}
		}
		
	</script>

	<style>

		.row {
			margin-left: 0px;
			margin-right: 0px;
		}

		.clsUnit {
			font-size: 200%; 
			padding-bottom: 0px; 
			padding-left: 15px; 
			background-color: #ffffff;
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
			padding-top:5px;
			padding-bottom:5px;
			overflow:auto;
			height:97%;
		}

		.clsPosition {
			height: 360px; 
			overflow: auto;
			border-bottom: 1px solid #EAEAEA; 
			border-right: 1px solid #EAEAEA;
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
		
		.x-border-box, .x-border-box * {
		    box-sizing: border-box;
		    -moz-box-sizing: border-box;
		    -ms-box-sizing: border-box;
		}
		
		.actionsHeader {
			border: 1px solid #EAEAEA;
			font-size:125%;
			font-weight:bold;
			padding:5px;
			cursor:pointer;
		}
		
		.actionsContainer {
			border: 1px solid #EAEAEA;
			background-color:#FAF7D4;
			padding:5px;
		}
		
	</style>

	<cf_mobileRow class="clsMainContainer toggleScroll-y">

		<cf_mobileRow>

			<cf_MobileCell id="filter" class="clsFilterContainer toggleScroll-y hidden-xs col-sm-2">
				<cfinclude template="StaffingPositionFilter.cfm">
			</cf_MobileCell>

			<cf_MobileCell id="main" class="clsMain col-sm-10"></cf_MobileCell>
			
		</cf_mobileRow>

	</cf_mobileRow>

	<script>
		doFilter();
	</script>
		
<cf_screenbottom layout="#vLayout#">

