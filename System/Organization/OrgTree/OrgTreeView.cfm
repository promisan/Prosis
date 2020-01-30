<cfparam name="url.id" 							default="">
<cfparam name="url.appId" 						default="OrgTree">
<cfparam name="url.showHeader" 					default="0">
<cfparam name="url.allowEdit" 					default="0">
<cfparam name="url.tree" 						default="Operational">
<cfparam name="url.systemfunctionid" 			default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.configsystemfunctionid" 		default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.mandateNo" 					default="">
<cfparam name="url.validateLogin" 				default="yes">
<cfparam name="url.date" 						default="#dateFormat(now(),client.dateformatshow)#">
<cfparam name="url.maxRowsDefault" 				default="600">
<cfparam name="url.printWindowSize" 			default="800">
<cfparam name="url.printWindowSizeChrome" 		default="800">
<cfparam name="url.showAllTopics"				default="SHOWALL">
<cfparam name="url.scope"						default="backoffice">

<!--- Define mandateno --->
<cfif trim(url.mandateNo) eq "">

	<cfquery name="getMandate" 
		datasource="AppsOrganization">
			SELECT *
			FROM   Ref_Mandate											
			WHERE  Mission = '#url.mission#'
			AND	   DateEffective  <= GETDATE()
			AND	   DateExpiration >= GETDATE()
	</cfquery>
	
	<cfif getMandate.recordCount gt 0>
		<cfset url.mandateNo = getMandate.MandateNo>
	</cfif>

</cfif>

<cfquery name="getMission" 
	datasource="AppsOrganization">
		SELECT 	*
		FROM 	Ref_Mission
		WHERE	Mission = '#url.mission#'
</cfquery>

<cfquery name="getMandate" 
	datasource="AppsOrganization">
		SELECT *
		FROM   Ref_Mandate											
		WHERE  Mission = '#url.mission#'
		AND	   MandateNo = '#url.mandateno#'
</cfquery>

<!--- Define start, end and current dates --->
<cfset vStartPickerDate = "">
<cfif trim(getMandate.dateEffective) neq "">
	<cfset vStartPickerDate = dateFormat(getMandate.dateEffective, 'yyyy-mm-dd')>
	<cfset vStartPickerDate = "#vStartPickerDate#">
</cfif>

<cfset vEndPickerDate = "">
<cfif trim(getMandate.dateExpiration) neq "">
	<cfset vEndPickerDate = dateFormat(getMandate.dateExpiration, 'yyyy-mm-dd')>
	<cfset vEndPickerDate = "#vEndPickerDate#">
</cfif>

<cfset dateValue = "">
<cf_dateConvert Value="#url.date#">
<cfset vCurrentDateYear = year(dateValue)>
<cfset vCurrentDateMonth = month(dateValue)>
<cfif len(vCurrentDateMonth) eq 1>
	<cfset vCurrentDateMonth = "0#vCurrentDateMonth#">
</cfif>
<cfset vCurrentDateDay = day(dateValue)>
<cfif len(vCurrentDateDay) eq 1>
	<cfset vCurrentDateDay = "0#vCurrentDateDay#">
</cfif>

<cfset vCurrentDateISO = "#vCurrentDateYear#-#vCurrentDateMonth#-#vCurrentDateDay#">

<!--- Define validation queries for default load and trees --->
<cfquery name="validateFunctionalTree" 
	datasource="AppsEmployee">
		SELECT 	A.*
		FROM	vwAssignment A
				INNER JOIN Organization.dbo.Organization O
					ON A.OrgUnitFunctional = O.OrgUnit
		WHERE	A.MissionOperational = '#url.mission#'
		AND		A.DateEffective <= '#vCurrentDateISO#'
		AND		A.DateExpiration >= '#vCurrentDateISO#'
		AND		A.AssignmentStatus IN ('0', '1')
		AND		A.Incumbency > 0
		AND 	A.Operational = 1
		AND		O.MandateNo = '#url.mandateno#'
		AND    	(O.DateExpiration <= '#getMandate.DateExpiration#' OR O.DateExpiration >= '#vCurrentDateISO#')	
		AND    	O.OrgUnitCode NOT LIKE '0000%'
</cfquery>

<cfquery name="validateDefaultLoad" 
	datasource="AppsEmployee">
		SELECT 	A.*
		FROM	vwAssignment A
				INNER JOIN Position P
					ON A.PositionNo = P.PositionNo
				INNER JOIN Organization.dbo.Organization O
					ON A.OrgUnitOperational = O.OrgUnit
		WHERE	A.MissionOperational = '#url.mission#'
		AND		A.DateEffective <= '#vCurrentDateISO#'
		AND		A.DateExpiration >= '#vCurrentDateISO#'
		AND		A.AssignmentStatus IN ('0', '1')
		AND		A.Incumbency > 0
		AND 	A.Operational = 1
		AND		O.MandateNo = '#url.mandateno#'
		AND    	(O.DateExpiration <= '#getMandate.DateExpiration#' OR O.DateExpiration >= '#vCurrentDateISO#')	
		AND    	O.OrgUnitCode NOT LIKE '0000%'
</cfquery>

<cfset vDefaultOrgUnit = "none">
<cfif validateDefaultLoad.recordCount lte url.maxRowsDefault>
	<cfset vDefaultOrgUnit = "all">
</cfif>

<!--- Start mobile application --->
<cf_mobile 
	appId="#url.appId#" 
	validateLogin="#url.validateLogin#" 
	printWindowSize="#url.printWindowSize#" 
	printWindowSizeChrome="#url.printWindowSizeChrome#"
	awesomeCheckbox="yes"
	datepicker="yes"
	customCSS="#session.root#/system/organization/orgTree/css/OrgTreeStyle.css">
	
	<cf_tl id="Staff profile" var="lblStaffProfile">
	<cf_tl id="Staff directory" var="lblStaffDirectory">
	<cf_tl id="This printout might take a while to complete.\n\nDo you want to continue ?" var="lblPrintListAck">
	
	<cf_systemScript>

	<cfoutput>
		<script>
			function doFlat(element)
			{
				if (element.checked)
				{
					flat = 1;
				}
				else
				{
					flat = 0;
				}
				var orgunittype = $('input[name=orgunittype]:checked').val();
				var orgunit = $('##orgunit').val();
				var postgrade = $('##postgrade').val();
				var functionno = $('##functionno').val();
				var buildingcode = $('##buildingcode').val();
				var locationcode = $('##locationcode').val();
				var nationality = $('##nationality').val();
				var functions = $.trim($('##functions').val());
				var employee = $.trim($('##employee').val());
				var referencedate = _mobileGetISODate('##referenceDatePicker');
				
				ptoken.navigate('#session.root#/system/organization/orgTree/OrgTreeDetail.cfm?id=#url.id#&showAllTopics=#url.showAllTopics#&mission=#url.mission#&mandateno=#url.mandateno#&systemfunctionid=#url.systemfunctionid#&configsystemfunctionid=#url.configsystemfunctionid#&orgunittype='+orgunittype+'&orgunit='+orgunit+'&postgrade='+postgrade+'&functionNo='+functionno+'&buildingcode='+buildingcode+'&locationcode='+locationcode+'&nationality='+nationality+'&referencedate='+referencedate+'&functions='+functions+'&employee='+employee+'&flat='+flat,'divDirectoryDetail');				
				
			} 
			
			function searchElement(v, closestElement, ev) {
				var keycode = (ev.keyCode ? ev.keyCode : ev.which);
				var vValue = $.trim(v).toLowerCase();

				//Cleanup value
				vValue = vValue.replace(/[àáâãäå]/g,"a").replace(/[éêëè]/g,"e").replace(/[íïîì]/g,"i").replace(/[óôöò]/g,"o").replace(/[úûùü]/g,"u");
				
				if (vValue != '') {
					if (keycode == '13') { 
						$('.clsListingContainer').hide();
						$('.clsSearchSpinner').show();
						$(closestElement).hide();
						
						setTimeout( function(){
							$('.searchable').each(function(){
								var vThisElement = $(this).closest(closestElement);
								var vThisValue = $(this).text().toLowerCase();
								vThisValue = vThisValue.replace(/[àáâãäå]/g,"a").replace(/[éêëè]/g,"e").replace(/[íïîì]/g,"i").replace(/[óôöò]/g,"o").replace(/[úûùü]/g,"u");
								
								if (vThisValue.indexOf(vValue) != -1) {
									vThisElement.show(function(){
										if (vThisElement.find('.panel-body').length > 0) {
											if (!vThisElement.find('.panel-body').is(':visible')) {
												vThisElement.find('.panel-heading').click();
											}
										}
									});
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

			function filterOnEnter(ev) {
				var keycode = (ev.keyCode ? ev.keyCode : ev.which);
				if (keycode == '13') { 
					$('.defaultFilterButton').trigger('click');
				}
			}
			
			function filterDirectory(filterType) {
				var orgunittype = $('input[name=orgunittype]:checked').val();
				var orgunit = $('##orgunit').val();
				var postgrade = $('##postgrade').val();
				var functionno = $('##functionno').val();
				var buildingcode = $('##buildingcode').val();
				var locationcode = $('##locationcode').val();
				var nationality = $('##nationality').val();
				var functions = $.trim($('##functions').val());
				var employee = $.trim($('##employee').val());
				var referencedate = _mobileGetISODate('##referenceDatePicker');
				
				ptoken.navigate('#session.root#/system/organization/orgTree/OrgTree'+filterType+'.cfm?id=#url.id#&showAllTopics=#url.showAllTopics#&mission=#url.mission#&mandateno=#url.mandateno#&systemfunctionid=#url.systemfunctionid#&configsystemfunctionid=#url.configsystemfunctionid#&orgunittype='+orgunittype+'&orgunit='+orgunit+'&postgrade='+postgrade+'&functionNo='+functionno+'&buildingcode='+buildingcode+'&locationcode='+locationcode+'&nationality='+nationality+'&referencedate='+referencedate+'&functions='+functions+'&employee='+employee,'divDirectoryDetail');
			}
			
			function showProfile(personno) {
				var referencedate = _mobileGetISODate('##referenceDatePicker');
				var orgunittype = $('input[name=orgunittype]:checked').val();
				
				ptoken.navigate('#session.root#/system/organization/orgTree/PersonProfileHeader.cfm?mission=#url.mission#&mandateno=#url.mandateno#&systemfunctionid=#url.systemfunctionid#&configsystemfunctionid=#url.configsystemfunctionid#&showAllTopics=#url.showAllTopics#&personno='+personno+'&referencedate='+referencedate+'&orgunittype='+orgunittype,'divProfileModalTitle');
				ptoken.navigate('#session.root#/system/organization/orgTree/PersonProfileBody.cfm?mission=#url.mission#&mandateno=#url.mandateno#&systemfunctionid=#url.systemfunctionid#&configsystemfunctionid=#url.configsystemfunctionid#&showAllTopics=#url.showAllTopics#&personno='+personno+'&referencedate='+referencedate+'&orgunittype='+orgunittype,'divProfileModalBody');
				$("##profileModal").modal('show');
			}
			
			function showPerson(personno) {
				ptoken.open('#session.root#/Staffing/Application/Employee/PersonView.cfm?ID='+personno, '_blank');
			}
			
			function toggleChildOrgUnit(id) {
				var vHierarchy = $('.clsHierarchyCode_'+id).html();
				$('.orgUnitContainer').each(function(){
					if ($(this).find('.clsHierarcyCode').text() != vHierarchy) {
						if ($(this).find('.clsHierarcyCode').text().indexOf(vHierarchy) == 0) {
							if ($(this).is(':visible')) {
								$(this).hide();
							} else {
								$(this).show();
							}
						}
					}
				});
			}
			
			function printProfile(printDirect) {
				$('.clsPrintHeader .clsPrintHeaderSubtitle').html('#lblStaffProfile#');
				___prosisMobileWebPrint(".clsPrintHeader, ##profileModal .modal-content", printDirect, "#session.root#/system/organization/orgTree/css/customPrint.css?ts=#getTickCount()#", "$('.clsPersonDetailsList .animated-panel').addClass('col-xs-6');");
			}
			
			function printList() {
				if ($('.personContainer').length > 0 || $('.orgUnitTopContainer').length > 0) {
					if (confirm('#lblPrintListAck#')) {
						$('.clsPrintHeader .clsPrintHeaderSubtitle').html('#lblStaffDirectory#');
						___prosisMobileWebPrint(".clsPrintHeader, .clsListingContainer", true, "#session.root#/system/organization/orgTree/css/customPrintList.css?ts=#getTickCount()#", "$('.personContainer').addClass('col-xs-6'); $('.personContainer .panel-footer .contact-stat').addClass('pull-left'); $('.orgUnitContainer').removeClass('panel-collapse'); $('.orgUnitContainer .panel-body').show(); $('.clsListingContainerRow').css('padding','5px'); $('.clsListingContainerRow').css('padding-left','15px'); $('.clsListingContainerRow').css('padding-right','15px'); $('.hpanel').css('margin-bottom','5px'); $('.panel-body').css('padding','8px');");
					}
				}
			}
			
			function doInitializeDatePicker(pSelector, pFormat, pDate, pStart, pEnd, pDefaultOrgUnit) {
				_mobileInitializeDatePicker(pSelector, pFormat, pDate, pStart, pEnd, function() {
					var referencedate = _mobileGetISODate(pSelector);
					window['_doInitializeDatePicker'] = function(){ filterDirectory('Detail'); };
					ptoken.navigate('#session.root#/system/organization/orgTree/getFiltersByDate.cfm?mission=#url.mission#&mandateNo=#url.mandateNo#&defaultOrgUnit='+pDefaultOrgUnit+'&referencedate='+referencedate,'divFiltersByDate', '_doInitializeDatePicker');
				});
			}

			function enlargeProfilePicture(selector) {
				var vHeight = parseInt($(selector).height());
				if (vHeight <= 120) {
					$(selector).css('height','350px').css('width','350px').removeClass('img-circle');
				} else {
					$(selector).css('height','120px').css('width','120px').addClass('img-circle');
				}
			}
			
		</script>
	</cfoutput>
	
	<cfoutput>
		<div class="clsPrintHeader" style="display:none;">
			<cfset url.missionName = getMission.MissionName>
			<cfinclude template="PrintHeader.cfm">
		</div>
	</cfoutput>
	
	<!-- Profile Modal -->
	<div id="profileModal" class="modal fade" role="dialog">
		<div class="modal-dialog" style="width:90%; margin-top:3%;">
			<!-- Profile Modal content-->
			<div class="modal-content">
				<div class="modal-header" style="padding-bottom:15px; padding-top:15px; background-color:#ECECEC; color:#FAFAFA;">
					<cfoutput>
						<cf_tl id="Close" var="1">
						<button type="button" class="close clsNoPrint" style="font-size:35px;" data-dismiss="modal" title="#lt_text#">&times;</button>
						<cf_tl id="Print profile" var="1">
						<a class="clsNoPrint pull-right" style="padding-right:10px;" title="#lt_text#">
							<i class="fa fa-print clsPrintProfileButton" onclick="printProfile(true);"></i>
						</a>
						<cf_tl id="Open complete profile in a new window" var="1">
						<a class="clsNoPrint pull-right" style="padding-right:10px;" title="#lt_text#">
							<cfif url.scope eq "backoffice">
								<i class="fa fa-external-link clsOpenProfileButton clsOpenStaffingProfile" onclick=""></i>
							</cfif>
						</a>
					</cfoutput>
					<h4 class="modal-title">
						<cfdiv id="divProfileModalTitle">
					</h4>
				</div>
				<div class="modal-body">
					<cfdiv id="divProfileModalBody">
				</div>
			</div>
		</div>
	</div>
	
	<cf_divscroll>
	
		<cfif url.showHeader eq "1">
			<cfoutput>
				<div class="row" style="padding:20px; background-color:##3498DB; color:##FAFAFA;">
					<div class="col-lg-12" style="font-size:150%; font-weight:bold;">#ucase(session.welcome)# #ucase(url.mission)#</div>
				</div>
			</cfoutput>
		</cfif>
		
		<div class="content animate-panel" style="padding-bottom:0px;">
	
		    <div class="row">
		        <div class="col-md-3 animated-panel zoomIn" style="animation-delay: 0.1s; position:fixed; max-height:100%; overflow-y:auto;">
					<cf_tl id="Filters" var="1">
					
					<cf_mobilePanel
						panelClass="panelFilters" 
						addContainer="0" 
						title="#lt_text#">
						
						<cfif validateFunctionalTree.recordCount gt 0>
						
							<div class="form-group">
		                        <div class="input-group">
									<div class="radio radio-info radio-inline">
										<input type="radio" id="orgunittype1" value="Operational" name="orgunittype" checked>
										<label for="orgunittype1"> <cf_tl id="Operational"> </label>
									</div>
									<div class="radio radio-info radio-inline">
										<input type="radio" id="orgunittype2" value="Functional" name="orgunittype">
										<label for="orgunittype2"> <cf_tl id="Functional"> </label>
									</div>
		                        </div>
		                    </div>
							
						<cfelse>
						
							<input type="radio" id="orgunittype1" value="Operational" name="orgunittype" style="display:none;" checked>
						
						</cfif>
						
						<cfset vShowReferenceDate = "display:none;">
						<cfif url.scope eq "backoffice">
							<cfset vShowReferenceDate = "">
						</cfif>
						<div class="form-group" style="<cfoutput>#vShowReferenceDate#</cfoutput>">
	                        <label class="control-label"><cf_tl id="Reference Date"> (<cfoutput>#client.dateformatshow#</cfoutput>) :</label>
	                        <div class="date">
								<div class="input-group input-append date" id="referenceDatePicker">
									<input type="text" class="form-control" name="date" readonly />
									<span class="input-group-addon add-on"><span class="fa fa-calendar" style="cursor:pointer;"></span></span>
								</div>
							</div>
							<div class="text-muted" style="text-align:right; font-size:85%;">
								<cfoutput>
									#getMandate.Description# : <cfif getMandate.dateExpiration eq ""><cf_tl id="Since"> </cfif>#lsDateFormat(getMandate.dateEffective,client.dateFormatShow)#<cfif getMandate.dateExpiration neq ""> - #lsDateFormat(getMandate.dateExpiration,client.dateFormatShow)#</cfif>
								</cfoutput>
							</div>
	                    </div>
	
	                    <cfdiv id="divFiltersByDate">
						
						<div class="row" style="padding:10px;">
							<cfoutput>
								<div class="col-lg-6 col-md-6 col-sm-6" style="padding-bottom:5px;">
									<cf_tl id="Listing" var="1">
									<button class="btn btn-info btn-block btn-sm defaultFilterButton" onclick="filterDirectory('Detail');" title="#lt_text#">
										<i class="fa fa-th" style="font-size:175%;"></i>
										<span class="visible-lg visible-sm visible-xs" style="text-transform:capitalize;">
											#lcase(lt_text)#
										</span>
									</button>
								</div>
								<div class="col-lg-6 col-md-6 col-sm-6" style="padding-bottom:5px;">
									<cf_tl id="Tree" var="1">
									<button class="btn btn-info btn-block btn-sm" onclick="filterDirectory('Chart');" title="#lt_text#">
										<i class="fa fa-sitemap" style="font-size:175%;"></i>
										<span class="visible-lg visible-sm visible-xs" style="text-transform:capitalize;">
											#lcase(lt_text)#
										</span>
									</button>
								</div>
							</cfoutput>
						</div>
						
					</cf_mobilePanel>
					
				</div>
		        <div class="col-md-9 col-lg-offset-3 animated-panel zoomIn" style="animation-delay: 0.2s;">
		            <div class="row">
		                <div class="col-lg-12 animated-panel zoomIn" style="animation-delay: 0.3s;">
							<div class="content animate-panel">
								<cfdiv id="divDirectoryDetail" bind="url:#session.root#/system/organization/orgTree/OrgTreeInstructions.cfm">
						    </div>
		                </div>
		            </div>
		        </div>
		    </div>
	
		</div>
	
	</cf_divscroll>
	
	<cfset AjaxOnLoad("function(){ doInitializeDatePicker('##referenceDatePicker', '#client.dateFormatShow#', '#vCurrentDateISO#', '#vStartPickerDate#', '#vEndPickerDate#', '#vDefaultOrgUnit#'); }")>
	
</cf_mobile>