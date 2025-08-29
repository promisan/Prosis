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
var globalMovePercentageChange = 0.25;

function setNavigationBar(pane) {
	var vId = $.trim($('#pane_'+pane+' .clsMainMenuId').html());
	var vTitle = $.trim($('#pane_'+pane+' .clsMainMenuTitle').html());
	
	var vTitlePrev = $.trim($('#pane_'+(pane-1)+' .clsMainMenuTitle').html());
	var vTitleNext = $.trim($('#pane_'+(pane+1)+' .clsMainMenuTitle').html());
	
	var vShowNavOnInit = $.trim($('#_ShowNavigationBarOnInit').html());
	var vShowRefresh = $.trim($('#pane_'+pane+' .clsMainMenuShowReload').html());
	
	$('.clsNavigationBarRefresh').off('click');
	$('.clsNavigationBarRefresh').on('click', function() {
		refreshIframeOnDemand(vId, true, function() {});
	});
	$('.clsNavigationBarPrev img').attr('title',vTitlePrev);
	$('.clsNavigationBarNext img').attr('title',vTitleNext);
	$('.clsNavigationBarPrev .clsNavigationBarTitlePrev').html(vTitlePrev);
	$('.clsNavigationBarNext .clsNavigationBarTitleNext').html(vTitleNext);
	
	$('.clsNavigationBarRefresh').hide();
	if (vShowRefresh == 1) {
		$('.clsNavigationBarRefresh').fadeIn(500);
	}

	$('.clsNavigationBarTitle').html(vTitle).hide().fadeIn(500);

	if (pane == carousel.pane_count-1) {
		$('.clsNavigationBarNext img').hide();
	}else{
		$('.clsNavigationBarNext img').show();
	}
	
	if (pane == 0) {
		$('.clsNavigationBarPrev img').hide();
		if (vShowNavOnInit == 0) {
			$('.clsNavigationBar').hide();
		}else{
			$('.clsNavigationBar').show();
		}
	}else{
		$('.clsNavigationBarPrev img').show();
		$('.clsNavigationBar').show();
	}
}

function selectMenu(pane, oncallback){
	setNavigationBar(pane);
	$('.clsMenuButton').find('.clsMainMenuOverlayItemSelectedBar').removeClass('clsMainMenuOverlayItemSelectedBar-Selected').addClass('clsMainMenuOverlayItemSelectedBar-NotSelected');
	$('.clsMenuButton').find('.clsMainMenuOverlayItemSelectedBar').removeClass('clsMainMenuOverlayItemSelectedBar-MouseOver').addClass('clsMainMenuOverlayItemSelectedBar-MouseOut');
	$('.clsMenuButton').removeClass('clsMainMenuOverlayItemSelected').addClass('clsMainMenuOverlayItemNotSelected');
	$('#btnPane'+pane).removeClass('clsMainMenuOverlayItemNotSelected').addClass('clsMainMenuOverlayItemSelected');
	$('#btnPane'+pane).find('.clsMainMenuOverlayItemSelectedBar').removeClass('clsMainMenuOverlayItemSelectedBar-NotSelected').addClass('clsMainMenuOverlayItemSelectedBar-Selected');
	
	if (oncallback) {
		oncallback();
	}
}

/**
* requestAnimationFrame and cancel polyfill
*/
(function() {
    var lastTime = 0;
    var vendors = ['ms', 'moz', 'webkit', 'o'];
    for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
        window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
        window.cancelAnimationFrame =
                window[vendors[x]+'CancelAnimationFrame'] || window[vendors[x]+'CancelRequestAnimationFrame'];
    }

    if (!window.requestAnimationFrame)
        window.requestAnimationFrame = function(callback, element) {
            var currTime = new Date().getTime();
            var timeToCall = Math.max(0, 10 - (currTime - lastTime));
            var id = window.setTimeout(function() { callback(currTime + timeToCall); },
                    timeToCall);
            lastTime = currTime + timeToCall;
            return id;
        };

    if (!window.cancelAnimationFrame)
        window.cancelAnimationFrame = function(id) {
            clearTimeout(id);
        };
}());


/**
* super simple carousel
* animation between panes happens with css transitions
*/
function Carousel(element)
{
    var self = this;
    element = $(element);

    var container = $(">ul", element);
    var panes = $(">ul>li", element);

    var pane_width = 0;
    var pane_count = panes.length;

    var current_pane = 0;


    /**
     * initial
     */
    this.init = function() {
        setPaneDimensions();

        $(window).on("load resize orientationchange", function() {
            setPaneDimensions();
            //updateOffset();
        })
    };


    /**
     * set the pane dimensions and scale the container
     */
    function setPaneDimensions() {
        pane_width = element.width();
        panes.each(function() {
            $(this).width(pane_width);
        });
        container.width(pane_width*pane_count);
    };


    /**
     * show pane by index
     * @param   {Number}    index
     */
    this.showPane = function( index ) {
        // between the bounds
        index = Math.max(0, Math.min(index, pane_count-1));
        current_pane = index;
        var offset = -((100/pane_count)*current_pane);
        setContainerOffset(offset, true);
		
		//Show content
		var vId = $('#pane_'+current_pane+' .clsMainMenuId').html();

        //if not force refresh
        if ($('#pane_'+current_pane+' .clsMainMenuEnforceReload').html() != 1) {
            //then refresh on demand not forcing, useful for first load
            refreshIframeOnDemand(vId, false, function() {});
        }
		
		//custom methods
		selectMenu(current_pane, function enforceReload() { 
			if ($('#pane_'+current_pane+' .clsMainMenuEnforceReload').html() == 1) {
				refreshIframeOnDemand(vId, true, function() {});
			}
		});
    };

    //gets the tab index by systemFunctionId
	this.getIndexById = function(pId) {
		for (i = 0; i < pane_count; i++) {
			console.log($('#pane_'+i+' .clsMainMenuId').html());
			if ($('#pane_'+i+' .clsMainMenuId').html() == pId) {
				return i;
			}
		}
		return 0;
	};
	
	//shows the tab by systemFunctionId
	this.showPaneById = function(pId){
		var vPortalTabId = pId.replace(/-/gi,'');
		this.showPane(this.getIndexById(vPortalTabId));
	};

    function setContainerOffset(percent, animate) {
        container.removeClass("animate");

        if(animate) {
            container.addClass("animate");
        }

        if(Modernizr.csstransforms3d) {
            container.css("transform", "translate3d("+ percent +"%,0,0) scale3d(1,1,1)");
        }
        else if(Modernizr.csstransforms) {
            container.css("transform", "translate("+ percent +"%,0)");
        }
        else {
            var px = ((pane_width*pane_count) / 100) * percent;
            container.css("left", px+"px");
        }
    }

    this.next = function() { return this.showPane(current_pane+1, true); };
    this.prev = function() { return this.showPane(current_pane-1, true); };
	this.pane_count = pane_count;
	this.current_pane = current_pane;

    function handleHammer(ev) {
        // disable browser scrolling
        ev.gesture.preventDefault();
        switch(ev.type) {
            case 'dragright':
            case 'dragleft':
                // stick to the finger
                var pane_offset = -(100/pane_count)*current_pane;
                var drag_offset = ((100/pane_width)*ev.gesture.deltaX) / pane_count;

                // slow down at the first and last pane
                if((current_pane == 0 && ev.gesture.direction == Hammer.DIRECTION_RIGHT) ||
                    (current_pane == pane_count-1 && ev.gesture.direction == Hammer.DIRECTION_LEFT)) {
                    drag_offset *= .4;
                }

                setContainerOffset(drag_offset + pane_offset, false);
                break;

            case 'swipeleft':
                self.next();
                ev.gesture.stopDetect();
                break;

            case 'swiperight':
                self.prev();
                ev.gesture.stopDetect();
                break;

            case 'release':
				if (ev.gesture.direction == 'right' || ev.gesture.direction == 'left') {
					if(Math.abs(ev.gesture.deltaX) > pane_width*globalMovePercentageChange) {
						switch(ev.gesture.direction) {
							case 'right': self.prev(); break;
							case 'left': self.next(); break;
							default: self.showPane(current_pane, true); break;
						}
					} else {
						if(Math.abs(ev.gesture.deltaX) > 0) {
							self.showPane(current_pane, true);
						}
    				}
				} else {
					if(Math.abs(ev.gesture.deltaX) > 0) {
						self.showPane(current_pane, true); 
					}
				}
                break;
				
			default:
				self.showPane(current_pane, true);
				break;
    	}
		
    }

	//Enable hammer
	//element.hammer({ drag_lock_to_axis: true }).on("release dragleft dragright swipeleft swiperight", handleHammer);
	
	//Enable hammer for header and navigation bar
	$('.clsHeader, .clsNavigationBar').hammer({ drag_lock_to_axis: true }).on("release dragleft dragright swipeleft swiperight", handleHammer);
}