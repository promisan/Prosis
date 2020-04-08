
<cfoutput>

<script language="JavaScript">	

	function edit(id) {      
	  ptoken.open("#SESSION.root#/programrem/application/program/ActivityProject/ActivityView.cfm?ProgramCode=#URL.ProgramCode#&Period=#url.period#&ActivityId=" + id,id)		  
	}
			
	 function showprogress(id) {
	
		row  = document.getElementById("row"+id)
		pmax = document.getElementById("max"+id)
		pmin = document.getElementById("min"+id)
		if (row.className == "hide") {
		   row.className = "regular"
		   pmax.className = "hide"
		   pmin.className = "regular"
		   ColdFusion.navigate('#SESSION.root#/ProgramREM/Application/Activity/Listing/ActivityListingOutput.cfm?activityid='+id,'box'+id)
		} else {
		   row.className = "hide"
		   pmin.className = "hide"
		   pmax.className = "regular"
		}
		}
		
	 function showproject(pr) {
	 	
	    se = document.getElementsByName("cl"+pr)		
		mx = document.getElementById("pmax"+pr)		
		mn = document.getElementById("pmin"+pr)
		
		var cnt = 0	
		if (mx.className == "regular") {
		    mx.className = "hide" 
		    mn.className = "regular"		  	
			while (se[cnt]) {
			 se[cnt].className = "navigation_row labelmedium line"
			 cnt++ } 		 
		} else {
		    mx.className = "regular" 
		    mn.className = "hide" 		  	
			while (se[cnt]) {
			 se[cnt].className = "hide"
			 cnt++ } 		
		}
	 }
	 
	 function menuoption(opt,show) {
	 
	 	 per = document.getElementById('period').value
			
	     if (opt == "list") {	
		    Prosis.busy('yes')	 
			_cf_loadingtexthtml='';	
		 	ColdFusion.navigate('#SESSION.root#/ProgramREM/Application/Activity/Listing/ActivityListing.cfm?mission=#url.mission#&programcode=#url.programcode#&period=#url.period#&periodfilter='+per+'&option='+show,'detail')
		 }			 
	 }	
	 
	 function showparent(act) {
	     if (act == "show") {
	       window.status = "connector" 
	     } else {
	       window.status = ""
	     }
	 }
			  		  
	</script>
	
</cfoutput>	