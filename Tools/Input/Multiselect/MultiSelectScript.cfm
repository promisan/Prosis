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