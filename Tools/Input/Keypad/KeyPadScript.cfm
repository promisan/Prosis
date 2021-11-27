<script>

var _key_pad_numeric_text = '';
var _key_pad_listener = '';

	function presskey(k) {
		
		_key_pad_numeric_text = $('#'+_key_pad_listener).val();
		if ( $('#tddot').is(':visible')) {
			if (_key_pad_numeric_text == '0.00' || _key_pad_numeric_text == '0' || _key_pad_numeric_text == '.00')
				_key_pad_numeric_text = '';
			else
				if (_key_pad_numeric_text.indexOf('.00') != -1)
					_key_pad_numeric_text = _key_pad_numeric_text.slice(0,_key_pad_numeric_text.indexOf('.00'));
		}		

		if (_key_pad_numeric_text.length < $('#'+_key_pad_listener).attr('maxlength') )	{
			switch (k){
			case "back":
				_key_pad_numeric_text = _key_pad_numeric_text.slice(0,_key_pad_numeric_text.length-1);			
				break;
			case "ce":
				_key_pad_numeric_text = '';						
				break;
			case ".":
				if (_key_pad_numeric_text.indexOf('.') == -1)
				_key_pad_numeric_text = _key_pad_numeric_text + k;
				break;				
			default:
				_key_pad_numeric_text = _key_pad_numeric_text + k;
			}	
	
			if ( $('#tddot').is(':visible')) {
				if (_key_pad_numeric_text.indexOf('.') == -1) {
					_key_pad_numeric_text = _key_pad_numeric_text + '.00';
				}
			}							
			$('#'+_key_pad_listener).val(_key_pad_numeric_text);			
		}		
		$('#'+_key_pad_listener).focus();			
	}	

</script>
