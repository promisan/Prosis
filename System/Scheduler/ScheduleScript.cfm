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

<script>

function output(id) {
     window.open("ScheduleOutput.cfm?id="+id,"DialogWindow", "width=860, height=760, status=no,toolbar=no,scrollbars=no,resizable=yes")
} 

function scheduleoption(id) {
     _cf_loadingtexthtml="";	
	 ptoken.navigate('ScheduleOption.cfm?id='+id,'option'+id)	
	 _cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy11.gif'/>"; 
}

function recordrun(id) {   
     ProsisUI.createWindow('executetask', 'Execute Task', '',{x:100,y:100,height:630,width:560,closable:false,modal:true,center:true})	
	 ptoken.navigate('#SESSION.root#/System/Scheduler/ScheduleExecute.cfm?id='+id,'executetask')
}

function showprogress(id,idlog) {
    _cf_loadingtexthtml="";	
    if (document.getElementById('progress'+id)) {
       ptoken.navigate('#SESSION.root#/System/Scheduler/ScheduleExecuteProgress.cfm?id='+id+'&idlog='+idlog,'progress'+id)
    }
    _cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy11.gif'/>"; 
}

function stopprogress() {
	clearInterval ( prg );
}	 

function showlastaction(id) {    
	ptoken.navigate('#SESSION.root#/System/Scheduler/ScheduleLast.cfm?id='+id,'last'+id)		
}

function deletelog(id,id1) {
	_cf_loadingtexthtml="";	
	ptoken.navigate('ScheduleLog.cfm?id='+id+'&id1='+id1,'detail'+id)
	_cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy11.gif'/>";
}

function recordexecute(id,idlog) {       
	ptoken.navigate('ScheduleExecuteGo.cfm?now=1&idlog='+idlog+'&id='+id+'&mode=manual','run'+id)		
    ptoken.navigate('#SESSION.root#/System/Scheduler/ScheduleExecuteProgress.cfm?init=1&idlog='+idlog+'&id='+id,'progress'+id)				
}

function schedulelog(id,id1,act) {    

	icM  = document.getElementById(id+"Min")
    icE  = document.getElementById(id+"Exp")
	se   = document.getElementById("log"+id);	
		
	if (id1 != "") { window.status = "deleting.." }
				 		 
	if (se.className == "hide" || act == "show") {	
	   	 icM.className = "regular";
	     icE.className = "hide";
		 se.className  = "regular";		
		 _cf_loadingtexthtml="";
		 ptoken.navigate('ScheduleLog.cfm?id='+id+'&id1='+id1,'detail'+id)
	} else {
	   	 icM.className = "hide";
	     icE.className = "regular";
    	 se.className  = "hide";
    }		 		
}
  
function schedulelogdetail(idlog) { 
    	
	se   = document.getElementById("log"+idlog);	
					 		 
	if (se.className == "hide")  {	
	 	 se.className  = "regular";		
		 ColdFusion.navigate('ScheduleLogDetail.cfm?idlog='+idlog,'log'+idlog)
	} else {
	   	 se.className  = "hide";
	 }
		 		
  }  

function toggle(id) {
    _cf_loadingtexthtml="";	
    ColdFusion.navigate('ScheduleStatus.cfm?ts='+new Date().getTime()+'&id='+id+'&toggle=1',id)	
	_cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy11.gif'/>";
}

</script>
</cfoutput>
