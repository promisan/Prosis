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
<cf_tl id = "Some changes have not been saved, do you still want to continue?" class="message" var = "vSave4">

<script>
	
	var vdate = $("##RecordingDate").val();
			
	if (vdate != '') {
		
		if (changes_made)
		{
			var response = confirm('#vSave4#');
			if (response)
				do_change('#URL.adate#','#URL.scope#','#URL.Mission#','','#CLIENT.Location#');
			else
				//revert
				$("##RecordingDate").val('#URL.adate#');
					
		}	
		else
			do_change('','#URL.scope#','#URL.Mission#','','#CLIENT.Location#');
	}
	
</script>
</cfoutput>
