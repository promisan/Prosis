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
//Get customer data from server
function getAndFillCustomerList() {
	if (checkInternetConnection()) {
		var vSession = '';
		if (window.localStorage) { 
			vSession = window.localStorage.getItem("hostSessionId"); 
		}
		
		showWait(languageTxtLoading);
	    $.getJSON(window['parameterDataService'] + '?method=getCustomersWorkOrdersByUser&callback=?&hostSessionId='+vSession+'&mission='+window['parameterMission'], function(customerData) {
			//Select first workOrder of the list
			$.coldfusion.eachRow(customerData, function(rowIndex){
				window['parameterSelectedWorkOrder'] = this.WORKORDERID;
				return false;
			});
			
			emptyCustomerList();
	        fillCustomerList(customerData);
			displayCriteria();
			getAndFillDataList(window['parameterSelectedWorkOrder'], globalISOSelectedDate);
	    })
		.error(function(request, type, errorThrown){
			alert(errorThrown);
			ajaxError(request, type, errorThrown);
			if (window.localStorage) { window.localStorage.removeItem("hostSessionId"); }
			hideWait();
			$('#modalLogin').css('display', 'block');
		});
	}
}

//Get Actions data from server
function getAndFillDataList(wo, dte) {
	if (checkInternetConnection()) {
		showWait(languageTxtLoading);
	    $.getJSON(window['parameterDataService'] + '?method=getActionsByIdDate&callback=?&workOrderId=' + wo + '&date=' + dte, function(data) {
			emptyDataList();
	        getPicturesList(wo, dte, data);
	    })
		.error(ajaxError);
	}
}

//Get pictures data from server
function getPicturesList(wo, dte, data) {
	if (checkInternetConnection()) {
		var vSession = '';
		if (window.localStorage.getItem("hostSessionId")) { 
			vSession = window.localStorage.getItem("hostSessionId"); 
		}
		
	    $.getJSON(window['parameterDataService'] + '?method=getPicturesByWorkOrderDate&callback=?&workOrderId=' + wo + '&date=' + dte + '&hostSessionId=' + vSession, function(picturesData) {
			fillPicturesList(picturesData);
			getPersonsList(wo, dte, data);
	    })
		.error(ajaxError);
	}
}

//Get persons data from server
function getPersonsList(wo, dte, data) {
	if (checkInternetConnection()) {
	    $.getJSON(window['parameterDataService'] + '?method=getPersonsByWorkOrderDate&callback=?&workOrderId=' + wo + '&date=' + dte, function(personsData) {
			fillPersonsList(personsData);
			fillDataList(data);
			loadFilters();
			displayCriteria();
			applyStyle();
			if (window['parameterFilterToCurrentHour'] == 1) {
				filterToCurrentHour();
			}
			//deselectAllFilters();
			applyLanguage(window['parameterApplicationLanguage']);
			
			//Adding custom behavior
			if (window['parameterCustomServerBehavior'] == 1) {
				customAddServerBehavior();
			}
			
			//Hide wait
			hideWait(); 
	    })
		.error(ajaxError)
		.complete(function(){});
	}
}

//Clear actions list
function emptyDataList() {
	$('#listing').html('');
}

//Clear customer list
function emptyCustomerList() {
	$('#customerContainer').html('');
}

//Fill actions list
function fillDataList(data) {
	var vText = '';
	var vPictures = '';
	var vPersons = '';
	var vAdd = '';
	var vDateTimeActual = '';
	var vDisplayAdd = '';
	var vCurrentAction = '';
	var vCompletedImage = '';
	var vCompletedClass = '';
	var vCompletedText = '';
	var vTextDateCompleted = '';
	var vRowCount = 0;
	var currentEmployeePicture = '';
	var defaultPicture = '../../../System/Mobile/Images/no-picture.png';
	var currentEmployeeErrorPicture = '';
	var vPreviousClass = '';
	var vPreviousDomain = '';
	var vPreviousArea = '';
	globalDataList = data;
	$('#mainListing').html('');
	
	$.coldfusion.eachRow(globalDataList, function( rowIndex ){
		
		vCompletedImage = 'completed.png';
		vCompletedClass = 'clsElementCompleted';
		vCompletedText = languageTxtCompleted;
		vText = '';
		
		if (this.COMPLETED == 0) {
			vCompletedImage = 'notCompleted.png';
			vCompletedClass = 'clsElementNotCompleted';
			vCompletedText = languageTxtNotCompleted;
		}
		
		//get pictures
		vCurrentAction = this.WORKACTIONID;
		vPictures = '';
		$.coldfusion.eachRow(globalPicturesList, function(picIndex){
			if (this.REFERENCE.toUpperCase() == vCurrentAction.toUpperCase()) {
				
				vPictures = vPictures + '<div class="clsActionDetailPictureContainer" id="actionDetailPictureImage_'+this.ATTACHMENTID+'">'
								+'<img class="clsImgActionDetailPicture" id="imgActionDetailPicture_'+this.ATTACHMENTID+'" src="'+defaultPicture+'" title="' + this.ATTACHMENTMEMO + '" on'+globalClickEvent+'="showPicture(\'' + this.ATTACHMENTID + '\', \'' + window['parameterDocumentRoot'] + this.PICTUREPATH + '\', \'' + this.ATTACHMENTMEMO + '\', \'' + languageTxtUploadedBy + ': ' + this.OFFICERFIRSTNAME + ' ' + this.OFFICERLASTNAME + ' @ ' + formatToAppDate(this.YEARCREATED, this.MONTHCREATED, this.DAYCREATED) + ' ' + this.HOURCREATED + '\');">'
								+'<script>setImageIfExist(\''+window['parameterDocumentRoot'] + this.PICTUREPATH+'\',\''+defaultPicture+'\',\'#imgActionDetailPicture_'+this.ATTACHMENTID+'\');</script>';
				if (this.ALLOWREMOVE > 0) {
					vPictures = vPictures +'<img src="Images/' + window['parameterIconSet'] + '/delete.png" class="clsRemoveActionDetailPicture" on'+globalClickEvent+'="removeActionPicture(\'' + this.ATTACHMENTID + '\');"/>';
				}
				vPictures = vPictures +'</div>';
			}
		});
		
		//get persons
		vCurrentAction = this.WORKACTIONID;
		vPersons = '';
		currentEmployeePicture = '';
		currentEmployeeErrorPicture = '';
		vText = '';
		$.coldfusion.eachRow(globalPersonsList, function(perIndex){
			if (this.WORKACTIONID.toUpperCase() == vCurrentAction.toUpperCase()) {
				currentEmployeePicture = window['parameterDocumentRoot'] + 'EmployeePhoto/' + this.INDEXNO + '.jpg';
				currentEmployeeErrorPicture = '../../../System/Mobile/Images/no-picture-male.png';
				if (this.GENDER.toUpperCase() == 'F') {
					currentEmployeeErrorPicture = '../../../System/Mobile/Images/no-picture-female.png';
				}
			
				vPersons = vPersons
						+'<div align="center" class="clsPersonPictureBox clearfix">'
							+'<img src="../../../System/Mobile/Images/no-picture-male.png" class="clsPersonPicture_'+this.PERSONNO+'" on'+globalClickEvent+'="showProfile(\'' + this.PERSONNO + '\');">'
							+'<script>setImageIfExist(\''+currentEmployeePicture+'\',\''+currentEmployeeErrorPicture+'\',\'.clsPersonPicture_'+this.PERSONNO+'\');</script>'
							+'<div class="clsPersonPictureName clsFilterableText">' + this.FIRSTNAME + ' ' + this.LASTNAME + ' (' + this.ISACTOR + ')</div>'
						+'</div>';
			}
		});
		
		//Add pictures
		vAdd = '';
		vDisplayAdd = 'visibility:hidden;';
		if (window['parameterIsCordovaEnabled'] == 1) { vDisplayAdd = 'visibility:visible;'; }
		vAdd = '<div class="clsAddBoxContainer" style="' + vDisplayAdd + '">'
					+'<div class="clsAddBox">'
						+'<img src="Images/' + window['parameterIconSet'] + '/add.png" class="clsImgAddDetails" title="' + languageTxtAddDetails + '" on'+globalClickEvent+'="showAddDetails(\'' + this.WORKACTIONID + '\');">'
					+'</div>'
				+'</div>';
				
		//Completed
		vDateTimeActual = '';
		vTextDateCompleted = '';
		if (this.DATETIMEACTUAL != null) {
			if (this.DATEDATETIMEACTUAL != this.DATEDATETIMEPLANNING) {
				vTextDateCompleted = formatToAppDate(this.YEARDATETIMEACTUAL, this.MONTHDATETIMEACTUAL, this.DAYDATETIMEACTUAL) + ' @ ';
			}
			vTextDateCompleted = vTextDateCompleted + this.HOURDATETIMEACTUAL
			vDateTimeActual = '<div class="clsFilterableText" style="font-weight:bold; font-style:italic; font-size:125%;" id="dateTimeActual_' + this.WORKACTIONID + '"><label class="clsTxtCompleted">' + languageTxtCompleted + '</label>: ' + vTextDateCompleted + '</div>';
		}else{
			vDateTimeActual = '<div class="clsFilterableText" style="font-weight:bold; font-style:italic; font-size:125%;" id="dateTimeActual_' + this.WORKACTIONID + '"><label class="clsTxtNotCompleted">' + languageTxtNotCompleted + '</label></div>';
		}
		
		if (vPreviousClass != this.ACTIONCLASS) {
			vText = vText + '<div class="clsMainListingElementGroup clsContainerGroupClass"> <span on'+globalClickEvent+'="filterActionClass(\''+this.ACTIONCLASS+'\');">' + this.ACTIONDESCRIPTION + '</span></div>';
		}
		
		vText = vText + '<div id="mainListingElementContainer_' + this.WORKACTIONID + '" class="clsMainListingElementContainer">';
		
		if (vPreviousDomain != this.CODE) {
			vText = vText + '<div class="clsMainListingElementGroup clsContainerGroupDomain">' + this.DESCRIPTION + '</div>';
		}
		if (vPreviousArea != this.REFERENCE) {
			vText = vText + '<div class="clsMainListingElementGroup clsContainerGroupArea">' + this.REFERENCE + ' - ' + this.REFERENCEDESCRIPTION + '</div>';
		}
		
		
		vText = vText + '<div class="clsHourBox clearfix" id="hourBox_' + this.WORKACTIONID + '">'
						+	'<img id="dateTimeActualImage_' + this.WORKACTIONID + '" src="Images/' + window['parameterIconSet'] + '/' + vCompletedImage + '" class="' + vCompletedClass + '" title="' + vCompletedText + '" on'+globalClickEvent+'="completeAction(' + this.COMPLETED + ', \'' + this.WORKACTIONID + '\');">'
						+ 	'<span>'+this.HOURDATETIMEPLANNING+'<br></span>'
					+'</div>'
		
					+'<div class="clsMainListingElement clearfix">'
					
						//Add button
						+ vAdd
						
						//Person pictures
						+'<div class="clsPersonPictureBoxContainer clearfix">'
							+ vPersons
						+'</div>'
						
						//Memo
						+'<div class="clsDescriptionBox">'
							+ vDateTimeActual
							+ '<div class="clsFilterableText" style="font-weight:bold; font-size:125%;">' + this.REFERENCE + ' - ' + this.REFERENCEDESCRIPTION + '</div>'
							+ '<div class="clsFilterableText" style="font-weight:bold; font-size:125%;">' + this.ACTIONCLASSDESCRIPTION + '</div>'
							+ '<div class="clsFilterableText" style="font-weight:bold; font-size:125%;">' + this.DESCRIPTION + '</div>'
							+ '<div class="clsFilterableText" style="font-size:125%;">'
								+ '<table>'
									+ '<tr>'
										+ '<td valign="top">'
											+ '<img src="Images/' + window['parameterIconSet'] + '/' + 'edit.png" id="imgEditActionMemo_'+this.WORKACTIONID+'" class="clsImgEditActionMemo" on'+globalClickEvent+'="editActionMemo(\''+this.WORKACTIONID + '\', \'' + this.ACTIONMEMO + '\');">'
										+ '</td>'
										+ '<td>'
											 + '<div id="actionDetailMemo_'+this.WORKACTIONID+'">' + this.ACTIONMEMO + '</div>'
										+ '</td>'
									+ '</tr>'
								+ '</table>'
							+ '</div>'
						+'</div>'
						
						//Action Pictures
						+'<div id="actionDetailPictureContainer_' + this.WORKACTIONID + '" class="clsActionDetailPictureBox">'
							+ vPictures
						+'</div>'
						
					+'</div>'
				+'</div>';

		$('#mainListing').append(vText);
		
		vPreviousClass = this.ACTIONCLASS;
		vPreviousDomain = this.CODE;
		vPreviousArea = this.REFERENCE;
		
	});	
	
	//Add AreaClass and Area classes
	$.coldfusion.eachRow(globalDataList, function(rowIndex){
		var vHourId = this.HOURDATETIMEPLANNING.replace(/:/g,"_");
		$('#mainListingElementContainer_' + this.WORKACTIONID).addClass('clsFilterableActionClass_' + this.ACTIONCLASS);
		$('#mainListingElementContainer_' + this.WORKACTIONID).addClass('clsFilterableAreaClass_' + this.CODE);
		$('#mainListingElementContainer_' + this.WORKACTIONID).addClass('clsFilterableArea_' + this.REFERENCE);
		$('#mainListingElementContainer_' + this.WORKACTIONID).addClass('clsFilterableHour_' + vHourId);
		
		if(this.COMPLETED == 1) {
			$('#mainListingElementContainer_' + this.WORKACTIONID).addClass('clsFilterableCompleted');
		}else{
			$('#mainListingElementContainer_' + this.WORKACTIONID).addClass('clsFilterableNotCompleted');
		}
		
		if(this.PICTURES == 0) {
			$('#mainListingElementContainer_' + this.WORKACTIONID).addClass('clsFilterableWithoutPictures');
		}else{
			$('#mainListingElementContainer_' + this.WORKACTIONID).addClass('clsFilterableWithPictures');
		}
	});
	
	//Add removing method to each picture
	/*
	$.coldfusion.eachRow(globalPicturesList, function(picIndex2){
		var timeOutId = 0;
		var currentAttachmentId = this.ATTACHMENTID;
		
		if ($('#imgActionDetailPicture_'+currentAttachmentId).length == 1) {
			$('#imgActionDetailPicture_'+currentAttachmentId).on(globalClickEvent, function() {
			    timeOutId = setTimeout(function() { 
					if(confirm(languageTxtRemovePicture)) {
						alert(currentAttachmentId);
					} 
				}, 2000);
			}).bind(globalClickOutEvent, function() {
			    clearTimeout(timeOutId);
			});
		}
	});
	*/

}

//Fill customer list
function fillCustomerList(data) {
	var currentCustomer = '';
	var vText = "";
	var isThisChecked = "";
	globalCustomerList = data;
	globalParentCustomerObj = {};
	globalCustomerObj = {};
	
	//Clear customer list
	$('#customerContainer').html('');
		
	//get distinct parentCustomers
	$.coldfusion.eachRow(globalCustomerList, function(rowIndex){
		if (!globalParentCustomerObj[this.PARENTCUSTOMERID]) {
			globalParentCustomerObj[this.PARENTCUSTOMERID] = this.PARENTCUSTOMER;
		}
	});
	
	//get distinct customers
	$.coldfusion.eachRow(globalCustomerList, function(rowIndex){
		if (!globalCustomerObj[this.CUSTOMERID]) {
			globalCustomerObj[this.CUSTOMERID] = this.CUSTOMERNAME;
		}
	});
	
	$.each(globalParentCustomerObj, function (idParent, nameParent) {
		
		//Parent div
		vText = '<div class="clsDivListing" id="parent_' + idParent + '">' 
				+'<img src="Images/' + window['parameterIconSet'] + '/client.png" class="clsBigInlineIcon">'
				+'&nbsp;<span class="clsBigText">' + nameParent + '</span>'
				+'</div>'
				;
		
    	$('#customerContainer').append(vText);
		
		$.coldfusion.eachRow(globalCustomerList, function(rowIndex){
			if (this.PARENTCUSTOMERID == idParent) {
			
				if ($('#parent_'+this.PARENTCUSTOMERID).find( $("#customer_"+this.CUSTOMERID) ).length == 0) {
				
					//Customer div
					vText = '<div class="clsDivListing" id="customer_' + this.CUSTOMERID + '">'
							+'<img src="Images/' + window['parameterIconSet'] + '/place.png" class="clsBigInlineIcon">'
							+'&nbsp;<span class="clsMediumText">' + this.CUSTOMERNAME + '</span>'
							+'</div>'
							;
							
					$('#parent_'+this.PARENTCUSTOMERID).append(vText);
					
					currentCustomer = this.CUSTOMERID;
					
					$.coldfusion.eachRow(globalCustomerList, function(rowIndex2){
						if ($('#customer_'+this.CUSTOMERID).find( $("#workOrder_"+this.WORKORDERID) ).length == 0) {
							if (this.PARENTCUSTOMERID == idParent && this.CUSTOMERID == currentCustomer) {
							
								//Check the default workorder
								isThisChecked = "";
								if (this.WORKORDERID.toLowerCase() == window['parameterSelectedWorkOrder'].toLowerCase()) {
									isThisChecked = "checked";
								}
								
								//WorkOrder div
								vText = '<div class="clsDivListing" id="workOrder_' + this.WORKORDERID + '">'
										+'<table>'
										+'<tr>'
										+'<td valign="middle" class="clsTdCheckbox">'
										+'<div class="clsRadioButton">'
										+'<input type="Radio" id="radioWorkOrder_' + this.WORKORDERID + '" name="radioWorkOrder" value="' + this.WORKORDERID + '" ' + isThisChecked + '>'
										+'<label on'+globalClickEvent+'="" on'+globalClickEvent+'="" for="radioWorkOrder_' + this.WORKORDERID + '"></label>'
										+'</div>'
										+'</td>'
										+'<td class="cslTextMenuContainer">'
										+'<label on'+globalClickEvent+'="" on'+globalClickEvent+'="" for="radioWorkOrder_' + this.WORKORDERID + '"> <span class="clsText">' + this.REFERENCE + '</span></label>'
										+'</td>'
										+'</tr>'
										+'</table>'
										+'</div>'
										;
										
								$('#customer_'+currentCustomer).append(vText);
		
							}
						}
					});
					
				}
				
			}
		});
		
	});
	
}

//Fill pictures list
function fillPicturesList(data) {
	globalPicturesList = data;
}

//Fill persons list
function fillPersonsList(data) {
	globalPersonsList = data;
	globalPersonObj = {};
	
	//get distinct persons
	$.coldfusion.eachRow(globalPersonsList, function(rowIndex){
		if (!globalPersonObj[this.PERSONNO]) {
			globalPersonObj[this.PERSONNO] = this.INDEXNO;
		}
	});
}