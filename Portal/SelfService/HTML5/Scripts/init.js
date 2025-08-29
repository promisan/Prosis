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
//Refresh iframe on demand
function refreshIframeOnDemand(id, force, callback) {
	var vTree = 'tools/treeView/treeViewInit.cfm';
	
	var vSrc = decodeURIComponent($.trim($('#PortalViewSrc_'+id).html()));
	
	var vCurrentSrc = $('#PortalView_'+id).attr('src');
	var rt = $('#_RootSite').html();
	var vMenuGUID = $('#mainMenuGUID_'+id).html();
	var vPortalMission = $('#_PortalMission').html();
	
	if (force || vCurrentSrc.indexOf(vTree) != -1 || vCurrentSrc == '') {
		$('#busy_'+id).show();
		$('#PortalView_'+id).hide();
		$('#PortalView_'+id).off('load');
		$('#PortalView_'+id).on('load', function() {
			$('#busy_'+id).hide(); 
			$('#PortalView_'+id).fadeIn(350); 
			resizeContentIFrame('#PortalView_'+id);
		});
		//here loads the content
		
		ptoken.setSrc(vSrc,'PortalView_'+id);
		_logActivity(rt, vMenuGUID, vPortalMission);
	}
	
	if (callback) {
		callback();
	}
}

//Menu functions
function toggleMenuOverlay(val, selector, endPosition, callback) {
	var vPosition = '-100%';
	var vDisplay = '';

	if (val) {
		vPosition = endPosition;
		if (selector.indexOf(",") == -1) {
			$(selector + ' .clsMainMenuOverlayClose img').css('visibility','visible');
		}
	}
	
	if (Modernizr.csstransforms3d) {
		$(selector).css('transform', 'translate3d('+vPosition+',0,0) scale3d(1,1,1)');
	} else if (Modernizr.csstransforms) {
		$(selector).css('transform', 'translate('+vPosition+',0)');
	} else {
		$(selector).css('left', vPosition);
	}
	
	if (!val) {
		if (selector.indexOf(",") == -1) {
			$(selector + ' .clsMainMenuOverlayClose img').css('visibility','hidden');
		}
	}
	
	if (callback) {
		setTimeout(function(){
			callback();
		},500)
	}
}

//Add 0 if less than 10
function formatDateNumber(v){
	var vReturn = v;
	if (v < 10) {
		vReturn = "0" + v;
	}
	
	return vReturn;
}

//Return text date/time
function getTextDate(format,separator) {
	var currentdate = new Date(); 
	var vReturn = "";
	
	if (format == "EU") {
		vReturn = formatDateNumber(currentdate.getDate()) + "/" + formatDateNumber(currentdate.getMonth()+1) + "/" + currentdate.getFullYear();
	}else{
		vReturn = formatDateNumber(currentdate.getMonth()+1) + "/" + formatDateNumber(currentdate.getDate()) + "/" + currentdate.getFullYear();
	}
	
	vReturn = vReturn + separator;
	
	vReturn = vReturn + formatDateNumber(currentdate.getHours() > 12 ? currentdate.getHours() - 12 : currentdate.getHours()) + ":" + formatDateNumber(currentdate.getMinutes()) + ":" + formatDateNumber(currentdate.getSeconds());
	vReturn = vReturn + " " + (currentdate.getHours() > 12 ? "PM" : "AM");
	vReturn = vReturn + " GMT" + (currentdate.getTimezoneOffset()/-60); 
	
	return vReturn;
}


//Show Login
function showLogin() {
	hideMenus();
	toggleMenuOverlay(true, '#MainMenuLogin', '0px', function() { $('#Account').focus(); if ($.trim($('#Account').val()) != '') { $('#password').focus(); } });
}

//Show Menu
function showMainMenu() {
	if ($('#MainMenu .clsMainMenuOverlayClose img').css('visibility') == 'hidden') {
		hideMenus();
		toggleMenuOverlay(true, '#MainMenu', '-40%', function() { });
	}else {
		toggleMenuOverlay(false, '#MainMenu', '-40%', function() { });
	}
}

//Show Options
function showOptions() {
	if ($('#MainMenuOptions .clsMainMenuOverlayClose img').css('visibility') == 'hidden') {
		hideMenus();
		toggleMenuOverlay(true, '#MainMenuOptions', '0px', function() {
			refreshIframeOnDemand('Options', true, function() {});
		});
	}else{
		toggleMenuOverlay(false, '#MainMenuOptions', '0px', function() { });
	}
}
//Show Clearances
function showClearances() {
	if ($('#MainMenuClearances .clsMainMenuOverlayClose img').css('visibility') == 'hidden') {
		hideMenus();
		toggleMenuOverlay(true, '#MainMenuClearances', '0px', function() {
			refreshIframeOnDemand('Clearances', true, function() {});
		});
	}else{
		toggleMenuOverlay(false, '#MainMenuClearances', '0px', function() { });
	}
}

//Show Portal Configurations
function showConfigurations(rt,id) {
	ptoken.open(rt+"/System/Modules/PortalBuilder/RecordEdit.cfm?systemmodule=Selfservice&functionClass=Selfservice&id="+id+"&ts="+new Date().getTime(), 'wPP_ShowConfigurations', "status=no,height=850,width=1024,top=50,left=50,resizable=yes");
}

//Show Account Request
function accountRequest(rt,id) {
	ptoken.open(rt+'/Portal/SelfService/Extended/Account/AccountRequestForm.cfm?showClose=0&id='+id+"&ts="+new Date().getTime(), 'wPP_AccountRequest', "status=no,height=620,width=700,top=50,left=50");
}

//Show Forgot Password
function forgotPassword(rt,id) {
	ptoken.open(rt+'/PasswordAssist.cfm?mode=portal&idtemplate=resetpassword&id='+id+"&ts="+new Date().getTime(), 'wPP_Forgotpassword', "status=no,height=600,width=590,top=50,left=50");
}

//Show Forgot User
function forgotUser(rt,id) {
	ptoken.open(rt+'/UsernameAssist.cfm?id='+id+"&ts="+new Date().getTime(), 'wPP_Forgotusername', "status=no,height=600,width=590,top=50,left=50");
}

//Show Support
function showSupport(rt,id) {
	ptoken.open(rt+'/System/Modification/DocumentEntry.cfm?systemfunctionid='+id+'&systemmodule=System&observationclass=inquiry&context=status&ts='+new Date().getTime(), 'supportticket', 'left=40, top=40, width=1100,height=885, status=yes, scrollbars=no, resizable=yes');
}

//Hide Portal Information
function hideInformation() {
	$('.clsHeaderInformation').slideUp(500);
}

//Show Portal Information
function showInformation() {
	if ($('.clsHeaderInformation').is(':visible')) {
		hideInformation();
	}else{
		$('.clsHeaderInformation').slideDown(500);
	}
}

//Resize content iframe
function resizeContentIFrame(selector) {
	resizeLIContainers();
	$(selector).each(function() {
		//$(this).css('height', ($(this).contents().height()) + 'px');
		$(this).css('height', ($(window).height() - 67) + 'px'); // minus header size
	});
}

//Resize the menu items depending on the size of the container
function resizeMenuItems() {
	var minMenuItemSize = 300;
	var containerWidth = $('#MainMenu .clsMainMenuOverlayItemContainer').first().width();
	var newMenuItemWidth = 1;
	var itemsInContainer = containerWidth / minMenuItemSize;
	var itemsInRow = Math.floor(itemsInContainer);
	
	if($('.clsMainMenuOverlayItem').length < itemsInContainer) {
		itemsInRow = $('.clsMainMenuOverlayItem').length;
	}
	
	//Recaluculate the new width
	if(itemsInContainer < 1) {
		newMenuItemWidth = minMenuItemSize;
	} else {
		if ((itemsInContainer % 1) === 0) {
			newMenuItemWidth = minMenuItemSize;
		}else {
			newMenuItemWidth = (containerWidth / itemsInRow) - 35; //-35 for the borders and spaces between items
		}
	}
	
	//Set the new width
	$('.clsMainMenuOverlayItem').width(newMenuItemWidth);
}

//Show/hide elements depending on size
function toggleResponsiveElements() {
	if ($(window).width() < 500) {
		$('body').css('font-size','10px');
		$('.clsMainMenuContainerText, .clsNavigationBarTitlePrev, .clsNavigationBarTitleNext, .clsHeaderLogoImage').css('display','none');
		$('.clsNavigationBarTitle').css('font-size','10px');
		$('.clsNavigationBarTitleNext, .clsNavigationBarTitlePrev').css('font-size','11px');
		$('.clsMainMenuContainer img, .clsLanguageMenuIcon').css('height','40px').css('width','40px');
		$('.clsLoginSide').hide();
	}else{
		$('body').css('font-size','13px');
		$('.clsMainMenuContainerText, .clsNavigationBarTitlePrev, .clsNavigationBarTitleNext, .clsHeaderLogoImage').css('display','');
		$('.clsNavigationBarTitle').css('font-size','15px');
		$('.clsNavigationBarTitleNext, .clsNavigationBarTitlePrev').css('font-size','12px');
		$('.clsMainMenuContainer img, .clsLanguageMenuIcon').css('height','30px').css('width','30px');
		$('.clsLoginSide').show();
	}
}

//Resize li containers from carousel
function resizeLIContainers() {
	$('.clsCarousel, .clsCarousel ul, .clsCarousel li').each(function() {
		$(this).css('height', ($(window).height() - 67) + 'px'); // minus header size
	});
}

//Responsive functions
function customResize()	{
	resizeContentIFrame('.clsIframeMainContent');
	resizeMenuItems();
	toggleResponsiveElements();
}
$(window).on('orientationchange resize', customResize);


//Function to hide the address bar in the mobile browser
$(window).on('load', function() {
	// Set a timeout...
	setTimeout(function(){
		// Hide the address bar!
		window.scrollTo(0, 1);
	}, 0);
});

//Prevent drag for selected areas
$('.clsUnselectableImages, .clsUnselectableImages img').on('dragstart', function(e) {
	e.preventDefault();
	return false;
});

//Selected effect for menus
$('.clsMainMenuOverlayItem').on('mouseover',function() {
	if (!$(this).hasClass('clsMainMenuOverlayItemSelected')) {
		$(this).find('.clsMainMenuOverlayItemSelectedBar').removeClass('clsMainMenuOverlayItemSelectedBar-MouseOut').addClass('clsMainMenuOverlayItemSelectedBar-MouseOver');
	}
});

$('.clsMainMenuOverlayItem').on('mouseout',function() {
	if (!$(this).hasClass('clsMainMenuOverlayItemSelected')) {
		$(this).find('.clsMainMenuOverlayItemSelectedBar').removeClass('clsMainMenuOverlayItemSelectedBar-MouseOver').addClass('clsMainMenuOverlayItemSelectedBar-MouseOut');
	}
});

//Toggle Prev/Next texts
/*
$('.clsNavigationBarNext').hover(function(){
	$('.clsNavigationBarTitleNext').fadeIn(750);
}, function(){
	$('.clsNavigationBarTitleNext').fadeOut(750);
});

$('.clsNavigationBarPrev').hover(function(){
	$('.clsNavigationBarTitlePrev').fadeIn(750);
}, function(){
	$('.clsNavigationBarTitlePrev').fadeOut(750);
});*/

//Hide menus with Escape key
function hideMenus() {
	$('.clsMainMenuOverlay, .clsLoginOverlay').each(function(){
		if ($(this).attr('id') != 'MainMenuWait') {
			toggleMenuOverlay(false, '#' + $(this).attr('id'), '0px', function() {});
		}
	});
}
$('html').on('keyup', function(e) {
	if(e.keyCode === 27) {
		hideMenus();
		hideInformation();
	}
});

//Hide any menu on click outside
/*
$('.clsIframeMainContent').contents().find('html').on('click', function(e) {
	alert();
});*/

//Show main menu with Alt+Q
$('html').on('keyup', function(e) {
	if(e.altKey && e.keyCode === 81) {
		showMainMenu();
	}
});

//Show options menu with Alt+W
$('html').on('keyup', function(e) {
	if(e.altKey && e.keyCode === 87) {
		showOptions();
	}
});

//Show options menu with Alt+L
$('html').on('keyup', function(e) {
	if(e.altKey && e.keyCode === 76) {
		showLogin();
	}
});

//Show information menu with Alt+I
$('html').on('keyup', function(e) {
	if(e.altKey && e.keyCode === 73) {
		showInformation();
	}
});


$('#mainMenuInformation').on('click',function() {
	showInformation();
});

$('#mainMenuMenu').on('click', function(){ 
	showMainMenu();
});

$('#btnMainMenuHide').on('click', function(){
	toggleMenuOverlay(false, '#MainMenu', '-40%', function() {});
});

$('#mainMenuPreferences').on('click', function(){ 
	showOptions();
});

$('#mainMenuClearances').on('click', function(){ 
	showClearances();
});

$('#btnMainMenuOptionsHide').on('click', function(){
	$('#PortalView_Options').attr('src', '');
	toggleMenuOverlay(false, '#MainMenuOptions', '0px', function() {});
});

$('#btnMainMenuClearancesHide').on('click', function(){
	$('#PortalView_Clearances').attr('src', '');
	toggleMenuOverlay(false, '#MainMenuClearances', '0px', function() {});
});

$('#mainMenuLogin').on('click', function(){ 
	showLogin();
});

$('#mainMenuConfiguration').on('click', function(){ 
	var rt = $('#_RootSite').html();
	var id = $('#_PortalGUID').html();
	showConfigurations(rt,id);
});

$('#mainMenuSupport').on('click', function(){ 
	var rt = $('#_RootSite').html();
	var id = $('#_PortalGUID').html();
	showSupport(rt,id);
});

$('#mainMenuLanguage').hover(function(){
	setTimeoutMainMenuLanguage = setTimeout(function(){
    	$('.clsMainMenuLanguageMenuContainer').slideDown(500);
    }, 500);
}, function() {
	clearTimeout(setTimeoutMainMenuLanguage);
	$('.clsMainMenuLanguageMenuContainer').slideUp(500);
});

$('#btnMainMenuLoginHide').on('click', function(){
	toggleMenuOverlay(false, '#MainMenuLogin', '0px', function() {});
});

//Initialize carousel
var carousel = new Carousel("#mainCarousel");
carousel.init();
$('.clsMenuButtonHome').on('click',function(){ carousel.showPane(0); });

//Auto Resize on load
customResize();

//function reload tab
function _reloadTab() {
	$('.clsNavigationBarRefresh').click();
}

//Go to tab by systemFunctionId
function _goToTab(systemFunctionId, reload) {
	if ($('#menuItem_'+systemFunctionId).length > 0) {
		if ($.trim($('#menuItem_'+systemFunctionId).html()) != '') {
			carousel.showPane($('#menuItem_'+systemFunctionId).html());
			if (reload) { _reloadTab(); }
		}
	}
}

//Go to tab by number
function _goToTabByNumber(tabNumber, reload) {
	carousel.showPane(tabNumber);
	if (reload) { _reloadTab();	}
}

//Go to next tab
function _goToNextTab(reload) {
	carousel.next();
	if (reload) { _reloadTab(); }
}

//Go to previous tab
function _goToPreviousTab(reload) {
	carousel.prev();
	if (reload) { _reloadTab(); }
}
