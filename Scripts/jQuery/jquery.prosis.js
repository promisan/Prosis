if (window.jQuery) {
	var focusedRow      = null;
	var currentSelected = null;
	var lastEnter = false;	
	var focusClick = false;
	var paging = false;
	
	var navigationhover    = "#A8EFF2";
	var navigationselected = "#F0F0F0";
	var previouscolor	   = "transparent";
	var previousclicked    = "transparent";

	function _ProsisObject(){}

	_ProsisObject.prototype.exportToExcel = function(tableId) {
		var vLocalId = tableId;
		
		if (tableId && $('#'+tableId).length > 0) {

	    	Prosis.busy('yes');

	    	setTimeout(function(){

	        	var uri = 'data:application/vnd.ms-excel;';
		  		var template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>';
		  		var base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) };
		  		var format = function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) };

		  		var $TempContent = $("<table>");
		  		$TempContent.html($('#'+tableId).html());
		  		$TempContent.find(".clsNoExportToExcel").remove();

		  		var vContent = $TempContent.html();

	        	if (!tableId.nodeType) tableId = document.getElementById(tableId);
		    	var ctx = { worksheet: vLocalId || 'Worksheet', table: vContent };
		    	var vBlob = __b64toBlob(base64(format(template, ctx)), uri);

		    	if (navigator.msSaveOrOpenBlob) {
		    		//IE and Edge
			    	navigator.msSaveOrOpenBlob(vBlob, vLocalId + ".xls");
			  	} else {
			  		//Chrome
			  		var link = document.createElement('a');
			    	link.download = vLocalId + '.xls';
			    	link.href = URL.createObjectURL(vBlob);
					link.click();
			  	}

			  	Prosis.busy('no');

	    	}, 250);

    	}

	}

	_ProsisObject.prototype.cleanMessage = function(msg) {
		var vMsg = $.trim(msg.replace(/\n/gi, '<br>'));
		return vMsg;
	};

	_ProsisObject.prototype.getPopupTitle = function(ptype) {
		var vTitle = '';

		if ($.trim(ptype).toLowerCase() == 'alert') {
			vTitle = 'Alert';
		}

		if ($.trim(ptype).toLowerCase() == 'confirm') {
			vTitle = 'Confirm';
		}

		if (__ProsisWelcome) {
			if ($.trim(__ProsisWelcome) != '') {
				vTitle = __ProsisWelcome;
			}
		}

		return vTitle;
	};

	_ProsisObject.prototype.alert = function(msg, pCallback) {
		var vMsg = this.cleanMessage(msg);
		var vTitle = this.getPopupTitle('alert');

		$.alert({
    		title: vTitle,
    		type: 'dark',
    		typeAnimated: true,
    		closeIcon: false,
    		boxWidth: '25%',
    		offsetTop: 175,
    		animation: 'zoom',
    		closeAnimation: 'scale',
    		draggable: false,
    		content: vMsg,
    		theme: 'material',
    		escapeKey: true,
    		useBootstrap: false,
    		buttons: {
		        OK: {
		        	text: __ProsisOk,
		            btnClass: 'btn-dark',
		            action: function(){ 
		            	if (typeof pCallback != 'undefined') {
		            		pCallback();
		            	}
		            }
		        }
		    }
		});
	};

	_ProsisObject.prototype.confirm = function(msg, yesCallback, noCallback) {
		var vMsg = this.cleanMessage(msg);
		var vTitle = this.getPopupTitle('confirm');

		$.confirm({
    		title: vTitle,
    		type: 'dark',
    		typeAnimated: true,
    		closeIcon: false,
    		boxWidth: '25%',
    		offsetTop: 175,
    		animation: 'zoom',
    		closeAnimation: 'scale',
    		draggable: false,
    		content: vMsg,
    		theme: 'material',
    		escapeKey: true,
    		useBootstrap: false,
    		buttons: {
		        Yes: {
		        	text: __ProsisYes,
		            btnClass: 'btn-green',
		            action: function(){ 
		            	if (typeof yesCallback != 'undefined') {
		            		yesCallback();
		            	}
		            }
		        },
		        No: {
		        	text: __ProsisNo,
		            btnClass: 'btn-red',
		            action: function(){ 
		            	if (typeof noCallback != 'undefined') {
		            		noCallback();
		            	}
		            }
		        }
		    }
		});
	};

	_ProsisObject.prototype.deferredConfirm = function(msg) {
		var def = $.Deferred();
		this.confirm(msg, function() { def.resolve(); }, function() { def.reject(); } );
		return def.promise();
	};

	_ProsisObject.prototype.submitConfirm = function(msg, element) {
		this.deferredConfirm(msg).done(function() {
			$(element).closest('form').trigger('submit');
		});
	};
	
	_ProsisObject.prototype.busy = function(mode,sdiv){

		var larg = arguments.length
		
		if (mode=='yes') {

			$("#page-cover").css("opacity",0.6);
			$("#page-cover").fadeIn(300, function () {
				
				if (larg==2)
				{ //div argument comes
					$('#'+sdiv).css({'position':'absolute','z-index':99999999});
					$('#'+sdiv).show();
				}
				
     		});			
		} else {
			$("#page-cover").fadeOut(300,function(){
				if (larg == 2)
				{
					$('#'+sdiv).css({'position':'absolute','z-index':0});
					$('#'+sdiv).hide();
				}				
			});
		}	
	}
	
	_ProsisObject.prototype.presentation = function(sel,mode,onoff,time,ease,callback){
		var vAnimation, vAnimationOff, vAnimationOn;
			
		if (mode.toLowerCase() == "fade") {
			vAnimationOff = {opacity:0};
			vAnimationOn = {opacity:1};
		}
		if (mode.toLowerCase() == "slidehorizontal") {
			vAnimationOff = {width:'toggle'};
			vAnimationOn = {width:'toggle'};
		}
		if (mode.toLowerCase() == "slidevertical") {
			vAnimationOff = {height:'toggle'};
			vAnimationOn = {height:'toggle'};
		}
		
		if (onoff.toLowerCase() == "on") {
			vAnimation = vAnimationOn;
		}
		
		if (onoff.toLowerCase() == "off") {
			vAnimation = vAnimationOff;
		}
		
		$(sel).animate(vAnimation,time/2,ease,function() { 
			if (callback) {
				callback();
			}
		});
	}
	
	_ProsisObject.prototype.presentationFade = function(sel,onoff,callback){
		_ProsisObject.prototype.presentation(sel,'fade',onoff,1500,'swing',callback);
	}
	
	_ProsisObject.prototype.presentationHSlide = function(sel,onoff,callback){
		_ProsisObject.prototype.presentation(sel,'slideHorizontal',onoff,1500,'swing',callback);
	}
	
	_ProsisObject.prototype.presentationVSlide = function(sel,onoff,callback){
		_ProsisObject.prototype.presentation(sel,'slideVertical',onoff,1500,'swing',callback);
	}

	var Prosis = new _ProsisObject;

	$(document).ready(function(){
		try {
			ColdFusion.Event.registerOnLoad(doHighlight, null, false, true);
			ColdFusion.Event.registerOnLoad(doEnterListener, null, false, true);
		} catch(ex)	{
			doHighlight();
			doEnterListener();	}

	});	

	function doClick() {
        lastEnter = true;		
        if (focusedRow.attr('class').indexOf("navigation_row") != -1) {        
            action_element = focusedRow.find('.navigation_action');
            if (action_element) {
                script = action_element.attr('onClick');
                if (script) {
                    action_element.click();
                } else {
                    script = action_element.attr('href');
                    if (script)
                    { 
                        window.location.href = script;
                    }
                }                
                
            }
        }		
	}			


	function doPageUpDown(ev){
		//Page Up	33
		//Page Down	34
		paging = false;
		if ($('#page').length) {
			if (ev.which == 33 || ev.which == 34) {
			
				obj_page = $('##page');
				
				var item_select = false;
				if (obj_page) 
					if (obj_page.val()) 
						item_select = true;
				
				if (item_select) {
					selected_page = obj_page.val();
					//Page Up
					if (ev.which == 33) {
						previous = parseInt(selected_page) - 1;
						if (previous > 0) {
							obj_page.val(selected_page - 1);
							obj_page.change();
							paging = true;
						}
						
					}
					//Page Down
					else {
						next = parseInt(selected_page) + 1;
						obj_page.val(next);
						obj_page.change();
						paging = true;
					}
					
				}
				else {
					//Page Up
					if (ev.which == 33) {
						obj_prior = $('##Prior');
						if (obj_prior) {
							obj_prior.click();
							paging = true;
							
						}
					}
					//Page Down
					else {
						obj_next = $('##Next');
						if (obj_next) {
							obj_next.click();
							paging = true;
						}
					}
				}
				
			}
		}
	}
	
	function clearFocus(t_focusedRow)
	{
		if (currentSelected)
		{
			currentSelected.css("backgroundColor",previousclicked);
			currentSelected.removeClass("focused");
			currentSelected.find('td.navigation_pointer').html('&nbsp;&nbsp;&nbsp;&nbsp;');
			
		}
	}
	
	function setFocus(t_focusedRow)	{
				
		previousclicked = t_focusedRow.attr('bgcolor');
		if (!previousclicked)
			previousclicked = 'transparent';
		
		setColors(t_focusedRow);
						
		var table = t_focusedRow.parents('.navigation_table');		
		$(table).children().find('.focused').css({background:previousclicked});
		$(table).children().find('.focused').css("backgroundColor",previousclicked);
		
		$(table).children().find('.focused').removeClass('focused');
		
		if (t_focusedRow) {
			
			t_focusedRow.find('td.navigation_pointer').html('<img src="'+hostname+'/Images/arrow5.png'+'"/>');
			t_focusedRow.addClass('focused');		
			if (navigationselected!='transparent')
			{
				t_focusedRow.css({background:navigationselected});
				t_focusedRow.css("backgroundColor",navigationselected);
			}
			
			current = t_focusedRow.nextAll("tr:visible").first();			
			while (current.hasClass("navigation_row_child")) {
				current.addClass('focused');
				current.css({background:navigationselected});
				current.css("background",navigationselected);
				current = current.nextAll("tr:visible").first();				
			}
			
			var eFocus = t_focusedRow.find('td.on_focus');
			if (eFocus)
			{
				focusClick = true;
				eFocus.click();
				
			}
			
			focusClick = false;			
			
		}				
	}
	
	function setHover(current) {
		
		setColors(current);		
		
		if (navigationselected!='transparent')
		{
			$('.focused').css({background:navigationselected});
			$('.focused').css("backgroundColor",navigationselected);
			current.addClass('rowhover');
		}
		
		
		
		if (navigationhover!='transparent')
		{
			current.css({background:navigationhover});
			current.css("backgroundColor",navigationhover);
		}
			
		current.find('td.navigation_pointer').html('<img src="'+hostname+'/Images/arrow5.png'+'"/>');
		
		current.css({cursor:'hand'});		
		current  = current.nextAll("tr:visible").first();	
		while(current.hasClass("navigation_row_child"))	{
			
			if (navigationhover!='transparent')
			{
				current.addClass('rowhover');
				current.css({background:navigationhover});
				current.css("background",navigationhover);
			}
			current.css({cursor:'hand'});
			current = current.nextAll("tr:visible").first();			
		}		
	}

	function setColors(tRow) {
		
		var table = tRow.parents('.navigation_table');
		previouscolor = tRow.attr('bgcolor')

		var navigationhover_tmp = table.attr('navigationhover');
		if (navigationhover_tmp)
			navigationhover = navigationhover_tmp

		var navigationselected_tmp = table.attr('navigationselected');
		if (navigationselected_tmp)
			navigationselected = navigationselected_tmp
		
	}
		
	function clearHover(tRow)
	{
		if (!previouscolor)
			previouscolor = 'transparent';
		
		tRow.css({background:previouscolor});
		tRow.css("backgroundColor", previouscolor);
		tRow.find('td.navigation_pointer').html('&nbsp;&nbsp;&nbsp;&nbsp;');
		
		
		tRow=tRow.nextAll("tr:visible").first();
		while(tRow.hasClass("navigation_row_child"))	{
			tRow.css({background:previouscolor});
			tRow.css("backgroundColor",previouscolor);
			tRow = tRow.nextAll("tr:visible").first();
		}			
		
		
	}

	function doHighlight() {
	
	try{
		
		
		$('.navigation_pointer').each(function () {
			$(this).html('&nbsp;&nbsp;&nbsp;&nbsp;'); 			
		});
				
		$(document).off('keydown');
		
		$(document).on('keydown',function(ev){
			doPageUpDown(ev);
			if (paging) {
				$('.focused').removeClass('focused');
				focusedRow = $('.navigation_row:first');
				if (focusedRow) 
					focusedRow.toggleClass('focused');
			}		
			
		});		
		
		$(document).off('.navigation_table');
		$(".navigation_table").off('keydown');
		$(".navigation_table").off('focusout');
				

		$(".navigation_table").on('focusout',function(){
			if (!lastEnter) {
				if (focusedRow) 
					focusedRow.addClass('focused');
				focusedRow = null;
			}
		});

	//Basically, we will ignore those tables whose parent has the "ignore" class	
			
		$(':not(.ignore) > .navigation_table').on('keydown',function(ev){
				
				$('.rowhover').removeClass('rowhover');
				
				if (ev.which == 38 || ev.which == 40) {				
					clearFocus();
					
					if (focusedRow == null) {
					
						focusedRow = $('.navigation_row:first', $(this));						
					}
					else 
						//Page up
						if (ev.which == 38) {		
					
							focusedRow = focusedRow.closest('tr').prevAll('.navigation_row:first')
							
							if (focusedRow) 
								if (focusedRow.length == 0) {
									focusedRow = $('.navigation_row:last', $(this));
								}
							
						}
						else 
							//Page down
							if (ev.which == 40) {							
								focusedRow = focusedRow.closest('tr').nextAll('.navigation_row:first');																
								if (focusedRow) {
									if (focusedRow.length == 0) {									
										focusedRow = $('.navigation_row:first', $(this));
									}
								}							
							}
					
					setFocus(focusedRow)
					currentSelected =focusedRow
				}
				else 
					if (ev.which == 33 || ev.which == 34) {
						doPageUpDown(ev);
					}
					else
					if (ev.which == 13) {
							doClick();							
				}				
				
			//ev.stopPropagation();				
				
		});
		
		$(".navigation_table").each(function(){				
			$(this).attr('tabindex',0);			
		});		
		
		$(".navigation_row").off('click');
		$(".navigation_row").off('dblclick');
		$(".navigation_row").off('hover');		
		$(".navigation_row_child").off('click');
		$(".navigation_row_child").off('dblclick');
		$(".navigation_row_child").off('hover');

		$(".navigation_row").on('click',function(ev){
			if (!focusClick)
			{
				clearFocus();
				focusedRow = $(this); 	
				setFocus(focusedRow);
				currentSelected =focusedRow
			} 									
	    });			
		
		$(".navigation_row").on('dblclick',function(ev){
			if (!focusClick)
			{
				clearFocus();
				focusedRow = $(this);
				doClick();
				setFocus(focusedRow);
				currentSelected=focusedRow
			}								
				
		});
		
		$(".navigation_row_child").on('dblclick',function(ev){
			if (!focusClick)
			{
				clearFocus();
				focusedRow = $(this).prev(".navigation_row").first(); 	
				doClick();
				setFocus(focusedRow);
				currentSelected =focusedRow
			}				
		});
		
		$(".navigation_row").on('mouseenter',function(){				
				current = $(this);
				setHover(current);				
		});

		$(".navigation_row").on('mouseleave',function(){				
				current = $(this);
				if (!current.hasClass('focused'))
					clearHover(current);	
		});


		$(".navigation_row_child").on('mouseenter',function(){

				current = $(this).prevAll(".navigation_row").first();
				setHover(current);				
		});

		$(".navigation_row_child").on('mouseleave',function(){
				current = $(this).prevAll(".navigation_row").first();
				if (!current.hasClass('focused'))
					clearHover(current);
		});



		$(".navigation_row_child").on('click',function(){
			if (!focusClick)
			{
				clearFocus();	
				focusedRow = $(this).prevAll(".navigation_row").first(); 	
				setFocus(focusedRow)
				currentSelected =focusedRow
			}							
		});

	} catch(e) {}
		
	}
		
	function doEnterListener() {
		
		try {
			$('body').on('keydown', 'input.enterastab, select.enterastab, textarea.enterastab', function(e){
				if (e.keyCode == 13) {
					var focusable = $('input,select,button,textarea').filter(':visible');
					
					var byIndex = -1;
					$.each( focusable, function( key, elem ) {
					  if ($(elem).attr("tabIndex"))
					  {
					  	if ($(elem).attr("tabIndex")>byIndex)
					  	{
					  		byIndex = $(elem).attr("tabIndex");
					  	}
					  }
					});
					
					console.log(byIndex);
					if (byIndex!=-1)
					{
						var currentIndex = $(this).attr("tabIndex");
						
						console.log(currentIndex);
						
						var focusable = $('input,select,button,textarea').filter(function() {
								return $(this).attr("tabIndex") > parseInt(currentIndex);
							
						});
						
						console.log(focusable);
						
						focusable.eq(0).focus();
					}
					else
					{
						focusable.eq(focusable.index(this) + 1).focus();
					}
					return false;
				}
			});			
		}catch(ex) {}	
	}
	
	function toggleobjectbox(box,target,src,action) {			
		if ($('#'+box).is(":visible") && action != 'reload') {				
			  	$('#'+box).fadeOut(200); 
		  } else { 
		  		if (target=='')
					target = box;		
					if (src) {
					ptoken.navigate(src,target);
					}
			  	$('#'+box).fadeIn(200);			  
		  } 
	}

	function __b64toBlob(b64Data, contentType, sliceSize) {
	  contentType = contentType || '';
	  sliceSize = sliceSize || 512;

	  var byteCharacters = atob(b64Data);
	  var byteArrays = [];

	  for (var offset = 0; offset < byteCharacters.length; offset += sliceSize) {
	    var slice = byteCharacters.slice(offset, offset + sliceSize);

	    var byteNumbers = new Array(slice.length);
	    for (var i = 0; i < slice.length; i++) {
	      byteNumbers[i] = slice.charCodeAt(i);
	    }

	    var byteArray = new Uint8Array(byteNumbers);

	    byteArrays.push(byteArray);
	  }

	  var blob = new Blob(byteArrays, {type: contentType});
	  return blob;
	}	
}
