
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

		function doCompressExpand(pos) {
			if ($('.clsPosition' + pos + ':visible .clsBig').first().is(':visible')) {
				//Small
				$('.clsPosition' + pos + ' .clsBig').hide();
				$('.clsPosition' + pos + ' .clsSmall').show();
				$('.clsPosition' + pos).css('height','110px');
				$('.clsPosition' + pos + ' .clsPostHeader').css('height','35px');
				$('.clsPosition' + pos + ' .clsPostHeaderText').css('font-size','13px');
				//$('.clsPosition').removeClass('col-lg-4').removeClass('col-md-6').addClass('col-lg-3');

				if (pos == '') {
					$('.clsCompressIcon').removeClass('fa-compress').addClass('fa-expand');
					sessionStorage.setItem('staffPositionMode','1');
				}
			} else {
				//Big
				$('.clsPosition' + pos + ' .clsBig').show();
				$('.clsPosition' + pos + ' .clsSmall').hide();
				$('.clsPosition' + pos).css('height','400px');
				$('.clsPosition' + pos + ' .clsPostHeader').css('height','46px');
				$('.clsPosition' + pos + ' .clsPostHeaderText').css('font-size','18px');
				//$('.clsPosition').removeClass('col-lg-3').addClass('col-lg-4').addClass('col-md-6');

				if (pos == '') {
					$('.clsCompressIcon').removeClass('fa-expand').addClass('fa-compress');
					sessionStorage.setItem('staffPositionMode','0');
				}
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
			border-top:3px solid #FFFFFF;
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
			height:98%;
		}

		.clsPosition {
			height: 380px; 
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

		.clsSmall  {
			display:none;
		}
		
	</style>

	<cf_mobileRow class="clsMainContainer toggleScroll-y">
		<cf_mobileRow>
			<cf_MobileCell id="filter" class="clsFilterContainer toggleScroll-y hidden-xs col-sm-5 col-md-4 col-lg-3">
				<cfinclude template="StaffingOrganization.cfm">
			</cf_MobileCell>
			<cf_MobileCell id="main" class="clsMain col-sm-7 col-md-8 col-lg-9"></cf_MobileCell>			
		</cf_mobileRow>
	</cf_mobileRow>

	<script>
		doFilter();
	</script>
	
</cf_divscroll>	
		
<cf_screenbottom layout="#vLayout#">

