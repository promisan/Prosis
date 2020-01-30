
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