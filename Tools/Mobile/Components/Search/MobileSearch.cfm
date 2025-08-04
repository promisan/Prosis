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
<!--- Mobile App settings --->
<cfparam name="Attributes.appId" 						default="Search">
<cfparam name="Attributes.validateLogin" 				default="yes">
<cfparam name="Attributes.showHeader" 					default="0">
<cfparam name="Attributes.modalDetailStyle"				default="width:90%; margin-top:3%;">

<!--- Portal Parameters --->
<cfparam name="Attributes.id" 							default="">
<cfparam name="Attributes.Mission" 						default="">
<cfparam name="Attributes.systemfunctionid" 			default="00000000-0000-0000-0000-000000000000">

<!--- Custom Styles and Scripts --->
<cfparam name="Attributes.customCSS"					default="">
<cfparam name="Attributes.customScripts"				default="">

<!--- External links --->
<cfparam name="Attributes.ExternalElementURL"			default="">

<!--- Printing --->
<cfparam name="Attributes.printWindowSize" 				default="800">
<cfparam name="Attributes.printWindowSizeChrome" 		default="800">
<cfparam name="Attributes.PrintHeaderIcon"				default="fa-search">
<cfparam name="Attributes.PrintDetailTitle"				default="Stock Item">
<cfparam name="Attributes.PrintListTitle"				default="Stock">
<cfparam name="Attributes.CustomPrintCSS" 				default="#session.root#/system/organization/orgTree/css/customPrint.css">
<cfparam name="Attributes.CustomPrintListCSS" 			default="#session.root#/system/organization/orgTree/css/customPrintList.css">

<!--- Instructions --->
<cfparam name="Attributes.InstructionsText"				default="Please select some valid search criteria on the filters section.">
<cfparam name="Attributes.InstructionsIcon"				default="fa-search">

<!--- Filters --->
<cfparam name="Attributes.FilterURL"					default="">

<!--- Listing --->
<cfparam name="Attributes.ListingURL"					default="">

<!--- Content --->
<cfparam name="Attributes.ContentHeaderURL"				default="">
<cfparam name="Attributes.ContentBodyURL"				default="">


<!--- Get mission info --->
<cfquery name="getMission" 
	datasource="AppsOrganization">
		SELECT  *
		FROM    Ref_Mission
		WHERE	Mission = '#Attributes.mission#'
</cfquery>

<cfset vBasePath = "#session.root#/tools/mobile/components/search">

<cfset vExternalLinkScript = "">
<cfif trim(Attributes.ExternalElementURL) neq "">
	<cfset vExternalLinkScript = "ptoken.open('#Attributes.ExternalElementURL#'+id, '_blank');">
</cfif>

<!--- Start mobile application --->
<cf_mobile 
	appId="#Attributes.appId#" 
	validateLogin="#Attributes.validateLogin#" 
	printWindowSize="#Attributes.printWindowSize#" 
	printWindowSizeChrome="#Attributes.printWindowSizeChrome#"
	awesomeCheckbox="yes"
	datepicker="yes"
	customCSS="#session.root#/tools/mobile/components/search/css/baseStyle.css">
	
	<cf_tl id="#Attributes.PrintDetailTitle#" var="lblPrintDetailTitle">
	<cf_tl id="#Attributes.PrintListTitle#" var="lblPrintListTitle">
	<cf_tl id="This printout might take a while to complete.\n\nDo you want to continue ?" var="lblPrintListAck">
	
	<cf_systemScript>

	<cfoutput>
		<script>

			function _mobile_CleanupValue(strValue) {
				return $.trim(strValue).toLowerCase().replace(/[àáâãäå]/g,"a").replace(/[éêëè]/g,"e").replace(/[íïîì]/g,"i").replace(/[óôöò]/g,"o").replace(/[úûùü]/g,"u");
			}

			function _mobile_defineParamLink(str) {
				var vParamLink = '?';
				if (str.indexOf('?') != -1) { vParamLink = "&"; }
				return vParamLink;
			}

			function _mobile_getFilterParameters() {
				var vFilterParameters = "";
				$('.filterElement').each(function(){
					vFilterParameters = vFilterParameters + '&' + $(this).attr('id') + '=' + _mobile_CleanupValue($(this).val()).replace(/'/g,"");
				});
				return vFilterParameters;
			}
		
			function _mobile_searchElement(v, closestElement, ev) {
				var keycode = (ev.keyCode ? ev.keyCode : ev.which);
				var vValue = _mobile_CleanupValue(v);
				
				if (vValue != '') {
					if (keycode == '13') { 
						$('.clsListingContainer').hide();
						$('.clsSearchSpinner').show();
						setTimeout( function(){
							$('.searchable').each(function(){
								var vThisValue = _mobile_CleanupValue($(this).text());
								
								if (vThisValue.indexOf(vValue) != -1) {
									$(this).closest(closestElement).show();
								} else {
									$(this).closest(closestElement).hide();
								}
							});
							$('.clsSearchSpinner').hide();
							$('.clsListingContainer').show();
						}, 50);	
					}
				} else {
					$('.clsListingContainer').hide();
					$('.clsSearchSpinner').show();
					setTimeout( function(){
						$('.searchable').closest(closestElement).show();
						$('.clsSearchSpinner').hide();
						$('.clsListingContainer').show();
					}, 50);	
				}
				
			}

			function _mobile_applyFilterOnEnter(ev) {
				var keycode = (ev.keyCode ? ev.keyCode : ev.which);
				if (keycode == '13') { 
					_mobile_applyFilter();
				}
			}
			
			function _mobile_applyFilter() {
				var vFilterParameters = _mobile_getFilterParameters();
				ptoken.navigate('#Attributes.ListingURL#?id=#url.id#&mission=#Attributes.mission#&systemfunctionid=#Attributes.systemfunctionid#'+vFilterParameters,'divSearchDetail');
			}
			
			function _mobile_showElement(reference) {
				var vFilterParameters = _mobile_getFilterParameters();
				var vParamLink;

				vParamLink = _mobile_defineParamLink('#Attributes.ContentHeaderURL#');
				ptoken.navigate('#Attributes.ContentHeaderURL#'+vParamLink+'mission=#Attributes.mission#&systemfunctionid=#Attributes.systemfunctionid#&reference='+reference+vFilterParameters,'divSearchElementModalTitle');

				vParamLink = _mobile_defineParamLink('#Attributes.ContentBodyURL#');
				ptoken.navigate('#Attributes.ContentBodyURL#'+vParamLink+'mission=#Attributes.mission#&systemfunctionid=#Attributes.systemfunctionid#&reference='+reference+vFilterParameters,'divSearchElementModalBody');

				$('.clsOpenExternalLink').off('click').on('click', function(){ _mobile_showExternalElement(reference); });
				$("##searchElementModal").modal('show');
			}

			function _mobile_hideModal() {
				$("##searchElementModal").modal('hide');
			}
			
			function _mobile_showExternalElement(id) {
				#vExternalLinkScript#
			}

			function _mobile_printElement(printDirect) {
				$('.clsPrintHeader .clsPrintHeaderSubtitle').html('#lblPrintDetailTitle#');
				___prosisMobileWebPrint(".clsPrintHeader, ##searchElementModal .modal-content", printDirect, "#Attributes.CustomPrintCSS#?ts=#getTickCount()#", "");
			}
			
			function _mobile_printList() {
				if ($('.elementContainer').length > 0 || $('.listGroupTopContainer').length > 0) {
					if (confirm('#lblPrintListAck#')) {
						$('.clsPrintHeader .clsPrintHeaderSubtitle').html('#lblPrintListTitle#');
						___prosisMobileWebPrint(".clsPrintHeader, .clsListingContainer", true, "#Attributes.CustomPrintListCSS#?ts=#getTickCount()#", "$('.elementContainer').addClass('col-xs-4'); $('.elementContainer .panel-footer .contact-stat').addClass('pull-left'); $('.orgUnitContainer').removeClass('panel-collapse'); $('.orgUnitContainer .panel-body').show();");
					}
				}
			}
			
		</script>
	</cfoutput>

	<cfif trim(attributes.customCSS) neq "">
		<cfoutput>
			<link rel="stylesheet" href="#trim(attributes.customCSS)#">
		</cfoutput>
	</cfif>

	<cfif trim(attributes.customScripts) neq "">
		<cfoutput>
			<script src="#trim(attributes.customScripts)#"></script>
		</cfoutput>
	</cfif>
	
	<cfoutput>
		<div class="clsPrintHeader" style="display:none;">
			<div style="background-color:##005B9A; color:##FAFAFA; border-bottom:3px solid ##606060; padding:25px; margin-bottom:-20px;">
				<div class="pull-left" style="padding-right:15px;">
					<i class="fa #attributes.printHeaderIcon#" style="font-size:50px;"></i>
				</div>
				<div>
					<span style="font-size:165%;">#getMission.MissionName#</span>
					<br>
					<span class="clsPrintHeaderSubtitle"></span>
				</div>
			</div>
		</div>
	</cfoutput>
	
	<!-- Search Element Modal -->
	<div id="searchElementModal" class="modal fade" role="dialog">
		<div class="modal-dialog" style="<cfoutput>#attributes.modalDetailStyle#</cfoutput>">
			<!-- Element Modal content-->
			<div class="modal-content">
				<div class="modal-header" style="padding-bottom:15px; padding-top:15px; background-color:#ECECEC; color:#FAFAFA;">
					<cfoutput>
						<cf_tl id="Close" var="1">
						<button type="button" class="close clsNoPrint" style="font-size:35px;" data-dismiss="modal" title="#lt_text#">&times;</button>
						<cf_tl id="Print profile" var="1">
						<a class="clsNoPrint pull-right" style="padding-right:10px;" title="#lt_text#">
							<i class="fa fa-print clsPrintProfileButton" onclick="_mobile_printElement(true);"></i>
						</a>
						<cfif trim(Attributes.ExternalElementURL) neq "">
							<cf_tl id="Open in a new window" var="1">
							<a class="clsNoPrint pull-right" style="padding-right:10px;" title="#lt_text#">
								<i class="fa fa-external-link clsOpenProfileButton clsOpenExternalLink" onclick=""></i>
							</a>
						</cfif>
					</cfoutput>
					<h4 class="modal-title">
						<cfdiv id="divSearchElementModalTitle">
					</h4>
				</div>
				<div class="modal-body">
					<cfdiv id="divSearchElementModalBody">
				</div>
			</div>
		</div>
	</div>
	
	<cf_divscroll>
	
		<cfif Attributes.showHeader eq "1">
			<cfoutput>
				<div class="row" style="padding:20px; background-color:##3498DB; color:##FAFAFA;">
					<div class="col-lg-12" style="font-size:150%; font-weight:bold;">#ucase(session.welcome)# #ucase(Attributes.mission)#</div>
				</div>
			</cfoutput>
		</cfif>
		
		<div class="content animate-panel" style="padding-bottom:0px;">
	
		    <div class="row">
		        <div class="col-md-3 animated-panel zoomIn" style="animation-delay: 0.1s;">
					
					<cf_tl id="Filters" var="1">
					
					<cf_mobilePanel
						panelClass="panelFilters" 
						addContainer="0" 
						title="#lt_text#">
	
	                    <cfdiv id="divFiltersByMission" bind="url:#Attributes.FilterURL#?mission=#Attributes.mission#">
						
						<div class="row" style="padding:10px;">
							<cfoutput>
								<div class="col-lg-6 col-md-6 col-sm-6" style="padding-bottom:5px;">
									<cf_tl id="Listing" var="1">
									<button class="btn btn-info btn-block btn-sm defaultFilterButton" onclick="_mobile_applyFilter();" title="#lt_text#">
										<i class="fa fa-th" style="font-size:175%;"></i>
										<span class="visible-lg visible-sm visible-xs" style="text-transform:capitalize;">
											#lcase(lt_text)#
										</span>
									</button>
								</div>
								<div class="col-lg-6 col-md-6 col-sm-6" style="padding-bottom:5px;">
									<cf_tl id="Print" var="1">
									<button class="btn btn-info btn-block btn-sm" onclick="_mobile_printList();" title="#lt_text#">
										<i class="fa fa-print" style="font-size:175%;"></i>
										<span class="visible-lg visible-sm visible-xs" style="text-transform:capitalize;">
											#lcase(lt_text)#
										</span>
									</button>
								</div>
							</cfoutput>
						</div>
						
					</cf_mobilePanel>
					
				</div>
		        <div class="col-md-9 animated-panel zoomIn" style="animation-delay: 0.2s;">
		            <div class="row">
		                <div class="col-lg-12 animated-panel zoomIn" style="animation-delay: 0.3s;">
							<div class="content animate-panel">
								<cfdiv id="divSearchDetail" bind="url:#vBasePath#/MobileSearchInstructions.cfm">
						    </div>
		                </div>
		            </div>
		        </div>
		    </div>
	
		</div>
	
	</cf_divscroll>
	
</cf_mobile>