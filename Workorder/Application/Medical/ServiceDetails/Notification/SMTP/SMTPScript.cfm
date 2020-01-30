<cfoutput>
	<script>
		
		function mark_smtp(action,total)	{
					
				se = document.getElementsByName("csmtp")
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
		
		function send_smtp(total) {
	
			se = document.getElementsByName("csmtp")
			count = 0
			to_send = 0;
		
			//checking on
			while (se[count]) {
				if (se[count].checked)
					to_send ++
				count++;
			}		
	
			if (to_send == 0)
				alert("You have to select at least one customer to send a e-Mail");
			else {
				ColdFusion.Window.create('bb_tts', 'PROSIS eMail Service','../Notification/SMTP/SMTPProcess.cfm',{height:520,width:710,modal:false,closable:true,draggable:true,resizable:false,center:true,initshow:true })				
			}
			
		}	
		
		function send_smtp_go() {
			e = document.getElementById("smtp_text");
			document.getElementById("end_text").value=e.value;
			ColdFusion.Window.hide('bb_tts')
			ColdFusion.Window.create('bb_wait', 'PROSIS SMTP - Processing','../Notification/SMTP/SMTPProcessing.cfm',{height:555,width:310,modal:false,closable:false,draggable:false,resizable:false,center:true,initshow:true })
			ColdFusion.navigate('../Notification/SMTP/SMTPSubmit.cfm?mission=#URL.Mission#&dts=#URL.date#','processing_smtp','','','post','fNotification');
		}
			
		
	</script>
</cfoutput>