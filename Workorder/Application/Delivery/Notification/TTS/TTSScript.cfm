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