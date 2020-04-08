/**
 * HOMER - Responsive Admin Theme
 * version 1.7
 *
 */

$(document).ready(function () {

    // Add special class to minimalize page elements when screen is less than 768px
    setBodySmall();

    // Handle minimalize sidebar menu
    $('.hide-menu').click(function(event){
        event.preventDefault();
        toggleSidebar();
		//Provision to fix the responsive issues on chartjs
		$("body").one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', function(e) {
			$('.prosisResponsiveGraph').width('100%');
		});
    });

    // Initialize metsiMenu plugin to sidebar menu
    $('#side-menu').metisMenu();

    // Initialize iCheck plugin
    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green',
        radioClass: 'iradio_square-green',
    });

    // Initialize animate panel function
    $('.animate-panel').animatePanel();

   	// Initializa hpanel buttons
	initPanelButtons();

    // Open close right sidebar
    $('.right-sidebar-toggle').click(function () {
        $('#right-sidebar').toggleClass('sidebar-open');
    });

    // Function for small header
    $('.small-header-action').click(function(event){
        event.preventDefault();
        var icon = $(this).find('i:first');
        var breadcrumb  = $(this).parent().find('#hbreadcrumb');
        $(this).parent().parent().parent().toggleClass('small-header');
        breadcrumb.toggleClass('m-t-lg');
        icon.toggleClass('fa-arrow-up').toggleClass('fa-arrow-down');
    });

    // Set minimal height of #wrapper to fit the window
    setTimeout(function () {
        fixWrapperHeight();
    });

    // Sparkline bar chart data and options used under Profile image on left navigation panel
    $("#sparkline1").sparkline([5, 6, 7, 2, 0, 4, 2, 4, 5, 7, 2, 4, 12, 11, 4], {
        type: 'bar',
        barWidth: 7,
        height: '30px',
        barColor: '#62cb31',
        negBarColor: '#53ac2a'
    });

    // Initialize tooltips
    $('.tooltip-demo').tooltip({
        selector: "[data-toggle=tooltip]"
    })

    // Initialize popover
    $("[data-toggle=popover]").popover();

    // Move modal to body
    // Fix Bootstrap backdrop issu with animation.css
    $('.modal').appendTo("body")

});

$(window).bind("load", function () {
    // Remove splash screen after load
    $('.splash').css('display', 'none')
})

$(window).bind("resize click", function () {

    // Add special class to minimalize page elements when screen is less than 768px
    setBodySmall();

    // Waint until metsiMenu, collapse and other effect finish and set wrapper height
    setTimeout(function () {
        fixWrapperHeight();
    }, 300);
})

function initPanelButtons() {
	// Function for collapse hpanel
	$('.showhide').off('click');
    $('.showhide').on('click', function (event) {
        event.preventDefault();
        var hpanel = $(this).closest('div.hpanel');
        var icon = $(this).find('i:first');
        var body = hpanel.find('div.panel-body');
        var footer = hpanel.find('div.panel-footer');
        body.slideToggle(300);
        footer.slideToggle(200);

        // Toggle icon from up to down
        icon.toggleClass('fa-chevron-up').toggleClass('fa-chevron-down');
        hpanel.toggleClass('').toggleClass('panel-collapse');
        setTimeout(function () {
            hpanel.resize();
            hpanel.find('[id^=map-]').resize();
        }, 50);
    });

    // Function for close hpanel
	$('.closebox').off('click');
    $('.closebox').on('click', function (event) {
        event.preventDefault();
        var hpanel = $(this).closest('div.hpanel');
        hpanel.remove();
    });
}

function _mobileGetISODate(pSelector) {
	var vDate = new Date($(pSelector).datepicker('getDate'));
	var vMonth = (((vDate.getMonth()+1) < 10) ? '0' + (vDate.getMonth()+1) : (vDate.getMonth()+1));
	var vDay = ((vDate.getDate() < 10) ? '0' + vDate.getDate() : vDate.getDate());
	var vDateISOStr = vDate.getFullYear() + '-' + vMonth + '-' + vDay;
	
	return vDateISOStr;
}

function _mobileCreateDateFromISO(ISODate) {
	var dateArray = ISODate.split(/\D/);
	return new Date(dateArray[0], --dateArray[1], dateArray[2]);
}

function _mobileInitializeDatePicker(pSelector, pFormat, pDate, pMinDate, pMaxDate, callback) {
	var vMinDate;
	var vMaxDate;
	var vCurrentDate = _mobileCreateDateFromISO(pDate);
	
	if (pMinDate == null || $.trim(pMinDate) == '') {
		vMinDate =  _mobileCreateDateFromISO('1980-01-01');
	} else {
		vMinDate = _mobileCreateDateFromISO(pMinDate);
	}
	
	if (pMaxDate == null || $.trim(pMaxDate) == '') {
		vMaxDate = _mobileCreateDateFromISO('2050-12-31');
	} else {
		vMaxDate = _mobileCreateDateFromISO(pMaxDate);
	}
	
	$(pSelector)
    	.datepicker({ 
    		format: pFormat,
    		todayHighlight: true,
    		todayBtn: 'linked'
    	})
    	.on('changeDate', function(e) {
    		$(this).datepicker('hide');
    		if (callback) { callback(); }
	});
	
	$(pSelector).datepicker('setStartDate', vMinDate);
	$(pSelector).datepicker('setEndDate', vMaxDate);
	$(pSelector).datepicker('setDate', vCurrentDate);
}

function doGrid(sel) {
	$(sel).dataTable();
}

function fixWrapperHeight() {

    // Get and set current height
    var headerH = 62;
    var navigationH = $("#navigation").height();
    var contentH = $(".content").height();

    // Set new height when contnet height is less then navigation
    if (contentH < navigationH) {
        $("#wrapper").css("min-height", navigationH + 'px');
    }

    // Set new height when contnet height is less then navigation and navigation is less then window
    if (contentH < navigationH && navigationH < $(window).height()) {
        $("#wrapper").css("min-height", $(window).height() - headerH  + 'px');
    }

    // Set new height when contnet is higher then navigation but less then window
    if (contentH > navigationH && contentH < $(window).height()) {
        $("#wrapper").css("min-height", $(window).height() - headerH + 'px');
    }
}

//Wait screen control
function prosisMobileWait(text) {
	$('#_waitModal .modal-body .modal-body-text').html(text);
	$('#_waitModal').modal('show');
}

function prosisMobileWaitClose() {
	$('#_waitModal').modal('hide');
}

//Add commas to number
function numberAddCommas(nStr)
{
	nStr += '';
	x = nStr.split('.');
	x1 = x[0];
	x2 = x.length > 1 ? '.' + x[1] : '';
	var rgx = /(\d+)(\d{3})/;
	while (rgx.test(x1)) {
		x1 = x1.replace(rgx, '$1' + ',' + '$2');
	}
	return x1 + x2;
}

//Round to N decimals
function roundNumber(num, dec) {
	return Math.round(num * 10 * dec) / (10 * dec);
}

//Toggle side-bar
function toggleSidebar() {
	if ($(window).width() < 769) {
		$("body").toggleClass("show-sidebar");
	} else {
		$("body").toggleClass("hide-sidebar");
	}
}

function setBodySmall() {
    if ($(this).width() < 769) {
        $('body').addClass('page-small');
    } else {
        $('body').removeClass('page-small');
        $('body').removeClass('show-sidebar');
    }
}

// Animate panel function
$.fn['animatePanel'] = function() {

    var element = $(this);
    var effect = $(this).data('effect');
    var delay = $(this).data('delay');
    var child = $(this).data('child');

    // Set default values for attrs
    if(!effect) { effect = 'zoomIn'};
    if(!delay) { delay = 0.06 } else { delay = delay / 10 };
    if(!child) { child = '.row > div'} else {child = "." + child};

    //Set defaul values for start animation and delay
    var startAnimation = 0;
    var start = Math.abs(delay) + startAnimation;

    // Get all visible element and set opactiy to 0
    var panel = element.find(child);
    panel.addClass('opacity-0');

    // Get all elements and add effect class
    panel = element.find(child);
    panel.addClass('animated-panel').addClass(effect);

    // Add delay for each child elements
    panel.each(function (i, elm) {
        start += delay;
        var rounded = Math.round(start * 10) / 10;
        $(elm).css('animation-delay', rounded + 's')
        // Remove opacity 0 after finish
        $(elm).removeClass('opacity-0');
    });
}