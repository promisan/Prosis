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
<cfparam name="attributes.optionFontSize" 	default="14px">

<cfoutput>
	<link rel="stylesheet" href="#session.root#/scripts/mobile/resources/vendor/bootstrap/dist/css/bootstrap.css" />

	<script src="#session.root#/scripts/mobile/resources/vendor/bootstrap/dist/js/bootstrap.min.js"></script>
	<script src="#session.root#/scripts/mobile/resources/vendor/selectr/selectr.js"></script>

	<cf_tl id="Search..." var="_multiSelectSearchLabel">
	<cf_tl id="Clear Selections" var="_multiSelectClearLabel">

	<style>
		.selectr .option-name {
			height:auto;
			font-size:#attributes.optionFontSize#;
		}
	</style>

	<script>
	    function doMultiSelect(selector, title, pWidth, pHeight) {
	        $(selector).selectr({
	            title: title,
	            placeholder: '#_multiSelectSearchLabel#',
	            width: pWidth,
	            maxListHeight: pHeight,
	            resetText: '#_multiSelectClearLabel#',
	            emptyOption: true
	        });
	    }
		
		function fixSelectedErrors(selector) {
			var vSelectedElements = $('.selectr .list-group').find('.selected').length;
			
			if(vSelectedElements == 0) {
				$(selector).val('');
				$('.selectr .panel-footer').addClass('hidden');
			} else {
				$('.selectr .badge').html(vSelectedElements);
			}
		}

	    function getMultiSelectValues(selector, autorefresh){
	    	var vSelected = '';

	    	 $(selector + ' :selected').each(function(){
	    	 	vSelected = vSelected + ',' + this.value;
	    	 });

	    	 if (vSelected != '') {
	    	 	vSelected = vSelected.substring(1, vSelected.length);
	    	 }
			 
			 if (autorefresh) {
				 fixSelectedErrors(selector);
			 }

	    	 return vSelected;
	    }
	</script>

</cfoutput>