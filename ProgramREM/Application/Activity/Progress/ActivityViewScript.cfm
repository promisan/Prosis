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

<cfoutput>

<script language="JavaScript">	

	function edit(id) {
	  
      w = #CLIENT.width#  - 110;
      h = #CLIENT.height# - 100;	 
	  ptoken.open("#SESSION.root#/programrem/application/program/ActivityProject/ActivityView.cfm?ProgramCode=#URL.ProgramCode#&Period=#url.period#&ActivityId=" + id,"_blank","width="+w+",height="+h+",status=yes,toolbar=no,scrollbars=yes,resizable=yes")
		  
	}
	
	function progressreport(id) {
      w = #CLIENT.width# - 180;
      h = #CLIENT.height# - 180;
	  ptoken.open("#SESSION.root#/programrem/application/Activity/Progress/ActivityProgressOutput.cfm?mode=edit&activityid=" + id,"_blank","left=40, right=40, width="+w+",height="+h+",status=yes,toolbar=no,scrollbars=yes,resizable=no")
	}
	
	function progressreportrefresh(id) {
	  ptoken.navigate('#SESSION.root#/programrem/application/Activity/Progress/ActivityProgressOutput.cfm?mode=read&activityid='+id,'box'+id)	  
	}  		 
	
	function menuoption(opt,out,show) {
	
		 per = document.getElementById("period").value
		
	     if (opt == "gantt") {		 		 
		 Prosis.busy('yes')
		 _cf_loadingtexthtml=''  
		 ptoken.navigate('#SESSION.root#/ProgramREM/Application/Activity/Progress/ActivityProgress.cfm?mission=#url.mission#&programcode=#url.programcode#&period=#url.period#&periodfilter='+per+'&output='+out+'&outputshow='+show,'detail')
		 }
						 
		 if (opt == "graph") {
		  Prosis.busy('yes')
		 _cf_loadingtexthtml=''  
		 ptoken.navigate('#SESSION.root#/ProgramREM/Reporting/Progress/Project/ProgressDrill.cfm?programcode=#url.programcode#&period=#URL.Period#','detail')
		 }
		 
	}	
   		
	function ganttprint(out) {
			    
		per = document.getElementById("period").value
		se = ptoken.open("#SESSION.root#/ProgramREM/Application/Activity/Progress/ActivityProgress.cfm?mission=#url.mission#&programcode=#url.programcode#&period="+per+"&output="+out+"&mode=Print","_blank","width=1000, height=700, status=no, toolbar=no, scrollbars=yes, resizable=yes")
		se.print()	
	} 
	
	 function showprogress(id) {
	
		row  = document.getElementById("row"+id)
		pmax = document.getElementById("max"+id)
		pmin = document.getElementById("min"+id)
		if (row.className == "hide") {
		   row.className = "regular"
		   pmax.className = "hide"
		   pmin.className = "regular"
		   ptoken.navigate('#SESSION.root#/ProgramREM/Application/Activity/Progress/ActivityProgressOutput.cfm?activityid='+id,'box'+id)
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
			 cnt++
			} 		 
		} else {
		   mx.className = "regular" 
		   mn.className = "hide" 		  	
			while (se[cnt]) {
			 se[cnt].className = "hide"
			 cnt++
			} 		
		}
	 }
	 
	 function showparent(act) {
	   if (act == "show") {
	   window.status = "connector" 
	   } else {
	   window.status = ""
	   }
	 }
	 
	 function showdep(act,id) {	 	  
	     ColdFusion.Window.create('executetask', 'Dependencies', '',{x:20,y:20,height:380,width:580,closable:true,modal:false,center:true})	
		 ColdFusion.navigate('ActivityDependency.cfm?activityid='+act,'executetask')
	 } 
			
	 function statusprogress(id,cls) {			
		se = document.getElementsByName("bar"+id)
		var cnt = 0		
		while (se[cnt]) {
		 se[cnt].className = cls
		 cnt++
		} 		
	 }   	
				  
	 function search(pg,prg,per) {
		 ptoken.navigate('#SESSION.root#/programREM/reporting/progress/project/ProgressDrillDetail.cfm?ProgramCode='+prg+'&Period='+per+'&Text='+pg,prg+'_result')
	 } 
		  		  
	</script>
	
</cfoutput>	