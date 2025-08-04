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
<cfparam name="attributes.scope"  default="settlement">

<cfoutput>

<script>
		
	function setFocusPOS(el,dot) {

		resetAmounts();
		if ($(el).hasClass('regularxl')) {
			$(el).removeClass('regularxl');
			$(el).addClass('inputamount_active');
		}
		
		_key_pad_listener = $(el).attr('name');
		if (dot == 'yes') {
			$('##dot').show();	
			$('##tddot').show();							
			$('##tdn0').attr('colspan',2);			
		} else {
			$('##dot').hide();
			$('##tddot').hide();				
			$('##tdn0').attr('colspan',3);
		}
		
	}
			
	function saveenter() {
	
		if (window.event) {   
			  keynum = window.event.keyCode;	  
		   } else {   
			  keynum = window.event.which;	  
		   }
		   
		   if (keynum == 13) {
		     document.getElementById("Update").click()	   
		   }		   
    }
	
	function setmode(c,box) {

		$('##line_amount_number').show();		
		$('td[name*="tdm"]').removeClass('active_color').removeClass('over_color').addClass('clear_color');
		$('##tdm'+box).removeClass('clear_color').removeClass('over_color').addClass('active_color');
		$('##btn_settlement').val('tdm'+box);	
		$('##settlement').val(box);	
		_cf_loadingtexthtml='';							   	      
		ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/pos/settlement/SettlementDetails.cfm?scope=#attributes.scope#&mode='+c,'additional');	
	      
	}
	
	function setcurrency(c) {
		$('##btn_currency').val('tdc'+c);	
		$('##currency').val(c);					
		$('td[name*="tdc"]').removeClass('active_color').removeClass('over_color').addClass('clear_color');
		$('##tdc'+c).removeClass('clear_color').removeClass('over_color').addClass('active_color');
	}
		
	function mouseover(t) {
		$(t).removeClass('clear_color').removeClass('active_color').addClass('over_color');
	}
	
	function mouseout(t) {
		if ( $('##btn_settlement').val() != t.id && $('##btn_currency').val() != t.id)
			$(t).removeClass('active_color').removeClass('over_color').addClass('clear_color');	}	
	
	function initSettlement() {

		var i= 0;	
		resetAmounts();
		$('input[name*="_number"]:visible').each(function() {
			if (i==0) {
				$(this).focus();
				return false;
			}	
		});
	
	}	
	
	function initPOS() {
	
		
		m = $('##btn_settlement').val();
		$('##'+m).removeClass('clear_color').removeClass('over_color').addClass('active_color');
		
		c = $('##btn_currency').val();
		$('##'+c).removeClass('clear_color').removeClass('over_color').addClass('active_color');
				
		setFocusPOS('##line_amount_number','yes');				
		$(document).off('keypress','input[name*="_number"]');			
		$(document).on('keypress','input[name*="_number"]', function(e) {		
            if (e.keyCode == 13) {
                var inputs = $('input[name*="_number"]');
                var idx = inputs.index(this); 
                if (idx == inputs.length - 1) {
                    inputs[0].select()
                } else {
                    inputs[idx + 1].focus(); 
                    inputs[idx + 1].select();
                }
                return false;
            }
        });		 
		 		
	}
	
	function resetSettlement() {
		$('input[name*="_number"]:visible').each(function() {
			$(this).val('');
		});				

		$('##line_amount_number').val('');
        $('##line_amount_number').focus();
	}
	
	
	function resetAmounts()	{
		$('input[name*="_number"]:visible').each(function()	{
			if ($(this).hasClass('inputamount_active'))	{
				$(this).removeClass('inputamount_active');
				$(this).addClass('regularxl');	  
			}						
		});	
	}
	
</script>

</cfoutput>	