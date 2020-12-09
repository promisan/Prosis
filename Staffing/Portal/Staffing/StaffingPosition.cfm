
<!--- Position box --->

<cfparam name="url.header"     default="0">
<cfparam name="url.mission"    default="STL">
<cfparam name="url.selection"  default="#dateformat(now(),client.dateSQL)#">

<cf_tl id="#url.mission# Position Incumbency View" var="vMainLabel">
<cfset vLayout = "webapp">

<cfif url.header eq "1">
	<cfset html = "Yes">
<cfelse>
	<cfset html = "No">
</cfif>
	
<cf_screentop jquery="yes" bootstrap="yes" html="#html#" layout="webapp" banner="gray" label="#vMainLabel#">

<cf_divscroll>

	<cf_staffingPositionScript>
		
	<cfoutput>
	<script>
	
		function toggleActions(unit) {
			var vIcon = $('.actionsIcon_'+unit);
			$('.actions_'+unit).slideToggle(); 
			
			if ($(vIcon).hasClass('fa-plus-circle')) {
				$(vIcon).removeClass('fa-plus-circle');
				$(vIcon).addClass('fa-minus-circle');
				// var vUnits = $('.clsFilterUnit:checked').map(function() {return this.value;}).get().join(',');				
				ptoken.navigate('#session.root#/Staffing/Portal/Staffing/StaffingEventListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&selection=#url.selection#&unit='+unit, 'events_'+unit);
	
			} else {
				$(vIcon).removeClass('fa-minus-circle');
				$(vIcon).addClass('fa-plus-circle');
			}
		}
		
		function doSearch(v) {
			var vVal = $.trim(v).toLowerCase();
			
			//hide all actions
			$('.actionsIcon').removeClass('fa-minus-circle').addClass('fa-plus-circle');
			$('.actionsContainer').hide();
			
			if (vVal == '') {
				$('.clsUnitContainer').removeClass('clsRemovePadding');
				$('.clsSearchable').show();
			} else {
				$('.clsUnitContainer').addClass('clsRemovePadding');
				$('.clsSearchable').hide();
				$('.clsSearchCriteria').each(function(){
					var vCriteria = $.trim($(this).html()).toLowerCase();
					if (vCriteria.includes(vVal)) {
						$(this).parent().show();
					}
				});
			}
		}
		
	</script>
	
	</cfoutput>

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
			top: 40px;
			z-index:99;
			border-top:10px solid #FFFFFF;
		}

		.clsUnitContainer {
			padding: 10px; 
			padding-top: 0px;
		}

		.clsRemovePadding {
			padding:0px!important;
		}
		
		.clsSearchContainer {
			height:40px;
			position: sticky;
			top: 0;
			z-index:100;
			background-color: #ffffff;
			padding:7px;
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
			height: 340px; 
			overflow: auto;
			border-bottom: 0px solid #EAEAEA; 
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
			border: 0px solid #EAEAEA;
			background-color:#ffffff;
			padding:5px;
		}
		
		.clsSearchCriteria {
			display:none;
		}
		
	</style>

	<cf_mobileRow class="clsMainContainer toggleScroll-y">

		<cf_mobileRow>

			<cf_MobileCell id="filter" class="clsFilterContainer toggleScroll-y hidden-xs col-sm-4 col-md-3 col-lg-2">
				<cfinclude template="StaffingOrganization.cfm">
			</cf_MobileCell>

			<cf_MobileCell id="main" class="clsMain col-sm-8 col-md-9 col-lg-10"></cf_MobileCell>
			
		</cf_mobileRow>

	</cf_mobileRow>

	<script>
		doFilter();
	</script>
	
</cf_divscroll>	
		
<cf_screenbottom layout="#vLayout#">

