<!--
    Copyright © 2025 Promisan B.V.

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
