/*
 * Copyright © 2025 Promisan B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
//Filter list
function filterDataList(wo, dte) {
	var vFilterData = $('#txtSearch').val();
	//reload data if necessary
	if (globalDataList == '') {
		if (checkInternetConnection()) {
			showWait(languageTxtLoading);
		    $.getJSON(window['parameterDataService'] + '?method=getActionsByIdDate&callback=?&workOrderId=' + wo + '&date='+ dte, function(data) {
				emptyDataList();
				fillDataList(data);
		        doFilterDataList(vFilterData);
		    })
			.error(ajaxError)
			.complete(function(){ hideWait(); });
		}
	}else{
		doFilterDataList(vFilterData);
	}
}

//Apply filter
function doFilterDataList(data) {
	var textFound = false;
	//filter
	if (data == '') {
		$globalVisible.css('display', 'block');
	}else{
		$globalVisible.css('display', 'none');
		$($globalVisible).each(function() {
			textFound = false;
			$(this).find('.clsFilterableText').each(function() {
				if ($(this).html().toLowerCase().indexOf(data.toLowerCase()) > -1) {
					textFound = true;
					return 0;
				}
			});
			if (textFound) { $(this).css('display', 'block'); }
		});
	}
}

//Building Class filters
function buildClassFilters() {
	var vText = '';
	$('#listingMenuLevel1').html('');

	//get distinct classes
	$.coldfusion.eachRow(globalDataList, function(rowIndex){
		if (!globalClassObj[this.CODE]) {
			globalClassObj[this.CODE] = this.DESCRIPTION;
		}
	});
	
	$.each(globalClassObj, function(code, description){
		vText = '<div id="divDataFilterLevel1_' + code + '" class="clsDivFilterListing">'					
					+'<div class="clsCheckbox" id="cbDataFilterLevel1_' + code + '">'
						+'<input type="Hidden" id="dataFilterLevel1_' + code + '" value="true">'
						+'<table>'
							+'<tr>'
								+'<td>'
									+'<img src="Images/' + window['parameterIconSet'] + '/check.png">'
								+'</td>'
								+'<td>'
									+'<span class="clsFilterText">' + description + '</span>'
								+'</td>'
							+'</tr>'
						+'</table>'
					+'</div>'
				+'</div>'
				;
		$('#listingMenuLevel1').append(vText);
		
		//Add filter click event
		$('#cbDataFilterLevel1_' + code + ' img').on(globalClickEvent, function() {
			var originalWidth1 = $('#verticalSubMenu1').width();
			var originalWidth2 = $('#verticalSubMenu2').width();
			var originalWidth3 = $('#verticalSubMenu3').width();
			
			//Filtering
			if ($('#dataFilterLevel1_' + code).val() == 'false') {
				$('#dataFilterLevel1_' + code).val('true');
				$('#cbDataFilterLevel1_' + code + ' img').attr('src','Images/' + window['parameterIconSet'] + '/check.png');
				$('.clsFilterableAreaClass_' + code).css('display', 'block');
			}else{
				$('#dataFilterLevel1_' + code).val('false');
				$('#cbDataFilterLevel1_' + code + ' img').attr('src','Images/' + window['parameterIconSet'] + '/uncheck.png');
				$('.clsFilterableAreaClass_' + code).css('display', 'none');
			}
			
			checkAllHiddenCheckboxes();
			updateHourFilter();
			
			$globalVisible = $('.clsMainListingElementContainer:visible');
			$('#txtSearch').val('');
			$('#verticalSubMenu1').width(originalWidth1);
			$('#verticalSubMenu2').width(originalWidth2);
			$('#verticalSubMenu3').width(originalWidth3);
			
		});
		
	});

}


//Check hidden filters
function checkAllHiddenCheckboxes() {
	$('.clsDivFilterListing:hidden').each(function() {
		$(this).find('.clsCheckbox').each(function() {
			$(this).find('img').attr('src','Images/' + window['parameterIconSet'] + '/check.png');
			$(this).find('[type="Hidden"]').val('true');
		});
	});
}

//Update hour filter
function updateHourFilter() {
	$.coldfusion.eachRow(globalDataList, function(rowIndex){
		var vId = this.HOURDATETIMEPLANNING.replace(/:/g,"_");
		if($('#dataFilterLevel1_'+this.CODE).is(':checked') && $('#dataFilterLevel2_'+this.REFERENCE).is(':checked')) {
			$('#divDataFilterLevel3_' + vId).css('display', 'block');
		}
	});
}

//building area filters
function buildAreaFilters() {
	var vText = '';
	$('#listingMenuLevel2').html('');

	//get distinct areas
	$.coldfusion.eachRow(globalDataList, function(rowIndex){
		if (!globalAreaObj[this.REFERENCE]) {
			globalAreaObj[this.REFERENCE] = this.REFERENCEDESCRIPTION;
		}
	});
	
	$.each(globalAreaObj, function(code, description){
		vText = '<div id="divDataFilterLevel2_' + code + '" class="clsDivFilterListing">'
					+'<div class="clsCheckbox" id="cbDataFilterLevel2_' + code + '">'
						+'<input type="Hidden" id="dataFilterLevel2_' + code + '" value="true">'
						+'<table>'
							+'<tr>'
								+'<td>'
									+'<img src="Images/' + window['parameterIconSet'] + '/check.png">'
								+'</td>'
								+'<td>'
									+'<span class="clsFilterText">' + description + '</span>'
								+'</td>'
							+'</tr>'
						+'</table>'
				+'</div>'
				;
		$('#listingMenuLevel2').append(vText);
		
		//Add filter click event
		$('#cbDataFilterLevel2_' + code + ' img').on(globalClickEvent, function() {			
			var originalWidth2 = $('#verticalSubMenu2').width();
			var originalWidth3 = $('#verticalSubMenu3').width();

			//Filtering
			if ($('#dataFilterLevel2_' + code).val() == 'false') {
				$('#dataFilterLevel2_' + code).val('true');
				$('#cbDataFilterLevel2_' + code + ' img').attr('src','Images/' + window['parameterIconSet'] + '/check.png');
				$('.clsFilterableArea_' + code).css('display', 'block');
			}else{
				$('#dataFilterLevel2_' + code).val('false');
				$('#cbDataFilterLevel2_' + code + ' img').attr('src','Images/' + window['parameterIconSet'] + '/uncheck.png');
				$('.clsFilterableArea_' + code).css('display', 'none');
			}
			
			checkAllHiddenCheckboxes();
			updateHourFilter();
			
			$globalVisible = $('.clsMainListingElementContainer:visible');
			$('#txtSearch').val('');
			$('#verticalSubMenu2').width(originalWidth2);
			$('#verticalSubMenu3').width(originalWidth3);
		});
		
	});
	
	//Add AreaClass class
	$.coldfusion.eachRow(globalDataList, function(rowIndex){
		if (globalAreaObj[this.REFERENCE]) {
			$('#divDataFilterLevel2_' + this.REFERENCE).addClass('clsFilterableAreaClass_' + this.CODE);
		}
	});

}


//build hour filters
function buildHourFilters() {
	var vText = '';
	$('#listingMenuLevel3').html('');
	
	//get distinct hours
	$.coldfusion.eachRow(globalDataList, function(rowIndex){
		var vId = this.HOURDATETIMEPLANNING.replace(/:/g,"_");
		if (!globalHourObj[vId]) {
			globalHourObj[vId] = this.HOURDATETIMEPLANNING;
		}
	});
	
	$.each(orderObject(globalHourObj), function(code, description){
		var vId = code.replace(/:/g,"_");
		vText = '<div id="divDataFilterLevel3_' + vId + '" class="clsDivFilterListing">'
					+'<div class="clsCheckbox" id="cbDataFilterLevel3_' + vId + '">'
						+'<input type="Hidden" id="dataFilterLevel3_' + vId + '" value="true">'
						+'<table>'
							+'<tr>'
								+'<td>'
									+'<img src="Images/' + window['parameterIconSet'] + '/check.png">'
								+'</td>'
								+'<td>'
									+'<span class="clsFilterText">' + description + '</span>'
								+'</td>'
							+'</tr>'
						+'</table>'
					+'</div>'
				+'</div>'
				;
		$('#listingMenuLevel3').append(vText);
		
		//Add filter click event
		$('#cbDataFilterLevel3_' + vId + ' img').on(globalClickEvent, function() {
			var originalWidth3 = $('#verticalSubMenu3').width();

			//Filtering
			if ($('#dataFilterLevel3_' + vId).val() == 'false') {
				$('#dataFilterLevel3_' + vId).val('true');
				$('#cbDataFilterLevel3_' + vId + ' img').attr('src','Images/' + window['parameterIconSet'] + '/check.png');
				$('.clsFilterableHour_' + vId).css('display', 'block');
			}else{
				$('#dataFilterLevel3_' + vId).val('false');
				$('#cbDataFilterLevel3_' + vId + ' img').attr('src','Images/' + window['parameterIconSet'] + '/uncheck.png');
				$('.clsFilterableHour_' + vId).css('display', 'none');
			}
			
			$globalVisible = $('.clsMainListingElementContainer:visible');
			$('#txtSearch').val('');
			$('#verticalSubMenu3').width(originalWidth3);
			
		});
		
	});	
	
	//Add AreaClass and Area classes
	$.coldfusion.eachRow(globalDataList, function(rowIndex){
		var vId = this.HOURDATETIMEPLANNING.replace(/:/g,"_");
		if (globalHourObj[vId]) {
			$('#divDataFilterLevel3_' + vId).addClass('clsFilterableAreaClass_' + this.CODE);
			$('#divDataFilterLevel3_' + vId).addClass('clsFilterableArea_' + this.REFERENCE);
		}
	});
	
}

//build level 4 filters
function buildLevel4Filters() {

	$('#cbDataFilterLevel4_Completed img').on(globalClickEvent, function() {
		//Filtering
		if ($('#dataFilterLevel4_Completed').val() == 'false') {
			$('#dataFilterLevel4_Completed').val('true');
			$('#cbDataFilterLevel4_Completed img').attr('src','Images/' + window['parameterIconSet'] + '/check.png');
			$globalVisible.filter('.clsFilterableCompleted').css('display', 'block');
		}else{
			$('#dataFilterLevel4_Completed').val('false');
			$('#cbDataFilterLevel4_Completed img').attr('src','Images/' + window['parameterIconSet'] + '/uncheck.png');
			$globalVisible.filter('.clsFilterableCompleted').css('display', 'none');
		}
	});
	
	$('#cbDataFilterLevel4_NotCompleted img').on(globalClickEvent, function() {
		//Filtering
		if ($('#dataFilterLevel4_NotCompleted').val() == 'false') {
			$('#dataFilterLevel4_NotCompleted').val('true');
			$('#cbDataFilterLevel4_NotCompleted img').attr('src','Images/' + window['parameterIconSet'] + '/check.png');
			$globalVisible.filter('.clsFilterableNotCompleted').css('display', 'block');
		}else{
			$('#dataFilterLevel4_NotCompleted').val('false');
			$('#cbDataFilterLevel4_NotCompleted img').attr('src','Images/' + window['parameterIconSet'] + '/uncheck.png');
			$globalVisible.filter('.clsFilterableNotCompleted').css('display', 'none');
		}
	});
	
	$('#cbDataFilterLevel4_WithPictures img').on(globalClickEvent, function() {
		//Filtering
		if ($('#dataFilterLevel4_WithPictures').val() == 'false') {
			$('#dataFilterLevel4_WithPictures').val('true');
			$('#cbDataFilterLevel4_WithPictures img').attr('src','Images/' + window['parameterIconSet'] + '/check.png');
			$globalVisible.filter('.clsFilterableWithPictures').css('display', 'block');
		}else{
			$('#dataFilterLevel4_WithPictures').val('false');
			$('#cbDataFilterLevel4_WithPictures img').attr('src','Images/' + window['parameterIconSet'] + '/uncheck.png');
			$globalVisible.filter('.clsFilterableWithPictures').css('display', 'none');
		}
	});
	
	$('#cbDataFilterLevel4_WithoutPictures img').on(globalClickEvent, function() {
		//Filtering
		if ($('#dataFilterLevel4_WithoutPictures').val() == 'false') {
			$('#dataFilterLevel4_WithoutPictures').val('true');
			$('#cbDataFilterLevel4_WithoutPictures img').attr('src','Images/' + window['parameterIconSet'] + '/check.png');
			$globalVisible.filter('.clsFilterableWithoutPictures').css('display', 'block');
		}else{
			$('#dataFilterLevel4_WithoutPictures').val('false');
			$('#cbDataFilterLevel4_WithoutPictures img').attr('src','Images/' + window['parameterIconSet'] + '/uncheck.png');
			$globalVisible.filter('.clsFilterableWithoutPictures').css('display', 'none');
		}
	});
	
}

function setSelectAll() {

	//Remove previous behavior
	$('#cbDataFilter_All').off(globalClickEvent);
	$('#dataFilter_All').val('true');
	$('#cbDataFilter_All img').attr('src','Images/' + window['parameterIconSet'] + '/check.png');
	
	//Add select all event
	$('#cbDataFilter_All').on(globalClickEvent, function() {
		var valCompare = '';

		$('#menuContainer').css('display','block');
		$('.clsDivFilterListingContainer').css('display','block');
		$('#menuContainer').css('opacity','1');
		$('.clsDivFilterListingContainer').css('opacity','1');
		
		if ($('#dataFilter_All').val() == 'false') {
			$('#dataFilter_All').val('true');
			$('#cbDataFilter_All img').attr('src','Images/' + window['parameterIconSet'] + '/check.png');
			valCompare = 'false';
		}else{
			$('#dataFilter_All').val('false');
			$('#cbDataFilter_All img').attr('src','Images/' + window['parameterIconSet'] + '/uncheck.png');
			valCompare = 'true';
		}
		
		$.each(globalClassObj, function(i, k){
			if ($('#dataFilterLevel1_' + i).val() == valCompare) {
				$('#cbDataFilterLevel1_' + i + " img").trigger(globalClickEvent);
			}
		});
		
	}); 
}

function filterActionClass(action) {
	if ($('.clsFilterableActionClass_' + action).is(':visible')) {
		$('.clsFilterableActionClass_' + action).css('display', 'none');
	}else{
		$('.clsFilterableActionClass_' + action).css('display', 'block');
	}
	$globalVisible = $('.clsMainListingElementContainer:visible');
}

//Load filters
function loadFilters() {
	
	//Initializing objects
	globalClassObj = {};
	globalAreaObj = {};
	globalHourObj = {};
	
	//Building filters
	buildClassFilters();
	buildAreaFilters();
	buildHourFilters();
	buildLevel4Filters();
	
	//Setting visible elements
	$globalVisible = $('.clsMainListingElementContainer:visible');
	
	//Set select all behavior
	setSelectAll();
	
}
