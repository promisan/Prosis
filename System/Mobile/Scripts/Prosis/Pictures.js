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
// Retrieve image file location from specified source

function getPhoto() {
	navigator.camera.getPicture(function(imageURI) {
		$('#cameraPicURI').html(imageURI);
		$('#cameraPic').attr('src', imageURI);
	}, null, {
		sourceType: navigator.camera.PictureSourceType.SAVEDPHOTOALBUM,
		quality: 40,
		destinationType: Camera.DestinationType.FILE_URI,
		allowEdit:true
	});
}

function capturePhoto() {
	navigator.camera.getPicture(function(imageURI) {
		$('#cameraPicURI').html(imageURI);
		$('#cameraPic').attr('src', imageURI);
	}, null, {
		sourceType: navigator.camera.PictureSourceType.CAMERA,
		quality: 40,
		destinationType: Camera.DestinationType.FILE_URI,
		allowEdit:true
	});
}

function uploadPhoto(woaid) {
	if (checkInternetConnection()) {
		var imageURI = $('#cameraPicURI').html();
		var imageMemo = $('#txtUploadMemo').val();
		var vAttachmentId = guidGenerator(); //new guid
		
		$('#cameraPicURIPercentage').html('');
		
		var vSession = '';
		if (window.localStorage.getItem("hostSessionId")) { 
			vSession = window.localStorage.getItem("hostSessionId"); 
		}
		
		if (imageURI != '') {
				var options = new FileUploadOptions();
				options.fileKey='file';
				options.fileName=imageURI.substr(imageURI.lastIndexOf('/')+1);
				if (options.fileName.indexOf('.jpg') == -1 && options.fileName.indexOf('.png') == -1 && options.fileName.indexOf('.gif') == -1) {
					options.fileName = options.fileName + '.jpg';
				}
				options.mimeType='image/jpeg';
				options.chunkedMode=false;
				
				var params = new Object();
				params.actionId = woaid;
				params.sessionId = vSession;
				params.memo = imageMemo;
				params.attachmentId = vAttachmentId;
				options.params = params;
				
				$('#btnUploadPhoto').css('display','none');
				var ft = new FileTransfer();
				ft.upload(imageURI, window['parameterUploadService'], function() {
				
					//successful upload
					successUploadPhoto(woaid, imageURI, imageMemo, vAttachmentId);
					
				}, 
				errorUploadPhoto, options, true);
				
				ft.onprogress = function(progressEvent) {
				    if (progressEvent.lengthComputable) {
				      $('#cameraPicURIPercentage').html(Math.round(100 * progressEvent.loaded / progressEvent.total).toString() + '%');
				    }
				};
		}
	}
}

function successUploadPhoto(woaid, imageURI, imageMemo, attachmentId) {
	var newPicture = '';
	var now = new Date();
	var dd = now.getDate();
	var mm = now.getMonth() + 1;
	var yyyy = now.getFullYear();
	var hh = now.getHours();
	var minutes = now.getMinutes();
	var newPictureDetails = languageTxtUploadedBy + ': ' + window['parameterUserName'] + ' @ ' + formatToAppDate(yyyy, mm, dd) + ' ' + hh + ':' + minutes;

	//Add picture to the interface
	newPicture = '<div class="clsActionDetailPictureContainer" id="actionDetailPictureImage_'+attachmentId+'">' 
					+'<img class="clsImgActionDetailPicture" id="imgActionDetailPicture_'+attachmentId+'" src="' + imageURI + '" title="'+imageMemo+'" on'+globalClickEvent+'="showPicture(\'' + attachmentId + '\', \'' + imageURI + '\', \'' + imageMemo + '\', \'' + newPictureDetails + '\');">'
					+'<img src="Images/' + window['parameterIconSet'] + '/delete.png" class="clsRemoveActionDetailPicture" on'+globalClickEvent+'="removeActionPicture(\'' + attachmentId + '\');"/>'
				+'</div>';
	
	$('#actionDetailPictureContainer_'+woaid).append(newPicture);
	$('.clsImgActionDetailPicture').css('border', window['parameterLinesStyle']);
	$('#mainListingElementContainer_'+woaid).removeClass('clsFilterableWithoutPictures').removeClass('clsFilterableWithPictures').addClass('clsFilterableWithPictures');
	
	//Update picture object list
	globalPicturesList.DATA.REFERENCE.push(woaid);
	globalPicturesList.DATA.ATTACHMENTID.push(attachmentId);
	globalPicturesList.DATA.PICTUREPATH.push(imageURI);
	globalPicturesList.DATA.ATTACHMENTMEMO.push(imageMemo);
	globalPicturesList.DATA.OFFICERFIRSTNAME.push('');
	globalPicturesList.DATA.OFFICERLASTNAME.push('');
	globalPicturesList.DATA.CREATED.push('');
	globalPicturesList.DATA.DATECREATED.push(0);
	globalPicturesList.DATA.YEARCREATED.push(0);
	globalPicturesList.DATA.MONTHCREATED.push(0);
	globalPicturesList.DATA.DAYCREATED.push(0);
	globalPicturesList.DATA.HOURCREATED.push(0);
	globalPicturesList.DATA.ALLOWREMOVE.push(1);
	
	//Clean screen
	$('#cameraPicURIPercentage').html(languageTxtCompleted);
	$('#cameraPicURI').html('');
	$('#cameraPic').attr('src', '../../../System/Mobile/Images/empty.gif');
	$('#txtUploadMemo').val('');
	$('#btnUploadPhoto').css('display','block');
}

function errorUploadPhoto(error) {
    alert(languageTxtErrorUpload + error.code + ' ' + languageTxtTryAgain);
	$('#btnUploadPhoto').css('display','block');
}