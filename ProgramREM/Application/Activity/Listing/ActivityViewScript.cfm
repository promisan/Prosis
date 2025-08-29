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
		   ptoken.navigate('#SESSION.root#/ProgramREM/Application/Activity/Listing/ActivityListingOutput.cfm?activityid='+id,'box'+id)
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
		 	ptoken.navigate('#SESSION.root#/ProgramREM/Application/Activity/Listing/ActivityListing.cfm?mission=#url.mission#&programcode=#url.programcode#&period=#url.period#&periodfilter='+per+'&option='+show,'detail')
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