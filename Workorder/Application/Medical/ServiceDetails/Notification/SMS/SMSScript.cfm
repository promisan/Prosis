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
<cfoutput>

	<script language="JavaScript">
			
		function mark_sms(action,total)	{
				
			se = document.getElementsByName("csms")
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
				
		function send_sms(total) {
	
			se = document.getElementsByName("csms")
			count = 0
			to_send = 0;		
			//checking on
			while (se[count]) {
				if (se[count].checked)
					to_send ++
				count++;
			}			
			if (to_send == 0)
				alert("You have to select at least one customer to send a SMS");
			else {			
			ColdFusion.Window.create('bb_sms', 'PROSIS SMS','Notification/SMS/SMSProcess.cfm',{height:590,width:350,modal:true,closable:true,draggable:false,resizable:false,center:true,initshow:true })				
			}
		}	
		
		function send_sms_go() {
			e = document.getElementById("sms_text")
			ColdFusion.Window.hide('bb_sms')
			se    = document.getElementById('DateEffective_date').value;
			ColdFusion.Window.create('bb_wait', 'PROSIS SMS - Processing','Notification/SMS/SMSProcessing.cfm?mission=#url.mission#',{height:590,width:350,modal:true,closable:false,draggable:false,resizable:false,center:true,initshow:true })
			ColdFusion.navigate('Notification/SMS/SMSSubmit.cfm?dts='+se+'&mission=#url.mission#&txt='+e.value,'processing','','','post','mapform');
		}
		
	</script>
	
</cfoutput>	

