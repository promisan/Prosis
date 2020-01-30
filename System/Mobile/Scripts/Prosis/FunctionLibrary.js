//Check Internet Connection
function checkInternetConnection() { 
	if (navigator.connection) {
		var networkState = navigator.connection.type;
	    if (networkState == Connection.NONE){
	  		alert(languageTxtErrorInternet);
			return false;
		}
	}
	return true;
}

//Checks if image exists and sets the url, otherwise sets the errorImage
function setImageIfExist(url, errorImage, objectSelector) {
	var img = new Image();
	img.onload = function() {
		$(objectSelector).attr('src', url);
	};
	img.onerror = function() {
		$(objectSelector).attr('src', errorImage);
	};
	img.src = url;
}

//GUID generator
function guidS4() {
	return (((1+Math.random())*0x10000)|0).toString(16).substring(1).toUpperCase();
}
function guidGenerator() {
	return (guidS4()+guidS4()+"-"+guidS4()+"-"+guidS4()+"-"+guidS4()+"-"+guidS4()+guidS4()+guidS4());
}

//Ajax error handling
function ajaxError(request, type, errorThrown) {
    var message = "Error in the AJAX request:\n\n";
    switch (type) {
        case 'timeout':
            message += languageTxtErrorText + "101."; // "The request timed out";
            break;
        case 'notmodified':
            message += languageTxtErrorText + "102."; // "The request was not modified but was not retrieved from the cache";
            break;
        case 'parsererror':
            message += languageTxtErrorText + "103."; // "XML/Json format is bad";
            break;
        default:
            message += languageTxtErrorText + "100. ";// + request.status + " " + request.statusText + "."; // "HTTP Error (" + request.status + " " + request.statusText + ")";
    }
    message += "\n";
	hideWait();
    alert(message);
}

//Show wait screen
function showWait(msg) {
	$('#lblModalWait').html(msg);
	$('#modalWait').css('display', 'block');
}

//Hide wait screen
function hideWait() {
	$('.clsPictureViewBox img').attr('src', null);
	$('.clsProfileViewBox img').attr('src', null);
	$('#modalWait').css('display', 'none');
}

//Show picture view window
function showPicture(attachmentid, src, memo, details) {
	var defaultPicture = '../../../System/Mobile/Images/no-picture.png';
	$('#memoPictureViewBox').val(memo);
	$('#btnMemoPictureViewBox').html(languageTxtSaveChanges);
	$('#btnMemoPictureViewBox').off(globalClickEvent);
	$('#btnMemoPictureViewBox').on(globalClickEvent, function() { updatePictureMemo(attachmentid, memo, $('#memoPictureViewBox').val(), src, details); });
	$('#detailsPictureViewBox').html(details);
	setImageIfExist(src, defaultPicture, '.clsPictureViewBox img');
	$('#modalPictureView').css('display', 'block');
}

function updatePictureMemo(attachmentid, oldmemo, memo, src, details) {
	var vMemo = $.trim(memo);
	var vAtt = attachmentid;
	var vDet = details;
	var vSrc = src;
	
	$('#modalPictureView').css('display', 'none');
	
	if (vMemo != oldmemo) {
		if (checkInternetConnection()) {
			validateSession(function() {
				showWait(languageTxtUpdatingMemo);
				$.getJSON(window['parameterDataService'] + '?method=updateAttachmentMemo&callback=?&attachmentId=' + vAtt + '&memo=' + vMemo, function(result) {
					$('#imgActionDetailPicture_'+vAtt).attr('title',vMemo);
					$('#imgActionDetailPicture_'+vAtt).off(globalClickEvent);
					$('#imgActionDetailPicture_'+vAtt).on(globalClickEvent, function() { showPicture(vAtt, vSrc, vMemo, vDet); });
					$.coldfusion.eachRow(globalPicturesList, function(picIndex){
						if (this.ATTACHMENTID == vAtt) {
							globalPicturesList.DATA.ATTACHMENTMEMO[picIndex] = vMemo;
							return false;
						}
					});
			    })
				.error(ajaxError)
				.complete(function(){ 
					//Hide wait
					hideWait(); 
				});
			});
		}
	}
}

//Edit action memo
function editActionMemo(workActionId, memo) {
	$('#txtActionMemoBox').val(memo);
	$('#btnTxtActionMemoBox').html(languageTxtSaveChanges);
	$('#btnTxtActionMemoBox').off(globalClickEvent);
	$('#btnTxtActionMemoBox').on(globalClickEvent, function() { updateActionMemo(workActionId, memo, $('#txtActionMemoBox').val()); });
	$('#modalEditActionMemo').css('display', 'block');
}

function updateActionMemo(workActionId, oldmemo, memo) {
	var vMemo = $.trim(memo);
	var vId = workActionId;
	
	$('#modalEditActionMemo').css('display', 'none');
	
	if (vMemo != oldmemo) {
		if (checkInternetConnection()) {
			validateSession(function() {
				showWait(languageTxtUpdatingMemo);
				$.getJSON(window['parameterDataService'] + '?method=updateWorkActionMemo&callback=?&workActionId=' + vId + '&memo=' + vMemo, function(result) {
					$('#actionDetailMemo_'+vId).html(vMemo);
					$('#imgEditActionMemo_'+vId).off(globalClickEvent);
					$('#imgEditActionMemo_'+vId).on(globalClickEvent, function() { editActionMemo(vId, vMemo); });
					$.coldfusion.eachRow(globalDataList, function(dataIndex){
						if (this.WORKACTIONID == vId) {
							globalDataList.DATA.ACTIONMEMO[dataIndex] = vMemo;
							return false;
						}
					});
			    })
				.error(ajaxError)
				.complete(function(){ 
					//Hide wait
					hideWait(); 
				});
			});
		}
	}
	
}

//Remove picture
function removeActionPicture(id) {
	if (checkInternetConnection()) {
		var vSession = '';
		if (window.localStorage.getItem("hostSessionId")) { 
			vSession = window.localStorage.getItem("hostSessionId"); 
		}
		if (confirm(languageTxtRemovePicture)) {
			showWait(languageTxtRemovingPicture);
			$.getJSON(window['parameterDataService'] + '?method=removePicture&callback=?&hostSessionId=' + vSession + '&attachmentId=' + id, function(result) {
				removeActionPictureCompleted(id, result);
		    })
			.error(ajaxError)
			.complete(function(){ 
				//Hide wait
				hideWait(); 
			});
		}
	}
}

//Action removed
function removeActionPictureCompleted(id, result) {
	$.coldfusion.eachRow(result, function(i){
		if (this.ATTACHMENTID != '') {
			$('#actionDetailPictureImage_'+id).remove();
		}
	});
}

//Show profile view window
function showProfileFromList(personNo) {
	$('#modalShowCustomerEmployees').css('display', 'none');
	showProfile(personNo);
}

function showProfile(personNo) {
	var vGender = '';
	var currentEmployeeErrorPicture = '';
	var currentAction = '';
	var currentActor = '';
	var activityList = '';
	var activityListCount = 0;
	var thisPerson = personNo;
	var vCompleted;
	var tempActivityList = {};
	var activityItemArray = new Array();
	var activityItem = new Array();
	
	$('#txtProfileViewIndexNo').html('');
	$('#txtProfileViewName').html('');
	$('#txtProfileViewGender').html('');
	$('#txtProfileViewAssignment').html('');
	$('#listProfileViewTasks').html('<div align="center" style="width:100%; font-size:75%;"><img src="Images/loader.gif"><br>'+languageTxtLoading+'</div>');
	$('.clsProfileViewBox img').attr('src', '../../../System/Mobile/Images/no-picture-male.png');
	$('#modalProfileView').css('display', 'block');
	
	$('#listProfileViewTasks').css('display', 'none');
	$('#listProfileViewTasks').fadeIn(500, function() {
	
		//get activities
		$.coldfusion.eachRow(globalPersonsList, function(perIndex){
			if (this.PERSONNO == thisPerson) {
				currentAction = this.WORKACTIONID;
				currentActor = this.ISACTOR;
				
				activityItemArray = new Array();
				$.coldfusion.eachRow(globalDataList, function(dataIndex){
					if (this.WORKACTIONID == currentAction) {
						vCompleted = 'completed.png';
						if (this.COMPLETED == 0) {
							vCompleted = 'notCompleted.png';
						}
						
						if (tempActivityList[this.HOURDATETIMEPLANNING]) {
							activityItemArray = tempActivityList[this.HOURDATETIMEPLANNING];
						}
						
						activityItem = new Array();
						activityItem[0] = currentActor;
						activityItem[1] = this.ACTIONMEMO;
						activityItem[2] = vCompleted;
						activityItemArray.push(activityItem);
						tempActivityList[this.HOURDATETIMEPLANNING] = activityItemArray;		
									
						activityListCount = activityListCount + 1;
					}
				});
			}
		});
		
		activityList = '<div class="clsActivityListContainer">';
		$.each(orderObject(tempActivityList), function (hour, hourArray) {
			$.each(hourArray, function (hourIndex, hourData) {
				activityList = activityList 
						+ '<div class="clsActivityItemContainer">'
							+ '<table width="100%">'
								+ '<tr>'
									+ '<td width="1%" valign="top" style="padding-right:3px; padding-top:2px;">'
										+ '<img src="Images/' + window['parameterIconSet'] + '/' + hourData[2] + '" class="clsActivityListContainerImg">'
									+'</td>'
									+ '<td valign="top" style="padding-top:3px;">'
										+ '<div class="clsActivityItemContainerMemo" style="font-size:75%;">'
											+ '<span class="clsActivityListContainerHour">' + hour + '</span>: (' + hourData[0] + ') ' + hourData[1]
										+ '</div>' 
									+'</td>'
								+'</tr>'
							+ '</table>'
						+ '</div>';
			});
		});			
		activityList = activityList + '</div>';
		
		vQuit = 0;
		$.coldfusion.eachRow(globalPersonsList, function(perIndex){
			if (this.PERSONNO == personNo && vQuit == 0) {
			
				if (this.GENDER.toUpperCase() == 'M') { 
					vGender = languageTxtPersonGenderM; 
					currentEmployeeErrorPicture = '../../../System/Mobile/Images/no-picture-male.png';
				}
				if (this.GENDER.toUpperCase() == 'F') { 
					vGender = languageTxtPersonGenderF; 
					currentEmployeeErrorPicture = '../../../System/Mobile/Images/no-picture-female.png';
				}
			
				setImageIfExist(window['parameterDocumentRoot'] + 'EmployeePhoto/' + this.INDEXNO + '.jpg', currentEmployeeErrorPicture, '.clsProfileViewBox img');
				$('.clsProfileViewBox img').css('display','none').fadeIn(1000);
				
				$('#txtProfileViewIndexNo').html('<span style="font-weight:bolder;">'+languageTxtPersonID + '</span>:  <span style="font-style:italic;">' + this.INDEXNO + '</span>');
				$('#txtProfileViewName').html('<span style="font-weight:bolder;">'+languageTxtPersonName + '</span>:  <span style="font-style:italic;">' + this.FIRSTNAME + ' ' + this.LASTNAME + '</span>');
				$('#txtProfileViewGender').html('<span style="font-weight:bolder;">'+languageTxtPersonGender + '</span>:  <span style="font-style:italic;">' + vGender + '</span>');
				$('#txtProfileViewAssignment').html('<span style="font-weight:bolder;">'+languageTxtPersonAssignment + '</span>:  <span style="font-style:italic;">' + this.FUNCTIONDESCRIPTION + '</span>');
				
				if (activityListCount > 0) {
					$('#listProfileViewTasks').html('<br><span style="font-weight:bolder;">' + languageTxtTodayActivities + ' (' + activityListCount + ')</span>:<br>' + activityList);
				}else{
					$('#listProfileViewTasks').html('<br><span style="font-weight:bolder;">' + languageTxtNoTodayActivities + '.</span>');
				}
				
				vQuit = 1;
			}
		});
	
	});
}

//Show add details window
function showAddDetails(woaid) {
	if (checkInternetConnection()) {
		$('#cameraPicURI').html('');
		$('#cameraPic').attr('src', '');
		$('#cameraPicURIPercentage').html('');
		$('#txtUploadMemo').val('');
		
		$('#btnCapturePhoto').html(languageTxtCamera);
		$('#btnCapturePhoto').off(globalClickEvent);
		$('#btnCapturePhoto').on(globalClickEvent, function() {
			capturePhoto();
		});
		
		$('#btnGetPhoto').html(languageTxtGallery);
		$('#btnGetPhoto').off(globalClickEvent);
		$('#btnGetPhoto').on(globalClickEvent, function() {
			getPhoto();
		});
		
		$('#btnUploadPhoto').html(languageTxtUpload);
		$('#btnUploadPhoto').off(globalClickEvent);
		$('#btnUploadPhoto').on(globalClickEvent, function() {
			uploadPhoto(woaid);
		});
		
		$('#modalAddDetails').css('display', 'block');
	}
}


//Set selected date in textbox
function setSelectedDate(control) {
	var dd = window['parameterSelectedDate'].getDate();
	var mm = window['parameterSelectedDate'].getMonth() + 1;
	var yyyy = window['parameterSelectedDate'].getFullYear();
	
	var sdd = String(dd);
	var smm = String(mm);
	
	if (dd < 10) { sdd = '0' + sdd; }
	if (mm < 10) { smm = '0' + smm; }
	
	if (window['parameterDateFormat'] == "dd/mm/yyyy") {
		globalSTRSelectedDate = sdd + '/' + smm + '/' + yyyy;
	}
	
	if (window['parameterDateFormat'] == "mm/dd/yyyy") {
		globalSTRSelectedDate = smm + '/' + sdd + '/' + yyyy;
	}
	
	if (window['parameterDateFormat'] == "yyyy-mm-dd") {
		globalSTRSelectedDate = yyyy + '-' + smm + '-' + sdd;
	}
	
	$('#'+control).val(globalSTRSelectedDate);
	globalISOSelectedDate = yyyy + "-" + smm + "-" + sdd;
}

//Set selected date as window['parameterSelectedDate']
function selectDate(val) {
	var year = 0;
	var month = 0;
	var day = 0;
	
	var smonth = "";
	var sday = "";
	
	if (window['parameterDateFormat'] == "dd/mm/yyyy") {
		year = parseInt(val.substring(6, 10));
		if (val.substring(3, 4) == '0') { month = parseInt(val.substring(4, 5)); } else { month = parseInt(val.substring(3, 5)); }
		if (val.substring(0, 1) == '0') { day = parseInt(val.substring(1, 2)); } else { day = parseInt(val.substring(0, 2)); }
		
		if (day < 10) { sday = '0' + day; } else { sday = day; }
		if (month < 10) { smonth = '0' + month; } else { smonth = month; }
		globalSTRSelectedDate = sday + "/" + smonth + "/" + year;
	}
	
	if (window['parameterDateFormat'] == "mm/dd/yyyy") {
		year = parseInt(val.substring(6, 10));
		if (val.substring(0, 1) == '0') { month = parseInt(val.substring(1, 2)); } else { month = parseInt(val.substring(0, 2)); }
		if (val.substring(3, 4) == '0') { day = parseInt(val.substring(4, 5)); } else { day = parseInt(val.substring(3, 5)); }
		
		if (day < 10) { sday = '0' + day; } else { sday = day; }
		if (month < 10) { smonth = '0' + month; } else { smonth = month; }
		globalSTRSelectedDate = smonth + "/" + sday + "/" + year;
	}
	
	if (window['parameterDateFormat'] == "yyyy-mm-dd") {
		year = parseInt(val.substring(0, 4));
		if (val.substring(5, 6) == '0') { month = parseInt(val.substring(6, 7)); } else { month = parseInt(val.substring(5, 7)); }
		if (val.substring(8, 9) == '0') { day = parseInt(val.substring(9, 10)); } else { day = parseInt(val.substring(8, 10)); }
		
		if (day < 10) { sday = '0' + day; } else { sday = day; }
		if (month < 10) { smonth = '0' + month; } else { smonth = month; }
		globalSTRSelectedDate = year + "-" + smonth + "-" + sday;
	}
	
	window['parameterSelectedDate'] = new Date(year, month-1, day, 0, 0, 0, 0);
	globalISOSelectedDate = year + "-" + smonth + "-" + sday;
}

//Convert database date to app dateformat
function formatToAppDate(year, month, day) {
	var result = '';
	var smonth = '';
	var sday = '';
	
	if (day < 10) { sday = '0' + day; } else { sday = day; }
	if (month < 10) { smonth = '0' + month; } else { smonth = month; }
	
	if (window['parameterDateFormat'] == "dd/mm/yyyy") { return sday + '/' + smonth + '/' + year.toString(); }
	
	if (window['parameterDateFormat'] == "mm/dd/yyyy") { return smonth + '/' + sday + '/' + year.toString(); }
	
	if (window['parameterDateFormat'] == "yyyy-mm-dd"){ return year.toString() + '-' + smonth + '-' + sday; }

}

//DatePicker Initialization
function initializeDatePicker() {

	//Destroy datePicker
	$('#txtDatePicker').mobiscroll('destroy');
	
	//initialize datePicker
	$('#txtDatePicker').mobiscroll().date({
        theme: window['parameterDatePickerTheme'],
        lang: languageDatePickerLanguage,
        display: window['parameterDatePickerDisplay'],
        mode: window['parameterDatePickerMode'],
        animate: window['parameterDatePickerAnimate'],
        dateOrder: window['parameterDatePickerFormat'],
		dateFormat: window['parameterDateFormat'],
		//maxDate: vMaxDate, no limit
		scrollLock: true
    });
	
	//Set selected date
	$('#txtDatePicker').mobiscroll('setDate', window['parameterSelectedDate'], true)

}

//Display Criteria
function displayDateCriteria() {
	var cntCompletedActions = 0;
	var AllActions = 0;
	var txtDay = "";
	var today = new Date();
	var tomorrow = new Date();
	var yesterday = new Date();
	
	tomorrow.setDate(today.getDate()+1);
	yesterday.setDate(today.getDate()-1);
	
	if (globalDataList.ROWCOUNT) {
		AllActions = globalDataList.ROWCOUNT;
	}
	
	$.coldfusion.eachRow(globalDataList, function( rowIndex ){
		if (this.COMPLETED == 1) {
			cntCompletedActions = cntCompletedActions + 1;
		}
	});
	
	if (window['parameterSelectedDate'].getDate() == today.getDate() && window['parameterSelectedDate'].getMonth() == today.getMonth() && window['parameterSelectedDate'].getFullYear() == today.getFullYear()) {
		txtDay = languageTxtToday + ": ";
	}
	
	if (window['parameterSelectedDate'].getDate() == tomorrow.getDate() && window['parameterSelectedDate'].getMonth() == tomorrow.getMonth() && window['parameterSelectedDate'].getFullYear() == tomorrow.getFullYear()) {
		txtDay = languageTxtTomorrow + ": ";
	}
	
	if (window['parameterSelectedDate'].getDate() == yesterday.getDate() && window['parameterSelectedDate'].getMonth() == yesterday.getMonth() && window['parameterSelectedDate'].getFullYear() == yesterday.getFullYear()) {
		txtDay = languageTxtYesterday + ": ";
	}
	
	$('.clsTxtDateDisplay').html(txtDay + globalSTRSelectedDate + " <span class='clsTxtCompletedDisplay'>(<label class='clsTxtCompleted'>" + languageTxtCompleted + "</label>: " + cntCompletedActions + " / " + AllActions + ")</span>");
}

function displayCriteria() {
	var customerDisplay = '';
	
	//Clear values
	$('.clsTxtPlaceDisplay').html('');
	$('.clsTxtUserDisplay').html('');
	
	//New values
	$.coldfusion.eachRow(globalCustomerList, function(rowIndex){
		if (this.WORKORDERID == window['parameterSelectedWorkOrder']) {
			customerDisplay = '<table width="100%">'
								+ '<tr>'
									+ '<td width="1%">'
										+ '<img src="Images/' + window['parameterIconSet'] + '/people.png" class="clsPeopleImage" on'+globalClickEvent+'="showCustomerEmployees();"> ' 
									+ '</td>'
									+ '<td>'
										+ this.CUSTOMERNAME + ' - ' + this.REFERENCE
									+ '</td>'
								+ '</tr>'
							+'</table>';
			$('.clsTxtPlaceDisplay').html(customerDisplay);	
		}
	});
	displayDateCriteria();
	$('.clsTxtUserDisplay').html(window['parameterUserName']);
}

function showCustomerEmployees() {
	var thisPerson;
	var thisIndexNo;
	var currentEmployeePicture = '';
	var currentEmployeeErrorPicture = '';
	var vName = '';
	var vGender = '';
	var vPosition = '';
	var cnt = 0;
	var vQuit = 0;
	var tempEmployeeList = {};
	var employeeItem = new Array();
	
	$('.clsCustomerEmployeesContainer').html('<div align="center" style="width:100%"><img src="Images/loader.gif"><br>'+languageTxtLoading+'</div>');
	$('#modalShowCustomerEmployees').css('display', 'block');

	$('.clsCustomerEmployeesContainer').css('display', 'none');
	$('.clsCustomerEmployeesContainer').fadeIn(1500, function() {
	
		//Employee list
		$.each(globalPersonObj, function (personNo, indexNo) {
			thisPerson = personNo;
			thisIndexNo = indexNo;
			
			taskCnt = 0;
			vQuit = 0;
			$.coldfusion.eachRow(globalPersonsList, function(personIndex){
				if (this.PERSONNO == thisPerson && vQuit == 0) {
					vName = this.FIRSTNAME + ' ' + this.LASTNAME;
					vGender = this.GENDER;
					vPosition = this.FUNCTIONDESCRIPTION;
					vQuit = 1;
				}
			});
			
			currentEmployeePicture = window['parameterDocumentRoot'] + 'EmployeePhoto/' + thisIndexNo + '.jpg';
			currentEmployeeErrorPicture = '../../../System/Mobile/Images/no-picture-male.png';
			if (vGender.toUpperCase() == 'F') {
				currentEmployeeErrorPicture = '../../../System/Mobile/Images/no-picture-female.png';
			}
			
			employeeItem = new Array();
			employeeItem[0] = currentEmployeePicture;
			employeeItem[1] = currentEmployeeErrorPicture;
			employeeItem[2] = thisPerson;
			employeeItem[3] = thisIndexNo;
			employeeItem[4] = vPosition;
			tempEmployeeList[vName] = employeeItem;
			
			
		});
		
		cnt = 0;
		employeeList = '<div>';
		$.each(orderObject(tempEmployeeList), function (personName, personData) {
			cnt = cnt + 1;
			employeeList = employeeList	
						+ '<div class="clsEmployeeContainer">'
							+ '<table class="clsTableEmployeeContainer">'
								+ '<tr>'
									+ '<td width="1%" style="padding-right:3px;">'
										+ '<div class="clsEmployeeContainerCounter">' + cnt + '. </div>'
									+'</td>'
									+ '<td width="1%" style="padding-right:3px;">'
										+'<img src="../../../System/Mobile/Images/no-picture-male.png" style="cursor:pointer;" class="clsPersonPictureBox clsPersonPictureList_'+personData[2]+'" on'+globalClickEvent+'="showProfileFromList(\''+personData[2]+'\');">'
										+'<script>setImageIfExist(\''+personData[0]+'\',\''+personData[1]+'\',\'.clsPersonPictureList_'+personData[2]+'\');</script>'
									+'</td>'
									+ '<td>'
										+ '<div>'
											+ '<div class="clsEmployeeContainerName">' + personName + '</div>'
											+ '<div class="clsEmployeeContainerIndexNo">' + personData[3] + '</div>'
											+ '<div class="clsEmployeeContainerPosition">' + personData[4] + '</div>'
										+ '</div>'
									+'</td>'
								+'</tr>'
							+ '</table>'
						+ '</div>';
		});
		employeeList = employeeList + '</div>';
		
		$('.clsCustomerEmployeesContainer').html('<span style="font-weight:bolder; font-size:150%;">' + languageTxtTodayEmployees + ' (' + cnt + '):</span><br><br>' + employeeList);
		$('.clsEmployeeContainer').css('border', window['parameterLinesStyle']);
	
	});
	
}

//Apply colors and images
function applyStyle() {
	
	//Select stylesheet
	if (window['parameterLowPrintStyle'] == 1) {
		$("#styleLowPrint").removeAttr("disabled");
		$("#styleNormal").attr("disabled", "disabled");
	}
	
	//Background
	$('body').css('background', 'url("' + window['parameterImgBackgroundSrc'] + '") no-repeat center center fixed');
	$('.modalBoxLoginOverlay').css('background', 'url("' + window['parameterImgLoginBackgroundSrc'] + '") repeat 49.9% center fixed');
	$('.modalBoxLoginOverlay').css('width', '100%');
	$('.modalBoxLoginOverlay').css('height', '100%');
	$('.modalBoxLoginOverlay').css('-moz-background-size', 'cover');
	$('.modalBoxLoginOverlay').css('-webkit-background-size', 'cover');
	$('.modalBoxLoginOverlay').css('-o-background-size', 'cover');
	$('.modalBoxLoginOverlay').css('-ms-background-size', 'cover');
	$('.modalBoxLoginOverlay').css('background-size', 'cover');
	$('.modalBoxLoginOverlay').css('margin', '0px');
	
	//Text Colors
	$('body').css('color', window['parameterTextColor']);
	$('.clsTopMenu').css('color', window['parameterTopMenuTextColor']);
	$('.clsMenuContainer').css('color', window['parameterFilterTextColor']);
	$('.clsMainContent').css('color', window['parameterContentTextColor']);	
	
	//Lines Style
	$('.clsPageHeader').css('border-bottom', window['parameterLinesStyle']);
	$('.clsContent').css('border-bottom', window['parameterLinesStyle']);
	$('.clsVerticalToggler').css('border-right', window['parameterLinesStyle']);
	$('.clsVerticalToggler').css('border-left', window['parameterLinesStyle']);
	$('.clsVerticalMenu').css('border-right', window['parameterLinesStyle']);
	$('.clsMainListingElement').css('border', window['parameterLinesStyle']);
	$('.clsImgActionDetailPicture').css('border', window['parameterLinesStyle']);
	$('.clsPersonPictureBox img').css('border', window['parameterLinesStyle']);
	$('.clsPictureViewBox img').css('border', window['parameterLinesStyle']);
	$('.clsProfileViewBox img').css('border', window['parameterLinesStyle']);
	$('.clsCriteriaDisplay').css('border', window['parameterLinesStyle']);
	$('.clsEmployeeContainer').css('border', window['parameterLinesStyle']);
	if (parameterMenuType == 'tall') { 
		$('.clsDivFilterListingContainer').css('border-top', window['parameterLinesStyle']); 
		$('.clsDivFilterListingContainer').css('border-bottom', window['parameterLinesStyle']); 
	}else{
		$('.clsDivFilterListingContainer').css('border-top', ''); 
		$('.clsDivFilterListingContainer').css('border-bottom', ''); 
	}
	
	//Logo
	$('#imgLogo').attr('src', window['parameterImgLogoSrc']);
	$('#imgLogo').attr('title', window['parameterPageTitle']);
	$('#imgLoginLogo').attr('src', window['parameterImgLogoSrc']);
	$('#imgLoginLogo').attr('title', window['parameterPageTitle']);
	
	//Filter Menu
	$('#menuFilterIcon').attr('src', window['parameterImgFilterMenuSrc']);
	
	//Clean Search
	$('#btnCleanSearch').attr('src', window['parameterImgDeleteSrc']);
	
	//Close modal
	$('.imgCloseModal').attr('src', window['parameterImgDeleteSrc']);
	
	//Menu Images
	$('#btnBuilding').attr('src', window['parameterImgMenuBuildingSrc']);
	$('#btnDate').attr('src', window['parameterImgMenuDateSrc']);
	$('#btnReload').attr('src', window['parameterImgMenuRefreshSrc']);
	$('#btnAbout').attr('src', window['parameterImgMenuAboutSrc']);
	$('#btnMenuFind').attr('src', window['parameterImgMenuFindSrc']);
	$('#cbDataFilter_All img').attr('src', window['parameterImgMenuAllSrc']);
	$('.clsCheckboxLevel4').attr('src', window['parameterImgMenuAllSrc']);
	
	//Filter Images
	$('#imgFilter1').attr('src', window['parameterImgFilter1Src']);
	$('#imgFilter2').attr('src', window['parameterImgFilter2Src']);
	$('#imgFilter3').attr('src', window['parameterImgFilter3Src']);
	$('#imgFilter4').attr('src', window['parameterImgFilter4Src']);
	
	//Show app
	$('#mainPage').fadeIn('slow');
}

//Apply language text
function applyLanguage(langCode) {

	//Change texts
	changeLanguageText(langCode);
	
	//Initialize datePicker
	initializeDatePicker();
	
	//Apply texts
	$(document).attr('title', window['parameterPageTitle']);
	
	$('.closeModal').attr('title', languageTxtCloseTitle);
	
	$('#lblMenuBuilding').html(languageTxtMenuBuilding);
	$('#lblMenuDate').html(languageTxtMenuDate);
	$('#lblMenuRefresh').html(languageTxtMenuRefresh);
	$('#lblMenuAbout').html(languageTxtMenuAbout);
	
	$('#lblFilter1').html(languageTxtFilter1);
	$('#lblFilter2').html(languageTxtFilter2);
	$('#lblFilter3').html(languageTxtFilter3);
	$('#lblFilter4').html(languageTxtFilter4);
	
	$('#txtSearch').attr('placeholder', languageTxtSearch);
	$('#txtSearch').attr('title', languageTxtSearch);
	$('#btnCleanSearch').attr('title', languageTxtCleanSearch);
	
	$('#btnSelectDate').html(languageTxtLoadData);
	$('#btnSelectWorkOrder').html(languageTxtLoadData);
	
	$('#lblAboutYear').html(window['parameterToday'].getFullYear());
	$('#lblAboutIcons').html(languageTxtAboutIcons);
	$('#lblAboutLanguage').html(languageTxtLanguage);
	
	$('#selectLanguage option[value="en"]').text(languageTxtEnglish);
	$('#selectLanguage option[value="es"]').text(languageTxtSpanish);
	
	$('#lblEnableAnimations').html(languageTxtAnimations);
	
	$('#selectEnableAnimations option[value="0"]').text(languageTxtDisable);
	$('#selectEnableAnimations option[value="1"]').text(languageTxtEnable);
	
	$('#lblFilter4Completed, .clsTxtCompleted').html(languageTxtCompleted);
	$('#lblFilter4NotCompleted, , .clsTxtNotCompleted').html(languageTxtNotCompleted);
	$('#lblFilter4WithPictures').html(languageTxtWithPictures);
	$('#lblFilter4WithoutPictures').html(languageTxtWithoutPictures);
	$('#lblFilterAll').html(languageTxtShowAll);
	
	$('.clsElementCompleted').attr('title',languageTxtCompleted);
	$('.clsElementNotCompleted').attr('title',languageTxtNotCompleted);
	$('.clsImgAddDetails').attr('title',languageTxtAddDetails);
	
	$('#btnLogin').html(languageTxtLogin);
	$('#btnLogout').html(languageTxtLogout);
	$('#lblLoginName').html(languageTxtUserName + ":");
	$('#lblLoginPwd').html(languageTxtPassword + ":");
	
	displayDateCriteria();
}

//Preselect data
function preSelectData() {
	$('#selectLanguage').val(window['parameterApplicationLanguage']);
	$('#selectEnableAnimations').val(window['parameterMenuAnimations']);
	setSelectedDate('txtDatePicker');
}

//Returns an object ordered asc
function orderObject(obj) {
	var keys = [];
    var sorted_obj = {};

    for(var key in obj){
        if(obj.hasOwnProperty(key)){
            keys.push(key);
        }
    }

    // sort keys
    keys.sort();

    // create new array based on Sorted Keys
    jQuery.each(keys, function(i, key){
        sorted_obj[key] = obj[key];
    });

    return sorted_obj;
}

//Menu Item Event
function menuItemEvent(menuItem) {
	if ($('#'+menuItem).is(':visible')) {
		if (window['parameterMenuAnimations'] == 0) {
			$('#'+menuItem).css('display', 'none');
		}else{
			$('#'+menuItem).animate({opacity: 0.05, height:'hide'}, window['parameterMenuItemEffectTime'], window['parameterMenuItemEffectEasing']);
		}
	}else{
		if (window['parameterMenuAnimations'] == 0) {
			$('#'+menuItem).css('display', 'block');
		}else{
			$('#'+menuItem).animate({height:'show', opacity: 1}, window['parameterMenuItemEffectTime'], window['parameterMenuItemEffectEasing']);
		}
	}
}

//Restore filter containers
function restoreFilterContainersDisplay() {
	$('#listingMenuLevel1').css('display','block');
	$('#listingMenuLevel2').css('display','block');
	$('#listingMenuLevel3').css('display','block');
	$('#listingMenuLevel4').css('display','block');
}

function restoreFilterContainersOpacity() {
	$('#menuContainer').css('opacity','1');
	$('#listingMenuLevel1').css('opacity','1');
	$('#listingMenuLevel2').css('opacity','1');
	$('#listingMenuLevel3').css('opacity','1');
	$('#listingMenuLevel4').css('opacity','1');
}


//Sets the menu style
function setMenuStyle(menuStyle) {

	/* wide filter menu */
	if (menuStyle == 'wide') {
	
		//Set appropriate css
		$("#styleTallMenu").attr("disabled", "disabled");
    	$("#styleWideMenu").removeAttr("disabled");
		
		//Change filter menu
		$('.clsDivLogo').css('display', 'block');
		$('.clsVerticalToggler').css('display', 'block');
		$('.clsMainMenuText').css('display', 'block');
		$('#btnMenuFindContainer').css('display', 'none');
		$('.clsMenuIcon').css('height', '80%');
		$('.clsMainContent').css('padding-left', '10px');
		$('.clsMainContent').css('padding-right', '10px');
		
		//Menu effects
		restoreFilterContainersDisplay();
		restoreFilterContainersOpacity();
		$('.clsMenuFilter1').off(globalClickEvent);
		$('.clsMenuFilter2').off(globalClickEvent);
		$('.clsMenuFilter3').off(globalClickEvent);
		$('.clsMenuFilter4').off(globalClickEvent);
	}
	
	/* tall filter menu */
	if (menuStyle == 'tall') {
	
		//Set appropriate css
		$("#styleWideMenu").attr("disabled", "disabled");
    	$("#styleTallMenu").removeAttr("disabled");
		
		//Change filter menu
		$('.clsDivLogo').css('display', 'none');
		$('.clsVerticalToggler').css('display', 'none');
		$('.clsMainMenuText').css('display', 'none');
		$('#btnMenuFindContainer').css('display', 'block');
		$('.clsMenuIcon').css('height', '100%');
		$('.clsMainContent').css('padding-left', '0px');
		$('.clsMainContent').css('padding-right', '0px');
		
		//Menu Effects
		$('.clsMenuFilter1').off(globalClickEvent);
		$('.clsMenuFilter2').off(globalClickEvent);
		$('.clsMenuFilter3').off(globalClickEvent);
		$('.clsMenuFilter4').off(globalClickEvent);
		$('.clsMenuFilter1').on(globalClickEvent, function() { menuItemEvent('listingMenuLevel1'); });
		$('.clsMenuFilter2').on(globalClickEvent, function() { menuItemEvent('listingMenuLevel2'); });
		$('.clsMenuFilter3').on(globalClickEvent, function() { menuItemEvent('listingMenuLevel3'); });
		$('.clsMenuFilter4').on(globalClickEvent, function() { menuItemEvent('listingMenuLevel4'); });
	}
	
}

//Resize event
function customResize()	{
	var originalType = window['parameterMenuType'];
	
	if (($(window).width() < $(window).height()) || ($(window).width() > 0 && $(window).width() < window['parameterMinimumWidthToChange'])) {
		window['parameterMenuType'] = 'tall';
	}else{
		window['parameterMenuType'] = 'wide';
	}
	
	if (originalType != window['parameterMenuType']) {
		$('#mainPage').css('display', 'none');
		setMenuStyle(window['parameterMenuType']);
		applyStyle();
		$('#mainPage').fadeIn('slow');
	}
}

//Get system parameters
function getSystemParameters() {
	if (checkInternetConnection()) {
		$('#mainPage').css('display', 'none');
		showWait(languageTxtLoadingConfig);
		$.getJSON(window['parameterGetConfigRoot'] + '?method=getParametersByAppId&callback=?&appId=' + window['parameterAppId'], function(conf) {
			setParameterConfiguration(conf);
	        initializeContainer();
	    })
		.error(ajaxError);
	}else{
		navigator.app.exitApp();
	}
}

//Complete actions
function completeAction(isCompleted, id) {
	if (checkInternetConnection()) {
		if (isCompleted == 0) {
			if (confirm(languageTxtAskCompletion)) {
			
				var vSession = '';
				if (window.localStorage.getItem("hostSessionId")) { 
					vSession = window.localStorage.getItem("hostSessionId"); 
				}
		
				validateSession(function() {
					showWait(languageTxtCompletingAction);
					$.getJSON(window['parameterDataService'] + '?method=completeWorkAction&callback=?&workActionId=' + id + '&sessionid=' + vSession, function(result) {
						showActionCompleted(id, result);
				    })
					.error(ajaxError)
					.complete(function(){ 
						//Hide wait
						hideWait(); 
					});
				});
				
			}
		}
	}
}

//Show action completed
function showActionCompleted(id, result) {
	var vTextDateCompleted = '';
	
	$('#dateTimeActualImage_'+id).attr('on'+globalClickEvent,'').unbind(globalClickEvent);
	$('#dateTimeActualImage_'+id).attr('src', 'Images/' + window['parameterIconSet'] + '/completed.png');
	$('#mainListingElementContainer_'+id).removeClass('clsFilterableNotCompleted').addClass('clsFilterableCompleted');

	//update data list
	$.coldfusion.eachRow(globalDataList, function( rowIndex ){
		if (this.WORKACTIONID == id) {
			globalDataList.DATA.COMPLETED[rowIndex] = 1;
			return false;
		}
	});
	
	$.coldfusion.eachRow(result, function(i){
		if (this.DATECOMPLETEDDATE != this.DATEDATETIMEPLANNING) {
			vTextDateCompleted = formatToAppDate(this.YEARCOMPLETEDDATE, this.MONTHCOMPLETEDDATE, this.DAYCOMPLETEDDATE) + ' @ ';
		}
		vTextDateCompleted = vTextDateCompleted + this.HOURCOMPLETEDDATE;
		$('#dateTimeActual_'+id).html('<label class="clsTxtCompleted">' + languageTxtCompleted + '</label>: ' + vTextDateCompleted);
	});
	
	displayDateCriteria();
}

//Set configuration
function setParameterConfiguration(conf) {
	var vQuotes = '';

	//Set parameters from server
	$.coldfusion.eachRow(conf, function(i){
	
		if (this.DATADOMAIN.toLowerCase() == 'string' || this.DATADOMAIN.toLowerCase() == 'color') { 
			vQuotes = '"'; 
		}else{ 
			vQuotes = ''; 
		}
		
		//Global Variables
		if (this.TYPE.toLowerCase() == 'variable') { 
			eval('window["' + this.NAME + '"] = ' + vQuotes + this.VALUE + vQuotes + '; '); 
		}
		
		//CSS
		if (this.TYPE.toLowerCase() == 'css') { 
			$('head').append('<link rel="stylesheet" href="' + this.VALUE + '" id="' + this.NAME + '" type="text/css" />');
		}
		
		//Scripts
		if (this.TYPE.toLowerCase() == 'script') { 
			$('head').append('<script type="text/javascript" charset="utf-8" src="' + this.VALUE + '"></script>');
		}
	});
	
	//Set data service
	window['parameterDataService'] = window['parameterRoot'] + window['parameterDataServicePath'];
	
	//Set upload service
	window['parameterUploadService'] = window['parameterRoot'] + window['parameterUploadServicePath'];
	
	//Set icon set
	setIconSet();
}

//Set icon set images
function setIconSet() {
	//Filter Menu
	window['parameterImgFilterMenuSrc']		= "Images/" + window['parameterIconSet'] + "/find.png";
	
	//Delete
	window['parameterImgDeleteSrc']			= "Images/" + window['parameterIconSet'] + "/delete.png";
	
	//Menu
	window['parameterImgMenuBuildingSrc'] 	= "Images/" + window['parameterIconSet'] + "/place.png";
	window['parameterImgMenuDateSrc'] 		= "Images/" + window['parameterIconSet'] + "/calendar.png";
	window['parameterImgMenuRefreshSrc'] 	= "Images/" + window['parameterIconSet'] + "/refresh.png";
	window['parameterImgMenuAboutSrc'] 		= "Images/" + window['parameterIconSet'] + "/info.png";
	window['parameterImgMenuFindSrc']		= "Images/" + window['parameterIconSet'] + "/find.png";
	window['parameterImgMenuAllSrc']		= "Images/" + window['parameterIconSet'] + "/check.png";
	
	//Filter Icons
	window['parameterImgFilter1Src']		= "Images/" + window['parameterIconSet'] + "/class.png";
	window['parameterImgFilter2Src'] 		= "Images/" + window['parameterIconSet'] + "/clean.png";
	window['parameterImgFilter3Src'] 		= "Images/" + window['parameterIconSet'] + "/clock.png";
	window['parameterImgFilter4Src'] 		= "Images/" + window['parameterIconSet'] + "/gear.png";
}

//Filter to current hour
function filterToCurrentHour() {
	var now = new Date();
	var currentHour = now.getHours();
	var vId = '';
	var currentHourId = 0;
	
	$.each(globalHourObj, function(code, description){
		vId = code.replace(/:/g,"_");
		
		if (vId.substring(0, 1) == '0') {
			currentHourId = parseInt(vId.substring(1, 2));
		}else{
			currentHourId = parseInt(vId.substring(0, 2));
		}
		
		if (currentHourId == currentHour || currentHourId == (currentHour-1) || currentHourId == (currentHour+1)) {
			$('#dataFilterLevel3_' + vId).val('true')
			$('#cbDataFilterLevel3_' + vId + ' img').attr('src','Images/' + window['parameterIconSet'] + '/check.png');
			$('.clsFilterableHour_' + vId).css('display', 'block');
		}else{
			$('#dataFilterLevel3_' + vId).val('false')
			$('#cbDataFilterLevel3_' + vId + ' img').attr('src','Images/' + window['parameterIconSet'] + '/uncheck.png');
			$('.clsFilterableHour_' + vId).css('display', 'none');
		}
	});
	
	$globalVisible = $('.clsMainListingElementContainer:visible');
}

//Deselect all
function deselectAllFilters() {
	$.each(globalClassObj, function(code, description){
		$('#dataFilterLevel1_' + code).val('false')
		$('#cbDataFilterLevel1_' + code + ' img').attr('src','Images/' + window['parameterIconSet'] + '/uncheck.png');
		$('.clsFilterableAreaClass_' + code).css('display', 'none');
	});
}

//Login function
function login(onSuccess, onError) {
	if (checkInternetConnection()) {
		var vUsr = $('#txtLoginName').val();
		var vPwd = $('#txtLoginPwd').val();
		var vDevId = '';
		
		if (window.device) {
			vDevId = device.uuid;
		}
		
		if (vUsr != '' && vPwd != '') {
			showWait(languageTxtLoginWait);
		    $.getJSON(window['parameterRoot'] + window['parameterLoginServicePath'] + '?method=mobileLogin&callback=?&user='+vUsr+'&pwd='+vPwd+'&deviceId='+vDevId, function(data) {
				var vSession = '';
				var vAccount = "";
				var vName = "";
				$.coldfusion.eachRow(data, function( rowIndex ){
					vSession = this.HOSTSESSIONID;
					vAccount = this.ACCOUNT;
					vName = this.NAME;
				});
				
				window['parameterSelectedWorkOrder'] = "00000000-0000-0000-0000-000000000000";
				if (vSession != '') {
					window['parameterUserName'] = vName + " [" + vAccount + "]";
					$('#modalLogin').css('display', 'none');
					if (window.localStorage) { window.localStorage.setItem("hostSessionId", vSession); }
					onSuccess();
				}else{
					window['parameterUserName'] = "";
					if (window.localStorage) { window.localStorage.removeItem("hostSessionId"); }
					onError();
					hideWait();
				}
				displayCriteria();
		    })
			.error(ajaxError);
		}else{
			alert(languageTxtLoginFields);
		}
	}
}

//Logout function
function logout(onSuccess, onError) {
	if (checkInternetConnection()) {
		var vSession = '';
		if (window.localStorage.getItem("hostSessionId")) { 
			vSession = window.localStorage.getItem("hostSessionId"); 
		}
		
		$('#txtLoginName').val('');
		$('#txtLoginPwd').val('');
		$('#txtLoginResult').html('');
		$('#txtLoginResult').html('');
		$('#modalAbout').css('display', 'none');
		
		showWait(languageTxtLogoutWait);
	    $.getJSON(window['parameterRoot'] + window['parameterLoginServicePath'] + '?method=mobileLogout&callback=?&hostSessionId='+vSession, function(data) {
			var vResult = 0;
			$.coldfusion.eachRow(data, function( rowIndex ){
				vResult = this.RESULT;
			});
			
			if (vResult == 1) {
				window.localStorage.removeItem("hostSessionId");
				window['parameterUserName'] = "";
				window['parameterSelectedWorkOrder'] = "00000000-0000-0000-0000-000000000000";
				displayCriteria();
				onSuccess();
			}else{
				onError();
				hideWait();
			}
	    })
		.error(ajaxError);
	}
}

//Validate Session function
function validateSession(onSuccess, onError) {
	if (checkInternetConnection()) {
		var vSession = '';
		if (window.localStorage.getItem("hostSessionId")) { 
			vSession = window.localStorage.getItem("hostSessionId"); 
		}
		
		if (vSession == '') {
			vSession = '00000000-0000-0000-0000-000000000000';
		}
	
		showWait(languageTxtSessionWait);
	    $.getJSON(window['parameterRoot'] + window['parameterLoginServicePath'] + '?method=mobileValidateSession&callback=?&hostSessionId='+vSession, function(data) {
			var vResult = 0;
			var vAccount = "";
			var vName = "";
			$.coldfusion.eachRow(data, function( rowIndex ){
				vResult = this.RESULT;
				vAccount = this.ACCOUNT;
				vName = this.NAME;
			});
			
			if (vResult == 1) {
				window['parameterUserName'] = vName + " [" + vAccount + "]";
				onSuccess();
			}else{
				if (vResult == -1) {
					alert(languageTxtErrorExpiredLicense);
				}
				window['parameterUserName'] = "";
				window['parameterSelectedWorkOrder'] = "00000000-0000-0000-0000-000000000000";
				window.localStorage.removeItem("hostSessionId");
				hideWait(); 
				$('#modalLogin').css('display', 'block');
				onError();
			}
	    })
		.error(ajaxError);
	}
}

//Initialize Container
function initializeContainer() {

	//Apply Style
	applyStyle();
	
	//Apply Language
	applyLanguage(window['parameterApplicationLanguage']);
	
	//Preselect data
	preSelectData();

	//Menu Effects
	$('#verticalToggler, #btnMenuFindContainer').on(globalClickEvent, function(event) {
		if ($('#menuContainer').is(':visible')) {
			if (window['parameterMenuAnimations'] == 0) {
				$('#menuContainer').css('display', 'none');
			}else{	
				$('#menuContainer').animate({opacity: 0.05, width:'hide'}, window['parameterMenuEffectTime'], window['parameterMenuEffectEasing']);
			}
		}else{
			if (window['parameterMenuAnimations'] == 0) {
				$('#menuContainer').css('display', 'block');
			}else{
				$('#menuContainer').animate({width:'show', opacity: 1}, window['parameterMenuEffectTime'], window['parameterMenuEffectEasing']);
			}
		}
	});
	
	//Responsiveness
	customResize();
	$(window).on('orientationchange resize', customResize);
	
	//Change Language
	$('#selectLanguage').change(function() {
		window['parameterApplicationLanguage'] = $('#selectLanguage option:selected').val();
		applyLanguage(window['parameterApplicationLanguage']);
	});
	
	//Change Animation Settings
	$('#selectEnableAnimations').change(function() {
		window['parameterMenuAnimations'] = $('#selectEnableAnimations option:selected').val();
		restoreFilterContainersOpacity();
	});
	
	//Close modals
	$('.closeModal, .closeModal img, .modalBoxOverlay, .vertical-offset').on(globalClickEvent, function(e) {
		if (e.target === this) {
			if (!$('#modalWait,#modalLogin').is(":visible")) {
				$('#txtDatePicker').mobiscroll('hide');
				$('.modalBoxWrap').css('display', 'none');
			}
		}
	});
	
	//Allows closing modals with ESC, all but the wait and login screen
	$('html').on('keyup', function(e) {
		if(e.keyCode === 27 && $('.modalBoxWrap').is(":visible") && !$('#modalWait,#modalLogin').is(":visible")) {
		    $('#txtDatePicker').mobiscroll('hide');
			$('.modalBoxWrap').css('display', 'none');
		}
	});
	
	//Show Building modal
	$('#btnBuilding').on(globalClickEvent, function() {
		$('#modalBuilding').css('display', 'block');
	});
	
	//Show Date modal
	$('#btnDate').on(globalClickEvent, function() {
		$('#modalDate').css('display', 'block');
	});
	
	//Show About modal
	$('#btnAbout').on(globalClickEvent, function() {
		$('#lblPromisanAppVersion').html(window['parameterAppName'] + '<br>Version: ' + window['parameterAppVersion']);
		$('#modalAbout').css('display', 'block');
	});
	
	//Login
	$('#btnLogin').on(globalClickEvent, function() {
		login(function(){
			validateSession( function() {
				//success
				getAndFillCustomerList();
			});
		},
		function(){
			//error
			$('#txtLoginResult').html(languageTxtErrorLogin);
		});
	});
	
	//Logout
	$('#btnLogout').on(globalClickEvent, function() {
		logout(function(){
			//success
			$('#modalLogin').css('display', 'block');
			hideWait();
		},
		function(){
			//error
			alert(languageTxtErrorLogout);
		});
	});
	
	//Login and first load data
	validateSession(function(){
		//success
		getAndFillCustomerList();
	}, function(){});
	
	//Reload button
	$('#btnReload').on(globalClickEvent, function(event) {
		validateSession(function(){
			//success
			$('#txtSearch').val('');
			getAndFillDataList(window['parameterSelectedWorkOrder'], globalISOSelectedDate);
		}, function(){});
	});
	
	//Clear search button
	$('#btnCleanSearch').on(globalClickEvent, function(event) {
		validateSession(function(){
			//success
			$('#txtSearch').val('');
			filterDataList(window['parameterSelectedWorkOrder'], globalISOSelectedDate);
		}, function(){});
	});
	
	//Select search text on focus
	$("#txtSearch").on('focus '+globalClickEvent, function(){
	    this.select();
	});
	
	//Hide menu on click on main content
	$("#mainContent").on(globalClickEvent, function(){
		if ($('#menuContainer').is(':visible')) {
			if (window['parameterMenuAnimations'] == 0) {
				$('#menuContainer').css('display', 'none');
			}else{	
				$('#menuContainer').animate({opacity: 0.05, width:'hide'}, window['parameterMenuEffectTime'], window['parameterMenuEffectEasing']);
			}
		}
	});
	
	//Do filter
	$('#txtSearch').on('keyup', function(event) {
		filterDataList();
	});
	
	//Select workOrder
	$('#btnSelectWorkOrder').on(globalClickEvent, function() {
		validateSession(function(){
			//success
			var selWO = $("input[type='radio'][name='radioWorkOrder']:checked").val();
			$('#modalBuilding').css('display', 'none');
			if (window['parameterSelectedWorkOrder'].toLowerCase() != selWO.toLowerCase()) {
				window['parameterSelectedWorkOrder'] = selWO;
				getAndFillDataList(window['parameterSelectedWorkOrder'], globalISOSelectedDate);
			}else{
				hideWait();
			}
		}, function(){});
	});
	
	//Select date
	$('#btnSelectDate').on(globalClickEvent, function() {
		validateSession(function(){
			//success
			$('#txtDatePicker').mobiscroll('hide');
			$('#modalDate').css('display', 'none');
			if ($('#txtDatePicker').val() != globalSTRSelectedDate) {
				selectDate($('#txtDatePicker').val());
				getAndFillDataList(window['parameterSelectedWorkOrder'], globalISOSelectedDate);
			}
		}, function(){});
	});
	
}


