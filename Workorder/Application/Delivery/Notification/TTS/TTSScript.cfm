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
	function mark_tts(action,total)	{
				
			se = document.getElementsByName("ctts")
			count = 0	
			//checking on
			while (se[count]) {
			    if (action == true) {
					se[count].checked = true;
				} else {
					se[count].checked = false;
				}
				count++;
			}			
		}	
	
	function send_tts(total) {

		se = document.getElementsByName("ctts")
		count = 0
		to_send = 0;
	
		//checking on
		while (se[count]) {
			if (se[count].checked)
				to_send ++
			count++;
		}		

		if (to_send == 0)
			alert("You have to select at least one customer to send a TTS");
		else {
		ColdFusion.Window.create('bb_tts', 'PROSIS TTS','Notification/TTS/TTSProcess.cfm',{height:320,width:510,modal:false,closable:true,draggable:true,resizable:false,center:true,initshow:true })				
		}
	}	
	
	function send_tts_go() {
		e = document.getElementById("tts_text")
		se    = document.getElementById('DateEffective_date').value;
		ColdFusion.Window.hide('bb_tts')
		ColdFusion.Window.create('bb_wait', 'PROSIS TTS - Processing','Notification/TTS/TTSProcessing.cfm',{height:555,width:310,modal:false,closable:false,draggable:false,resizable:false,center:true,initshow:true })
		ColdFusion.navigate('Notification/TTS/TTSsubmit.cfm?dts='+se+'&txt='+e.value,'processing_tts','','','post','mapform');
	}
</script>