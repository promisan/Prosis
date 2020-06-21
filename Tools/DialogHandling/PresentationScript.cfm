<!--- By Armin Generic function as of 11/23/2012 it has been decided the use jquery in a broader scope of tasks as it can help search features.--->

<cfoutput>

	<script language="JavaScript">
	
	function __prosisPresentation_do_tablesearch(event, searchmode, searchcondition, searchvalue, row, content, displayValue, filterLabel) {
				
		var unicode = event.keyCode ? event.keyCode : event.charCode;
		
		// get the search value
		var strValue = $('##'+searchvalue+'search').val();

		var testValue = "";
		var vhidden   = 0;
		var cnt       = 0;
		var total     = 0;
										
		if ((searchmode == 'enter' && (unicode == '13' || strValue == '')) || (searchmode != 'enter' && (unicode != '13' || strValue == ''))) {
						
			$('##'+searchvalue+'busy').css({'display':'block'});						
			strValue = strValue.toLowerCase();
			
			if (strValue == "") {
				
				total = $('.'+row).css({'display':displayValue});
				cnt   = total.length;
				
			}else{
			
				total = $('.'+row).css({'display':'none'});						
				var searchElements = $(content);																						
				cnt = 0;
				
				for (var i = 0; i < searchElements.length; ++i) {
					
					var doThisSearch = 0;
					testValue = searchElements[i].innerHTML.toLowerCase();
					
					if ($.trim(searchcondition).toLowerCase() == 'contains') {
						if (testValue.indexOf(strValue) > -1) {
							doThisSearch = 1;				
						}	
					}

					if ($.trim(searchcondition).toLowerCase() == 'equals') {
						if (testValue == strValue) {
							doThisSearch = 1;				
						}	
					}

					if (doThisSearch == 1) {
						cnt = cnt + 1;
						vParent = searchElements[i].parentNode;
						
						while(!$(vParent).hasClass(row)) {
							vParent = vParent.parentNode;
						}	
						vParent.style.display = displayValue;
					}				
				}					
			}			
			vhidden = total.length - cnt;
			setTimeout(function() { updatecounter(searchvalue,vhidden,filterLabel); },120);			
		}							
	}
	
	function __prosisPresentation_do_clearsearch(event, searchmode, searchcondition, searchvalue, row, content, displayValue){
		if ($('##'+searchvalue+'search').val() != '') {
			$('##'+searchvalue+'search').val('');
			__prosisPresentation_do_tablesearch(event, searchmode, searchcondition, searchvalue, row, content, displayValue);	
		}
	}
	
	function updatecounter(n,vHidden,filterLabel)	{
		if (vHidden > 0) {
			 $('.'+n+'counter').html(filterLabel);
		}
		if (vHidden < 1) {
			$('.'+n+'counter').html("");			
		}
		$('##'+n+'busy').css({'display':'none'});
	}
	
	</script>
	
</cfoutput>