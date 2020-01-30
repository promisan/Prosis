
<cf_systemscript>

<cfoutput>
	
	<script>
	
	function memoshow(memo,act,id,per) {
	    icM  = document.getElementById(memo+"Min")
	    icE  = document.getElementById(memo+"Exp")
		se   = document.getElementById(memo)
		
		if (act == "show") {
		
			se.className  = "regular";
			icM.className = "regular";
		    icE.className = "hide";
			ColdFusion.navigate('#session.root#/Attendance/Application/Workflow/Clearance/DocumentMemo.cfm?id='+id+'&personno='+per,memo+'_content')
			
		} else {
		
			se.className  = "hide";
		    icM.className = "hide";
		    icE.className = "regular";
		}
	}
	
	</script>

</cfoutput>