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

<cfajaximport tags="cfform,cfwindow">

<cf_textareascript>

<cfoutput>
	
	<script language="JavaScript">

		function show(box,id) {
				
			if ($('.clsToggler'+id).is(':visible')) {
				$('.clsToggler'+id).hide();
			}else{
			   url = "#SESSION.root#/Vactrack/Application/Announcement/Announcement.cfm?header=0&id="+id+"&apply=1";
			   window['scrollFunction_'+id] = function() {
			   		$('.clsToggler'+id).show(0,function(){
						$('##content').animate({ scrollTop: $('.clsTogglerTitle'+id).offset().top - 25}, 200);
					});
			   }	
			   ptoken.navigate(url,'vcontent'+box,'scrollFunction_'+id);
			}
			
		}
		
		function withdraw(box,id) {

			se = document.getElementById("c"+box)		
			if (se.className == "regular") {  
			  se.className = "hide" 
			} else {  
    		  se.className = "regular"; 
		      url = "#SESSION.root#/Roster/PHP/PHPEntry/Application/doWithdraw.cfm?id="+id+"&apply=1"
		      ptoken.navigate(url,'c'+box)
		 	}
		}
		
	   function application(id) {
		kl = document.getElementById("a"+id)
		url = "#SESSION.root#/Roster/PHP/PHPEntry/Application/doApply.cfm?id="+id+"&apply=1"		   
		ptoken.navigate(url,'acontent'+id)	
		// if (kl.className == "regular") {  
		   // kl.className = "hide" 
		// } else {  
		//   kl.className = "regular"; 
		//   url = "#SESSION.root#/Roster/PHP/PHPEntry/Application/doApply.cfm?id="+id+"&apply=1"		   
		//   ptoken.navigate(url,'acontent'+id)		  
		// }
		}
		
		function shortBucketApply(id) {
			ptoken.navigate('#SESSION.root#/Roster/PHP/PHPEntry/Application/doApplySubmit.cfm?id='+id,'process');
		}
					
	</script>

</cfoutput>