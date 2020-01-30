<cf_textareascript>
<cfajaximport tags="cfform,cfwindow">

<cfoutput>
	
	<script language="JavaScript">

		function show(box,id) {
		
		se = document.getElementById("v"+box)
		
		if (se.className == "regular") {  
		  se.className = "hide" 
		} else {  
		   se.className = "regular"; 
		   url = "#SESSION.root#/vactrack/Application/Announcement/Announcement.cfm?id="+id+"&apply=1"		   
		   ColdFusion.navigate(url,'v'+box)		  
		}
		}
		
		function withdraw(box,id) {

			se = document.getElementById("c"+box)
		
			if (se.className == "regular") {  
			  se.className = "hide" 
			} else {  
    		  se.className = "regular"; 
		      url = "#SESSION.root#/Roster/PHP/Apply/Withdraw.cfm?id="+id+"&apply=1"
		      ColdFusion.navigate(url,'c'+box)
		 	}
		}
		
	   function application(id) {
		
		se = document.getElementById("a"+id)
		
		if (se.className == "regular") {  
		  se.className = "hide" 
		} else {  
		   se.className = "regular"; 
		   url = "#SESSION.root#/Roster/PHP/Apply/Apply.cfm?id="+id+"&apply=1"		   
		   ColdFusion.navigate(url,'a'+id)		  
		}
		}
					
	</script>

</cfoutput>