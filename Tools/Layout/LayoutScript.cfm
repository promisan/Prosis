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
<cfoutput>

	<script>		
		//Load jQuery if it isn't loaded
		/*
		if (!window.jQuery) {
	        var script = document.createElement("script");
	        script.type = "text/javascript";
	        script.src = "#session.root#/Scripts/jQuery/jquery.js";
	        document.body.appendChild(script);
	    }
		*/
		
		var _array_customToggleLayout_script = new Array();
	</script>

	<cfset vAuto = "auto">
	<cfif find("Firefox","#CGI.HTTP_USER_AGENT#")>
		<cfset vShow = "">
	<cfelse>	
		<cfset vShow = "">
	</cfif>
	
	<cfset vRowShow = "">
	<cfif find("MSIE 7","#CGI.HTTP_USER_AGENT#")>
		<cfset vRowShow = "block">
	</cfif>	

	<script type="text/javascript" charset="utf-8" src="#session.root#/Scripts/jQuery/jqueryeffects.js"></script>
	<script type="text/javascript" charset="utf-8" src="#session.root#/Scripts/Modernizr/modernizr.js"></script>

	<script>
		// ************************************************************************
		// ********************** ACCORDION METHODS *******************************
		// ************************************************************************
		
		function toggleLayoutArea(parentId, id, delay, openIcon, closeIcon, onshow) { 
			//hide all sections
			$('.'+parentId+'_clsLayoutArea').not('##'+parentId+'_containerLayoutArea_'+id).css('display','none');
			$('.'+parentId+'_clsTogglerLayoutArea').find('.'+parentId+'_clsTogglerLayoutAreaImage').attr('src','#session.root#/Images/'+openIcon);
			$('.'+parentId+'_clsTogglerLayoutArea').find('.'+parentId+'_clsTogglerLayoutAreaText').css('font-size','100%');
			
			//show this section
			$('##'+parentId+'_containerLayoutArea_'+id).toggle(delay, function() {
				if ($('##'+parentId+'_containerLayoutArea_'+id).is(':visible')) { 
					//callback onshow
					onshow();
					$('##'+parentId+'_trFiller').css('display','none');
					$('##'+parentId+'_togglerLayoutArea_'+id).find('.'+parentId+'_clsTogglerLayoutAreaImage').attr('src','#session.root#/Images/'+closeIcon);
					$('##'+parentId+'_togglerLayoutArea_'+id).find('.'+parentId+'_clsTogglerLayoutAreaText').css('font-size','125%');
				}
				else {
					$('##'+parentId+'_trFiller').css('display','#vRowShow#');
					$('##'+parentId+'_togglerLayoutArea_'+id).find('.'+parentId+'_clsTogglerLayoutAreaImage').attr('src','#session.root#/Images/'+openIcon);
					$('##'+parentId+'_togglerLayoutArea_'+id).find('.'+parentId+'_clsTogglerLayoutAreaText').css('font-size','100%');
				}
			});
		}
		
		function showLayoutArea(parentId, id, openIcon, closeIcon) {
			//hide all sections
			$('.'+parentId+'_clsLayoutArea').not('##'+parentId+'_containerLayoutArea_'+id).css('display','none');
			$('.'+parentId+'_clsTogglerLayoutArea').find('.'+parentId+'_clsTogglerLayoutAreaImage').attr('src','#session.root#/Images/'+openIcon);
			$('.'+parentId+'_clsTogglerLayoutArea').find('.'+parentId+'_clsTogglerLayoutAreaText').css('font-size','100%');
			
			//show this section
			$('##'+parentId+'_containerLayoutArea_'+id).css('display','#vRowShow#');
			$('##'+parentId+'_trFiller').css('display','none');
			$('##'+parentId+'_togglerLayoutArea_'+id).find('.'+parentId+'_clsTogglerLayoutAreaImage').attr('src','#session.root#/Images/'+closeIcon);
			$('##'+parentId+'_togglerLayoutArea_'+id).find('.'+parentId+'_clsTogglerLayoutAreaText').css('font-size','125%');
		}
		
		function hideLayoutArea(parentId, id, openIcon) {
			//hide all sections
			$('.'+parentId+'_clsLayoutArea').not('##'+parentId+'_containerLayoutArea_'+id).css('display','#vRowShow#');
			$('.'+parentId+'_clsTogglerLayoutArea').find('.'+parentId+'_clsTogglerLayoutAreaImage').attr('src','#session.root#/Images/'+openIcon);
			$('.'+parentId+'_clsTogglerLayoutArea').find('.'+parentId+'_clsTogglerLayoutAreaText').css('font-size','100%');
			$('##'+parentId+'_trFiller').css('display','#vRowShow#');
		}
			
		
		// ************************************************************************
		// ************************* BORDER METHODS *******************************
		// ************************************************************************
		
		function toggleBorderSection(parentId, position, easing, delay, openIcon, closeIcon, onshow, onhide, type){
			var criteriaShow = {};
			var criteriaHide = {};
			
			if (position == "RIGHT" || position == "LEFT") {
				criteriaShow.width = "show";
				criteriaHide.width = "hide";
			}
			
			if (position =="HEADER" || position == "TOP" || position == "BOTTOM") {
				criteriaShow.height = "show";
				criteriaHide.height = "hide";
			}
			
			if ($('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_border' + position).is(':visible') && (type == 2 || type == 0)) {
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_border' + position).find('table').css('display','none');
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_border' + position).animate(criteriaHide, delay, easing, function() {
					$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderToggler'+position+' > img').attr('src','#session.root#/Images/'+closeIcon);
					onhide();
				});		
			}
			
			if (!$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_border' + position).is(':visible') && (type == 2 || type == 1)) {
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_border' + position).animate(criteriaShow, delay, easing, function() {
					$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_border' + position).find('table').css('display','#vShow#');
					$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderToggler'+position+' > img').attr('src','#session.root#/Images/'+openIcon);
					onshow();
				});	
			}
		}
		
		function onEvents(parentId, position, easing, delay, openIcon, closeIcon, onshow, onhide, id) {
			try{
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderToggler'+position+', ##'+parentId+'_borderToggler'+position+' > img').off('click');
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderToggler'+position+', ##'+parentId+'_borderToggler'+position+' > img').on('click', function(event) {
					toggleBorderSection(parentId, position, easing, delay, openIcon, closeIcon, onshow, onhide, 2);
					event.preventDefault(); 
					event.stopPropagation();
					return false;
				});
				
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderToggler'+position+', ##'+parentId+'_borderToggler'+position+' > img').off('mouseenter');
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderToggler'+position+', ##'+parentId+'_borderToggler'+position+' > img').on('mouseenter', function(event) {
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderToggler'+position+', ##'+parentId+'_borderToggler'+position+' > img').css('opacity','0.75');
					event.preventDefault(); 
					event.stopPropagation();
					return false;
				});
				
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderToggler'+position+', ##'+parentId+'_borderToggler'+position+' > img').off('mouseout');
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderToggler'+position+', ##'+parentId+'_borderToggler'+position+' > img').on('mouseout', function(event) {
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderToggler'+position+', ##'+parentId+'_borderToggler'+position+' > img').css('opacity','1');
					event.preventDefault(); 
					event.stopPropagation();
					return false;
				});
			
				var fcn1 = function(){
						 	$('##'+id).closest('.'+parentId+'_clsBorderTogglable').off('customToggle');
							$('##'+id).closest('.'+parentId+'_clsBorderTogglable').on('customToggle',function(event, type){
								toggleBorderSection(parentId, position, easing, delay, openIcon, closeIcon, onshow, onhide, type);
								event.preventDefault();
								event.stopPropagation();
								return false;
							});
				}
				
				fcn1();
				
				_array_customToggleLayout_script.push(fcn1);

			}
			catch(ex)
			{
				
			}	
		} 
			
		
		function showBorderSection(parentId, id){
			if (id == "CENTER" || id == "RIGHT" || id == "LEFT") {
				$('##'+parentId+'_borderWrapper_'+parentId).find('.'+parentId+'_clsBorder'+id).css('display', '#vShow#');
			}
			
			if (id == "HEADER" || id == "TOP" || id == "BOTTOM") {
				$('##'+parentId+'_borderWrapper_'+parentId).find('.'+parentId+'_clsBorder'+id).css('display', '#vRowShow#');
			}
		}
		
		function setIdBorderSection(parentId, id, position) {
			$('##'+parentId+'_borderWrapper_'+parentId).find('.'+parentId+'_clsBorderPresenter'+position).attr('id',id);
		}
		
		function enableBorderSection(parentId, position, isEnabled) {
			var vShowSection;
			var vPosition = position.toUpperCase();
			
			if (vPosition == "CENTER" || vPosition == "RIGHT" || vPosition == "LEFT") {
				vShowSection = '#vShow#';
			}
			
			if (vPosition == "HEADER" || vPosition == "TOP" || vPosition == "BOTTOM") {
				vShowSection = '#vRowShow#';
			}
			
			if (isEnabled) {
				$('##'+parentId+'_borderWrapper_'+parentId).find('.'+parentId+'_clsBorder'+vPosition).css('display',vShowSection);
			}else{
				$('##'+parentId+'_borderWrapper_'+parentId).find('.'+parentId+'_clsBorder'+vPosition).css('display','none');
			}
		}

		function _getNotificationContainerId(parentId, position) {
			return '##'+parentId+'_borderToggler'+position.toUpperCase();
		}

		function _getNotificationId(parentId, position, pId) {
			return parentId + position.toUpperCase() + '_notification_' + pId;
		}

		function _createBorderSectionNotification(parentId, position, pImage, pMessage, pNotificationId){
			var vNotificationElement = '<div id="'+pNotificationId+'" class="borderSectionNotification" style="float:right; display:none; background-image:url(#session.root#/images/'+pImage+'); background-repeat:no-repeat; background-position:center; background-size:25px 25px; height:25px; width:25px; margin-top:5px;" title="'+pMessage+'"></div>';
			
			$(_getNotificationContainerId(parentId, position)).append(vNotificationElement);
			$('##'+pNotificationId).fadeIn(500);
		}

		function _removeBorderSectionNotification(pNotificationId) {
			$('##'+pNotificationId).fadeOut(500, function(){
				$('##'+pNotificationId).remove();
			});
		}

		function notifyBorder(parentId, position, pImage, pMessage, pTTL) {
			var vNotificationId = _getNotificationId(parentId, position, ($(_getNotificationContainerId(parentId, position) + ' > div').length + 1));
			_createBorderSectionNotification(parentId, position, pImage, pMessage, vNotificationId);

			var vTTL = 1;
			if (pTTL) {
				if (pTTL > 0) {
					vTTL = pTTL;
				}
			}

			setTimeout(function(){
				_removeBorderSectionNotification(vNotificationId);
			}, vTTL*1000);
		}

		function notifyBorderById(parentId, position, pImage, pMessage, pId) {
			var vNotificationId = _getNotificationId(parentId, position, pId);
			_createBorderSectionNotification(parentId, position, pImage, pMessage, vNotificationId);
		}

		function removeNotificationBorderById(parentId, position, pId) {
			var vNotificationId = _getNotificationId(parentId, position, pId);
			_removeBorderSectionNotification(vNotificationId);
		}
		
		function setOverflowBorderSection(parentId, id, overflow) {
			var vScroll = "#vAuto#";
			if (overflow == "hidden") { vScroll = "hidden"; }

			$('##'+id).css('overflow',vScroll);
			$('##'+id).css('overflow-x',vScroll);
			$('##'+id).css('overflow-y',vScroll);
		}
		
		function appendBorderSection(parentId, id, source){
			
			var tempContent = $.trim($('##'+parentId+'_tempContainer_'+id).html().toString());
			
			//remove the html comment tags from the temp div
			tempContent = tempContent.substring(4, tempContent.length - 3);
			
			$('##'+id).html(tempContent);
			$('##'+parentId+'_tempContainer_'+id).html('');
			
			if (source != "") { $('##'+id).load(source); }
		}
		
		function setStatusBorderSection(parentId, id, initcollapsed) {
			if (initcollapsed == 'false' || id =="HEADER" || id == "CENTER") {
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_border'+id).css('display','#vShow#');	
			}else{
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_border'+id).css('display','none');
			}
		}
		
		function setLabelBorderSection(parentId, id, label, style, backgroundColor) {
			if (label != "") { 
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderPresenterLabel'+id).html(label);
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderPresenterLabel'+id).attr('style', $('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderPresenterLabel'+id).attr('style') + ' ' + style);
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderPresenterLabel'+id).css('background-color', backgroundColor);
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderPresenterLabel'+id).css('display','#vShow#');
			}
		}
		
		function applyBorderAttributes(parentId, id, togglerBorderColor, togglerColor, backgroundColor, collapsible, size, maxSize, minSize, initcollapsed, openIcon, closeIcon, style){
			if ($('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderToggler'+id).length > 0) { 
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderToggler'+id).css('border-color',togglerBorderColor); 
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderToggler'+id).css('background-color',togglerColor);
				if (initcollapsed == 'false') {
					$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderToggler'+id+' > img').attr('src','#session.root#/Images/'+openIcon);
				}else{
					$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderToggler'+id+' > img').attr('src','#session.root#/Images/'+closeIcon);
				}
				if (collapsible == 'false') {
					$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderToggler'+id).css('display','none');	
				}
			}			
			$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_border'+id).css('border-color',togglerBorderColor);
			$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_borderPresenterLabel'+id).css('border-color',togglerBorderColor);
			$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_border'+id).css('background-color',backgroundColor);
			$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_border'+id).attr('style', $('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_border'+id).attr('style') + ' ' + style);
			
			if (id == "HEADER" || id == "TOP" || id == "BOTTOM") {
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_border' + id).css('height', size);
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_border' + id).css('max-height', maxSize);
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_border' + id).css('min-height', minSize);
			}
			
			if (id == "RIGHT" || id == "LEFT") {
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_border' + id).css('width', size);
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_border' + id).css('max-width', maxSize);
				$('##'+parentId+'_borderWrapper_'+parentId).find('##'+parentId+'_border' + id).css('min-width', minSize);
			}
		}
		
		function reloadCustomToggleEvents(element) {
			if (!$._data(element).events) {
				for (i=0; i<_array_customToggleLayout_script.length; i++) {
					_array_customToggleLayout_script[i]();
				}			
			}
		}
		
		function doChangeLayoutAreaState(parentId, id, state) {
			var vElement = $('##'+id).closest('.'+parentId+'_clsBorderTogglable').first();
			reloadCustomToggleEvents(vElement);
			$(vElement).trigger('customToggle', [state]);
		}
		
		function toggleArea(parentId, id) {
			doChangeLayoutAreaState(parentId, id, 2);
		}
		
		function expandArea(parentId, id) {
			doChangeLayoutAreaState(parentId, id, 1);
		}
		
		function collapseArea(parentId, id) {
			doChangeLayoutAreaState(parentId, id, 0);
		}
		
		function isAreaVisible(parentId, id) {
			return $('##'+id).closest('.'+parentId+'_clsBorderTogglable').is(':visible');
		}
		
	</script>

</cfoutput>